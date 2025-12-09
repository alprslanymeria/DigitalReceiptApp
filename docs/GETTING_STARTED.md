# Başlangıç Rehberi

Bu dokümanda projeyi nasıl kullanacağınızı ve geliştireceğinizi adım adım açıklıyoruz.

## 🚀 Hızlı Başlangıç

### 1. Gereksinimler
- Flutter SDK (3.0.0 veya üzeri)
- Dart SDK
- Android Studio / VS Code
- Git

### 2. Projeyi Klonlama ve Kurulum

```bash
# Projeyi klonlayın
git clone https://github.com/alprslanymeria/DigitalReceiptApp.git
cd DigitalReceiptApp

# Bağımlılıkları yükleyin
flutter pub get

# Test mock'larını oluşturun
flutter pub run build_runner build --delete-conflicting-outputs

# Uygulamayı çalıştırın
flutter run
```

### 3. IDE Kurulumu

#### VS Code
Önerilen extension'lar:
- Flutter
- Dart
- Bloc (Felix Angelov)

#### Android Studio
- Flutter plugin
- Dart plugin

## 📖 Temel Konseptler

### Clean Architecture Nedir?

Clean Architecture, kodunuzu katmanlara ayırarak:
- ✅ Test edilebilirliği artırır
- ✅ Bağımlılıkları azaltır
- ✅ Değişiklikleri kolaylaştırır
- ✅ İş mantığını framework'den ayırır

### Katmanlar

```
┌─────────────────────────────┐
│   Presentation (UI)         │  ← Flutter widgets, BLoC
├─────────────────────────────┤
│   Domain (İş Mantığı)       │  ← Pure Dart, hiç framework yok
├─────────────────────────────┤
│   Data (Veri Erişimi)       │  ← API, Database, Cache
└─────────────────────────────┘
```

## 🛠️ Yeni Feature Eklemek

### Örnek: "User" Feature Ekleyelim

#### Adım 1: Domain Katmanı

```bash
# Klasörleri oluştur
mkdir -p lib/features/user/{domain/{entities,repositories,usecases},data/{models,datasources,repositories},presentation/{bloc,pages,widgets}}
```

**Entity oluştur** (`lib/features/user/domain/entities/user.dart`):
```dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;

  const User({
    required this.id,
    required this.name,
    required this.email,
  });

  @override
  List<Object> get props => [id, name, email];
}
```

**Repository interface** (`lib/features/user/domain/repositories/user_repository.dart`):
```dart
import 'package:dartz/dartz.dart';
import 'package:digital_receipt_app/core/error/failures.dart';
import 'package:digital_receipt_app/features/user/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUserById(String id);
  Future<Either<Failure, List<User>>> getUsers();
}
```

**Use Case** (`lib/features/user/domain/usecases/get_user.dart`):
```dart
import 'package:dartz/dartz.dart';
import 'package:digital_receipt_app/core/error/failures.dart';
import 'package:digital_receipt_app/core/usecases/usecase.dart';
import 'package:digital_receipt_app/features/user/domain/entities/user.dart';
import 'package:digital_receipt_app/features/user/domain/repositories/user_repository.dart';

class GetUser implements UseCase<User, GetUserParams> {
  final UserRepository repository;

  GetUser(this.repository);

  @override
  Future<Either<Failure, User>> call(GetUserParams params) async {
    return await repository.getUserById(params.userId);
  }
}

class GetUserParams {
  final String userId;
  const GetUserParams({required this.userId});
}
```

#### Adım 2: Data Katmanı

**Model** (`lib/features/user/data/models/user_model.dart`):
```dart
import 'package:digital_receipt_app/features/user/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
```

**Data Source** (`lib/features/user/data/datasources/user_remote_data_source.dart`):
```dart
import 'package:digital_receipt_app/features/user/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUserById(String id);
  Future<List<UserModel>> getUsers();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  // Dio client inject edilir
  
  @override
  Future<UserModel> getUserById(String id) async {
    // API call implementation
    throw UnimplementedError();
  }

  @override
  Future<List<UserModel>> getUsers() async {
    // API call implementation
    throw UnimplementedError();
  }
}
```

**Repository Implementation** (`lib/features/user/data/repositories/user_repository_impl.dart`):
```dart
import 'package:dartz/dartz.dart';
import 'package:digital_receipt_app/core/error/exceptions.dart';
import 'package:digital_receipt_app/core/error/failures.dart';
import 'package:digital_receipt_app/features/user/data/datasources/user_remote_data_source.dart';
import 'package:digital_receipt_app/features/user/domain/entities/user.dart';
import 'package:digital_receipt_app/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> getUserById(String id) async {
    try {
      final user = await remoteDataSource.getUserById(id);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    try {
      final users = await remoteDataSource.getUsers();
      return Right(users);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
```

#### Adım 3: Presentation Katmanı

**BLoC Events** (`lib/features/user/presentation/bloc/user_event.dart`):
```dart
import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserEvent extends UserEvent {
  final String userId;

  const LoadUserEvent(this.userId);

  @override
  List<Object> get props => [userId];
}
```

**BLoC States** (`lib/features/user/presentation/bloc/user_state.dart`):
```dart
import 'package:equatable/equatable.dart';
import 'package:digital_receipt_app/features/user/domain/entities/user.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;

  const UserLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object> get props => [message];
}
```

