//
//  ChannelBridge.swift
//  Runner
//
//  Created by Rafael Takahashi on 27/03/23.
//

import Foundation

typealias BridgeHandler = (Any?) throws -> Any

/// iOS side of the method channel bridge.
///
/// Use this bridge to communicate with Flutter code instead of directly opening method channels.
/// To use it, open a port with a name.
///
/// After having obtained a port, you can use it just like you would use the method channel, with a few differences:
/// - Handlers are registered one by one, by method name. You shouldn't register a method name that has been registered before on
/// the same port. If you do, the previous handler will be discarded and that may lead to bugs.
/// - Port names work like prefixes, but you don't have to worry about constructing the names of methods.
/// - Calls and responses are exposed through simple callbacks that are easier to use than the method channel.
///
/// ```Swift
/// let weatherPort = MethodChannelBridge.openPort("WeatherRepository")
///
/// // Send a call to the Flutter side and get its response:
/// let forecast = weatherPort.call(
///   "fetchWeatherForecast",
///   withArguments: args,
///   onError: { exception in logError(exception) }
///   onSuccess: { params in ... }
///   )
///
/// // or register to receive calls from the Flutter side:
/// weatherPort.registerHandler("fetchWeatherForecast") { (params) -> Void in ... }
/// ```
class MethodChannelBridge {
    /// This exact string must also be used in the Flutter side of the bridge.
    static let methodChannelName = "br.com.rtakahashi.playground.flutter_reference"
    
    /// A static method channel that's shared by all ports in the bridge.
    static var sharedChannel: FlutterMethodChannel? = nil
    
    /// Handlers for the iOS side of the method channel bridge.
    static var bridgeHandlers: Dictionary<String,BridgeHandler> = [:]
    
    // The functions in this class could've been top-level functions and they would work the same;
    // I decided to put them in a class to make their usage more explicit about what they are.
    // That is, you call them with MethodChannelBridge.initialize() rather than just calling
    // the function.
    
    private init() { /** Do not instantiate this class. */}
    
    /// Open a port to the Flutter side.
    ///
    /// Anything from navigation to repositories can use a port.
    ///
    /// "Open" might not be accurate because a port simply works as a prefix when sending and receiving messages through
    /// the message channel. Many classes may "open" the same method channel port and they'll all be able to use it, but you
    /// should avoid that because only one handler can be registered for each name in the same port.
    static func openPort(_ portName: String) -> MethodChannelBridgePort {
        return MethodChannelBridgePortImpl(portName: portName)
    }
    
    /// Initialize this side of the bridge. This function MUST be called at least once, informing the Flutter binary messenger.
    /// The bridge can be used to make calls to the Flutter side only after initialization.
    ///
    /// It is possible to register handlers before initialization, but method calls from the Flutter side will only reach this side of
    /// the bridge after initialization.
    static func initialize(withBinaryMessenger messenger: FlutterBinaryMessenger) {
        if (sharedChannel !== nil) {
            // Method channel already initialized. Skipping.
            return
        }
        
        let newChannel = FlutterMethodChannel(name: methodChannelName, binaryMessenger: messenger, codec: FlutterJSONMethodCodec())
        
        sharedChannel = newChannel
        
        // Set the one and only handler on the shared method channel. This handler checks the
        // method name (which also contains the port name) and routes it to the correct
        // bridge handler.
        newChannel.setMethodCallHandler() {
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // All calls that arrive here are coming from the other side of the bridge.
            // The method names there are constructed using the same rules as this side.
            // Therefore, we expect the method name to include the port name.
            // Our handlers in the bridge are kept in a dictionary, where the keys are strings
            // that also follow that rule.
            let methodName = call.method
            let a = bridgeHandlers
            guard let handler = bridgeHandlers[methodName] else {
                result(FlutterMethodNotImplemented)
                return
            }
            
            do {
                // This value will be whatever is returned by the handler that was registered
                // in the bridge. It may return nothing, in which case the Flutter side will
                // receive a null.
                let val = try handler(call.arguments)
                // In case the handler returns void, we'll get an empty tuple.
                // Check if that's the case, and if so, replace it with nil. Otherwise, the
                // empty tuple causes a crash when the method handler tries to serialize it.
                // (If the value is not void, then the cast will fail and compare false.)
                result(val as! () == () ? nil : val)
            } catch let error {
                result(FlutterError(code: "bridge-handler-execution-error", message: "iOS handler for method \(methodName) failed.", details: error.localizedDescription))
            }
            return
        }
    }
    
