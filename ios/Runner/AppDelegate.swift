import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    private let channelName = "com.example.flutter_challenge/comments"

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller = window?.rootViewController as! FlutterViewController
        let commentsChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)
        
        commentsChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "getComments" {
                if let args = call.arguments as? [String: Any],
                   let postId = args["postId"] as? Int {
                    self.fetchComments(postId: postId, result: result)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "postId missing", details: nil))
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func fetchComments(postId: Int, result: @escaping FlutterResult) {
        let urlString = "https://jsonplaceholder.typicode.com/comments?postId=\(postId)"
        guard let url = URL(string: urlString) else {
            result(FlutterError(code: "INVALID_URL", message: "URL is invalid", details: nil))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                result(FlutterError(code: "NETWORK_ERROR", message: error.localizedDescription, details: nil))
                return
            }
            
            guard let data = data else {
                result(FlutterError(code: "NO_DATA", message: "No data received", details: nil))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                result(jsonString)  // 👈 Devolvemos el JSON como String
            } else {
                result(FlutterError(code: "STRING_ENCODING_ERROR", message: "Failed to encode data to string", details: nil))
            }
        }
        
        task.resume()
    }
}
