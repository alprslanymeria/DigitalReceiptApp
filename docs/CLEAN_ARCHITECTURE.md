# Clean Architecture in Flutter

This Flutter application follows Clean Architecture principles, organizing code into distinct layers with clear separation of concerns.

## Architecture Overview

The project is structured using Clean Architecture with three main layers:

### 1. Domain Layer (`lib/features/*/domain/`)
The **innermost layer** containing business logic and rules. It has no dependencies on other layers.

- **Entities** (`entities/`): Core business objects (e.g., `Receipt`, `ReceiptItem`)
- **Repositories** (`repositories/`): Abstract interfaces defining data operations
- **Use Cases** (`usecases/`): Application-specific business rules (Single Responsibility Principle)
  - `GetAllReceipts`: Retrieve all receipts
  - `GetReceiptById`: Retrieve a specific receipt
  - `CreateReceipt`: Create a new receipt
  - `DeleteReceipt`: Delete a receipt

### 2. Data Layer (`lib/features/*/data/`)
Implements the domain layer interfaces and handles data sources.

- **Models** (`models/`): Data transfer objects extending domain entities with serialization
- **Data Sources** (`datasources/`):
  - `ReceiptRemoteDataSource`: API/network operations
  - `ReceiptLocalDataSource`: Local caching with SharedPreferences
- **Repository Implementation** (`repositories/`): Concrete implementation of domain repositories
  - Handles network/cache logic
  - Converts exceptions to failures
  - Implements offline-first pattern

### 3. Presentation Layer (`lib/features/*/presentation/`)
Handles UI and user interactions using BLoC pattern.

- **BLoC** (`bloc/`): State management following BLoC pattern
  - `ReceiptBloc`: Manages receipt-related states
  - `ReceiptEvent`: User actions
  - `ReceiptState`: UI states
- **Pages** (`pages/`): Full-screen UI components
- **Widgets** (`widgets/`): Reusable UI components

### 4. Core Layer (`lib/core/`)
Shared utilities and base classes used across features.

- **Error Handling** (`error/`):
  - `Failure`: Abstract error types for domain/presentation layers
  - `Exception`: Concrete errors thrown in data layer
- **Use Cases** (`usecases/`): Base `UseCase` class
- **Utils** (`utils/`): Shared utilities

## SOLID Principles

### Single Responsibility Principle (SRP)
- Each use case has one specific responsibility
- Each data source handles one type of data operation (remote or local)
- Each BLoC manages one feature's state

### Open/Closed Principle (OCP)
- Abstract repository interfaces allow extension without modification
- New use cases can be added without changing existing code
- New data sources can be implemented without touching existing ones

### Liskov Substitution Principle (LSP)
- Models extend entities and can be used interchangeably
- Repository implementations can replace abstract interfaces
- Data sources follow their contracts

### Interface Segregation Principle (ISP)
- Separate interfaces for remote and local data sources
- Specific use case interfaces instead of one large repository
- Focused BLoC events and states

### Dependency Inversion Principle (DIP)
- High-level domain layer doesn't depend on low-level data layer
- Dependencies flow inward toward domain
- Dependency injection with GetIt service locator

## Error Handling

The application uses functional error handling with the `dartz` package:

1. **Data Layer**: Throws `Exception` types
2. **Repository**: Catches exceptions and converts to `Failure` types
3. **Use Cases**: Returns `Either<Failure, Success>`
4. **BLoC**: Handles failures and emits appropriate states
5. **UI**: Displays user-friendly error messages

## Dependency Injection

Dependencies are managed using GetIt service locator (`lib/injection_container.dart`):

- `registerFactory`: Creates new instance each time (BLoCs)
- `registerLazySingleton`: Creates instance on first use, reuses thereafter (Use Cases, Repositories, Data Sources)

## Data Flow

1. **User Interaction** → Widget triggers an event
2. **BLoC** → Receives event, calls appropriate use case
3. **Use Case** → Executes business logic, calls repository
4. **Repository** → Coordinates data sources (remote/local)
5. **Data Source** → Fetches/saves data
6. **Repository** → Returns result as `Either<Failure, Data>`
7. **Use Case** → Passes result back to BLoC
8. **BLoC** → Emits new state
9. **Widget** → Rebuilds based on new state

## Project Structure

```
lib/
├── core/
│   ├── error/
│   │   ├── exceptions.dart       # Data layer exceptions
│   │   └── failures.dart         # Domain layer failures
│   └── usecases/
│       └── usecase.dart          # Base use case class
├── features/
│   └── receipt/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── receipt_local_data_source.dart
│       │   │   └── receipt_remote_data_source.dart
│       │   ├── models/
│       │   │   ├── receipt_model.dart
│       │   │   └── receipt_model.g.dart
│       │   └── repositories/
│       │       └── receipt_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── receipt.dart
│       │   ├── repositories/
│       │   │   └── receipt_repository.dart
│       │   └── usecases/
│       │       ├── create_receipt.dart
│       │       ├── delete_receipt.dart
│       │       ├── get_all_receipts.dart
│       │       └── get_receipt_by_id.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── receipt_bloc.dart
│           │   ├── receipt_event.dart
│           │   └── receipt_state.dart
│           ├── pages/
│           │   ├── receipt_detail_page.dart
│           │   └── receipts_list_page.dart
│           └── widgets/
│               ├── receipt_detail_widget.dart
│               └── receipt_list_item.dart
├── injection_container.dart      # Dependency injection setup
└── main.dart                      # App entry point
```

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Generate model code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Run the app:
```bash
flutter run
```

## Key Dependencies

- **flutter_bloc**: State management
- **get_it**: Dependency injection
- **dartz**: Functional programming (Either type)
- **equatable**: Value equality
- **shared_preferences**: Local storage
- **json_annotation**: JSON serialization
- **intl**: Date formatting

## Testing

The architecture is designed to be testable:

- **Domain Layer**: Pure business logic, easily unit tested
- **Data Layer**: Mock data sources for repository tests
- **Presentation Layer**: Mock use cases for BLoC tests
- **Widgets**: Mock BLoCs for widget tests

## Best Practices

1. **Keep domain layer pure**: No Flutter dependencies
2. **Use dependency injection**: All dependencies injected via constructor
3. **Follow naming conventions**: Clear, descriptive names
4. **Single responsibility**: Each class has one job
5. **Error handling**: Always return Either<Failure, Success>
6. **Immutability**: Use const constructors where possible
7. **Equatable**: Use for value equality in entities, events, and states

## Adding New Features

To add a new feature:

1. Create feature folder in `lib/features/your_feature/`
2. Create domain layer (entities, repositories, use cases)
3. Create data layer (models, data sources, repository implementation)
4. Create presentation layer (BLoC, pages, widgets)
5. Register dependencies in `injection_container.dart`

## References

- [Clean Architecture by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture by Reso Coder](https://resocoder.com/flutter-clean-architecture-tdd/)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)
