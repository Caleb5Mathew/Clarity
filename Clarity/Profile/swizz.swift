//
//  swizz.swift
//  Clarity
//
//  Created by user269258 on 2/20/25.
//
import UIKit
import GoogleSignIn

extension Bundle {
    // Swizzled Method
    @objc func swizzled_objectForKey(_ key: String) -> Any? {
        if key == "CFBundleURLTypes" {
            print("[DEBUG] Swizzled CFBundleURLTypes Called")

            // Inject the URL scheme
            let urlType: [String: Any] = [
                "CFBundleTypeRole": "Editor",
                "CFBundleURLSchemes": ["com.googleusercontent.apps.647672598237-prpllfhl5qu973b4d9rnnheao11kdjle"]
            ]
            return [urlType]
        }
        
        // Call the original method
        return self.swizzled_objectForKey(key)
    }

    // Swizzle Method
    static func swizzleURLTypes() {
        guard self === Bundle.self else { return }
        
        let originalSelector = #selector(Bundle.object(forInfoDictionaryKey:))
        let swizzledSelector = #selector(Bundle.swizzled_objectForKey(_:))

        guard let originalMethod = class_getInstanceMethod(Bundle.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(Bundle.self, swizzledSelector) else {
            print("[ERROR] Method swizzling failed.")
            return
        }

        method_exchangeImplementations(originalMethod, swizzledMethod)
        print("[DEBUG] Swizzled CFBundleURLTypes to inject URL scheme.")
    }
}
