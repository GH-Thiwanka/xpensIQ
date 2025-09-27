# XpensIQ 💰

A Flutter-based mobile application for managing daily expenses with a clean UI and smooth performance. Perfect for anyone looking to stay organized with personal finances.


<img width="480" height="480" alt="image" src="https://github.com/user-attachments/assets/4a8a21f1-a819-4746-95db-1fb4d1ddcc91" />


## 📱 Features

- **Add & Delete Entries**: Easily manage your daily expense entries
- **Categorized Lists**: View expenses organized by categories
- **Clean UI**: Intuitive and user-friendly interface
- **Isolated Users**: Each user has their own private expense data
- **Real-time Sync**: Data synchronized with Firebase backend

## 🛠️ Tech Stack

- **Language**: Dart
- **Framework**: Flutter
- **Database**: Firebase
- **Platform**: Mobile (Android/iOS)

## 📋 Prerequisites

Before you begin, ensure you have the following installed:
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (latest stable version)
- [Dart SDK](https://dart.dev/get-dart) (comes with Flutter)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)
- [Firebase CLI](https://firebase.google.com/docs/cli)

## 🚀 Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/GH-Thiwanka/XpensIQ.git
cd XpensIQ
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Firebase Setup
1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add your Android/iOS app to the Firebase project
3. Download `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS)
4. Place the configuration files in the appropriate directories:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

### 4. Run the app
```bash
flutter run
```

## 📁 Project Structure

```
lib/
├── main.dart
├── models/
├── screens/
├── widgets/
├── services/
└── utils/
```

## 🔧 Configuration

Make sure to configure Firebase Authentication and Firestore rules according to your security requirements. Example Firestore rules for isolated user data:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/expenses/{document} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 📱 Screenshots

![home](https://github.com/user-attachments/assets/0618fb51-aae3-44d8-a136-efc919b6567f)

![budget](https://github.com/user-attachments/assets/0e3fec05-b244-47eb-9ca3-5e7647b64592)


## 👤 Author

**Heshan Thiwanka**
- GitHub: [@GH-Thiwanka](https://github.com/GH-Thiwanka)

## 📞 Support

If you encounter any issues or have questions, please [open an issue](https://github.com/GH-Thiwanka/XpensIQ/issues) on GitHub.

## 🎯 Future Enhancements

- [ ] Budget planning and alerts
- [ ] Export data to CSV/PDF
- [ ] Expense analytics and insights
- [ ] Multiple currency support
- [ ] Dark mode theme

## 📊 Version

**Current Version**: 1.0.0

---

Made with ❤️ by Heshan Thiwanka
