# SOLID Principles Implementation

This document explains how SOLID principles are implemented in the Digital Receipt App's Clean Architecture.

## Single Responsibility Principle (SRP)

**"A class should have one, and only one, reason to change."**

### Implementation Examples:

#### Use Cases
Each use case handles exactly one business operation:
- `GetAllReceipts` - Only responsible for fetching all receipts
- `GetReceiptById` - Only responsible for fetching a single receipt by ID
- `CreateReceipt` - Only responsible for creating a new receipt
- `DeleteReceipt` - Only responsible for deleting a receipt

```dart
class GetAllReceipts implements UseCase<List<Receipt>, NoParams> {
  final ReceiptRepository repository;
  
  GetAllReceipts(this.repository);
  
  @override
  Future<Either<Failure, List<Receipt>>> call(NoParams params) async {
    return await repository.getAllReceipts();
  }
}
```

#### Data Sources
- `ReceiptRemoteDataSource` - Only handles remote API calls
- `ReceiptLocalDataSource` - Only handles local storage operations

#### BLoC
- `ReceiptBloc` - Only manages receipt feature state
- Each event handler has single responsibility

## Open/Closed Principle (OCP)

**"Software entities should be open for extension, but closed for modification."**

### Implementation Examples:

#### Abstract Repository
```dart
abstract class ReceiptRepository {
  Future<Either<Failure, List<Receipt>>> getAllReceipts();
  Future<Either<Failure, Receipt>> getReceiptById(String id);
  // ... more methods
}
```

New implementations can be created without modifying the interface:
- Can add `ReceiptFirebaseRepository`
- Can add `ReceiptSQLiteRepository`
- Original code remains unchanged

#### Abstract Data Sources
```dart
abstract class ReceiptRemoteDataSource {
  Future<List<ReceiptModel>> getAllReceipts();
  // ... more methods
}
```

Can implement different remote sources:
- `ReceiptHttpDataSource`
- `ReceiptGraphQLDataSource`
- `ReceiptFirebaseDataSource`

#### Use Case Base Class
```dart
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
```

New use cases can extend this without modification.

## Liskov Substitution Principle (LSP)

**"Derived classes must be substitutable for their base classes."**

### Implementation Examples:

#### Models Extend Entities
```dart
class Receipt extends Equatable {
  final String id;
  final String storeName;
  // ... properties
}

class ReceiptModel extends Receipt {
  // Can be used anywhere Receipt is expected
  // Adds serialization without breaking base contract
}
```

#### Repository Implementation
```dart
class ReceiptRepositoryImpl implements ReceiptRepository {
  // Can be substituted wherever ReceiptRepository is used
  // Fulfills all contract requirements
}
```

#### Data Source Implementations
```dart
class ReceiptRemoteDataSourceImpl implements ReceiptRemoteDataSource {
  // Fulfills the remote data source contract
  // Can replace any ReceiptRemoteDataSource
}
```

## Interface Segregation Principle (ISP)

**"Clients should not be forced to depend on methods they do not use."**

### Implementation Examples:

#### Separate Data Sources
Instead of one large data source:
```dart
// ✅ GOOD: Separate interfaces
abstract class ReceiptRemoteDataSource {
  Future<List<ReceiptModel>> getAllReceipts();
  Future<ReceiptModel> getReceiptById(String id);
  // ... remote-specific methods
}

abstract class ReceiptLocalDataSource {
  Future<List<ReceiptModel>> getCachedReceipts();
  Future<void> cacheReceipts(List<ReceiptModel> receipts);
  // ... cache-specific methods
}

// ❌ BAD: One interface with all methods
// abstract class ReceiptDataSource {
//   // Both remote and local methods mixed
// }
```

#### Focused Use Cases
Each use case has a specific interface:
```dart
// Each use case defines only what it needs
class GetAllReceipts implements UseCase<List<Receipt>, NoParams>
class GetReceiptById implements UseCase<Receipt, GetReceiptByIdParams>
class CreateReceipt implements UseCase<Receipt, CreateReceiptParams>
```

#### Specific Event Types
```dart
abstract class ReceiptEvent extends Equatable {}

class LoadAllReceipts extends ReceiptEvent {}
class LoadReceiptById extends ReceiptEvent {
  final String id;
  // Only has what it needs
}
```

## Dependency Inversion Principle (DIP)

**"Depend upon abstractions, not concretions."**

### Implementation Examples:

#### High-Level Modules Don't Depend on Low-Level Modules

**Domain Layer** (high-level) depends on abstractions:
```dart
class GetAllReceipts implements UseCase<List<Receipt>, NoParams> {
  final ReceiptRepository repository; // Abstract interface
  
  GetAllReceipts(this.repository);
  // Doesn't know about ReceiptRepositoryImpl
}
```

