# Proje Yapısı

Bu dokümanda proje klasör yapısını ve dosyaların sorumluluklarını detaylı olarak açıklıyoruz.

## 📂 Ana Klasör Yapısı

```
DigitalReceiptApp/
├── android/                    # Android platform kodu
├── ios/                        # iOS platform kodu  
├── web/                        # Web platform kodu
├── lib/                        # Ana uygulama kodu
│   ├── core/                   # Ortak/Paylaşılan kod
│   ├── features/               # Özellikler (Feature-first)
│   ├── injection_container.dart # DI yapılandırması
│   └── main.dart               # Uygulama giriş noktası
├── test/                       # Test dosyaları
├── docs/                       # Dokümantasyon
├── pubspec.yaml               # Bağımlılıklar
└── analysis_options.yaml      # Lint kuralları
```

## 🎯 Core Katmanı (`lib/core/`)

Uygulamanın tüm feature'ları tarafından kullanılan ortak kod.

```
lib/core/
├── error/
│   ├── exceptions.dart        # Exception sınıfları
│   └── failures.dart          # Failure sınıfları
├── usecases/
│   └── usecase.dart          # Base UseCase interface
└── utils/
    ├── constants.dart         # Uygulama sabitleri
    └── network_info.dart      # Network durumu kontrolü
```

### Dosya Açıklamaları

#### `error/exceptions.dart`
```dart
// Data layer'da kullanılan exception'lar
// Örnek: ServerException, CacheException, NetworkException
// Kullanım: Data source'larda throw edilir
```

#### `error/failures.dart`
```dart
// Domain layer'da kullanılan failure'lar
// Örnek: ServerFailure, CacheFailure, NetworkFailure
// Kullanım: Repository'ler Either<Failure, T> döner
```

#### `usecases/usecase.dart`
```dart
// Tüm use case'lerin implement ettiği base interface
// Generic: UseCase<Type, Params>
// Zorunlu metod: Future<Either<Failure, Type>> call(Params params)
```

#### `utils/constants.dart`
```dart
// API URL'leri, timeout süreleri, cache key'leri
// Sabit değerler, magic number'lardan kaçınmak için
```

#### `utils/network_info.dart`
```dart
// Internet bağlantısı kontrolü
// Repository'ler remote/cache kararı için kullanır
```

## 🎨 Features Katmanı (`lib/features/`)

Her feature kendi klasöründe, Clean Architecture'a uygun şekilde organize.

```
lib/features/
└── receipt/                    # Receipt özelliği
    ├── data/                   # Data Layer
    │   ├── datasources/        # Veri kaynakları
    │   │   ├── receipt_local_data_source.dart   # Cache
    │   │   └── receipt_remote_data_source.dart  # API
    │   ├── models/             # Data modelleri
    │   │   └── receipt_model.dart
    │   └── repositories/       # Repository implementasyonları
    │       └── receipt_repository_impl.dart
    │
    ├── domain/                 # Domain Layer
    │   ├── entities/           # İş nesneleri
    │   │   └── receipt.dart
    │   ├── repositories/       # Repository interface'leri
    │   │   └── receipt_repository.dart
    │   └── usecases/           # İş mantığı
    │       ├── add_receipt.dart
    │       ├── delete_receipt.dart
    │       └── get_receipts.dart
    │
    └── presentation/           # Presentation Layer
        ├── bloc/               # State management
        │   ├── receipt_bloc.dart
        │   ├── receipt_event.dart
        │   └── receipt_state.dart
        ├── pages/              # Tam ekran sayfalar
        │   └── receipts_page.dart
        └── widgets/            # Yeniden kullanılabilir widget'lar
            └── receipt_list_item.dart
```

## 📊 Veri Akışı Diyagramı

### Read Operation (Veri Okuma)

