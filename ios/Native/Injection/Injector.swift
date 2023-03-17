//
//  Injector.swift
//  Runner
//
//  Created by Rafael Takahashi on 10/03/23.
//

import Foundation

/// This project doesn't have real dependency injection anywhere, as it is
/// a minimal example of using blocs in native code. In a real project, you
/// should use the DI library of your choice instead of this.
class Injector {
    private var objects: [String:Any] = Dictionary<String, Any>()
    
    private init() {}
    
    static var shared: Injector = {
        // This class is a singleton. But that's not very
        // important; you should be using a real DI lib.
        let instance = Injector()
        return instance
    } ()
    
    /// Register an object that will become available anywhere with a certain name.
    func registerObject(_ value: Any, withName name: String) {
        objects[name] = value
    }
    
    /// Attempt to get a certain object with a certain type.
    /// If the object with the specified name has not been registered or
    /// the cast fails, then this throws an InjectionError.
    func read<T>(_ name: String) throws -> T {
        if let o = objects[name] as? T {
            return o
        } else {
            throw InjectionError.runtimeError("Instance of name \(name) not found in the injector!")
        }
    }

}

extension Injector: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

enum InjectionError: Error {
    case runtimeError(String)
}
