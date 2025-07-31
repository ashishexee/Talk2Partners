# Talk2Partners

## 🚀 Overview

Talk2Partners is a Flutter-based mobile application designed to facilitate communication between users and support staff. The app provides a real-time chat interface where users can engage in conversations with designated admin support representatives.


## ✨ Features

* **User Authentication**

  * Email and password-based authentication
  * User registration and login
  * Secure session management

* **Real-time Chat**

  * One-on-one conversations with support staff
  * Message status indicators
  * Timestamp display

* **Modern UI**

  * Clean, intuitive interface
  * Responsive design for various device sizes
  * Smooth animations and transitions

* **Security**

  * Secure data storage
  * User-specific chat isolation
  * Firebase authentication

## 🔧 Architecture

The app follows a clean architecture pattern with Riverpod for state management:

* **UI Layer**: Screen widgets and components
* **State Management**: Riverpod providers and notifiers
* **Service Layer**: Authentication and chat services
* **Data Layer**: Models and Firebase integration

## 🛠️ Technologies Used

* **Flutter**: UI framework
* **Firebase**:

  * Authentication
  * Cloud Firestore
* **Riverpod**: State management
* **SharedPreferences**: Local storage

## 📋 Prerequisites

* Flutter SDK (version 3.0.0 or higher)
* Dart SDK (version 3.0.0 or higher)
* Firebase account
* Android Studio / VS Code

## ⚙️ Installation

```bash
git clone https://github.com/yourusername/talk2partners.git
cd talk2partners
flutter pub get
flutterfire configure
flutter run
```

## 📁 Project Structure

```
talk2partners/
|-- lib/
|   |-- main.dart               # App entry point
|   |-- models/                 # Data models
|   |   |-- message_model.dart  # Chat message model
|   |   \-- user_model.dart     # User data model
|   |-- providers/              # State management
|   |   |-- auth_provider.dart  # Authentication state
|   |   \-- chat_provider.dart  # Chat state
|   |-- screens/                # UI screens
|   |   |-- chat_screen.dart    # Chat interface
|   |   |-- home_screen.dart    # Main dashboard
|   |   \-- login_screen.dart   # Auth screen
|   \-- services/               # Business logic
|       |-- auth_service.dart   # Authentication service
|       \-- chat_service.dart   # Chat service
|-- assets/                     # Static assets
|-- android/                    # Android-specific code
|-- ios/                        # iOS-specific code
\-- web/                        # Web-specific code
```

## 📖 Usage

1. **Launch the app**: Open the app and you'll be presented with the login screen.
2. **Authentication**: Sign in with your email and password or create a new account.
3. **Home Screen**: Navigate through available features using the dashboard.
4. **Chat**: Access the chat screen to communicate with support staff.

## ⚡ Performance Optimization

* **Image Optimization**: All assets are compressed using WebP format.
* **Code Splitting**: Deferred loading for non-critical screens.
* **Firebase Optimization**: Only required Firebase modules are imported.

**Release Configuration**:

* R8 shrinking enabled for Android
* App thinning enabled for iOS

## 🛡️ Security Features

* **User Data Isolation**: Each user's chat data is stored in separate Firebase collections.
* **Authentication Flow**: Secure JWT-based authentication using Firebase Auth.
* **Data Validation**: Server-side validation for all incoming messages.