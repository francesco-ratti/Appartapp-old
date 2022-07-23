import 'package:appartapp/widgets/google_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

/* ##############################

  FAILING TEST
  how to build a parent context in the test scenario ??

*/
void main() {
  /* We need a context to pass as argument to the parentContext of the GoogleSinInButton.
  We can actually mock the BuildContext so the test will run headless.
  BuildContext is an abstract class therefore it cannot be instantiated but
  it can be mocked by creating implementations of it. */

  MockBuildContext _mockContext;
  _mockContext = MockBuildContext();

  testWidgets('GoogleSignInButton has the button to sign in', (tester) async {
    // Create the widget by telling the tester to build it.

    await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(
            home: GoogleSignInButton(
          isLoadingCbk: (bool testArg) {},
          parentContext: _mockContext,
        ))));

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the GoogleSignInButton widgets appear exactly once in the widget tree.
    expect(find.byType(GoogleSignInButton), findsOneWidget);
  });
}
