abstract class SocialLoginStates {}

class LoginInitialState extends SocialLoginStates {}

class LoginChangePasswordModeState extends SocialLoginStates {}

class LoginSuccessState extends SocialLoginStates {
  final uId;

  LoginSuccessState(
    this.uId,
  );
}

class LoginLoadingState extends SocialLoginStates {}

class LoginErrorState extends SocialLoginStates {
  final error;

  LoginErrorState(this.error);
}
