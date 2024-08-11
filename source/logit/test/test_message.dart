import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:logit/doctor/screen/message.dart';
import 'package:logit/model/message.dart';
import 'package:logit/model/user.dart';

// Mock classes
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
  });

  testWidgets('MessageScreenDoctor displays messages',
      (WidgetTester tester) async {
    // Prepare test data
    final patientUid = 'patient123';
    final doctorUid = 'doctor456';

    // Add some test messages to the fake Firestore
    await fakeFirestore
        .collection('chats')
        .doc('$patientUid-$doctorUid')
        .collection('messages')
        .add({
      'sender': await fetchWithUID(doctorUid),
      'text': 'Test message 1',
      'timestamp': Timestamp.now(),
    });

    await fakeFirestore
        .collection('chats')
        .doc('$patientUid-$doctorUid')
        .collection('messages')
        .add({
      'sender': await fetchWithUID(patientUid),
      'text': 'Test message 2',
      'timestamp': Timestamp.now(),
    });

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: MessageScreenDoctor(patientUid, doctorUid),
    ));

    // Wait for the future to complete
    await tester.pumpAndSettle();

    // Verify that the messages are displayed
    expect(find.text('Test message 1'), findsOneWidget);
    expect(find.text('Test message 2'), findsOneWidget);
  });

  testWidgets('NewMessage widget sends a message', (WidgetTester tester) async {
    final patientUid = 'patient123';
    final doctorUid = 'doctor456';

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: NewMessage(patientUid, doctorUid, () {}),
      ),
    ));

    // Enter a message
    await tester.enterText(find.byType(TextField), 'New test message');

    // Tap the send button
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    // Verify that the message was sent (added to Firestore)
    final messages = await fakeFirestore
        .collection('chats')
        .doc('$patientUid-$doctorUid')
        .collection('messages')
        .get();

    expect(messages.docs.length, 1);
    expect(messages.docs.first['text'], 'New test message');
  });

  testWidgets('MessageScreenDoctor updates when new message is sent',
      (WidgetTester tester) async {
    final patientUid = 'patient123';
    final doctorUid = 'doctor456';

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: MessageScreenDoctor(patientUid, doctorUid),
    ));

    // Wait for the future to complete
    await tester.pumpAndSettle();

    // Initially, there should be no messages
    expect(find.text('No messages found.'), findsOneWidget);

    // Send a new message
    final newMessageWidget = tester.widget<NewMessage>(find.byType(NewMessage));
    await tester.enterText(find.byType(TextField), 'New test message');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    // Verify that the new message is displayed
    expect(find.text('New test message'), findsOneWidget);
  });
}
