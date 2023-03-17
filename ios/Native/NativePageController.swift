//
//  NativePageController.swift
//  Runner
//
//  Created by Rafael Takahashi on 09/03/23.
//

import UIKit
import Foundation

/// Controller for the native page that displays the Flutter bloc state.
/// This is an example of how you should use a bloc adapter.
class NativePageController: UIViewController {
    
    // The instance of our shared bloc.
    // Only one instance of each bloc adapter should exist,
    // so don't instantiate it here. You can use a singleton,
    // or better yet, a library for dependency injection.
    private var _counterBlocAdapter: CounterBlocAdapter
    
    private var _listenerHandle: String?
    
    required init?(coder: NSCoder) {
        do {
            try self._counterBlocAdapter = Injector.shared.read("counterBlocAdapter")
        } catch {
            // You shouldn't use code like this.
            // Handle it according to your DI library of choice.
            print("counterBlocAdapter was not available!")
            exit(0)
        }
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Subscribe to the counter bloc adapter to get updates from it.
        // If there was already a handle, clear that one first. This may
        // happen because viewDidLoad() can be called more than once during
        // self's life.
        //
        // Note that the exact mechanism of this listener is not important.
        // You can use RxSwift or another library if you prefer (you probably should).
        // I'm using a simple, hand-made observable because this project is a
        // minimal example of Flutter blocs being used in native code.
        // Everything else, including the navigators and dependency injection,
        // is merely an example and is not important.
        if (self._listenerHandle != nil) {
            self._counterBlocAdapter.clearListener(ofHandle: self._listenerHandle!)
        }
        self._listenerHandle = self._counterBlocAdapter.listen { [weak self] counterState in
            DispatchQueue.main.async {
                self?.showStateOnScreen(counterState)
            }
        }
        
        let currentState = _counterBlocAdapter.currentState()
        showStateOnScreen(currentState)
        
    }
    
    deinit {
        // Clear a listener, if there is one.
        // A listener takes up a negligible amount of memory and
        // shouldn't cause crashes because it's an escaping closure,
        // but it's still good manners to clean up.
        // In practice, you should probably use a better observable.
        guard let handle = _listenerHandle else {
            return
        }
        self._counterBlocAdapter.clearListener(ofHandle: handle)
    }
    
    private func showStateOnScreen(_ counterState: CounterState) {
        print("Printing the state.")
        if let counterStateNumber = counterState as? CounterStateNumber {
            self.valueLabel.text = String(counterStateNumber.value)
        } else if let counterStateError = counterState as? CounterStateError {
            self.valueLabel.text = counterStateError.errorMessage
        }
    }
    
    @IBOutlet weak var valueLabel: UILabel!;
    
    @IBAction func addOneButtonPressed(_ sender: UIButton) {
        self._counterBlocAdapter.incrementBy(step: 1)
    }
    
    @IBAction func addFiveButtonPressed(_ sender: UIButton) {
        self._counterBlocAdapter.incrementBy(step: 5)
    }
    
    @IBAction func doubleButtonPressed(_ sender: UIButton) {
        self._counterBlocAdapter.multiplyBy(factor: 2)
    }
    
    @IBAction func tripleButtonPressed(_ sender: UIButton) {
        self._counterBlocAdapter.multiplyBy(factor: 3)
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        self._counterBlocAdapter.reset()
    }

}
