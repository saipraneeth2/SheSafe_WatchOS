// SheSafeApp.swift
// SheSafe - Women's Safety App for Apple Watch
// Trigger: Press the Digital Crown 3 times → Emergency Alert → Calls Emergency Contact

import SwiftUI
import WatchKit

@main
struct SheSafeApp: App {

    @WKApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(EmergencyManager.shared)
                .environmentObject(CrownPressDetector.shared)
        }
    }
}

// MARK: - App Delegate
class AppDelegate: NSObject, WKApplicationDelegate {

    func applicationDidFinishLaunching() {
        // Register for background tasks if needed
        print("SheSafe launched and ready.")
    }

    func applicationWillResignActive() {
        // Keep crown detector active in background
        CrownPressDetector.shared.keepActive()
    }
}
