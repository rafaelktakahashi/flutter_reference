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
/// Once created, this navigator will listen to calls from the Flutter side, and can be used to navigate Flutter pages (but
/// cannot be used to manipulate native pages).
class InteropNavigator {
    // Prevent more than one instance of this class from existing.
    // This is not mandatory, and your navigator may work in a different way.
    // What matters here is how this class uses the bridge to listen to calls
    // from Flutter.
    static var _instance: InteropNavigator?
    
    // This navigator works by having a reference to a Flutter view controller. If you
    // have more than one Flutter view controller in you app (I do not recommend that!),
    // then you'll need to make modifications to this class.
    private let _fController: FlutterViewController
    
    // Keep only one reference to a bridge port.
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
                            try self?.handleNavigate(toPage: pageName, withParameters: pageParameters)
                        } else {
                            try self?.handleNavigate(toPage: pageName, withParameters: nil)
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
    
    /// Navigate to a Flutter page in a view that's already loaded.
    ///
    /// Be careful! This probably doesn't work in the way you expect. This sends a command to the Flutter navigator,
    /// but that won't affect any native pages.
    ///
    /// For example, if you have the following stack:
    ///
    /// A -> B
    ///
    /// Where A is a Flutter page and B is a native page, then navigating to a new Flutter page C will NOT make that page
    /// appear over B. It'll affect only the preexisting Flutter view:
    ///
    /// A -> C -> B
    ///
    /// If you're in a native page and you want to navigate to a new Flutter page, you'll have to also show the Flutter view.
    /// Calling the InteropNavigator only affects the Flutter pages inside the Flutter view.
    func navigateInFlutter(toPageWithUrl url: String, withMethod method: String = "push") {
        // There's an InteropNavigator in Flutter that exposes a "navigate" method, expecting
        // a url and a method.
        // Urls in the Flutter side are implemented in GoRouter, but depending on the project,
        // you can choose a different way of identifying pages.
        self._bridgePort.call("navigate", withArguments: ["url": url, "method": method], onError: {exception in print(exception) }
        )
    }
    
    // This function can also be called from elsewhere in native code, but it's primarily
    // intended to handle calls from Flutter.
    private func handleNavigate(toPage pageName: String, withParameters parameters: Dictionary<String,Any>?) throws {
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
