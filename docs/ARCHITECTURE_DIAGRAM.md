# Digital Receipt App - Architecture Diagram

## Clean Architecture Layers

```
┌─────────────────────────────────────────────────────────────────────┐
│                         PRESENTATION LAYER                           │
│                                                                       │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │                         UI (Flutter)                          │  │
│  │                                                                │  │
│  │  ┌─────────────────┐         ┌─────────────────┐            │  │
│  │  │ ReceiptsListPage│         │ReceiptDetailPage│            │  │
│  │  └─────────────────┘         └─────────────────┘            │  │
│  │                                                                │  │
│  │  ┌─────────────────┐         ┌─────────────────┐            │  │
│  │  │ReceiptListItem  │         │ReceiptDetailWdgt│            │  │
│  │  └─────────────────┘         └─────────────────┘            │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                 │                                    │
│                                 ▼                                    │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │                     STATE MANAGEMENT                          │  │
│  │                                                                │  │
│  │                    ┌─────────────────┐                        │  │
│  │                    │  ReceiptBloc    │                        │  │
│  │                    │   (BLoC)        │                        │  │
│  │                    │                 │                        │  │
│  │  ReceiptEvent ──▶  │  Event Handler  │  ──▶ ReceiptState     │  │
│  │                    └─────────────────┘                        │  │
│  └──────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
                                 │
                    Depends on Use Cases (Abstract)
                                 ▼
┌─────────────────────────────────────────────────────────────────────┐
│                           DOMAIN LAYER                               │
│                        (Business Logic)                              │
│                                                                       │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │                         USE CASES                             │  │
│  │                                                                │  │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │  │
│  │  │GetAllReceipts│  │GetReceiptById│  │CreateReceipt │       │  │
│  │  └──────────────┘  └──────────────┘  └──────────────┘       │  │
│  │                                                                │  │
│  │                    ┌──────────────┐                           │  │
│  │                    │DeleteReceipt │                           │  │
│  │                    └──────────────┘                           │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                       │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │                    REPOSITORY INTERFACE                       │  │
│  │                                                                │  │
│  │                  ┌────────────────────┐                       │  │
│  │                  │ ReceiptRepository  │  (Abstract)           │  │
│  │                  │   (Interface)      │                       │  │
│  │                  └────────────────────┘                       │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                       │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │                        ENTITIES                               │  │
│  │                                                                │  │
│  │              ┌─────────┐       ┌──────────────┐              │  │
│  │              │ Receipt │       │ ReceiptItem  │              │  │
│  │              └─────────┘       └──────────────┘              │  │
│  └──────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
                                 ▲
                    Implements Repository Interface
                                 │
┌─────────────────────────────────────────────────────────────────────┐
│                            DATA LAYER                                │
│                                                                       │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │                  REPOSITORY IMPLEMENTATION                    │  │
│  │                                                                │  │
│  │                ┌──────────────────────────┐                   │  │
│  │                │ ReceiptRepositoryImpl    │                   │  │
│  │                │                          │                   │  │
│  │                │ • Exception → Failure    │                   │  │
│  │                │ • Offline-first logic    │                   │  │
│  │                │ • Cache coordination     │                   │  │
│  │                └──────────────────────────┘                   │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                 │                                    │
│                    ┌────────────┴────────────┐                      │
│                    ▼                         ▼                      │
│  ┌────────────────────────────┐  ┌────────────────────────────┐   │
│  │     DATA SOURCES           │  │     DATA SOURCES           │   │
│  │                            │  │                            │   │
│  │  ReceiptRemoteDataSource  │  │  ReceiptLocalDataSource   │   │
│  │                            │  │                            │   │
│  │  • API calls               │  │  • SharedPreferences      │   │
│  │  • Network requests        │  │  • Local caching          │   │
│  │  • HTTP operations         │  │  • Offline storage        │   │
│  └────────────────────────────┘  └────────────────────────────┘   │
│                                                                       │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │                         MODELS                                │  │
│  │                                                                │  │
│  │           ┌──────────────┐    ┌──────────────────┐           │  │
│  │           │ ReceiptModel │    │ ReceiptItemModel │           │  │
│  │           │              │    │                  │           │  │
│  │           │ + fromJson() │    │  + fromJson()    │           │  │
│  │           │ + toJson()   │    │  + toJson()      │           │  │
│  │           │ extends      │    │  extends         │           │  │
│  │           │ Receipt      │    │  ReceiptItem     │           │  │
│  │           └──────────────┘    └──────────────────┘           │  │
│  └──────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                            CORE LAYER                                │
│                                                                       │
│  ┌──────────────────────┐        ┌──────────────────────┐          │
│  │   Error Handling     │        │    Base Classes      │          │
│  │                      │        │                      │          │
│  │  • Failure (abs)     │        │  • UseCase<T,P>      │          │
│  │  • ServerFailure     │        │  • NoParams          │          │
│  │  • CacheFailure      │        │                      │          │
│  │  • NetworkFailure    │        │                      │          │
│  │  • Exception types   │        │                      │          │
│  └──────────────────────┘        └──────────────────────┘          │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                    DEPENDENCY INJECTION                              │
│                                                                       │
│                      ┌────────────────────┐                          │
│                      │   GetIt Service    │                          │
│                      │     Locator        │                          │
│                      │                    │                          │
│                      │  registerFactory   │                          │
│                      │  registerSingleton │                          │
│                      └────────────────────┘                          │
└─────────────────────────────────────────────────────────────────────┘
```

## Data Flow

### Fetching Receipts Flow:

```
1. User opens app
      ↓
2. ReceiptsListPage initializes
      ↓
3. BLoC receives LoadAllReceipts event
      ↓
4. BLoC calls GetAllReceipts use case
      ↓
5. Use case calls repository.getAllReceipts()
      ↓
6. Repository tries remote data source
      ↓
   ┌──────────────┬──────────────┐
   │              │              │
   ▼              ▼              ▼
Success      Network Error    Server Error
   │              │              │
   │              ├─────────────►│
   │              │              │
   ▼              ▼              ▼
Cache data    Try cache     Return Failure
   │              │              │
   └──────────────┴──────────────┘
                  ↓
7. Repository returns Either<Failure, List<Receipt>>
      ↓
8. Use case passes result to BLoC
      ↓
9. BLoC emits new state (Loading → Loaded/Error)
      ↓
10. UI rebuilds with data
```

## Dependency Direction (Dependency Inversion Principle)

```
Presentation  ──►  Domain  ◄──  Data
   (BLoC)         (Use Cases)   (Repository Impl)
                      ▲
                      │
                 Abstractions
              (Interfaces only)
```

All dependencies point **inward** toward the domain layer!

## SOLID Principles Applied

- **S**: Each use case, data source, repository has single responsibility
- **O**: Abstract interfaces allow new implementations without modification
- **L**: Models extend entities and can substitute them
- **I**: Separate interfaces for Remote and Local data sources
- **D**: All layers depend on abstractions, injected via GetIt

## Key Benefits

1. **Testability**: Each layer can be tested independently with mocks
2. **Maintainability**: Changes isolated to specific layers
3. **Scalability**: Easy to add new features following the same pattern
4. **Flexibility**: Can swap implementations (e.g., different data sources)
5. **Clean Code**: Clear separation of concerns