    /// Implementation of the method bridge port. See the protocol to see how to use a port.
    fileprivate class MethodChannelBridgePortImpl: MethodChannelBridgePort {
        private let portName: String
        
        fileprivate init(portName: String) {
            self.portName = portName
        }
        
        func call(_ methodName: String) {
            return call(methodName, withArguments: nil)
        }
        
        func call(_ methodName: String, withArguments args: Any?) {
            return call(methodName, withArguments: args) { _ in }
        }
        
        func call(_ methodName: String, withArguments args: Any?, onError errorCallback: @escaping (MethodChannelBridgeException) -> Void) {
            return call(methodName, withArguments: args, onError: errorCallback) { _ in }
        }
        
        func call(_ methodName: String, withArguments args: Any?, onError errorCallback: @escaping (MethodChannelBridgeException) -> Void, onSuccess successCallback: @escaping (Any?) -> Void) {
            // I considered making this an async function, but requiring iOS 13 just for that
            // doesn't seem worth it.
            
            // If the channel is still nil, that can only mean the bridge hasn't been initialized yet.
            guard let channel = MethodChannelBridge.sharedChannel else {
                errorCallback(MethodChannelBridgeException(MethodChannelBridgeExceptionCause.bridgeNotInitialized))
                return
            }
            
            // Invoke the method using the method channel.
            // We'll call either the error callback or the success callback depending on the
            // value.
            channel.invokeMethod("\(portName).\(methodName)", arguments: args) {
                (value: Any?) -> Void in
                if (value is FlutterError) {
                    errorCallback(MethodChannelBridgeException(MethodChannelBridgeExceptionCause.methodExecutionFailed))
                }
                else if (FlutterMethodNotImplemented.isEqual(value)) {
                    errorCallback(MethodChannelBridgeException(MethodChannelBridgeExceptionCause.receiverNotFound))
                } else {
                    successCallback(value)
                }
            }
        }
        
        func registerHandler(_ handlerName: String, _ handler: @escaping BridgeHandler) {
            let fullHandlerName = "\(portName).\(handlerName)"
            if (bridgeHandlers[fullHandlerName] != nil) {
                NSLog("Method \(handlerName) has already been registered for port \(portName) in the bridge, and will be discarded!")
            }
            
            bridgeHandlers[fullHandlerName] = handler
        }
        
        func unregisterHandler(_ handlerName: String) {
            bridgeHandlers.removeValue(forKey: handlerName)
        }
        
        func unregisterAllHandlers() {
            let filtered = bridgeHandlers.filter() {
                $0.key.hasPrefix("\(portName).")
            }
            bridgeHandlers.removeAll()
            filtered.forEach { (key: String, value: @escaping BridgeHandler) in
                bridgeHandlers[key] = value
            }
        }
    }
}


/// Represents a port in our method channel bridge that can communicate with the Flutter side.
///
/// A port can be used to send data to the Flutter side, and also register methods that the Flutter side can call.
///
/// You can think of each port as only being able to communicate with the corresponding port (with the same name)
/// on the other side.
protocol MethodChannelBridgePort: AnyObject {
    
    /// Make a method call without arguments and without callbacks.
    /// Note that even though you're not receiving the result of this call, it's a blocking operation that will only complete
    /// when the corresponding method on the other side of the bridge finishes handling the call.
    ///
    /// Do consider also specifying an error callback whenever possible.
    func call(_ methodName: String) -> Void
    /// Make a method call with arguments (which may be null), but without callbacks.
    /// Note that even though you're not receiving the result of this call, it's a blocking operation that will only complete
    /// when the corresponding method on the other side of the bridge finishes handling the call.
    ///
    /// Do consider also specifying an error callback whenever possible.
    func call(_ methodName: String, withArguments args: Any?) -> Void
    /// Make a method call with arguments (which may be null) and an error handler, which will be called once if the call
    /// fails. It is highly recommended to always specify an error callback.
    func call(_ methodName: String, withArguments args: Any?, onError errorCallback: @escaping (MethodChannelBridgeException) -> Void)
    /// Make a method call with arguments (which may be null) and handlers for error and success. Either one of the
    /// handlers will be called exactly once.
    ///
    /// There must be a port on the Flutter side with the same name as this port with a registered handler with the method
    /// name specified in this method.
    ///
    /// If a corresponding port with a corresponding method handler doesn't exist in the Flutter side, or if either side of the bridge
    /// hasn't finished initializing, the error callback will be called receiving an exception as parameter. Otherwise, the success
    /// callback will be called receiving what the Flutter method returned (may be null).
    func call(_ methodName: String, withArguments args: Any?, onError errorCallback: @escaping (MethodChannelBridgeException) -> Void, onSuccess successCallback: @escaping (Any?) -> Void)
    
    /// Register a handler for a name. If a different handler was already registered for the same name, it'll be discarded
    /// in favor of this one.
    ///
    /// Note that this does not directly register a handler in the method channel. This handler is stored on the bridge, and
    /// when some message comes through the method channel, the bridge routes it to the correct handler.
    ///
    /// Handlers are allowed to throw, but avoid that because anything that's thrown gets turned into an error that's sent to
    /// the Flutter side of the bridge.
    ///
    /// Anything that's returned by the handler reaches the other side of the bridge, but the return value must be void or a
    /// serializable value.
    func registerHandler(_ handlerName: String, _ handler: @escaping BridgeHandler)
    
    /// Unregister a handler by name.
    func unregisterHandler(_ handlerName: String)
    
    /// Unregister all handlers for this port.
    func unregisterAllHandlers()
}

/// Custom exception that represents some problem when calling methods on the Flutter side.
class MethodChannelBridgeException: NSObject, LocalizedError {
    public let cause: MethodChannelBridgeExceptionCause
    
    fileprivate init(_ cause: MethodChannelBridgeExceptionCause) {
        self.cause = cause
    }
    
    public override var description: String { return "Bridge error with cause \(cause)" }
    
    var errorDescription: String? {
        get {
            return self.description
        }
    }
}

enum MethodChannelBridgeExceptionCause {
    case receiverNotFound
    case bridgeNotInitialized
    case methodExecutionFailed
}
