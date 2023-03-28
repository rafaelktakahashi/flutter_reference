//
//  InteropNavigator.swift
//  Runner
//
//  Created by Rafael Takahashi on 27/03/23.
//

import Foundation

/// This native navigator is provided mostly just as an example of how you can use the bridge from your own navigator
/// in order to receive messages from Flutter.
///
/// Once created, this navigator will listen to calls from the Flutter side.
class InteropNavigator {
    // Prevent more than one instance of this class from existing.
    // This is not mandatory, and your navigator may work in a different way.
    // What matters here is how this class uses the bridge to listen to calls
    // from Flutter.
    static var _instance: InteropNavigator?
    
    private let _fController: FlutterViewController
    
    private let _bridgePort: MethodChannelBridgePort
    
    /// Creates a new navigator, but returns a previous instance if one has been built before.
    static func buildNavigator(withFlutterController flutterViewController : FlutterViewController) -> InteropNavigator {
        if (_instance == nil) {
            _instance = InteropNavigator(withFlutterController: flutterViewController)
        }
        
        return _instance!
    }
    
    /// Returns the navigator that's currently instantiated, but will return nil if none has been built yet.
    static func getNavigator() -> InteropNavigator? {
        return _instance
    }
    
    private init(withFlutterController flutterViewController : FlutterViewController) {
        self._fController = flutterViewController
        
        // Use our bridge to connect to the Flutter side instead of creating a
        // method channel directly. The bridge exposes calls and responses more
        // conveniently, centralizes all method channl logic in a single channel,
        // and also frees other classes from having to worry about the binary messenger.
        self._bridgePort = MethodChannelBridge.openPort("InteropNavigator")
        
        // The callback itself is not really worth explaining, because you could
        // implement yours however you want (for example, using your preferred navigation
        // library). What's important is that the parameters that are expected on this side
        // of the bridge must match what the Flutter InteropNavigator sends.
        self._bridgePort.registerHandler("navigate") {[weak self] params in
            if let paramsDict = params as? Dictionary<String, Any> {
                if let pageName = paramsDict["pageName"] as? String {
                    do {
                        if let pageParameters = paramsDict["parameters"] as? Dictionary<String, Any>? {
                            try self?.navigate(toPage: pageName, withParameters: pageParameters)
                        } else {
                            try self?.navigate(toPage: pageName, withParameters: nil)
                        }
                        
                        return
                    } catch is RouteNotFoundError {
                        NSLog("Navigator.navigate could not navigate to requested page \(pageName).")
                        return
                    }
                } else {
                    NSLog("Navigator.navigate didn't receive the page name.");
                    return
                }
            } else {
                NSLog("Navigator.navigate received parameter different from a dictionary, which is not allowed.");
                return
            }
        }
    }
    
    // This function can also be called from elsewhere in native code, but it's primarily
    // intended to handle calls from Flutter.
    func navigate(toPage pageName: String, withParameters parameters: Dictionary<String,Any>?) throws {
        switch (pageName) {
        case "counter":
            let sb = UIStoryboard(name: "NativePage", bundle: nil)
            let uiController = sb.instantiateViewController(withIdentifier: "nativepage")
            
            // You could also read the parameters and set them in the controller if you want,
            // but in this example we don't need them.
            
            self._fController.present(uiController, animated: true)
        default:
            throw RouteNotFoundError()
        }
    }
    
    fileprivate class RouteNotFoundError: Error {}
}
