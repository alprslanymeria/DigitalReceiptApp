# Digital Receipt App

Flutter uygulaması için Clean Architecture ve SOLID prensiplerine uygun bir proje taslağı.

## 📐 Mimari (Architecture)

Bu proje **Clean Architecture** prensiplerine göre yapılandırılmıştır. Uygulama üç ana katmandan oluşur:

### 1. Domain Layer (İş Mantığı Katmanı)
En içteki katman, hiçbir dış bağımlılığı yoktur.
- **Entities**: Saf iş nesneleri (Receipt, ReceiptItem)
- **Repositories**: Repository arayüzleri (abstract)
- **Use Cases**: İş mantığı kuralları (GetReceipts, AddReceipt, DeleteReceipt)

### 2. Data Layer (Veri Katmanı)
Domain katmanını implemente eder.
- **Models**: Entity'lerin JSON serializasyonu için genişletilmiş halleri
- **Data Sources**: 
  - Remote: API çağrıları için
  - Local: Yerel cache için (SharedPreferences, SQLite)
- **Repository Implementations**: Domain katmanındaki repository arayüzlerinin implementasyonları

### 3. Presentation Layer (Sunum Katmanı)
Kullanıcı arayüzü ve state management.
- **Pages**: Ekran bileşenleri
- **Widgets**: Yeniden kullanılabilir UI bileşenleri
- **BLoC**: State management (Business Logic Component)

## 🎯 SOLID Prensipleri

### Single Responsibility Principle (SRP)
Her sınıf tek bir sorumluluğa sahiptir:
- Use Case'ler sadece bir işi yapar
- Repository'ler sadece veri erişiminden sorumludur
- BLoC'lar sadece state yönetiminden sorumludur

### Open/Closed Principle (OCP)
Sınıflar genişletmeye açık, değişikliğe kapalıdır:
- Abstract repository'ler farklı implementasyonlara izin verir
- Use Case'ler değiştirilmeden yeni özellikler eklenebilir

### Liskov Substitution Principle (LSP)
Alt sınıflar üst sınıfların yerine kullanılabilir:
- ReceiptModel, Receipt entity'sini genişletir
- Tüm data source implementasyonları arayüzlerini tam olarak implemente eder

### Interface Segregation Principle (ISP)
Arayüzler özel ve odaklanmıştır:
- ReceiptRepository sadece gerekli metodları içerir
- Data source arayüzleri ayrı ayrı tanımlanmıştır

### Dependency Inversion Principle (DIP)
Yüksek seviye modüller düşük seviye modüllere bağımlı değildir:
- Use Case'ler abstract repository'lere bağımlıdır
- Dependency Injection (get_it) kullanılır
- NetworkInfo, Connectivity gibi platformlar abstract edilmiştir

## 📁 Proje Yapısı

```
lib/
├── core/                           # Çekirdek katman
│   ├── error/                      # Hata yönetimi
│   │   ├── exceptions.dart         # Exception sınıfları
│   │   └── failures.dart           # Failure sınıfları
│   ├── usecases/                   # Base use case
│   │   └── usecase.dart
│   └── utils/                      # Yardımcı sınıflar
│       ├── constants.dart
│       └── network_info.dart
│
├── features/                       # Özellikler (Feature-first)
│   └── receipt/                    # Receipt özelliği
│       ├── data/                   # Data katmanı
│       │   ├── datasources/        # Veri kaynakları
│       │   │   ├── receipt_local_data_source.dart
│       │   │   └── receipt_remote_data_source.dart
│       │   ├── models/             # Data modelleri
│       │   │   └── receipt_model.dart
│       │   └── repositories/       # Repository implementasyonları
│       │       └── receipt_repository_impl.dart
│       │
│       ├── domain/                 # Domain katmanı
│       │   ├── entities/           # İş nesneleri
│       │   │   └── receipt.dart
│       │   ├── repositories/       # Repository arayüzleri
│       │   │   └── receipt_repository.dart
│       │   └── usecases/           # Use case'ler
│       │       ├── add_receipt.dart
│       │       ├── delete_receipt.dart
│       │       └── get_receipts.dart
│       │
│       └── presentation/           # Presentation katmanı
│           ├── bloc/               # BLoC state management
│           │   ├── receipt_bloc.dart
│           │   ├── receipt_event.dart
│           │   └── receipt_state.dart
│           ├── pages/              # Ekranlar
│           │   └── receipts_page.dart
│           └── widgets/            # UI bileşenleri
│               └── receipt_list_item.dart
│
├── injection_container.dart        # Dependency Injection
└── main.dart                       # Uygulama giriş noktası

test/                               # Test dosyaları
└── features/
    └── receipt/
        ├── domain/
        │   ├── entities/
        │   └── usecases/
        ├── data/
        └── presentation/
```

## 🚀 Kullanılan Teknolojiler

- **State Management**: flutter_bloc
- **Dependency Injection**: get_it
- **Functional Programming**: dartz (Either, Option)
- **Network**: dio
- **Local Storage**: shared_preferences, sqflite
- **Testing**: mockito, bloc_test

## 📦 Kurulum

1. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

2. Test mock'larını oluşturun:
```bash
flutter pub run build_runner build
```

3. Uygulamayı çalıştırın:
```bash
flutter run
```

## 🧪 Test

Unit testleri çalıştırın:
```bash
flutter test
```

## 📚 Ek Özellikler Eklemek

Yeni bir özellik eklemek için:

1. `lib/features/` altında yeni bir klasör oluşturun
2. Domain katmanını oluşturun (entities, repositories, use cases)
3. Data katmanını oluşturun (models, data sources, repository impl)
4. Presentation katmanını oluşturun (bloc, pages, widgets)
5. `injection_container.dart` dosyasına bağımlılıkları ekleyin

## 🎨 Kod Stili

Proje Flutter linting kurallarını takip eder:
```bash
flutter analyze
```

## 📝 Lisans

Bu proje MIT lisansı altında lisanslanmıştır.
