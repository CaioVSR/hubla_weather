import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_presentation_event.dart';

void main() {
  group('SignInPresentationEvent', () {
    group('ShowLoadingEvent', () {
      test('should be equal to another ShowLoadingEvent', () {
        expect(ShowLoadingEvent(), equals(ShowLoadingEvent()));
      });

      test('should have empty props', () {
        expect(ShowLoadingEvent().props, isEmpty);
      });
    });

    group('HideLoadingEvent', () {
      test('should be equal to another HideLoadingEvent', () {
        expect(HideLoadingEvent(), equals(HideLoadingEvent()));
      });

      test('should have empty props', () {
        expect(HideLoadingEvent().props, isEmpty);
      });
    });

    group('ErrorEvent', () {
      test('should be equal when error messages match', () {
        const eventA = ErrorEvent('Something went wrong');
        const eventB = ErrorEvent('Something went wrong');

        expect(eventA, equals(eventB));
      });

      test('should not be equal when error messages differ', () {
        const eventA = ErrorEvent('Error A');
        const eventB = ErrorEvent('Error B');

        expect(eventA, isNot(equals(eventB)));
      });

      test('should have errorMessage in props', () {
        const event = ErrorEvent('Oops');

        expect(event.props, ['Oops']);
      });

      test('should store the error message', () {
        const event = ErrorEvent('Network failure');

        expect(event.errorMessage, 'Network failure');
      });
    });

    group('SuccessEvent', () {
      test('should be equal to another SuccessEvent', () {
        expect(SuccessEvent(), equals(SuccessEvent()));
      });

      test('should have empty props', () {
        expect(SuccessEvent().props, isEmpty);
      });
    });

    group('type checks', () {
      test('ShowLoadingEvent should implement SignInPresentationEvent', () {
        expect(ShowLoadingEvent(), isA<SignInPresentationEvent>());
      });

      test('HideLoadingEvent should implement SignInPresentationEvent', () {
        expect(HideLoadingEvent(), isA<SignInPresentationEvent>());
      });

      test('ErrorEvent should implement SignInPresentationEvent', () {
        expect(const ErrorEvent('test'), isA<SignInPresentationEvent>());
      });

      test('SuccessEvent should implement SignInPresentationEvent', () {
        expect(SuccessEvent(), isA<SignInPresentationEvent>());
      });
    });
  });
}
