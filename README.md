# SheSafe - Women's Safety App for Apple Watch

> "I've had this idea since I was young. Women deserve a way to call for help without anyone noticing."
> - Sai Praneeth Medisetti, Creator

---

## The Story Behind SheSafe

From a young age, I always thought about women's safety. In a dangerous moment, reaching for a phone, unlocking it, finding an app, and pressing a button takes too long. Too many steps. Too much visibility.

That one thought stayed with me for years: what if help was just three presses away?

When AI tools became powerful enough to help me bring ideas to life, I finally built it. I worked with Claude AI (by Anthropic) to develop SheSafe, my first Apple Watch app. The idea, the concept, and the purpose are entirely mine. Claude helped me write the Swift code and structure the project.

SheSafe is currently in its early stage but it works, it runs on Apple Watch, and the core SOS feature is fully functional. This is just the beginning.

---

## What SheSafe Does

SheSafe is a watchOS safety app built for women. In any dangerous situation, without taking out your phone and without looking at your wrist, you press the Digital Crown 3 times.

That's it.

The watch vibrates, starts a 5-second silent countdown, and then automatically calls your emergency contact. If it was a false alarm, one tap cancels it.

No unlocking. No searching. No typing. Just three presses.

---

## Features

- Triple Crown Press Detection - press the Digital Crown 3 times within 2 seconds to trigger SOS
- Haptic Feedback - the watch buzzes on each press so you know it registered
- 5-Second Countdown - time to cancel if it was accidental
- Auto Emergency Call - calls your saved contact via the watch phone capability
- One-Tap Cancel - safely abort at any point during countdown
- Emergency Contact Storage - saves name and number locally on the watch
- 4 Animated Screens - Idle, Countdown, Calling, and Cancelled states with smooth transitions

---

## Tech Stack

| Technology | Usage |
|------------|-------|
| Swift | Core programming language |
| SwiftUI | All UI screens and animations |
| watchOS 10+ | Target platform |
| WKCrownDelegate | Digital Crown interaction detection |
| WKInterfaceDevice | Haptic feedback control |
| WKExtension | Emergency call via tel:// URL scheme |
| UserDefaults | Local emergency contact storage |
| XCTest | 28 automated unit and UI tests |

---

## Project Structure

```
SheSafe/
├── SheSafe Watch App/
│   ├── SheSafeApp.swift          # App entry point + WKApplicationDelegate
│   ├── ContentView.swift         # All 4 screens (Idle, Countdown, Calling, Cancelled)
│   ├── EmergencyManager.swift    # SOS logic, countdown timer, contact storage
│   └── CrownPressDetector.swift  # Triple crown press detection (WKCrownDelegate)
├── SheSafeTests/
│   └── SheSafeTests.swift        # 24 unit tests for EmergencyManager + CrownPressDetector
└── SheSafeUITests/
    └── SheSafeUITests.swift      # UI tests for all app screens
```

---

## How to Run

### Requirements
- Mac with macOS 13 (Ventura) or later
- Xcode 15 or later
- Apple Watch (Series 4+) running watchOS 10+ or the Xcode Watch Simulator

### Steps

```bash
# 1. Clone the repo
git clone https://github.com/saipraneeth2/SheSafe_WatchOS.git

# 2. Open in Xcode
cd SheSafe_WatchOS
open SheSafe.xcodeproj
```

3. Select your target device (Watch Simulator or paired Apple Watch)
4. Press Cmd + R to build and run
5. To run tests: press Cmd + U

Note: The actual phone call only works on a real Apple Watch, not the simulator. All screens and animations work in the simulator.

---

## Testing

SheSafe has 28 automated tests covering all core features:

| Test Suite | Tests | What It Covers |
|------------|-------|----------------|
| EmergencyManagerTests | 12 | Countdown logic, contact saving, state transitions |
| CrownPressDetectorTests | 12 | Triple press detection, timeout window, press counting |
| IntegrationTests | 4 | Full SOS flow end-to-end |
| UITests | 10 | Screen rendering, button interactions, app stability |

Run all tests with Cmd + U in Xcode.

---

## Roadmap - Future Plans

This is an early stage project. Here is what I want to build next:

- [ ] Live GPS Location Sharing - automatically send location to emergency contact via SMS
- [ ] Loud Alarm Mode - optional siren sound when SOS triggers
- [ ] Multiple Emergency Contacts - call a priority list, not just one number
- [ ] Shake Detection - alternative trigger for users who cannot press crown
- [ ] Apple Watch Complication - always visible shield icon on watch face
- [ ] iOS Companion App - manage contacts and settings from iPhone
- [ ] App Store Release - submit to Apple Watch App Store

---

## Built With AI Assistance

This project was conceptualized, designed, and directed by me, Sai Praneeth Medisetti. I have had the idea of a women's safety wearable feature since I was young, and this is my first step toward building it.

The Swift and SwiftUI code was developed with the help of Claude AI by Anthropic. Using AI as a development partner allowed me to bring this idea to life even as someone learning iOS and watchOS development. I believe this is the future of building - having an idea that matters, and using the best tools available to make it real.

Idea and Concept: Sai Praneeth Medisetti
Code: AI-assisted development using Claude by Anthropic
Purpose: Make women safer, one wrist tap at a time

---

## License

MIT License - free to use, learn from, and build on.

---

## Acknowledgements

- Anthropic and Claude AI for helping me write the Swift code and structure this project
- Apple for watchOS and the WKCrownDelegate API that makes this feature possible
- Every woman who deserves to feel safer

---

Made with love and a purpose

SheSafe - Because safety should not require looking at your phone.

Star this repo if you think this idea matters!
