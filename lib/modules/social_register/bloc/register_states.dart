abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterChangePasswordModeState extends RegisterStates {}

class RegisterSelectMaleState extends RegisterStates {}

class RegisterSelectFemaleState extends RegisterStates {}

class SocialRegisterSuccessState extends RegisterStates {}

class SocialRegisterLoadingState extends RegisterStates {}

class SocialRegisterErrorState extends RegisterStates {
  final error;

  SocialRegisterErrorState(this.error);
}

class SocialCreateUserSuccessState extends RegisterStates {
  final uId;

  SocialCreateUserSuccessState(this.uId);
}

class SocialCreateUserErrorState extends RegisterStates {
  final error;

  SocialCreateUserErrorState(this.error);
}
