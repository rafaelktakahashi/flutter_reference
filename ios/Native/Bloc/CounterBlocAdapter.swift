//
//  CounterBlocAdapter.swift
//  Runner
//
//  Created by Rafael Takahashi on 10/03/23.
//

import Foundation

// MARK: - State

/**
 State class that merely mirrors the one in Flutter.
 In Flutter, there's one abstract class and its specializations (this style
 is rather common for representing a bloc's state); here I'm using fileprivate
 inits in all classes to prevent them from being created elsewhere, since
 only the bloc adapter should know how to create these objects.
 */
class CounterState {
    fileprivate init() {}
}

class CounterStateNumber: CounterState {
    public let value: Int
    fileprivate init(value: Int) {
        self.value = value
        super.init()
    }
}

class CounterStateError: CounterState {
    public let errorMessage: String
    fileprivate init(errorMessage: String) {
        self.errorMessage = errorMessage
        super.init()
    }
}

// MARK: - Delegate

class CounterBlocDelegate: BlocAdapterDelegate {
    typealias S = CounterState
    
    func messageToState(data: Any) -> CounterState {
        // In this method, I'm returning instances of error when something
        // goes wrong, but in a real project you probably wouldn't want to
        // add these error messages to the state if you intend to show them
        // to the user.
        
        // There exists a corresponding encoding logic
        // in the counter bloc (in Flutter).
        if let dict = data as? [String:Any?] {
            if let type = dict["type"] as? String {
                switch (type) {
                case "NUMBER":
                    if let value = dict["value"] as? Int {
                        return CounterStateNumber(value: value)
                    }
                case "ERROR":
                    if let errorMessage = dict["errorMessage"] as? String {
                        return CounterStateError(errorMessage: errorMessage)
                    }
                default:
                    ()
                }
            }
        }
        // In case of any error, fall here.
        return CounterStateError(errorMessage: "Unexpected type of state.")
    }
    
    fileprivate init() {}
}

// MARK: - Adapter

/// Adapter for the counter bloc.
/// This is an example for how you should implement each bloc adapter.
///
/// Importantly, one one instance of each bloc adapter should exist, because each one
/// creates its own method channel. (If you *really* need more than one instance of this class,
/// you'll have to write additional code to share the method channel).
///
/// The main limitation when creating an instance of this class, is that it needs
/// the binary messenger in order to create the method channel.
class CounterBlocAdapter: BaseBlocAdapter<CounterBlocDelegate> {
    typealias S = CounterState
    
    init(withBinaryMessenger binaryMessenger: FlutterBinaryMessenger) {
        super.init("counter", withDelegate: CounterBlocDelegate(), andBinaryMessenger: binaryMessenger, andInitialState: CounterStateNumber(value: 0))
    }
    
    func incrementBy(step: Int) {
        super.send(message: ["type": "INCREMENT", "step": step])
    }
    
    func multiplyBy(factor: Int) {
        super.send(message: ["type": "MULTIPLY", "factor": factor])
    }
    
    func reset() {
        super.send(message: ["type": "RESET"])
    }
    
}
