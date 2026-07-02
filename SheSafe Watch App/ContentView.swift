// ContentView.swift
// Main UI — shows status, crown press progress, countdown, and emergency screen

import SwiftUI
import WatchKit

struct ContentView: View {

    @EnvironmentObject var emergency: EmergencyManager
    @EnvironmentObject var crownDetector: CrownPressDetector

    var body: some View {
        ZStack {
            switch emergency.appState {
            case .idle:
                IdleView()
            case .countdown:
                CountdownView()
            case .calling:
                CallingView()
            case .cancelled:
                CancelledView()
            }
        }
        .enableCrownDetection()  // Crown focus listener
        .animation(.easeInOut(duration: 0.3), value: emergency.appState)
    }
}

// MARK: - Idle View (Normal State)
struct IdleView: View {

    @EnvironmentObject var emergency: EmergencyManager
    @EnvironmentObject var crownDetector: CrownPressDetector
    @State private var showSetup = false
    @State private var showTip = false

    var body: some View {
        VStack(spacing: 6) {

            // Shield Icon
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.pink.opacity(0.3), Color.clear],
                            center: .center,
                            startRadius: 10,
                            endRadius: 40
                        )
                    )
                    .frame(width: 80, height: 80)

                Image(systemName: "shield.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .foregroundColor(.pink)
                    .scaleEffect(crownDetector.crownAnimating ? 1.3 : 1.0)
                    .animation(.spring(response: 0.2), value: crownDetector.crownAnimating)

                // Crown press dots indicator
                VStack {
                    Spacer()
                    HStack(spacing: 4) {
                        ForEach(0..<3) { i in
                            Circle()
                                .fill(i < crownDetector.pressCount ? Color.pink : Color.gray.opacity(0.4))
                                .frame(width: 6, height: 6)
                        }
                    }
                }
                .frame(height: 80)
            }

            Text("She Safe")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)

            if emergency.emergencyContactName.isEmpty {
                Button(action: { showSetup = true }) {
                    Text("Set Contact")
                        .font(.system(size: 10))
                        .foregroundColor(.pink)
                }
            } else {
                Text("SOS → \(emergency.emergencyContactName)")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }

            Text("Press crown ×3")
                .font(.system(size: 9))
                .foregroundColor(.gray.opacity(0.7))
        }
        .sheet(isPresented: $showSetup) {
            SetupView()
        }
    }
}

// MARK: - Countdown View
struct CountdownView: View {

    @EnvironmentObject var emergency: EmergencyManager

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Pulsing red ring
                Circle()
                    .stroke(Color.red.opacity(0.6), lineWidth: 3)
                    .frame(width: 70, height: 70)
                    .scaleEffect(1.1)
                    .animation(
                        Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true),
                        value: emergency.countdownValue
                    )

                Text("\(emergency.countdownValue)")
                    .font(.system(size: 36, weight: .black))
                    .foregroundColor(.red)
            }

            Text("CALLING SOS")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.red)

            Text(emergency.emergencyContactName.isEmpty ? "Emergency (112)" : emergency.emergencyContactName)
                .font(.system(size: 10))
                .foregroundColor(.white)

            Button(action: { emergency.cancelEmergency() }) {
                Text("CANCEL")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(20)
            }
        }
    }
}

// MARK: - Calling View
struct CallingView: View {

    @EnvironmentObject var emergency: EmergencyManager
    @State private var wave = false

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Animated sound waves
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .stroke(Color.red.opacity(0.4 - Double(i) * 0.1), lineWidth: 2)
                        .frame(width: CGFloat(50 + i * 20), height: CGFloat(50 + i * 20))
                        .scaleEffect(wave ? 1.3 : 1.0)
                        .opacity(wave ? 0 : 1)
                        .animation(
                            Animation.easeOut(duration: 1.0).repeatForever().delay(Double(i) * 0.3),
                            value: wave
                        )
                }

                Image(systemName: "phone.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
                    .padding(13)
                    .background(Color.red)
                    .clipShape(Circle())
            }
            .onAppear { wave = true }

            Text("CALLING...")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.red)

            Text(emergency.emergencyContactName.isEmpty ? "112" : emergency.emergencyContactName)
                .font(.system(size: 11))
                .foregroundColor(.white)

            Text(emergency.emergencyContactPhone)
                .font(.system(size: 10))
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Cancelled View
struct CancelledView: View {
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.green)

            Text("Cancelled")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)

            Text("You're safe")
                .font(.system(size: 11))
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Setup View
struct SetupView: View {

    @EnvironmentObject var emergency: EmergencyManager
    @Environment(\.dismiss) var dismiss

    @State private var name: String = ""
    @State private var phone: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                Text("Emergency Contact")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.pink)

                TextField("Name", text: $name)
                    .textFieldStyle(.plain)
                    .font(.system(size: 12))
                    .padding(6)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                TextField("Phone Number", text: $phone)
                    .textFieldStyle(.plain)
                    .font(.system(size: 12))
                    .padding(6)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                Button(action: {
                    emergency.saveContact(name: name, phone: phone)
                    dismiss()
                }) {
                    Text("Save")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.pink)
                        .cornerRadius(20)
                }
                .disabled(name.isEmpty || phone.isEmpty)
            }
            .padding(.horizontal, 8)
        }
        .onAppear {
            name = emergency.emergencyContactName
            phone = emergency.emergencyContactPhone
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(EmergencyManager.shared)
        .environmentObject(CrownPressDetector.shared)
}
