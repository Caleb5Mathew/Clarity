import UIKit
import GoogleSignIn
import ObjectiveC.runtime

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let path = Bundle.main.path(forResource: "credentials", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path),
           let clientID = dict["GIDClientID"] as? String,
           let reversedClientID = dict["REVERSED_CLIENT_ID"] as? String {
            print("[DEBUG] Loaded and Set GIDClientID: \(clientID)")
            print("[DEBUG] Loaded REVERSED_CLIENT_ID: \(reversedClientID)")

            // Inject URL scheme via swizzling
            Bundle.swizzleURLTypes()
            
            // Initialize Google Sign-In
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        } else {
            print("[ERROR] Failed to load GIDClientID from credentials.plist")
        }

        return true
    }
}
