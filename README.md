# Digital Receipt App

A Flutter mobile application for managing digital receipts, built with Clean Architecture principles and following SOLID design patterns.

## Features

- 📱 Modern Flutter UI with Material Design 3
- 🏗️ Clean Architecture (Domain, Data, Presentation layers)
- 🎯 SOLID Principles implementation
- 🔄 BLoC pattern for state management
- 💉 Dependency Injection with GetIt
- 🗄️ Offline-first approach with local caching
- ⚡ Functional error handling with Either type
- 🧪 Testable architecture

## Architecture

This project follows **Clean Architecture** with clear separation between:

- **Domain Layer**: Business logic and entities
- **Data Layer**: Data sources and repository implementations
- **Presentation Layer**: UI and state management with BLoC

For detailed architecture documentation, see:
- [Clean Architecture Guide](docs/CLEAN_ARCHITECTURE.md)
- [SOLID Principles Implementation](docs/SOLID.md)

## Project Structure

```
lib/
├── core/                     # Shared utilities
│   ├── error/               # Error handling
│   └── usecases/            # Base use case
├── features/
│   └── receipt/             # Receipt feature
│       ├── domain/          # Business logic
│       ├── data/            # Data management
│       └── presentation/    # UI and BLoC
├── injection_container.dart # Dependency injection
└── main.dart               # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/alprslanymeria/DigitalReceiptApp.git
cd DigitalReceiptApp
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code (for JSON serialization):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

## Key Technologies

- **Flutter**: UI framework
- **flutter_bloc**: State management
- **get_it**: Dependency injection
- **dartz**: Functional programming
- **equatable**: Value equality
- **shared_preferences**: Local storage
- **json_annotation**: JSON serialization

## SOLID Principles

This project demonstrates all five SOLID principles:

- **S**ingle Responsibility: Each class has one job
- **O**pen/Closed: Open for extension, closed for modification
- **L**iskov Substitution: Subtypes are substitutable
- **I**nterface Segregation: Focused, minimal interfaces
- **D**ependency Inversion: Depend on abstractions

See [SOLID.md](docs/SOLID.md) for detailed examples.

## Testing

The architecture supports comprehensive testing at all layers:

```bash
flutter test
```

## Contributing

Contributions are welcome! Please ensure your code follows the established Clean Architecture patterns and SOLID principles.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Documentation

- [Clean Architecture](docs/CLEAN_ARCHITECTURE.md)
- [SOLID Principles](docs/SOLID.md)

## Author

**Alparslan Ymeria**
