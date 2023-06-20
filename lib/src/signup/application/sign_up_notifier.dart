import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pos/src/blocs/authentication/authentication_bloc.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/services/user_repository.dart';
import 'package:pos/src/signup/data/remote/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_notifier.freezed.dart';

part 'sign_up_notifier.g.dart';

@freezed
class SignUpState with _$SignUpState {
  const factory SignUpState.data(
    List<String> items,
    int totalItemsCount, {
    @Default(true) bool hasReachedMax,
  }) = SignUpStateData;

  const factory SignUpState.initial() = SignUpStateInitial;

  const factory SignUpState.emailVerification(String userId) =
      SignUpStateEmailVerification;

  const factory SignUpState.loading() = SignUpStateLoading;

  const factory SignUpState.error(Object error, StackTrace st) =
      SignUpStateError;
}

@riverpod
class SignUpNotifier extends _$SignUpNotifier {
  @override
  SignUpState build() {
    return SignUpStateInitial();
  }

  Future singUp(
    String email,
    String name,
    String surname,
    String password,
  ) async {
    final userId = await ref.read(getPosProvider).singUp(
          email,
          name,
          surname,
          password,
        );

    print(userId);
    final authResponse =
        await ref.read(authNotifierProvider.notifier).login(email, password);
    // final authResponse = await ref.read(userRepositoryProvider).authenticate(
    //       username: email,
    //       password: password,
    //     );
    if (authResponse == null) {
      throw Exception('AuthResponse is null');
    }
    await ref
        .read(getPosProvider)
        .sendVerificationEmail(userId, authResponse.token);

    // state = SignUpStateEmailVerification(userId);
  }

// void resendVerificationEmail() async {
//   if (state is SignUpStateEmailVerification) {
//     final userId = (state as SignUpStateEmailVerification).userId;
//     final token = (state as SignUpStateEmailVerification).token;
//     await ref.read(signUpRemoteApiProvider).sendVerificationEmail(userId, token);
//   }
// }
}
