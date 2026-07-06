# omni_clean

A flutter-based Android utility app for automated phone storage management, subscription handling and private media handling. Built to reduce manual cleanup by detecting unused storage, recurring subscriptions, and organizing sensitive files automatically in the background.

Status: In active development — core features implemented, currently being tested and refined.

## Features(in progress)

-Storage Scanner :scans device storage to identify unused or duplicate media and files
-Subscription Detection: identifies recurring app subscriptions to help users track and manage spend
-Safe Vault: a private, protected space for sensitive media within the app
-Background Task Dispatcher: uses Android's WorkManager to run scans and checks automatically without user intervention
-Geo Zone Manager: location-aware zones that can trigger automated app behavior
-Notifications & Reports: summarizes findings (storage freed, subscriptions found) to the user

## Tech Stack
-Flutter / Dart — cross-platform UI and app logic
-Kotlin native Android integration (notification listener service, platform channels)
-WorkManager — reliable background task scheduling on Android
-Swift — iOS platform support

## Project Structure
lib/
background/     # Background task logic (storage scanning, dispatch, geofencing)
models/          # Data models (media items, subscriptions, geo zones)
screens/         # UI screens (home, vault)
services/        # Core services (notifications, reports, vault, subscriptions)
android/           # Android-specific native code
ios/               # iOS-specific native code

## Getting Started

This is a standard Flutter project. To run it locally:

```bash
flutter pub get
flutter run
```

Requires Flutter SDK and a connected Android/iOS device or emulator.

## Notes

This project is being built independently as a learning and portfolio project, with ongoing work on background task reliability and permissions handling on Android.
