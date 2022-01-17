import Flutter
import UIKit

public class SwiftAccessControlPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "access_control", binaryMessenger: registrar.messenger())
        let instance = SwiftAccessControlPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "createAccessRequest":
            self.createAccessRequest(call, result)
        case "checkAccessRequest":
            self.checkAccessRequest(call, result)
        case "acceptAccessRequest":
            self.acceptAccessRequest(call, result)
        case "rejectAccessRequest":
            self.rejectAccessRequest(call, result)
        case "resetAccessRequest":
            self.resetAccessRequest(call, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func createAccessRequest(_ call: FlutterMethodCall,_ result: @escaping FlutterResult){
        guard let args = call.arguments as? Dictionary<String, String> else {
            result(
                FlutterError(
                    code: "invalidArgs",
                    message: "Missing arguments",
                    details: nil
                )
            )
            return
        }
        guard let uri = args["uri"] else {
            result(
                FlutterError(
                    code: "invalidArgs",
                    message: "Missing argument uri",
                    details: nil
                )
            )
            return
        }
        result(nil)
    }
    
    private func checkAccessRequest(_ call: FlutterMethodCall,_ result: @escaping FlutterResult){
        guard let args = call.arguments as? Dictionary<String, String> else {
            result(
                FlutterError(
                    code: "invalidArgs",
                    message: "Missing arguments",
                    details: nil
                )
            )
            return
        }
        guard let owner = args["owner"] else {
            result(
                FlutterError(
                    code: "invalidArgs",
                    message: "Missing argument owner",
                    details: nil
                )
            )
            return
        }
        guard let uri = args["uri"] else {
            result(
                FlutterError(
                    code: "invalidArgs",
                    message: "Missing argument uri",
                    details: nil
                )
            )
            return
        }
        guard let accessKey = args["accessKey"] else {
            result(
                FlutterError(
                    code: "invalidArgs",
                    message: "Missing argument accessKey",
                    details: nil
                )
            )
            return
        }
        result(NSNumber(0))
    }
    
    private func acceptAccessRequest(_ call: FlutterMethodCall,_ result: @escaping FlutterResult){
        guard let args = call.arguments as? Dictionary<String, String> else {
            result(
                FlutterError(
                    code: "invalidArgs",
                    message: "Missing arguments",
                    details: nil
                )
            )
            return
        }
        guard let uri = args["uri"] else {
            result(
                FlutterError(
                    code: "invalidArgs",
                    message: "Missing argument uri",
                    details: nil
                )
            )
            return
        }
        result(nil)
    }
    
    private func rejectAccessRequest(_ call: FlutterMethodCall,_ result: @escaping FlutterResult){
        guard let args = call.arguments as? Dictionary<String, String> else {
            result(
                FlutterError(
                    code: "invalidArgs",
                    message: "Missing arguments",
                    details: nil
                )
            )
            return
        }
        guard let uri = args["uri"] else {
            result(
                FlutterError(
                    code: "invalidArgs",
                    message: "Missing argument uri",
                    details: nil
                )
            )
            return
        }
        result(nil)
    }
    
    private func resetAccessRequest(_ call: FlutterMethodCall,_ result: @escaping FlutterResult){
        guard let args = call.arguments as? Dictionary<String, String> else {
            result(
                FlutterError(
                    code: "invalidArgs",
                    message: "Missing arguments",
                    details: nil
                )
            )
            return
        }
        guard let uri = args["uri"] else {
            result(
                FlutterError(
                    code: "invalidArgs",
                    message: "Missing argument uri",
                    details: nil
                )
            )
            return
        }
        result(nil)
    }
}
