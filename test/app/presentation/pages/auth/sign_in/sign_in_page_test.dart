import 'package:bloc_presentation_test/bloc_presentation_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/design_system/widgets/hubla_dialog.dart';
import 'package:hubla_weather/app/core/design_system/widgets/hubla_loading.dart';
import 'package:hubla_weather/app/core/design_system/widgets/hubla_primary_button.dart';
import 'package:hubla_weather/app/core/design_system/widgets/hubla_text_input.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_cubit.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_presentation_event.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_state.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/sign_in_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/google_fonts_mocks.dart';
import '../../../../../helpers/pump_app.dart';
import '../../../../../mocks/cubits_mocks.dart';

void main() {
  late MockSignInCubit mockCubit;

  setUp(() {
    setUpGoogleFontsMocks();
    mockCubit = MockSignInCubit();
    when(() => mockCubit.state).thenReturn(SignInState.initial());
    whenListen(mockCubit, const Stream<SignInState>.empty(), initialState: SignInState.initial());
    whenListenPresentation(mockCubit);
  });

  tearDown(tearDownGoogleFontsMocks);

  group('SignInPage', () {
    testWidgets('should render the welcome texts', (tester) async {
      await pumpApp<SignInCubit>(tester, const SignInPage(), cubit: mockCubit);

      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Sign in to check the weather'), findsOneWidget);
    });

    testWidgets('should render email and password text inputs', (tester) async {
      await pumpApp<SignInCubit>(tester, const SignInPage(), cubit: mockCubit);

      final textInputs = find.byType(HublaTextInput);
      expect(textInputs, findsNWidgets(2));

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should render the sign-in button', (tester) async {
      await pumpApp<SignInCubit>(tester, const SignInPage(), cubit: mockCubit);

      expect(find.byType(HublaPrimaryButton), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('should render the weather icon', (tester) async {
      await pumpApp<SignInCubit>(tester, const SignInPage(), cubit: mockCubit);

      expect(find.byIcon(Icons.wb_sunny_rounded), findsOneWidget);
    });

    group('interaction', () {
      testWidgets('should call updateEmail when email text changes', (tester) async {
        await pumpApp<SignInCubit>(tester, const SignInPage(), cubit: mockCubit);

        final emailField = find.byType(TextFormField).first;
        await tester.enterText(emailField, 'user@test.com');

        verify(() => mockCubit.updateEmail('user@test.com')).called(1);
      });

      testWidgets('should call updatePassword when password text changes', (tester) async {
        await pumpApp<SignInCubit>(tester, const SignInPage(), cubit: mockCubit);

        final passwordField = find.byType(TextFormField).last;
        await tester.enterText(passwordField, 'secret123');

        verify(() => mockCubit.updatePassword('secret123')).called(1);
      });

      testWidgets('should call togglePasswordVisibility when eye icon is tapped', (tester) async {
        await pumpApp<SignInCubit>(tester, const SignInPage(), cubit: mockCubit);

        await tester.tap(find.byIcon(Icons.visibility_outlined));
        await tester.pump();

        verify(() => mockCubit.togglePasswordVisibility()).called(1);
      });

      testWidgets('should show visibility_off icon when password is visible', (tester) async {
        when(() => mockCubit.state).thenReturn(SignInState.initial().copyWith(obscurePassword: false));
        whenListen(
          mockCubit,
          const Stream<SignInState>.empty(),
          initialState: SignInState.initial().copyWith(obscurePassword: false),
        );

        await pumpApp<SignInCubit>(tester, const SignInPage(), cubit: mockCubit);

        expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      });
    });

    group('button state', () {
      testWidgets('should disable button when input is invalid', (tester) async {
        when(() => mockCubit.state).thenReturn(SignInState.initial());
        whenListen(mockCubit, const Stream<SignInState>.empty(), initialState: SignInState.initial());

        await pumpApp<SignInCubit>(tester, const SignInPage(), cubit: mockCubit);

        final button = tester.widget<HublaPrimaryButton>(find.byType(HublaPrimaryButton));
        expect(button.isEnabled, isFalse);
      });

      testWidgets('should enable button when input is valid', (tester) async {
        final validState = SignInState.initial().copyWith(email: 'user@test.com', password: 'secret');
        when(() => mockCubit.state).thenReturn(validState);
        whenListen(mockCubit, const Stream<SignInState>.empty(), initialState: validState);

        await pumpApp<SignInCubit>(tester, const SignInPage(), cubit: mockCubit);

        final button = tester.widget<HublaPrimaryButton>(find.byType(HublaPrimaryButton));
        expect(button.isEnabled, isTrue);
      });

      testWidgets('should call signIn when button is tapped with valid input', (tester) async {
        final validState = SignInState.initial().copyWith(email: 'user@test.com', password: 'secret');
        when(() => mockCubit.state).thenReturn(validState);
        whenListen(mockCubit, const Stream<SignInState>.empty(), initialState: validState);
        when(() => mockCubit.signIn()).thenAnswer((_) async {});

        await pumpApp<SignInCubit>(tester, const SignInPage(), cubit: mockCubit);

        await tester.tap(find.byType(HublaPrimaryButton));
        await tester.pump();

        verify(() => mockCubit.signIn()).called(1);
      });
    });

    group('presentation events', () {
      testWidgets('should show loading overlay when ShowLoadingEvent is emitted', (tester) async {
        // ignore: close_sinks
        final presentationController = whenListenPresentation(mockCubit);

        await pumpApp<SignInCubit>(tester, const SignInPage(), cubit: mockCubit);

        presentationController.add(ShowLoadingEvent());
        await tester.pump();
        await tester.pump();

        // HublaLoading pushes a DialogRoute — verify the loading widget is present.
        expect(find.byType(HublaLoading), findsOneWidget);
      });

      testWidgets('should show error dialog when ErrorEvent is emitted', (tester) async {
        // ignore: close_sinks
        final presentationController = whenListenPresentation(mockCubit);

        await pumpApp<SignInCubit>(tester, const SignInPage(), cubit: mockCubit);

        presentationController.add(const ErrorEvent('Something went wrong'));
        await tester.pumpAndSettle();

        expect(find.byType(HublaDialog), findsOneWidget);
        expect(find.text('Error'), findsOneWidget);
        expect(find.text('Something went wrong'), findsOneWidget);
      });
    });
  });
}
