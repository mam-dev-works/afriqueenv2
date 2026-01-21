# Testing Guide for AfriQueen

## Running Tests

### Run all tests
```bash
flutter test
```

### Run specific test file
```bash
flutter test test/features/home/bloc/home_bloc_test.dart
```

### Run tests with coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Run tests in watch mode
```bash
flutter test --watch
```

## Test Structure

```
test/
├── helpers/
│   └── test_helpers.dart          # Shared test utilities
├── features/
│   ├── home/
│   │   ├── bloc/
│   │   │   └── home_bloc_test.dart
│   │   └── repository/
│   │       └── home_repository_test.dart
│   ├── chat/
│   ├── auth/
│   └── profile/
└── widgets/
    └── common_button_test.dart     # Reusable widget tests
```

## Writing Your First Test

### 1. Start with Repository Tests (Easiest)

Test data layer logic without UI complexity:

```dart
test('fetchUser returns user data', () async {
  // Arrange - Set up test data
  final repository = UserRepository();
  
  // Act - Call the function
  final user = await repository.fetchUser('user123');
  
  // Assert - Verify result
  expect(user.id, 'user123');
  expect(user.name, isNotEmpty);
});
```

### 2. Then BLoC Tests (Business Logic)

Use `bloc_test` package for testing state transitions:

```dart
blocTest<HomeBloc, HomeState>(
  'emits [Loading, Loaded] when data fetched successfully',
  build: () => HomeBloc(repo: mockRepo),
  act: (bloc) => bloc.add(FetchData()),
  expect: () => [Loading(), Loaded(data: testData)],
);
```

### 3. Widget Tests (UI Components)

Test individual widgets in isolation:

```dart
testWidgets('button shows text', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: MyButton(text: 'Click'),
    ),
  );
  
  expect(find.text('Click'), findsOneWidget);
});
```

### 4. Integration Tests (Full Screens)

Test complete user flows:

```dart
testWidgets('user can login', (tester) async {
  await tester.pumpWidget(MyApp());
  
  await tester.enterText(find.byKey(Key('email')), 'test@test.com');
  await tester.enterText(find.byKey(Key('password')), 'password');
  await tester.tap(find.text('Login'));
  
  await tester.pumpAndSettle();
  
  expect(find.text('Welcome'), findsOneWidget);
});
```

## Mocking Dependencies

### Mock Firebase
```dart
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

final fakeFirestore = FakeFirebaseFirestore();
final mockAuth = MockFirebaseAuth(signedIn: true);
```

### Mock Repositories
```dart
class MockHomeRepository extends Mock implements HomeRepository {}

final mockRepo = MockHomeRepository();
when(() => mockRepo.fetchUsers()).thenAnswer((_) async => testUsers);
```

## Testing Best Practices

### ✅ DO:
- Test public APIs, not implementation details
- Use descriptive test names: `'should return error when network fails'`
- Follow AAA pattern: Arrange, Act, Assert
- Mock external dependencies (Firebase, HTTP)
- Test edge cases and error scenarios
- Keep tests fast (under 1 second each)

### ❌ DON'T:
- Test private methods
- Test framework code (Flutter/Firebase)
- Create brittle tests that break on UI changes
- Skip tearDown (memory leaks)
- Test multiple things in one test

## Common Testing Patterns

### Testing Async Code
```dart
test('async operation completes', () async {
  final result = await repository.fetchData();
  expect(result, isNotNull);
});
```

### Testing Errors
```dart
test('throws error on failure', () {
  expect(
    () => repository.invalidOperation(),
    throwsA(isA<CustomException>()),
  );
});
```

### Testing Streams
```dart
test('stream emits values', () async {
  expect(
    repository.watchUsers(),
    emitsInOrder([user1, user2]),
  );
});
```

### Testing with Delays
```dart
testWidgets('shows loading indicator', (tester) async {
  await tester.pumpWidget(MyWidget());
  
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  
  await tester.pumpAndSettle(); // Wait for all animations
  
  expect(find.byType(CircularProgressIndicator), findsNothing);
});
```

## Priority for This Project

Given the messy codebase, test in this order:

### Week 1-2: Critical Paths
1. ✅ Auth tests (login, signup)
2. ✅ Chat repository tests
3. ✅ Profile repository tests

### Week 3-4: Business Logic
4. ✅ HomeBloc tests
5. ✅ ChatBloc tests
6. ✅ FavoriteBloc tests

### Month 2: UI Coverage
7. ✅ Common widgets
8. ✅ Main screens
9. ✅ User flows

### Month 3+: Full Coverage
10. ✅ Edge cases
11. ✅ Integration tests
12. ✅ Performance tests

## Debugging Test Failures

### Test times out
```dart
// Increase timeout
test('slow operation', () async {
  // ...
}, timeout: Timeout(Duration(minutes: 5)));
```

### Widget not found
```dart
// Print widget tree
await tester.pumpWidget(MyWidget());
debugPrint(find.byType(Text).evaluate().toString());
```

### Async errors
```dart
// Use pumpAndSettle for animations
await tester.pump(); // One frame
await tester.pumpAndSettle(); // All frames
```

## Resources

- [Flutter Testing Docs](https://docs.flutter.dev/testing)
- [BLoC Testing](https://bloclibrary.dev/#/testing)
- [Mocktail Package](https://pub.dev/packages/mocktail)
- [bloc_test Package](https://pub.dev/packages/bloc_test)

---

**Remember:** Don't aim for 100% coverage immediately. Start with critical features and build up gradually. Even 30% coverage of important code is better than 0%.
