//
//  BaseBlocAdapter.swift
//  Runner
//
//  Created by Rafael Takahashi on 09/03/23.
//

import Foundation

/// This protocol specifies only the methods from the concrete bloc adapter
/// that needs to be used by the base class.
/// It's a way of implementing what I originally intended to be abstract methods,
/// but abstract classes don't exist in Swift. And anyway, this aligns well with
/// the job of a delegate.
protocol BlocAdapterDelegate: AnyObject {
    /// Any class that represents the corresponding bloc's state
    /// and is used by the pages.
    associatedtype S
    
    /// Converts a message received through the method channel
    /// into an object that represents the bloc's state.
    func messageToState(data: Any) -> S
}

/// Pseudo-abstract class. Has methods that need to be inherited into the
/// concrete bloc adapters.
///
/// This class can be used directly, but should not. Bloc adapter classes
/// should initialize this with a delegate (typically the bloc adapter itself)
/// to provide needed information. The bloc adapter can use the send method
/// to send messages.
class BaseBlocAdapter<D: BlocAdapterDelegate> {
    typealias BlocListener = (D.S) -> Void
    
    private let _blocName: String
    private let _delegate: D
    private let _bridgePort: MethodChannelBridgePort
    private var _callbackName: String?
    private var _cachedState: D.S
    private var _listeners: [String: BlocListener]
    
    /// Instantiate this class with a delegate that provides functionality that the
    /// methods in this class need, and a binary messenger that's necessary
    /// for opening the method chanel.
    /// The initial state is not very important because this class will attempt to
    /// obtain the current state from the Flutter bloc right away.
    internal init(_ blocName: String, withDelegate delegate: D, andInitialState initialState: D.S) {
        self._delegate = delegate
        
        _blocName = blocName
        _bridgePort = MethodChannelBridge.openPort("bloc/\(blocName)")
        
        _cachedState = initialState
        _listeners = Dictionary<String, BlocListener>()
    }
    
    /// Informs the Flutter bloc that this bloc adapter would like to be notified
    /// of state changes.
    /// This is not automatically done during initialization because the corresponding
    /// Flutter bloc needs to be initialized to receive the registerCallback call.
    /// This should be called from `listen()`. This way, the callback will only be
    /// set up when someone wants to use this adapter.
    private func setUpCallback() {
        // If a callback name has already been created,
        // then this bloc adapter is already listening to changes
        // from the Flutter bloc and initialization is not necessary.
        if (_callbackName != nil) {
            return
        }
        
        // The callback name is simply the name of a function that the
        // Flutter bloc will call to notify the native code about
        // state changes.
        // The callback is not called automatically because an adapter
        // is not guaranteed to exist for every Flutter bloc.
        //
        // The method name can be anything. I'm appending a random part to avoid collisions.
        // Collisions are theoretically impossible because only one instance of each bloc
        // adapter should exist at any given time. If you need multiple adapters for the same
        // bloc, you'll need to make further modifications to the code.
        _callbackName = "updateState-\(UUID().uuidString)"
        
        // Rather than use the method channel directly, here we're using our bridge which
        // centralizes all method channel logic.
        _bridgePort.call("registerCallback", withArguments: _callbackName)
        
        _bridgePort.registerHandler(_callbackName!) {
            [weak self] (params) -> Void in
            self?.updateState(message: params)
        }
        
        // Get the state for the first time, otherwise this
        // adapter will use the initialState until the next
        // state change. The initialState is only a safety
        // measure.
        self.syncStateWithFlutter()
        
    }
    
    deinit {
        guard let cn = _callbackName else {
            return
        }
        _bridgePort.unregisterHandler(cn)
    }
    
    private func syncStateWithFlutter() -> Void {
        let blocName = _blocName
        _bridgePort.call("getCurrentState", withArguments: nil, onError: { exception in
            NSLog("Adapter \(blocName) failed to get current state. Continuing with initial state. Error: \(exception.localizedDescription)")
        }) {
            [weak self] (params) -> Void in
            self?.updateState(message: params)
        }
        
    }
    
    private func updateState(message: Any?) -> Void {
        // Use the delegate to convert this message, then update
        // the cached state and notify all listeners.
        guard let _message = message else {
            print("Message from Flutter was null; Skipping updateState.")
            return
        }
        let converted: D.S = _delegate.messageToState(data: _message)
        _cachedState = converted
        // Send this converted value to the listeners
        for (_, value) in _listeners {
            value(converted)
        }
    }
    
    /// This method is expected to be used only by subclasses of BaseBlocAdapter.
    /// Only those subclasses are expected to know what format that the Flutter bloc
    /// understands.
    ///
    /// This sends a Dictionary through the method channel, and we expect the
    /// Flutter bloc to know how to interpret it.
    func send(message: [String : Any]) {
        let blocName = _blocName
        _bridgePort.call("sendEvent", withArguments: message) {
            error in
            NSLog("Adapter \(blocName) failed to send message: \(message), error: \(error.localizedDescription)")
        }
    }
    
    /// Register to listen to the stream of the corresponding bloc.
    /// This will return a handle that must be used to unregister the
    /// listener when it's no longer needed.
    ///
    /// Note that the exact mechanism of this "observable" doesn't matter;
    /// if you use something else for your observables (ex.: RxSwift), then you
    /// should use that instead. This project is a minimal example without any
    /// libraries.
    func listen(_ callback: @escaping BlocListener) -> String {
        self.setUpCallback()
        
        let handle = UUID().uuidString
        _listeners[handle] = callback
        return handle
    }
    
    func clearListener(ofHandle handle: String) -> Void {
        _listeners.removeValue(forKey: handle)
    }
    
    /// Get the current state of this bloc adapter. It is guaranteed to correspond to
    /// the latest data received from the Flutter bloc. It will be the initial state if nothing
    /// was received so far, but that is not expected to ever be the case.
    func currentState() -> D.S {
        return _cachedState
    }
    
}
