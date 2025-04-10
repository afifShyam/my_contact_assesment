## 🚀 Getting Started

### 🧱 Prerequisites

Make sure you have the following installed:

- **Flutter SDK** version **3.29.0 or above**
- Compatible IDE (e.g. VS Code or Android Studio or Windsurf)
- Dart enabled

You can verify your Flutter version with:

```bash
flutter --version
```

---

### 🛠️ Installation & Setup

1. **Clone the repository**:

```bash
git clone https://github.com/your-username/your-project.git
cd your-project
```

2. **Install dependencies**:

```bash
flutter pub get
```

3. **Generate freezed & model files**:

This project uses [`freezed`](https://pub.dev/packages/freezed) and `json_serializable`. You must generate the necessary files before running the app:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

### ▶️ Running the App

Run the app on a connected device or emulator:

```bash
flutter run
```

---

### 📁 Project Structure

```
lib/
├── bloc/           # BLoC files
├── model/          # Data models (Freezed)
├── screen/         # Screens / Pages
├── utils/          # Shared utilities & styles
├── main.dart       # App entry point
```

---

### ✅ Notes

- Make sure to re-run `build_runner` if you update any models or bloc/event/state files.
- Feel free to customize the theme and extend the app structure as needed.