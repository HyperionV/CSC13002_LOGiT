import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:logit/screen/auth.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirebaseFirestore;

  setUp(() async {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseFirestore = MockFirebaseFirestore();

    await Firebase.initializeApp();
  });

  testWidgets('Login form is displayed initially', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AuthScreen()));

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Enter your email'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
  });

  testWidgets('Switch to register form', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AuthScreen()));

    await tester.tap(find.text('Create an account'));
    await tester.pumpAndSettle();

    expect(find.text('Register'), findsOneWidget);
    expect(find.text('Enter your name'), findsOneWidget);
    expect(find.text('Enter your email'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
    expect(
        find.text('I agree to the LOGiT Terms of Service and Privacy Policy'),
        findsOneWidget);
  });

  testWidgets('Login with valid credentials', (WidgetTester tester) async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
      email: 'test@example.com',
      password: 'password123',
    )).thenAnswer((_) async => MockUserCredential());

    await tester.pumpWidget(MaterialApp(home: AuthScreen()));

    await tester.enterText(
        find.byType(TextFormField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    verify(mockFirebaseAuth.signInWithEmailAndPassword(
      email: 'test@example.com',
      password: 'password123',
    )).called(1);
  });

  testWidgets('Register with valid information', (WidgetTester tester) async {
    final mockUser = MockUser();
    when(mockUser.uid).thenReturn('test_uid');

    when(mockFirebaseAuth.createUserWithEmailAndPassword(
      email: 'newuser@example.com',
      password: 'newpassword123',
    )).thenAnswer((_) async => MockUserCredential());

    when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

    // when(mockFirebaseFirestore.collection('users').doc('test_uid').set(any))
    //     .thenAnswer((_) async => {});

    await tester.pumpWidget(MaterialApp(home: AuthScreen()));

    await tester.tap(find.text('Create an account'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'New User');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'newuser@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'newpassword123');

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Signup'));
    await tester.pumpAndSettle();

    verify(mockFirebaseAuth.createUserWithEmailAndPassword(
      email: 'newuser@example.com',
      password: 'newpassword123',
    )).called(1);

    // verify(mockFirebaseFirestore.collection('users').doc('test_uid').set(any)).called(1);
  });
}
