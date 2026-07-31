# Feroxbuster Engine (`feroxbuster_engine`)

> Recursive High-Speed Web Content Discovery Engine  
> **Author & Original Architect:** [Abdallah Fawzi Ali Mahmoud](https://github.com/AbdoFawzi777)  
> **Part of the RedOps Hub Monorepo Suite**

---

## 📌 Overview
`feroxbuster_engine` is a production-grade, standalone Flutter package engineered for high-performance mobile security auditing. Built with pure Dart and native Flutter MethodChannels/Isolates, it delivers enterprise-level capability directly on Android & iOS devices without relying on external Linux command-line dependencies.

---

## 🚀 New Capabilities & Features (v2.0)
- **Recursive Directory Discovery:** Automatically spawns sub-scans for newly discovered directories.
- **Adaptive Rate Limiting:** Auto-tunes concurrency based on server response times and HTTP 429 rate limit responses.
- **File Extension Mutation:** Appends custom extension lists (`.php`, `.asp`, `.json`, `.bak`) dynamically.
- **WAF Auto-Bailout:** Detects web application firewall blockages and gracefully pauses execution.

---

## 🛠 Usage & Integration

Add `feroxbuster_engine` to your Flutter `pubspec.yaml`:

```yaml
dependencies:
  feroxbuster_engine:
    path: ../packages/feroxbuster_engine
```

### Basic Example

```dart
import 'package:feroxbuster_engine/feroxbuster_engine.dart';

void main() async {
  final engine = FeroxbusterEngine();
  
  print('Starting Feroxbuster Engine audit...');
  final results = await engine.execute(
    target: '192.168.1.1',
  );
  
  print('Audit Complete!');
}
```

---

## 🔒 Security & Privacy
- **Zero Telemetry:** No analytics, tracking, or network calls home.
- **Encrypted Local Storage:** Integrates seamlessly with RedOps Hub AES-256 local database.
- **Thread Safety:** All heavy operations execute inside Dart Isolates to maintain 60fps UI rendering.

---

## 👤 Author & Copyright

**Abdallah Fawzi Ali Mahmoud**  
Lead Developer & Security Architect of RedOps Hub  
- **GitHub:** [@AbdoFawzi777](https://github.com/AbdoFawzi777)  
- **Telegram:** [@ABdo_FawZi1](https://telegram.me/ABdo_FawZi1)  
- **Website:** [RedOps Hub Platform](https://redops-hub.web.app)

*Copyright (c) 2026 Abdallah Fawzi Ali Mahmoud. All rights reserved.*