**BLoC** (`lib/features/user/presentation/bloc/user_bloc.dart`):
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:digital_receipt_app/features/user/domain/usecases/get_user.dart';
import 'package:digital_receipt_app/features/user/presentation/bloc/user_event.dart';
import 'package:digital_receipt_app/features/user/presentation/bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUser getUser;

  UserBloc({required this.getUser}) : super(UserInitial()) {
    on<LoadUserEvent>(_onLoadUser);
  }

  Future<void> _onLoadUser(
    LoadUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await getUser(GetUserParams(userId: event.userId));
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }
}
```

**Page** (`lib/features/user/presentation/pages/user_page.dart`):
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:digital_receipt_app/features/user/presentation/bloc/user_bloc.dart';
import 'package:digital_receipt_app/features/user/presentation/bloc/user_event.dart';
import 'package:digital_receipt_app/features/user/presentation/bloc/user_state.dart';

class UserPage extends StatelessWidget {
  final String userId;

  const UserPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Details')),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserInitial) {
            context.read<UserBloc>().add(LoadUserEvent(userId));
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${state.user.name}'),
                  Text('Email: ${state.user.email}'),
                ],
              ),
            );
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
```

#### Adım 4: Dependency Injection

`lib/injection_container.dart` dosyasına ekleyin:

```dart
// Features - User
// Bloc
sl.registerFactory(
  () => UserBloc(getUser: sl()),
);

// Use cases
sl.registerLazySingleton(() => GetUser(sl()));

// Repository
sl.registerLazySingleton<UserRepository>(
  () => UserRepositoryImpl(remoteDataSource: sl()),
);

// Data sources
sl.registerLazySingleton<UserRemoteDataSource>(
  () => UserRemoteDataSourceImpl(),
);
```

#### Adım 5: Test Yazma

**Entity Test** (`test/features/user/domain/entities/user_test.dart`):
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:digital_receipt_app/features/user/domain/entities/user.dart';

void main() {
  group('User Entity', () {
    test('should have correct properties', () {
      const user = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
      );

      expect(user.id, '1');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
    });
  });
}
```

**Use Case Test** (`test/features/user/domain/usecases/get_user_test.dart`):
```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:digital_receipt_app/features/user/domain/entities/user.dart';
import 'package:digital_receipt_app/features/user/domain/repositories/user_repository.dart';
import 'package:digital_receipt_app/features/user/domain/usecases/get_user.dart';

import 'get_user_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late GetUser usecase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    usecase = GetUser(mockRepository);
  });

  const tUser = User(
    id: '1',
    name: 'John Doe',
    email: 'john@example.com',
  );

  test('should get user from repository', () async {
    // Arrange
    when(mockRepository.getUserById('1'))
        .thenAnswer((_) async => const Right(tUser));

    // Act
    final result = await usecase(const GetUserParams(userId: '1'));

    // Assert
    expect(result, const Right(tUser));
    verify(mockRepository.getUserById('1'));
    verifyNoMoreInteractions(mockRepository);
  });
}
```

## 🧪 Testing

### Unit Tests Çalıştırma
```bash
flutter test
```

### Coverage Raporu
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Mock Oluşturma
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🔍 Kod Kalitesi

### Linting
```bash
flutter analyze
```

### Formatting
```bash
dart format lib/ test/
```

## 📦 Build

### Android APK
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🐛 Debugging İpuçları

### 1. BLoC State Logging
`main.dart`'a ekleyin:
```dart
import 'package:bloc/bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}

void main() async {
  Bloc.observer = SimpleBlocObserver();
  // ...
}
```

### 2. Network Logging
Dio interceptor ekleyin:
```dart
dio.interceptors.add(LogInterceptor(
  requestBody: true,
  responseBody: true,
));
```

### 3. Test Debugging
```bash
flutter test --debug test/features/receipt/domain/usecases/get_receipts_test.dart
```

## 📚 Kaynaklar

### Resmi Dokümantasyon
- [Flutter Docs](https://flutter.dev/docs)
- [Dart Docs](https://dart.dev/guides)
- [BLoC Library](https://bloclibrary.dev)

### Clean Architecture
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture by Reso Coder](https://resocoder.com/flutter-clean-architecture-tdd/)

### SOLID Prensipleri
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)
- [SOLID in Flutter](https://medium.com/flutter-community/solid-principles-in-flutter-3c6e8c8c0d18)

## 💡 Best Practices

1. **Her feature için ayrı klasör**
   ```
   features/
   ├── feature1/
   ├── feature2/
   └── feature3/
   ```

2. **Domain katmanı pure Dart**
   - Flutter import etme
   - Sadece Dart paketleri kullan

3. **Dependency Injection kullan**
   - Tight coupling'den kaçın
   - Test için mock'ları kolayca inject edin

4. **Test yaz**
   - Her use case için unit test
   - Her repository için test
   - Widget testleri

5. **Error handling**
   - Either<Failure, T> kullan
   - Custom exception'lar tanımla
   - User-friendly error mesajları

## ❓ Sık Sorulan Sorular

### Q: Neden 3 katman?
A: Separation of concerns. Her katman kendi sorumluluğuna sahip.

### Q: Neden abstract repository'ler?
A: Dependency Inversion. Implementation'ları kolayca değiştirebilirsiniz.

### Q: BLoC yerine Provider kullanabilir miyim?
A: Evet, presentation katmanını değiştirin. Domain ve Data katmanı aynı kalır.

### Q: API endpoint'leri nerede?
A: `lib/core/utils/constants.dart` dosyasında tanımlayın.

### Q: Database için SQLite mi yoksa Hive mı?
A: İkisi de kullanılabilir. Local data source implementation'ını değiştirin.

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/AmazingFeature`)
3. Commit yapın (`git commit -m 'Add some AmazingFeature'`)
4. Push edin (`git push origin feature/AmazingFeature`)
5. Pull Request açın

## 📞 İletişim

Sorularınız için issue açabilirsiniz.
