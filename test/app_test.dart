import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:perfect_cyrcle/main.dart';

void main() {
  testWidgets('App should launch without crashing', (WidgetTester tester) async {
    // Initialize SharedPreferences mock
    SharedPreferences.setMockInitialValues({});
    
    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp());
    
    // Wait for any async operations to complete
    await tester.pumpAndSettle();
    
    // Verify app launched successfully by checking for a basic element
    expect(find.text('Σχεδίασε έναν τέλειο κύκλο'), findsOneWidget);
  });
}