```
┌──────────────┐
│   UI Layer   │ ReceiptsPage
└──────┬───────┘
       │ BlocBuilder dinler
       ↓
┌──────────────┐
│  BLoC Layer  │ ReceiptBloc
└──────┬───────┘
       │ LoadReceiptsEvent
       ↓
┌──────────────┐
│  Use Case    │ GetReceipts
└──────┬───────┘
       │ call(NoParams)
       ↓
┌──────────────┐
│  Repository  │ ReceiptRepository (interface)
└──────┬───────┘
       │
       ↓
┌──────────────┐
│ Repository   │ ReceiptRepositoryImpl
│    Impl      │
└──────┬───────┘
       │ Network var mı?
       ├─── Evet → Remote Data Source
       └─── Hayır → Local Data Source
       │
       ↓
┌──────────────┐
│ Data Source  │ API / Cache
└──────┬───────┘
       │ ReceiptModel
       ↓
┌──────────────┐
│  Repository  │ Model → Entity dönüşümü
│    Impl      │
└──────┬───────┘
       │ Either<Failure, List<Receipt>>
       ↓
┌──────────────┐
│   Use Case   │
└──────┬───────┘
       │
       ↓
┌──────────────┐
│    BLoC      │ ReceiptLoaded state emit eder
└──────┬───────┘
       │
       ↓
┌──────────────┐
│      UI      │ State değişikliğini algılar, rebuild
└──────────────┘
```

### Write Operation (Veri Yazma)

```
┌──────────────┐
│      UI      │ FAB'a tıklama
└──────┬───────┘
       │ AddReceiptEvent(receipt)
       ↓
┌──────────────┐
│    BLoC      │
└──────┬───────┘
       │
       ↓
┌──────────────┐
│  Use Case    │ AddReceipt
└──────┬───────┘
       │ call(AddReceiptParams)
       ↓
┌──────────────┐
│ Repository   │
│    Impl      │
└──────┬───────┘
       │ Network var mı?
       ├─── Evet → Remote'a gönder + Cache'e yaz
       └─── Hayır → Sadece cache'e yaz
       │
       ↓
┌──────────────┐
│    BLoC      │ ReceiptOperationSuccess
└──────┬───────┘
       │ Reload data
       ↓
┌──────────────┐
│      UI      │ Başarı mesajı + Liste güncellenir
└──────────────┘
```

## 🧪 Test Yapısı (`test/`)

Test klasörü, `lib/` klasörünü mirror eder.

```
test/
└── features/
    └── receipt/
        ├── domain/
        │   ├── entities/
        │   │   └── receipt_test.dart
        │   └── usecases/
        │       └── get_receipts_test.dart
        ├── data/
        │   ├── models/
        │   ├── datasources/
        │   └── repositories/
        └── presentation/
            └── bloc/
```

### Test Türleri

1. **Unit Tests** (Domain & Data)
   - Entity testleri
   - Use case testleri
   - Repository testleri
   - Model testleri

2. **Widget Tests** (Presentation)
   - Widget render testleri
   - User interaction testleri

3. **Integration Tests**
   - End-to-end flow testleri

## 📱 Dependency Injection

### `injection_container.dart` Yapısı

```dart
final sl = GetIt.instance; // Service Locator

Future<void> init() async {
  //! Features - Receipt
  
  // Bloc (Factory - her seferinde yeni instance)
  sl.registerFactory(() => ReceiptBloc(...));
  
  // Use Cases (Lazy Singleton - ilk kullanımda oluşturulur)
  sl.registerLazySingleton(() => GetReceipts(sl()));
  sl.registerLazySingleton(() => AddReceipt(sl()));
  
  // Repository (Lazy Singleton)
  sl.registerLazySingleton<ReceiptRepository>(
    () => ReceiptRepositoryImpl(...),
  );
  
  // Data Sources (Lazy Singleton)
  sl.registerLazySingleton<ReceiptRemoteDataSource>(...);
  sl.registerLazySingleton<ReceiptLocalDataSource>(...);
  
  //! Core
  sl.registerLazySingleton<NetworkInfo>(...);
  
  //! External (Singleton - hemen oluşturulur)
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
```

### Registration Type'ları

| Type | Açıklama | Kullanım |
|------|----------|----------|
| `registerFactory` | Her seferinde yeni instance | BLoC'lar |
| `registerLazySingleton` | İlk kullanımda bir kez oluşturulur | Use Cases, Repositories |
| `registerSingleton` | Hemen oluşturulur | External dependencies |

## 🔄 State Management (BLoC)

### BLoC Bileşenleri

