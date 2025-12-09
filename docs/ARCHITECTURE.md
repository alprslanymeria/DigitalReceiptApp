# Clean Architecture Prensipleri

## Genel Bakış

Bu dokümanda Clean Architecture'ın bu projede nasıl uygulandığını detaylı bir şekilde açıklıyoruz.

## Katmanlar ve Bağımlılık Kuralı

```
┌─────────────────────────────────────────────────────┐
│                  Presentation Layer                 │
│              (UI, Widgets, BLoC, Pages)             │
│              flutter_bloc, equatable                │
└────────────────────┬────────────────────────────────┘
                     │ depends on
                     ↓
┌─────────────────────────────────────────────────────┐
│                   Domain Layer                      │
│        (Entities, Use Cases, Repositories)          │
│              Pure Dart - No Framework               │
└────────────────────┬────────────────────────────────┘
                     │ depends on
                     ↓
┌─────────────────────────────────────────────────────┐
│                    Data Layer                       │
│   (Models, Data Sources, Repository Implementations)│
│      dio, shared_preferences, sqflite              │
└─────────────────────────────────────────────────────┘
```

**Bağımlılık Kuralı**: Dış katmanlar iç katmanlara bağımlıdır, asla tersi değildir.

## Domain Katmanı

### Neden En İçte?
- Hiçbir framework'e bağımlı değil
- Pure Dart kodu
- İş mantığı değişmeden kalır
- Test edilmesi en kolay katman

### Entities (Varlıklar)
```dart
class Receipt extends Equatable {
  final String id;
  final String storeName;
  final DateTime date;
  final double totalAmount;
  // ...
}
```
- İş kurallarını temsil eder
- Framework'lerden bağımsız
- Equatable ile değer karşılaştırması

### Repositories (Abstract)
```dart
abstract class ReceiptRepository {
  Future<Either<Failure, List<Receipt>>> getReceipts();
  Future<Either<Failure, Receipt>> addReceipt(Receipt receipt);
}
```
- Sadece interface tanımlar
- Implementation detayları bilinmez
- DIP (Dependency Inversion Principle) uygulanır

### Use Cases
```dart
class GetReceipts implements UseCase<List<Receipt>, NoParams> {
  final ReceiptRepository repository;
  
  Future<Either<Failure, List<Receipt>>> call(NoParams params) {
    return repository.getReceipts();
  }
}
```
- Tek bir iş akışı
- SRP (Single Responsibility Principle)
- Test edilmesi kolay

## Data Katmanı

### Models
```dart
class ReceiptModel extends Receipt {
  // JSON serialization
  factory ReceiptModel.fromJson(Map<String, dynamic> json) {...}
  Map<String, dynamic> toJson() {...}
}
```
- Entity'yi genişletir (LSP - Liskov Substitution)
- Serialization logic'i içerir
- Framework specific (json, xml, etc.)

### Data Sources
```dart
abstract class ReceiptRemoteDataSource {
  Future<List<ReceiptModel>> getReceipts();
}

class ReceiptRemoteDataSourceImpl implements ReceiptRemoteDataSource {
  final Dio client;
  // API calls implementation
}
```
- Remote ve Local ayrı arayüzler (ISP)
- Değiştirilebilir implementasyonlar (OCP)

### Repository Implementation
```dart
class ReceiptRepositoryImpl implements ReceiptRepository {
  final ReceiptRemoteDataSource remoteDataSource;
  final ReceiptLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  
  Future<Either<Failure, List<Receipt>>> getReceipts() async {
    if (await networkInfo.isConnected) {
      // try remote
    } else {
      // use cache
    }
  }
}
```
- Domain repository'yi implemente eder
- Data source'ları koordine eder
- Error handling ve caching logic

## Presentation Katmanı

### BLoC Pattern
```dart
class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  final GetReceipts getReceipts;
  final AddReceipt addReceipt;
  
  // Event handlers
}
```
- UI'dan business logic'i ayırır
- Testable
- Reactive programming

### Pages & Widgets
```dart
class ReceiptsPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptBloc, ReceiptState>(...);
  }
}
```
- BLoC ile iletişim kurar
- Platform specific UI
- Dumb components (sadece görüntüleme)

## Veri Akışı (Data Flow)

### Read Operation
```
User Action (UI)
    ↓
Event dispatched (BLoC)
    ↓
Use Case called
    ↓
Repository (abstract)
    ↓
Repository Implementation
    ↓
Data Source (Remote/Local)
    ↓
Model → Entity
    ↓
Either<Failure, Entity>
    ↓
State emitted (BLoC)
    ↓
UI Updated
```

### Write Operation
```
User Input (UI)
    ↓
Event with data (BLoC)
    ↓
Use Case with params
    ↓
Repository
    ↓
Repository Implementation
    - Check network
    - Save to remote
    - Cache locally
    ↓
Success/Failure
    ↓
State emitted
    ↓
UI feedback
```

## Error Handling

### Exceptions vs Failures
```dart
// Data Layer - throw exceptions
throw ServerException('Server error');

// Repository - convert to failures
catch (e) {
  return Left(ServerFailure(e.message));
}

// Domain Layer - return Either<Failure, Data>
Future<Either<Failure, Receipt>> getReceipt();

// Presentation - handle failures
result.fold(
  (failure) => emit(Error(failure.message)),
  (data) => emit(Loaded(data)),
);
```

## Dependency Injection

### Service Locator Pattern (get_it)
```dart
// Registration
sl.registerFactory(() => ReceiptBloc(
  getReceipts: sl(),
  addReceipt: sl(),
));

sl.registerLazySingleton(() => GetReceipts(sl()));
sl.registerLazySingleton<ReceiptRepository>(() => 
  ReceiptRepositoryImpl(
    remoteDataSource: sl(),
    localDataSource: sl(),
    networkInfo: sl(),
  )
);

// Usage
BlocProvider(
  create: (_) => sl<ReceiptBloc>(),
  child: ReceiptsPage(),
)
```

## Testing Stratejisi

### Unit Tests
- **Domain Layer**: Mock repositories
- **Data Layer**: Mock data sources
- **Presentation Layer**: Mock use cases

### Integration Tests
- Test full feature flow
- Use real implementations

### Widget Tests
- Test UI components
- Mock BLoCs

## Best Practices

1. **Domain katmanında pure Dart kullan**
   - Flutter import etme
   - Framework bağımlılığı yok

2. **Her use case tek bir iş yapsın**
   - Küçük ve odaklı
   - Kolayca test edilebilir

3. **Repository pattern kullan**
   - Data source'ları soyutla
   - Caching stratejisi uygula

4. **Either type ile error handling**
   - Exception fırlatma
   - Functional approach

5. **Dependency Injection**
   - Tight coupling'den kaçın
   - Test edilebilirlik artırın

## Yeni Feature Ekleme Adımları

1. **Domain Layer**
   - Entity oluştur
   - Repository interface tanımla
   - Use case'ler yaz

2. **Data Layer**
   - Model oluştur (Entity'yi extend et)
   - Data source'ları tanımla
   - Repository'yi implemente et

3. **Presentation Layer**
   - BLoC oluştur (events, states)
   - UI pages ve widgets ekle

4. **DI Configuration**
   - `injection_container.dart`'a ekle

5. **Tests**
   - Unit tests yaz
   - Widget tests ekle

## Kaynaklar

- [Clean Architecture by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture by Reso Coder](https://resocoder.com/flutter-clean-architecture-tdd/)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)
