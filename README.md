# Shopping List App

A Flutter application for managing shopping lists with offline support and real-time synchronization using Firebase.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Features

- ✅ Create, update, and delete shopping items
- 📱 Offline-first architecture with local caching
- 🔄 Real-time synchronization with Firebase
- 🔍 Search functionality
- 📊 Analytics tracking for user actions
- 💫 Smooth animations and modern UI
- 📏 Customizable quantity units (Units, Weight, Volume, Length)

## Prerequisites

Before you begin, ensure you have:
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Firebase account

## Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/Ysparky/shopping_list
   cd pc_3_shopping_list
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   
   This app requires Firebase configuration. Follow these steps:

   a. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   
   b. Enable Firestore Database
   - Create a database in test mode
   - Set up Firestore rules (copy from firestore.rules)
   
   c. Add your apps:
   - For Android: Add an Android app in Firebase console
     - Download `google-services.json`
     - Place it in `android/app/`
   
   - For iOS: Add an iOS app in Firebase console
     - Download `GoogleService-Info.plist`
     - Place it in `ios/Runner/`

4. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── features/          # Feature modules
├── models/           # Data models
├── pages/            # Screen widgets
├── providers/        # State management
├── repositories/     # Data layer
├── theme/           # App theme and styling
├── utils/           # Utility functions
└── widgets/         # Reusable widgets
```

## Firebase Collections

The app uses the following Firestore collection:

- `shopping_items`: Stores shopping list items
  ```typescript
  {
    id: string
    name: string
    quantity: string | null
    isPurchased: boolean
    createdAt: timestamp
  }
  ```

## Offline Support

The app implements an offline-first architecture:
- Data is cached locally using Firestore persistence
- Changes are synchronized when online
- Cache-first query strategy with fallback to network

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

For more information about the MIT License, visit [choosealicense.com/licenses/mit](https://choosealicense.com/licenses/mit/).
