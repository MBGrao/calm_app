# 🧘 MeditAi - Flutter Frontend

A beautiful and modern meditation app built with Flutter, featuring AI-powered guidance and personalized content recommendations.

## 🚀 Features

- **Clean Authentication**: Email-based registration and login
- **AI Assistant**: Intelligent meditation recommendations
- **Content Management**: Curated meditation and sleep content
- **Responsive Design**: Optimized for all screen sizes
- **Offline Support**: Local content caching
- **Dark/Light Theme**: Customizable appearance

## 📱 Platforms

- ✅ Android
- ✅ iOS
- ✅ Web (coming soon)

## 🛠️ Tech Stack

- **Framework**: Flutter 3.4.3+
- **State Management**: GetX
- **UI Components**: Material Design 3
- **HTTP Client**: http package
- **Local Storage**: SharedPreferences
- **Audio**: just_audio
- **Responsive**: flutter_screenutil

## 🔧 Setup

### Prerequisites
- Flutter SDK 3.4.3 or higher
- Dart SDK 3.4.3 or higher
- Android Studio / Xcode

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/MBGrao/calm_app.git
   cd calm_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 🌐 Backend Integration

The app is configured to work with the MeditAi backend API:
- **Base URL**: `http://168.231.66.116:3000/api/v1`
- **Authentication**: JWT-based with refresh tokens
- **Content**: RESTful API endpoints

## 📁 Project Structure

```
lib/
├── app/
│   ├── components/          # Reusable UI components
│   ├── core/               # App constants and theme
│   ├── modules/            # Feature modules
│   │   ├── auth/          # Authentication
│   │   ├── home/          # Main app screens
│   │   ├── onboarding/    # User onboarding
│   │   └── settings/      # App settings
│   ├── routes/            # App navigation
│   ├── services/          # API and business logic
│   └── widgets/           # Custom widgets
└── main.dart              # App entry point
```

## 🎨 UI Components

- **Custom Bottom Navigation**: Modern tab navigation
- **Breathing Bubble**: Interactive breathing exercise
- **Audio Player**: Custom audio controls
- **AI Assistant Button**: Floating action button
- **Category Grid**: Content organization
- **Search Interface**: Content discovery

## 🔐 Authentication Flow

1. **Onboarding**: Welcome screens and feature introduction
2. **Signup**: Email-based account creation
3. **Login**: Secure authentication
4. **Profile**: User preferences and settings

## 📊 State Management

- **GetX Controller**: Reactive state management
- **Shared Preferences**: Local data persistence
- **HTTP Service**: API communication
- **Error Handling**: Comprehensive error management

## 🚀 Building for Production

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 📞 Support

For support and questions, please contact the development team.

---

**Built with ❤️ using Flutter**
