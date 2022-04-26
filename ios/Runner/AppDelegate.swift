import UIKit
import Flutter
/* import Firebase */
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyCufOj42MG9JnoIvWnxSq7v1DRZ_V3E4kY")
    GeneratedPluginRegistrant.register(with: self)
   /*  FirebaseApp.configure() */
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
