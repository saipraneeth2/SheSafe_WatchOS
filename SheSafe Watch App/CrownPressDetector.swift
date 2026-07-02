// CrownPressDetector.swift
// Detects triple Digital Crown press and triggers emergency

import SwiftUI
import WatchKit
import Combine

class CrownPressDetector: NSObject, ObservableObject, WKCrownDelegate {

    static let shared = CrownPressDetector()

    // MARK: - Published
    @Published var pressCount: Int = 0
    @Published var isListening: Bool = true
    @Published var crownAnimating: Bool = false

    // MARK: - Private
    private var pressResetTimer: Timer?
    private let requiredPresses = 3
    private let pressWindow: TimeInterval = 2.0  // 2 seconds to complete 3 presses
    private var crownAccumulator: Double = 0.0
    private var lastCrownTime: Date = Date()

    private override init() {
        super.init()
    }

    // MARK: - Keep Active
    func keepActive() {
        isListening = true
    }

    // MARK: - WKCrownDelegate
    // Called on each significant crown rotation event (simulates "press" via rapid clicks)
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        // Detect rapid back-and-forth flick (simulates press gesture)
        crownAccumulator += abs(rotationalDelta)

        if crownAccumulator >= 0.15 {
            crownAccumulator = 0
            registerCrownPress()
        }
    }

    func crownDidBecomeIdle(_ crownSequencer: WKCrownSequencer?) {
        // Reset accumulator when crown stops
        crownAccumulator = 0
    }

    // MARK: - Press Registration (also callable from UI for button-based trigger)
    func registerCrownPress() {
        guard isListening else { return }

        pressCount += 1
        crownAnimating = true

        // Haptic on each press
        WKInterfaceDevice.current().play(.click)

        // Visual flash off
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.crownAnimating = false
        }

        // Reset timer — if 3 presses don't happen within window, reset
        pressResetTimer?.invalidate()
        pressResetTimer = Timer.scheduledTimer(withTimeInterval: pressWindow, repeats: false) { [weak self] _ in
            self?.resetPressCount()
        }

        // Check if threshold reached
        if pressCount >= requiredPresses {
            pressResetTimer?.invalidate()
            resetPressCount()
            EmergencyManager.shared.triggerEmergency()
        }
    }

    private func resetPressCount() {
        DispatchQueue.main.async {
            self.pressCount = 0
        }
    }
}

// MARK: - SwiftUI View Modifier for Crown Focus
struct CrownPressModifier: ViewModifier {
    @ObservedObject var detector = CrownPressDetector.shared
    @State private var crownSequencer = WKExtension.shared().visibleInterfaceController?.crownSequencer

    func body(content: Content) -> some View {
        content
            .focusable(true)
            .onAppear {
                crownSequencer?.delegate = detector
                crownSequencer?.isHapticFeedbackEnabled = true
            }
    }
}

extension View {
    func enableCrownDetection() -> some View {
        self.modifier(CrownPressModifier())
    }
}