**Data Layer** (low-level) implements abstractions:
```dart
class ReceiptRepositoryImpl implements ReceiptRepository {
  final ReceiptRemoteDataSource remoteDataSource; // Abstract
  final ReceiptLocalDataSource localDataSource;   // Abstract
  
  // Depends on abstractions, not concrete implementations
}
```

#### Dependency Injection
All dependencies are injected through constructors:

```dart
// injection_container.dart
sl.registerLazySingleton(() => GetAllReceipts(sl()));
sl.registerLazySingleton<ReceiptRepository>(
  () => ReceiptRepositoryImpl(
    remoteDataSource: sl(),
    localDataSource: sl(),
  ),
);
```

#### BLoC Dependencies
```dart
class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  final GetAllReceipts getAllReceipts;
  final GetReceiptById getReceiptById;
  final CreateReceipt createReceipt;
  final DeleteReceipt deleteReceipt;
  
  ReceiptBloc({
    required this.getAllReceipts,    // Abstract use cases
    required this.getReceiptById,
    required this.createReceipt,
    required this.deleteReceipt,
  }) : super(ReceiptInitial());
  // BLoC depends on abstractions (use cases)
  // Not on repositories or data sources directly
}
```

## Dependency Flow Diagram

```
┌─────────────────────────────────────────┐
│         Presentation Layer               │
│  ┌────────────────────────────────────┐ │
│  │         ReceiptBloc                 │ │
│  │  (depends on Use Case interfaces)  │ │
│  └────────────────────────────────────┘ │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│           Domain Layer                   │
│  ┌────────────────────────────────────┐ │
│  │         Use Cases                   │ │
│  │  (depend on Repository interface)  │ │
│  └────────────────────────────────────┘ │
│  ┌────────────────────────────────────┐ │
│  │    ReceiptRepository (abstract)    │ │
│  └────────────────────────────────────┘ │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│            Data Layer                    │
│  ┌────────────────────────────────────┐ │
│  │   ReceiptRepositoryImpl             │ │
│  │  (implements Repository interface)  │ │
│  │  (depends on DataSource interfaces) │ │
│  └────────────────────────────────────┘ │
│  ┌────────────────────────────────────┐ │
│  │       Data Sources (abstract)       │ │
│  │  - ReceiptRemoteDataSource          │ │
│  │  - ReceiptLocalDataSource           │ │
│  └────────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

All arrows point **inward** toward the domain layer. Dependencies flow from outer layers to inner layers, following the Dependency Inversion Principle.

## Benefits of SOLID in This Architecture

1. **Testability**: Each component can be easily mocked and tested in isolation
2. **Maintainability**: Changes are localized to specific layers/classes
3. **Scalability**: New features can be added without modifying existing code
4. **Flexibility**: Implementations can be swapped (e.g., different data sources)
5. **Reusability**: Components are decoupled and can be reused

## Testing Examples

### Testing Use Cases (SRP, DIP)
```dart
// Mock repository, test use case in isolation
test('should get all receipts from repository', () async {
  // Arrange
  when(mockRepository.getAllReceipts())
    .thenAnswer((_) async => Right(tReceiptList));
  
  // Act
  final result = await useCase(NoParams());
  
  // Assert
  expect(result, Right(tReceiptList));
  verify(mockRepository.getAllReceipts());
});
```

### Testing BLoC (DIP)
```dart
// Mock use cases, test BLoC in isolation
test('should emit [Loading, Loaded] when data is gotten successfully', () {
  // Arrange
  when(mockGetAllReceipts(any))
    .thenAnswer((_) async => Right(tReceiptList));
  
  // Assert later
  final expected = [
    ReceiptLoading(),
    ReceiptsLoaded(tReceiptList),
  ];
  expectLater(bloc.stream, emitsInOrder(expected));
  
  // Act
  bloc.add(LoadAllReceipts());
});
```

### Testing Repository (LSP, ISP)
```dart
// Mock data sources, test repository in isolation
test('should return remote data when call to remote is successful', () async {
  // Arrange
  when(mockRemoteDataSource.getAllReceipts())
    .thenAnswer((_) async => tReceiptModelList);
  
  // Act
  final result = await repository.getAllReceipts();
  
  // Assert
  verify(mockRemoteDataSource.getAllReceipts());
  expect(result, equals(Right(tReceiptList)));
});
```

## Conclusion

This Clean Architecture implementation demonstrates all five SOLID principles working together to create a maintainable, testable, and scalable application. Each principle reinforces the others to ensure code quality and long-term sustainability.
