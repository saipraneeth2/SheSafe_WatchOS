// EmergencyManager.swift
// Manages emergency contact storage and call triggering

import SwiftUI
import WatchKit
import Combine

class EmergencyManager: ObservableObject {

    static let shared = EmergencyManager()

    // MARK: - Published Properties
    @Published var emergencyContactName: String = ""
    @Published var emergencyContactPhone: String = ""
    @Published var isCallActive: Bool = false
    @Published var countdownValue: Int = 5
    @Published var appState: AppState = .idle

    // MARK: - Private
    private var countdownTimer: Timer?
    private let defaults = UserDefaults.standard

    enum AppState {
        case idle
        case countdown
        case calling
        case cancelled
    }

    private init() {
        loadContact()
    }

    // MARK: - Contact Persistence
    func saveContact(name: String, phone: String) {
        emergencyContactName = name
        emergencyContactPhone = phone
        defaults.set(name, forKey: "emergency_name")
        defaults.set(phone, forKey: "emergency_phone")
        print("Emergency contact saved: \(name) - \(phone)")
    }

    private func loadContact() {
        emergencyContactName = defaults.string(forKey: "emergency_name") ?? ""
        emergencyContactPhone = defaults.string(forKey: "emergency_phone") ?? ""
    }

    // MARK: - Emergency Trigger
    func triggerEmergency() {
        guard appState == .idle else { return }

        appState = .countdown
        countdownValue = 5

        // Haptic feedback — strong pulse
        WKInterfaceDevice.current().play(.failure)

        startCountdown()
    }

    func cancelEmergency() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        appState = .cancelled

        WKInterfaceDevice.current().play(.success)

        // Reset to idle after 2s
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.appState = .idle
        }
    }

    private func startCountdown() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }

            if self.countdownValue > 1 {
                self.countdownValue -= 1
                WKInterfaceDevice.current().play(.click)
            } else {
                timer.invalidate()
                self.placeEmergencyCall()
            }
        }
    }

    private func placeEmergencyCall() {
        appState = .calling
        WKInterfaceDevice.current().play(.notification)

        let phone = emergencyContactPhone.isEmpty ? "112" : emergencyContactPhone
        let cleanPhone = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

        // Open phone call via WatchOS URL scheme
        if let url = URL(string: "tel://\(cleanPhone)") {
            WKExtension.shared().openSystemURL(url)
        }

        isCallActive = true

        // Reset state after 10s
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.appState = .idle
            self.isCallActive = false
        }
    }

    // MARK: - Location Share (Optional Extension)
    func shareLocation() {
        // In production: use CoreLocation + URLSession to POST GPS coords
        // to a backend or send via iMessage using MFMessageComposeViewController
        print("Location shared with emergency contact.")
    }
}
