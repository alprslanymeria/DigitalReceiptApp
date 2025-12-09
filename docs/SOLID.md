# SOLID Prensipleri - Detaylı Açıklama

Bu dokümanda SOLID prensiplerininin projede nasıl uygulandığını örneklerle açıklıyoruz.

## 1. Single Responsibility Principle (SRP)
**"Bir sınıf sadece bir değişme sebebine sahip olmalıdır."**

### ❌ Yanlış Kullanım
```dart
class ReceiptManager {
  // Veri çekme
  Future<List<Receipt>> getReceipts() { ... }
  
  // Veritabanına kaydetme
  Future<void> saveToDatabase(Receipt receipt) { ... }
  
  // API'ye gönderme
  Future<void> sendToAPI(Receipt receipt) { ... }
  
  // UI state yönetimi
  void updateUI() { ... }
}
```

### ✅ Doğru Kullanım (Projemizdeki)
```dart
// Use Case - Sadece bir iş yapar
class GetReceipts implements UseCase<List<Receipt>, NoParams> {
  final ReceiptRepository repository;
  
  Future<Either<Failure, List<Receipt>>> call(NoParams params) {
    return repository.getReceipts();
  }
}

// Data Source - Sadece veri çekmeyle ilgilenir
class ReceiptLocalDataSource {
  Future<List<ReceiptModel>> getCachedReceipts() { ... }
  Future<void> cacheReceipts(List<ReceiptModel> receipts) { ... }
}

// BLoC - Sadece state yönetimi
class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  // Sadece event'leri dinler ve state üretir
}
```

## 2. Open/Closed Principle (OCP)
**"Sınıflar genişletmeye açık, değişikliğe kapalı olmalıdır."**

### Projemizdeki Uygulama

```dart
// Abstract repository - Değişikliğe kapalı
abstract class ReceiptRepository {
  Future<Either<Failure, List<Receipt>>> getReceipts();
}

// Farklı implementasyonlarla genişletilebilir
class ReceiptRepositoryImpl implements ReceiptRepository {
  // SharedPreferences implementation
}

class ReceiptFirebaseRepository implements ReceiptRepository {
  // Firebase implementation - Repository'yi değiştirmeden eklenir
}

class ReceiptSQLiteRepository implements ReceiptRepository {
  // SQLite implementation
}
```

### Yeni Data Source Ekleme
```dart
// Mevcut kodu değiştirmeden yeni data source ekleyebiliriz
abstract class ReceiptDataSource {
  Future<List<ReceiptModel>> getReceipts();
}

class ReceiptGraphQLDataSource implements ReceiptDataSource {
  // Yeni GraphQL implementation
}

class ReceiptRESTDataSource implements ReceiptDataSource {
  // REST API implementation
}
```

## 3. Liskov Substitution Principle (LSP)
**"Alt sınıflar, üst sınıfların yerine kullanılabilmeli."**

### Projemizdeki Uygulama

```dart
// Base Entity
class Receipt extends Equatable {
  final String id;
  final String storeName;
  final DateTime date;
  final double totalAmount;
  final List<ReceiptItem> items;
  
  const Receipt({...});
}

// Model - Receipt'in yerine kullanılabilir
class ReceiptModel extends Receipt {
  const ReceiptModel({...}) : super(...);
  
  // Ek functionality - JSON conversion
  factory ReceiptModel.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
}

// Her yerde Receipt beklendiğinde ReceiptModel kullanılabilir
void processReceipt(Receipt receipt) {
  // ReceiptModel de kabul edilir
  print(receipt.storeName);
}

// Usage
Receipt receipt = ReceiptModel(...); // ✅ Çalışır
processReceipt(ReceiptModel(...));    // ✅ Çalışır
```

### LSP İhlali Örneği (Projemizde YOK)
```dart
// ❌ Yanlış - Square is-a Rectangle ihlal eder
class Rectangle {
  int width;
  int height;
  
  int area() => width * height;
}

class Square extends Rectangle {
  // Square'de width ve height aynı olmalı
  // Bu LSP'yi ihlal eder
}
```

