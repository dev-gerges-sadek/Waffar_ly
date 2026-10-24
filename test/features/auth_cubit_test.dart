import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waffar_ly_app/core/l10n/app_localizations.dart';
import 'package:waffar_ly_app/features/auth/cubit/cubit.dart';
import 'package:waffar_ly_app/features/auth/cubit/states.dart';
import 'package:waffar_ly_app/features/auth/firebase/auth_service.dart';

class _MockAuthService extends Mock implements AuthService {}

void main() {
  group('password policy', () {
    test('requires >= 8 chars with a letter and a digit', () {
      expect(AuthCubit.isStrongPassword('abc12'), isFalse);
      expect(AuthCubit.isStrongPassword('abcdefgh'), isFalse);
      expect(AuthCubit.isStrongPassword('12345678'), isFalse);
      expect(AuthCubit.isStrongPassword('abcd1234'), isTrue);
    });
  });

  group('AuthCubit', () {
    late _MockAuthService service;
    final l10n = lookupAppLocalizations(const Locale('en'));

    setUp(() => service = _MockAuthService());

    blocTest<AuthCubit, AuthStates>(
      'rejects an invalid e-mail without calling the service',
      build: () => AuthCubit.withL10n(l10n, authService: service),
      act: (c) => c.login('not-an-email', 'secret'),
      expect: () => [isA<LoginErrorState>()],
      verify: (_) => verifyNever(() => service.signIn(any(), any())),
    );

    blocTest<AuthCubit, AuthStates>(
      'weak sign-up password is rejected locally',
      build: () => AuthCubit.withL10n(l10n, authService: service),
      act: (c) => c.signUp('a@b.co', 'short1', 'Ali'),
      expect: () => [
        isA<SignUpErrorState>().having(
          (s) => s.error,
          'error',
          l10n.errWeakPassword,
        ),
      ],
    );

    blocTest<AuthCubit, AuthStates>(
      'successful login emits loading then success',
      build: () {
        when(() => service.signIn(any(), any())).thenAnswer((_) async {});
        return AuthCubit.withL10n(l10n, authService: service);
      },
      act: (c) => c.login('a@b.co', 'abcd1234'),
      expect: () => [isA<LoginLoadingState>(), isA<LoginSuccessState>()],
    );
  });
}
