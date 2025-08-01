# Perfect Circle - Draw Perfect Circle Game

A fun and challenging Flutter game where users try to draw the most perfect circle possible. Test your hand-eye coordination and see how close you can get to drawing a mathematically perfect circle!

## 🎯 Features

- **Interactive Drawing**: Touch and drag to draw circles on a responsive canvas
- **Real-time Scoring**: Get instant feedback on how circular your drawing is (0-100 points)
- **Grid Toggle**: Optional grid overlay to help with drawing
- **Score Persistence**: Your best scores and statistics are saved locally
- **Dark/Light Theme**: Automatic theme switching based on system preferences
- **Accessibility**: Full accessibility support with semantic labels
- **Performance Optimized**: Smooth drawing experience with performance optimizations
- **Haptic Feedback**: Tactile feedback for different interactions and scores

## 🏗️ Architecture

The app follows clean architecture principles with clear separation of concerns:

```
lib/
├── config/           # App configuration and constants
├── constants/        # String constants and localization
├── models/          # Data models
├── providers/       # State management (Provider pattern)
├── screens/         # UI screens
├── services/        # Business logic and external services
├── themes/          # App theming
└── widgets/         # Reusable UI components
```

## 🛠️ Technical Stack

- **Framework**: Flutter 3.24.0+
- **State Management**: Provider
- **Local Storage**: SharedPreferences
- **Testing**: Unit, Widget, and Integration tests
- **Analytics**: Configurable analytics service (ready for Firebase/Mixpanel)
- **Crash Reporting**: Configurable crash reporting (ready for Crashlytics/Sentry)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.24.0 or higher
- Dart SDK 3.8.1 or higher

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/perfect_cyrcle.git
cd perfect_cyrcle
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 🧪 Testing

The app includes comprehensive testing:

### Run all tests:
```bash
flutter test
```

### Run specific test types:
```bash
# Unit tests
flutter test test/unit/

# Widget tests
flutter test test/widget/

# Integration tests
flutter test integration_test/
```

### Test Coverage:
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 🎮 How to Play

1. **Start Drawing**: Touch anywhere on the screen and drag to draw your circle
2. **Complete the Circle**: Try to end your drawing close to where you started
3. **Get Your Score**: Release to see your score out of 100 points
4. **Try Again**: Tap "Try Again" to draw another circle
5. **Beat Your Best**: Keep trying to achieve the perfect score of 100!

## 📊 Scoring System

The scoring algorithm evaluates two main factors:

- **Circularity (60%)**: How consistent the radius is throughout the drawing
- **Closure (40%)**: How close the end point is to the start point

Score ranges:
- **95-100**: Perfect! 🌟
- **85-94**: Excellent! 🎯
- **75-84**: Very Good! 👏
- **60-74**: Good Attempt! 💪
- **40-59**: Not Bad! 🖊️
- **20-39**: Try Again! 🔄
- **0-19**: Abstract Art! 🎨

## ⚙️ Configuration

### App Config (`lib/config/app_config.dart`)

Key settings you can modify:
- Minimum points for evaluation
- Score thresholds
- Performance limits
- Analytics/crash reporting toggles

### Analytics & Crash Reporting

The app is ready for analytics and crash reporting services. To enable:

1. Uncomment desired services in `pubspec.yaml`
2. Set `analyticsEnabled` and `crashReportingEnabled` to `true` in `AppConfig`
3. Implement the actual service calls in the respective service files

## 🌍 Localization

Currently supports Greek language. The app is structured for easy localization:

- All strings are centralized in `lib/constants/app_strings.dart`
- Ready for `flutter_localizations` implementation

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🔧 Development

### Code Style

The project follows Flutter/Dart best practices:
- Uses `very_good_analysis` for strict linting
- Comprehensive error handling
- Proper null safety
- Performance optimizations

### Adding Features

1. Follow the existing architecture patterns
2. Add appropriate tests
3. Update documentation
4. Ensure accessibility compliance

## 📈 Performance Considerations

- **Point Limiting**: Drawing paths are limited to prevent performance issues
- **Efficient Painting**: Custom painter optimizations for smooth rendering
- **Memory Management**: Proper disposal of resources
- **Debounced Updates**: Smooth 60fps drawing experience

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Community contributors and testers
- Greek language support for cultural inclusivity

## 📞 Support

If you encounter any issues or have questions:
- Open an issue on GitHub
- Check the documentation
- Review the test cases for usage examples

---

**Made with ❤️ using Flutter**