## 4. Interface Segregation Principle (ISP)
**"Kullanmadığınız metodlara bağımlı olmayın."**

### ❌ Yanlış - Fat Interface
```dart
abstract class ReceiptDataSource {
  // Tüm operasyonlar bir arayüzde
  Future<List<Receipt>> getFromAPI();
  Future<List<Receipt>> getFromCache();
  Future<void> saveToAPI(Receipt receipt);
  Future<void> saveToCache(Receipt receipt);
  Future<void> syncWithCloud();
  Future<void> exportToPDF();
  Future<void> sendEmail();
}

// LocalDataSource tüm metodları implement etmek zorunda
// Ama API metodlarını kullanmıyor!
class LocalDataSource implements ReceiptDataSource {
  Future<List<Receipt>> getFromAPI() => throw UnimplementedError(); // ❌
  Future<List<Receipt>> getFromCache() { ... } // ✅
  // ...
}
```

### ✅ Doğru - Segregated Interfaces (Projemizdeki)
```dart
// Remote için ayrı interface
abstract class ReceiptRemoteDataSource {
  Future<List<ReceiptModel>> getReceipts();
  Future<ReceiptModel> addReceipt(ReceiptModel receipt);
  Future<void> deleteReceipt(String id);
}

// Local için ayrı interface
abstract class ReceiptLocalDataSource {
  Future<List<ReceiptModel>> getCachedReceipts();
  Future<void> cacheReceipts(List<ReceiptModel> receipts);
  Future<void> deleteCachedReceipt(String id);
}

// Her implementation sadece ihtiyacı olanı implement eder
class ReceiptRemoteDataSourceImpl implements ReceiptRemoteDataSource {
  // Sadece remote metodlar
}

class ReceiptLocalDataSourceImpl implements ReceiptLocalDataSource {
  // Sadece local metodlar
}
```

### Repository'de Kullanım
```dart
class ReceiptRepositoryImpl implements ReceiptRepository {
  // Her data source kendi interface'ini implement ediyor
  final ReceiptRemoteDataSource remoteDataSource;
  final ReceiptLocalDataSource localDataSource;
  
  // Repository istediği data source'u kullanır
  Future<Either<Failure, List<Receipt>>> getReceipts() async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.getReceipts(); // Remote interface
    } else {
      return localDataSource.getCachedReceipts(); // Local interface
    }
  }
}
```

## 5. Dependency Inversion Principle (DIP)
**"Üst seviye modüller alt seviye modüllere bağımlı olmamalı. İkisi de soyutlamalara bağımlı olmalı."**

### ❌ Yanlış - Concrete Dependency
```dart
class ReceiptBloc {
  // Concrete implementation'a bağımlı ❌
  final ReceiptRepositoryImpl repository;
  
  ReceiptBloc() : repository = ReceiptRepositoryImpl();
  
  void loadReceipts() {
    repository.getReceipts(); // Specific implementation'a bağlı
  }
}
```

### ✅ Doğru - Abstraction Dependency (Projemizdeki)

```dart
// 1. Abstraction tanımlama (Domain Layer)
abstract class ReceiptRepository {
  Future<Either<Failure, List<Receipt>>> getReceipts();
}

// 2. Use Case abstraction'a bağımlı
class GetReceipts implements UseCase<List<Receipt>, NoParams> {
  final ReceiptRepository repository; // Abstract ✅
  
  GetReceipts(this.repository); // Injection
  
  Future<Either<Failure, List<Receipt>>> call(NoParams params) {
    return repository.getReceipts();
  }
}

// 3. BLoC use case'e bağımlı (yine abstraction)
class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  final GetReceipts getReceipts; // Use case (abstraction) ✅
  
  ReceiptBloc({required this.getReceipts});
}

// 4. Implementation (Data Layer)
class ReceiptRepositoryImpl implements ReceiptRepository {
  // Implementation detayları
}

// 5. Dependency Injection ile bağlama
void setupDI() {
  sl.registerLazySingleton<ReceiptRepository>(
    () => ReceiptRepositoryImpl(...), // Concrete
  );
  
  sl.registerLazySingleton(() => GetReceipts(sl())); // Abstract
  
  sl.registerFactory(() => ReceiptBloc(
    getReceipts: sl(), // Abstract
  ));
}
```

