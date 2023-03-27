import UIKit
import Flutter

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
      
      // If you're using the project as a reference, you should use a read DI library here.
      // The main limitation is that the bloc adapters need a binary messenger in order to
      // open the method channel.
      Injector.shared.registerObject(CounterBlocAdapter(), withName: "counterBlocAdapter")
      
      Injector.shared.registerObject(InteropNavigator.buildNavigator(withFlutterController: controller), withName: "navigator")
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
}
