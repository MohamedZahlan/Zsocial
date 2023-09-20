import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/social_login/bloc/states.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates> {
  SocialLoginCubit() : super(LoginInitialState());

  static SocialLoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  void changePasswordMode() {
    isPassword = !isPassword;
    emit(LoginChangePasswordModeState());
  }

  // this method used to Login
  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());

    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      print(value.user!.email);
      emit(LoginSuccessState(
        value.user!.uid,
      ));
    }).catchError((error) {
      emit(LoginErrorState(error.toString()));
    });
  }
}