### DIP Faydaları

1. **Değiştirilebilirlik**
```dart
// Test'te mock kullanabilirsiniz
class MockReceiptRepository implements ReceiptRepository {
  @override
  Future<Either<Failure, List<Receipt>>> getReceipts() async {
    return Right([/* test data */]);
  }
}

// Test
final mockRepo = MockReceiptRepository();
final useCase = GetReceipts(mockRepo); // ✅ Çalışır
```

2. **Esneklik**
```dart
// Farklı implementation'lar kullanabilirsiniz
sl.registerLazySingleton<ReceiptRepository>(
  () => isProduction 
    ? ReceiptRepositoryImpl(...)      // Production
    : MockReceiptRepository(...),     // Development
);
```

3. **Test Edilebilirlik**
```dart
void main() {
  test('should get receipts from repository', () async {
    // Arrange
    final mockRepository = MockReceiptRepository();
    final useCase = GetReceipts(mockRepository);
    
    when(mockRepository.getReceipts())
      .thenAnswer((_) async => Right(tReceipts));
    
    // Act
    final result = await useCase(NoParams());
    
    // Assert
    expect(result, Right(tReceipts));
  });
}
```

## SOLID Prensiplerinin Birlikte Kullanımı

### Örnek: Receipt Feature

```dart
// SRP - Her sınıf tek sorumluluk
class GetReceipts { /* Sadece receipts getir */ }
class AddReceipt { /* Sadece receipt ekle */ }
class DeleteReceipt { /* Sadece receipt sil */ }

// OCP - Yeni repository eklenebilir
abstract class ReceiptRepository { }
class ReceiptRepositoryImpl implements ReceiptRepository { }
class ReceiptFirebaseRepository implements ReceiptRepository { } // Yeni

// LSP - Model, Entity yerine kullanılabilir
class ReceiptModel extends Receipt { }

// ISP - Ayrı arayüzler
abstract class ReceiptRemoteDataSource { }
abstract class ReceiptLocalDataSource { }

// DIP - Abstraction'lara bağımlılık
class ReceiptBloc {
  final GetReceipts getReceipts; // Abstract use case
  final AddReceipt addReceipt;   // Abstract use case
}
```

## Pratik Öneriler

1. **Her zaman interface'lere kod yazın**
   ```dart
   // ✅ Doğru
   ReceiptRepository repo;
   
   // ❌ Yanlış
   ReceiptRepositoryImpl repo;
   ```

2. **Dependency Injection kullanın**
   ```dart
   // get_it, injectable, provider gibi
   ```

3. **Test yazarken SOLID'in değerini görürsünüz**
   ```dart
   // SOLID olmadan test yazmak zor
   // SOLID ile mock'lar kolayca inject edilir
   ```

4. **Küçük sınıflar oluşturun**
   ```dart
   // Her sınıf 50-100 satırdan az olmalı (SRP)
   ```

5. **Concrete'leri gizleyin**
   ```dart
   // Public API'niz abstract olmalı
   // Implementation detayları private
   ```

## Özet

| Prensip | Anlamı | Projede |
|---------|--------|---------|
| SRP | Bir sınıf = Bir sorumluluk | Use Case başına bir sınıf |
| OCP | Genişletmeye açık | Repository pattern |
| LSP | Alt sınıf yerine kullanılabilir | Model extends Entity |
| ISP | Küçük interface'ler | Remote/Local ayrı |
| DIP | Abstraction'lara bağımlı | DI + Abstract repositories |

Bu prensipler birlikte kullanıldığında:
- ✅ Test edilebilir kod
- ✅ Bakımı kolay
- ✅ Genişletilebilir
- ✅ Anlaşılabilir
- ✅ Yeniden kullanılabilir
