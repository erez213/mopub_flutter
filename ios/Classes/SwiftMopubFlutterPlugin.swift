import Flutter
import UIKit
import MoPubSDK

public class SwiftMopubFlutterPlugin: NSObject, FlutterPlugin {
  var isInitializedSdk:Bool = false
  public static func register(with registrar: FlutterPluginRegistrar) {
    print("register mopub plugin")
    let channel = FlutterMethodChannel(name: MopubConstants.MAIN_CHANNEL, binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(SwiftMopubFlutterPlugin(), channel: channel)
    
    // Banner Ad PlatformView channel
    registrar.register(
        MopubBannerAdPlugin(messeneger: registrar.messenger()),
        withId: MopubConstants.BANNER_AD_CHANNEL
    )
    
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult)  {
    print("start mopub method")
    let args = call.arguments as? [String : Any] ?? [:]
    let testMode:Bool = args["testMode"] as? Bool ?? false
    let adUnitId:String = args["adUnitId"] as? String ?? ""
    print("call this method")
    print(adUnitId)
    switch call.method {
    case MopubConstants.INIT_METHOD:
        let sdkConfig = MPMoPubConfiguration(adUnitIdForAppInitialization: adUnitId)
        sdkConfig.loggingLevel = testMode ? .debug : .debug
        
        MoPub.sharedInstance().initializeSdk(with: sdkConfig) {
            //SDK initialized
            self.isInitializedSdk = true
            
        }
        result(self.isInitializedSdk)
        break
    default:
        result(FlutterMethodNotImplemented)
    }
    result(self.isInitializedSdk)
    //return self.isInitializedSdk
  }
}
