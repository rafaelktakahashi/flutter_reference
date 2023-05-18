import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
      let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
      
      // Initialize the bridge. Any other class that needs to use the method channel, does so
      // through the bridge.
      MethodChannelBridge.initialize(withBinaryMessenger: controller.binaryMessenger)
      
      // If you're using the project as a reference, you should use a real DI library here.
      // The "Injector" is only an example.
      Injector.shared.registerObject(CounterBlocAdapter(), withName: "counterBlocAdapter")
      Injector.shared.registerObject(ProductRepository(), withName: "productRepository")
      
      Injector.shared.registerObject(InteropNavigator.buildNavigator(withFlutterController: controller), withName: "navigator")
      
      // Initialization for Google Maps. This needs to happen here in the AppDelegate.
      // This project only uses Google Maps in one page, to showcase controller logic.
      // You should use your own key here.
      GMSServices.provideAPIKey("--PLACE_YOUR_KEY_HERE--")
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
}
