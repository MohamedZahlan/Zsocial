import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/layout/social_app/social_app.dart';
import 'package:social_app/modules/social_login/login_screen.dart';
import 'package:social_app/shared/network/shared.styles/colors.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/shared_components/components.dart';
import 'bloc/register_cubit.dart';
import 'bloc/register_states.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  final genderController = TextEditingController();

  final passwordFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  final scaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is SocialCreateUserSuccessState) {
            Cache_Helper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value) {
              SocialCubit.get(context).getUserData();
              showToast(msg: 'Welcome', state: ToastStates.SUCCESS);
              SocialCubit.get(context).getUserData();
              SocialCubit.get(context).currentIndex = 0;
              navigateToFinish(context, SocialLayout());
            });
          }
          if (state is SocialRegisterErrorState) {
            showToast(msg: state.error.toString(), state: ToastStates.ERROR);
          }
        },
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                "Sign Up",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            // this method for indicator loading
            body: state is SocialRegisterLoadingState
                ? const LinearProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //first text
                              Text(
                                "Register now to communicate with your friends",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                      fontSize: 15,
                                    ),
                              ),
                              // this method for space with TextFormField
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 50,
                              ),
                              // this method for Username TextFormField
                              TextFormField(
                                controller: usernameController,
                                keyboardType: TextInputType.name,
                                cursorColor: myDefaultColor,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: "Username",
                                  prefixIcon: const Icon(
                                    Icons.person_outline,
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Username must not be empty";
                                  }
                                  return null;
                                },
                              ),
                              // this method for space with Username TextFormField and email TextFormField
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 40,
                              ),
                              // this method for E-mail TextFormField
                              TextFormField(
                                controller: emailController,
                                cursorColor: myDefaultColor,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: "E-mail",
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "E-mail must not be empty";
                                  }
                                  return null;
                                },
                              ),
                              // this method for space with email TextFormField and Phone TextFormField
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 40,
                              ),
                              // this method for Phone TextFormField
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                cursorColor: myDefaultColor,

                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: "Phone",
                                  prefixIcon:
                                      const Icon(Icons.phone_android_outlined),
                                ),
                                //obscureText: cubit.passwordShow,
                                keyboardType: TextInputType.phone,
                                controller: phoneController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Phone must not be empty";
                                  }
                                  return null;
                                },
                              ),
                              // this method for space with Phone TextFormField and gender TextFormField
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 40,
                              ),
                              // this method for gender TextFormField
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                readOnly: true, cursorColor: myDefaultColor,

                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: "Gender",
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) => SizedBox(
                                            height: screenHeight(context) / 5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: TextButton.icon(
                                                    onPressed: () {
                                                      cubit.selectMale();
                                                    },
                                                    icon: Icon(cubit.isMale
                                                        ? Icons.check_box
                                                        : Icons
                                                            .check_box_outline_blank),
                                                    label: const Text('Male'),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: TextButton.icon(
                                                    onPressed: () {
                                                      cubit.selectFemale();
                                                    },
                                                    icon: Icon(cubit.isFemale
                                                        ? Icons.check_box
                                                        : Icons
                                                            .check_box_outline_blank),
                                                    label: const Text('Female'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ).then((value) {
                                          if (kDebugMode) {
                                            print(value);
                                          }
                                          genderController.text = value;
                                        });
                                      },
                                      icon: const Icon(Icons
                                          .arrow_drop_down_circle_outlined)),
                                  prefixIcon: const Icon(Icons.transgender),
                                ),
                                //obscureText: cubit.passwordShow,
                                keyboardType: TextInputType.text,
                                controller: genderController,
                              ),
                              // this method for space with gender TextFormField and Password TextFormField
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 40,
                              ),
                              // this method for Password TextFormField
                              TextFormField(
                                obscureText: cubit.isPassword,
                                cursorColor: myDefaultColor,

                                focusNode: passwordFocusNode,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: "Password",
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      cubit.changePasswordMode();
                                    },
                                    icon: Icon(
                                      cubit.isPassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility,
                                    ),
                                  ),
                                  prefixIcon: const Icon(Icons.lock),
                                ),
                                //obscureText: cubit.passwordShow,
                                keyboardType: TextInputType.visiblePassword,
                                controller: passwordController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Password must not be empty";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 50,
                              ),
                              // this method for Register button
                              defaultButtonBuilder(
                                condition: State is! SocialRegisterLoadingState,
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.userRegister(
                                      name: usernameController.text,
                                      email: emailController.text,
                                      phone: phoneController.text,
                                      password: passwordController.text,
                                      //gender: genderController.text,
                                    );
                                  }
                                },
                                text: "Sign Up",
                                fontSize: 18,
                                doubleWidth: double.infinity,
                              ),
                              // This method space between sign up button and log in button
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 25,
                              ),
                              // This method for users already have an account to log in
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // first text
                                  Text(
                                    "Already have an account ?",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          fontSize: 15,
                                        ),
                                  ),
                                  // this method let users go to log in screen to log in
                                  defaultTextButton(
                                    function: () {
                                      navigateToFinish(
                                          context, SocialLoginScreen());
                                    },
                                    text: "Log in",
                                    context: context,
                                    color: myDefaultColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
