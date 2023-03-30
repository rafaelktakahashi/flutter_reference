//
//  InteropRepository.swift
//  Runner
//
//  Created by Rafael Takahashi on 29/03/23.
//

import Foundation

/// iOS side of the interop repository.
///
/// Use this class as a superclass of any repository that needs to make calls to a Flutter repository or expose its methods to the
/// Flutter side.
///
/// An instance of this class will be able to communicate with the corresponding repository on the other side, which has been
/// instantiated with the same name.
///
/// Most of the work this class does is simply encapsulating calls to the bridge. If that sounds like it doesn't save any work, that's
/// mostly true; this is just organizational, so that changes in our bridge's API don't have to affect every concrete repository.
///
/// Do not instantiate this class directly. This is meant to be the superclass of all concrete repositories that need to expose their
/// methods to the other side of the bridge or call repositories on the other side of the bridge.
/// Repositories that do not need to integrate with the Flutter side don't need to inherit from this class.
///
/// The concrete repository is expected to provide the name (to use in the port). The name must be the same as another repository
/// that exists on the Flutter side.
class InteropRepository {
    private let bridgePort: MethodChannelBridgePort;
    
    init(withRepositoryName name: String) {
        self.bridgePort = MethodChannelBridge.openPort("repository/\(name)")
    }
    
    /// Call a Flutter function that exists in a Flutter repository of the same name as this one.
    func call(_ methodName: String, withArguments args: Any?, onError errorCallback: @escaping (MethodChannelBridgeException) -> Void, onSuccess successCallback: @escaping (Any?) -> Void) {
        bridgePort.call(methodName, withArguments: args, onError: errorCallback, onSuccess: successCallback)
    }
    
    /// Method to be called by concrete implementations to expose a method to be used on the other side of the bridge.
    /// Anything returned should be serializable. That means primitive types, strings and collections are fine, but send
    /// dictionaries instead of objects.
    ///
    /// In the InteropRepository, we only expose the non-blocking version of handlers, because all functions of a repository
    /// are expected to be non-blocking. This somewhat complicates the syntax (and you can simplify it by using async functions
    /// if you don't need support for iOS 12), but should definitely be used when you would otherwise block the thread.
    ///
    /// The first parameter of the handler is a variable with whatever came from the Flutter side. The second and third parameters,
    /// respectively, are fulfil and reject methods that should be called once.
    func exposeMethod(_ handlerName: String, _ handler: @escaping (Any?, @escaping (Any?) -> Void, @escaping (Any?) -> Void) -> Void) {
        bridgePort.registerHandler(handlerName, handler)
    }
    
}