```
receipt_bloc.dart       # Ana BLoC sınıfı
    ↓
receipt_event.dart      # UI'dan gelen olaylar
    ↓
receipt_bloc.dart       # Event handler'lar
    ↓  
receipt_state.dart      # UI'a dönen durumlar
```

### Event → State Akışı

```
LoadReceiptsEvent
    ↓
ReceiptLoading (loading indicator)
    ↓
[Use Case çalışır]
    ↓
Success → ReceiptLoaded(receipts)
Failure → ReceiptError(message)
```

## 📦 Paket Yapısı

### Katmanlara Göre Bağımlılıklar

#### Domain Layer
```yaml
dependencies:
  dartz: ^0.10.1       # Either, Option
  equatable: ^2.0.5    # Value equality
```
**Önemli**: Flutter veya diğer framework'ler YOK!

#### Data Layer
```yaml
dependencies:
  dio: ^5.3.3                      # HTTP client
  shared_preferences: ^2.2.2       # Simple cache
  sqflite: ^2.3.0                  # SQLite database
  path_provider: ^2.1.1            # File paths
```

#### Presentation Layer
```yaml
dependencies:
  flutter_bloc: ^8.1.3   # BLoC implementation
  intl: ^0.18.1          # Internationalization
```

#### Core
```yaml
dependencies:
  get_it: ^7.6.4              # Service locator
  connectivity_plus: ^5.0.1    # Network check
  logger: ^2.0.2+1            # Logging
```

## 🎯 Dosya Boyutları ve Sorumluluklar

### Küçük Dosyalar (< 100 satır)
- Entities
- Events
- States
- Constants

### Orta Dosyalar (100-300 satır)
- Use Cases
- Models
- Widgets
- Data Sources

### Büyük Dosyalar (300-500 satır)
- Repository Implementations
- BLoCs
- Pages

> **Not**: Bir dosya 500 satırı geçiyorsa, refactor etmeyi düşünün!

## 🔍 Dosya İsimlendirme Kuralları

### Genel Kural: `snake_case.dart`

```
✅ Doğru:
receipt_repository.dart
receipt_remote_data_source.dart
get_receipts.dart

❌ Yanlış:
ReceiptRepository.dart
receipt-repository.dart
receiptRepository.dart
```

### Sınıf İsimleri: `PascalCase`

```dart
✅ Doğru:
class ReceiptRepository
class GetReceipts
class ReceiptBloc

❌ Yanlış:
class receipt_repository
class getReceipts
class receiptBLOC
```

## 📋 Feature Ekleme Checklist

Yeni bir feature eklerken:

- [ ] Domain katmanı
  - [ ] Entity oluştur
  - [ ] Repository interface tanımla
  - [ ] Use case'ler ekle
- [ ] Data katmanı
  - [ ] Model oluştur
  - [ ] Remote data source
  - [ ] Local data source
  - [ ] Repository implementation
- [ ] Presentation katmanı
  - [ ] Events tanımla
  - [ ] States tanımla
  - [ ] BLoC oluştur
  - [ ] Page/Widget ekle
- [ ] DI yapılandırması
  - [ ] `injection_container.dart` güncelle
- [ ] Tests
  - [ ] Entity tests
  - [ ] Use case tests
  - [ ] Widget tests

## 🚀 Proje Büyüdükçe

### Yeni Feature Eklemek

```
lib/features/
├── receipt/        # Mevcut
├── user/          # Yeni
├── settings/      # Yeni
└── authentication/# Yeni
```

### Shared Components

Birden fazla feature'da kullanılan componentler:

```
lib/
├── core/
│   └── widgets/          # Ortak widget'lar
│       ├── loading_indicator.dart
│       └── error_message.dart
├── features/
    └── ...
```

### Config Files

Environment-specific yapılandırma:

```
lib/
├── core/
│   └── config/
│       ├── app_config.dart
│       ├── dev_config.dart
│       └── prod_config.dart
```

## 📚 Özet

Bu proje yapısı:
- ✅ Clean Architecture prensiplerine uygun
- ✅ SOLID prensiplerini takip eder
- ✅ Test edilebilir
- ✅ Ölçeklenebilir
- ✅ Bakımı kolay
- ✅ Anlaşılabilir

Her katmanın kendi sorumluluğu var ve katmanlar arası bağımlılıklar minimum seviyede.
