# 📹 VideoCall Flutter (Agora SDK)

A **Flutter-based real-time video calling application** built using **Agora RTC Engine**. This repository demonstrates how to implement a **1-to-1 video call experience** similar to WhatsApp / Zoom with ringing sound, timeout handling, draggable remote video, and full call controls.

---

## 🚀 What This Repository Does

This project showcases:

* 📞 One-to-one **video calling** using Agora
* 🔔 **Ringing sound** before the other user joins
* ⏳ **Auto-timeout** if the remote user does not join
* 🎥 Local & remote video rendering
* 🔄 Camera switch with animation
* 🎙️ Mute / unmute microphone
* 🧲 Draggable remote video view
* ❌ End call handling with proper cleanup

This repo is useful for **learning**, **reference**, or **direct integration** into production apps.

---

## 🛠️ Tech Stack

* **Flutter** (UI & app logic)
* **Agora RTC Engine** (video/audio calling)
* **audioplayers** (ringtone playback)
* **permission_handler** (camera & mic permissions)

---

## 📂 Project Structure

```
assets/
 ├── ring.mp3        # Ringtone played before call connects
 └── user.png        # Placeholder user avatar

lib/
 └── video_call.dart # Main video call screen
```

---

## 🎥 Features Breakdown

### 1️⃣ Video Calling

* Uses Agora Live Broadcasting profile
* Supports **Broadcaster** & **Audience** roles

### 2️⃣ Ringing State

* Plays looping ringtone until remote user joins
* Animated "Ringing..." UI

### 3️⃣ Timeout Handling

* Automatically ends call after **30 seconds** if no one joins
* Shows timeout UI with retry option

### 4️⃣ Call Controls

* 🎙️ Mute / Unmute microphone
* 🔄 Switch camera (front/back)
* ❌ End call

### 5️⃣ Draggable Remote View

* Remote video appears in a draggable floating window

---

## 📦 Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  agora_rtc_engine: ^6.3.2
  audioplayers: ^6.1.0
  permission_handler: ^11.3.1
```

---

## 🎵 Assets Configuration

```yaml
flutter:
  assets:
    - assets/ring.mp3
    - assets/user.png
```

Run:

```bash
flutter clean
flutter pub get
```

---

## 🔑 Agora Setup

1. Create an app at **Agora Console**
2. Copy your **App ID**
3. Generate a **temporary token**
4. Replace values in `video_call.dart`

```dart
const String appId = 'YOUR_AGORA_APP_ID';
const String rtcToken = 'YOUR_TEMP_TOKEN';
```

---

## 🔐 Permissions

### Android

`android/app/src/main/AndroidManifest.xml`

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
```

### iOS

`ios/Runner/Info.plist`

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for video calls</string>

<key>NSMicrophoneUsageDescription</key>
<string>Microphone access is required for audio calls</string>
```

---

## ▶️ How to Run

```bash
flutter pub get
flutter run
```

Open the app on **two devices** (or emulator + device) and join the same channel.

---

## 🧪 Use Cases

* Video calling apps
* Astrology / consultation apps
* Telemedicine apps
* Online tutoring platforms
* Customer support video calls

---

## 🧑‍💻 Author

**Jatin Sharma**
Flutter Developer

GitHub: [https://github.com/sharmajatin1997](https://github.com/sharmajatin1997)

---

## ⭐ Support

If this repository helps you:

* ⭐ Star the repo
* 🍴 Fork it
* 🧑‍💻 Use it in your projects

---

## 📄 License

This project is open-source and available under the **MIT License**.

---

> ⚠️ Note: This repository uses **temporary Agora tokens**. For production, always generate tokens securely from your backend.
