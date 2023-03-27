import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
      let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
      // TODO: Refactor the navigator to use the bridge.
      let nativeNavigatorChannel = FlutterMethodChannel(name: "br.com.rtakahashi.playground.flutter_reference/navigator", binaryMessenger: controller.binaryMessenger)
      nativeNavigatorChannel.setMethodCallHandler({
          [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          guard call.method == "navigate" else {
              result(FlutterMethodNotImplemented)
              return
          }
          self?.navigateToNativePage(result: result)
      })
      
      MethodChannelBridge.initialize(withBinaryMessenger: controller.binaryMessenger)
      
      // If you're using the project as a reference, you should use a read DI library here.
      // The main limitation is that the bloc adapters need a binary messenger in order to
      // open the method channel.
      Injector.shared.registerObject(CounterBlocAdapter(), withName: "counterBlocAdapter")
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    // Go to our native page. Of course, in a real project this would be a real navigator.
    private func navigateToNativePage(result: FlutterResult) {
        let sb = UIStoryboard(name: "NativePage", bundle: nil)
        let uiController = sb.instantiateViewController(withIdentifier: "nativepage")
        
        let fController: FlutterViewController = window?.rootViewController as! FlutterViewController
        fController.present(uiController, animated: true)
    }
}
