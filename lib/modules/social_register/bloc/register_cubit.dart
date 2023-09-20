import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import '../bloc/register_states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;

  bool isMale = false;

  bool isFemale = false;

  // This method used to change password state
  void changePasswordMode() {
    isPassword = !isPassword;
    emit(RegisterChangePasswordModeState());
  }

  void selectMale() {
    isMale = !isMale;
    emit(RegisterSelectMaleState());
  }

  void selectFemale() {
    isFemale = !isFemale;
    emit(RegisterSelectFemaleState());
  }

  // this method used to create an account
  void userRegister({
    required String name,
    required String email,
    required String phone,
    required String password,
    //required String gender,
  }) {
    emit(SocialRegisterLoadingState());

    // use firebase to create account
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      userCreate(
        email: email,
        name: name,
        phone: phone,
        //gender: gender,
        uId: value.user!.uid,
      );
    }).catchError((error) {
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

  // this method used to create user in FireStore
  void userCreate({
    required String name,
    required String email,
    required String phone,
    required String uId,
    //required String gender,
    String current_city = '',
    String education = '',
    String relationship = '',
    String facebook = '',
    String instagram = '',
    String linkedIn = '',
    String whatsapp = '',
    String work = '',
  }) {
    UserModel userModel = UserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      //gender: gender,
      isEmailVerified: false,
      image:
          'https://img.freepik.com/free-photo/taj-mahal-agra-india_53876-16340.jpg?w=740&t=st=1677047327~exp=1677047927~hmac=3013ad3a42ad132205bf3074e0840960f1072a85bc56f9f82dc33257a5fd9887',
      cover:
          'https://www.freepik.com/free-photo/scenic-seascape-landscape-with-light-sunbeam-through-clouds-town-istanbul-traveling-concept_26093757.htm#page=6&query=muslim&position=26&from_view=search&track=sph',
      bio: 'Write your bio...',
      current_city: current_city,
      education: education,
      relationship: relationship,
      facebook: facebook,
      instagram: instagram,
      linkedIn: linkedIn,
      whatsapp: whatsapp,
      work: work,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userModel.toMap()!)
        .then((value) {
      emit(SocialCreateUserSuccessState(uId));
    }).catchError((error) {
      print(error.toString());
      emit(SocialCreateUserErrorState(error.toString()));
    });
  }
}
