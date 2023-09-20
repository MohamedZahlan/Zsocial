import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/layout/social_app/social_app.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:rive/rive.dart';
import 'package:social_app/shared/shared_components/constants.dart';
import '../../shared/network/shared.styles/colors.dart';
import '../../shared/shared_components/components.dart';
import '../social_register/register_screen.dart';
import 'bloc/cubit.dart';
import 'bloc/states.dart';

class SocialLoginScreen extends StatefulWidget {
  const SocialLoginScreen({Key? key}) : super(key: key);

  @override
  State<SocialLoginScreen> createState() => _SocialLoginScreenState();
}

class _SocialLoginScreenState extends State<SocialLoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  Artboard? riveArtBoard;

  final testEmail = "mohamedzahlan.056@gmail.com";
  final testPassword = '123456';
  final focusNode = FocusNode();
  bool isLookingRight = false;
  bool isLookingLeft = false;

  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerLookLeft;
  late RiveAnimationController controllerLookRight;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;

  // this method used to delete all controller
  void removeAllControllers() {
    riveArtBoard?.artboard.removeController(controllerIdle);
    riveArtBoard?.artboard.removeController(controllerHandsUp);
    riveArtBoard?.artboard.removeController(controllerHandsDown);
    riveArtBoard?.artboard.removeController(controllerLookLeft);
    riveArtBoard?.artboard.removeController(controllerLookRight);
    riveArtBoard?.artboard.removeController(controllerSuccess);
    riveArtBoard?.artboard.removeController(controllerFail);
    isLookingRight = false;
    isLookingLeft = false;
  }

  // this method used to add controller that state idle we needed to set animation
  void addIdleController() {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerIdle);
    debugPrint('idle');
  }

  // this method used to add controller that state HandsUp we needed to set animation
  void addHandsUpController() {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerHandsUp);
    debugPrint('HandsUp');
  }

  // this method used to add controller that state HandsDown we needed to set animation
  void addHandsDownController() {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerHandsDown);
    debugPrint('HandsDown');
  }

  // this method used to add controller that state Look left we needed to set animation
  void addLookLeftController() {
    removeAllControllers();
    isLookingLeft = true;
    riveArtBoard?.artboard.addController(controllerLookLeft);
    debugPrint('LookLeft');
  }

  // this method used to add controller that state look right we needed to set animation
  void addLookRightController() {
    removeAllControllers();
    isLookingRight = true;
    riveArtBoard?.artboard.addController(controllerLookRight);
    debugPrint('LookRight');
  }

  // this method used to add controller that state Success we needed to set animation
  void addSuccessController() {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerSuccess);
    debugPrint('Success');
  }

  // this method used to add controller that state fail we needed to set animation
  void addFailController() {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerFail);
    debugPrint('Fail');
  }

  // this method used for check if password focus or no
  void checkFocusPasswordNodeToChangeAnimationState() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        addHandsUpController();
      } else if (!focusNode.hasFocus) {
        addHandsDownController();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsUp = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerHandsDown = SimpleAnimation(AnimationEnum.hands_down.name);
    controllerLookLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);
    controllerLookRight = SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);

    // this method used to load animation from assets
    rootBundle.load('assets/animated_login_screen.riv').then((data) {
      final file = RiveFile.import(data);
      final artBoard = file.mainArtboard;
      artBoard.addController(controllerIdle);
      setState(() {
        riveArtBoard = artBoard;
      });
    });
    checkFocusPasswordNodeToChangeAnimationState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state) {
          if (state is LoginErrorState) {
            showToast(msg: state.error, state: ToastStates.ERROR);
            addFailController();
          }
          if (state is LoginSuccessState) {
            addSuccessController();
            Cache_Helper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value) {
              showToast(msg: 'Welcome', state: ToastStates.SUCCESS);
              SocialCubit.get(context).getUserData();
              Future.delayed(const Duration(seconds: 1), () {
                SocialCubit.get(context).currentIndex = 0;

                navigateToFinish(context, const SocialLayout());
              });
              //navigateToFinish(context, SocialLayout());
            });
          }
        },
        builder: (context, state) {
          var cubit = SocialLoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text("Zsocial"),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 20,
                        vertical: MediaQuery.of(context).size.height / 90),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // this method for display animation and select size of animation
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 4,
                          child: riveArtBoard == null
                              ? const SizedBox.shrink()
                              : Rive(
                                  artboard: riveArtBoard!,
                                ),
                        ),
                        // first text Login now to communicate with your friends
                        Text(
                          "Login now to communicate with your friends",
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    fontSize: 15,
                                  ),
                        ),
                        // This method for space between text and textFormField
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 40,
                        ),
                        // This method for Email TextFormField
                        TextFormField(
                          controller: emailController,
                          textInputAction: TextInputAction.next,
                          cursorColor: myDefaultColor,

                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            labelText: "E-mail",
                            prefixIcon: const Icon(
                              Icons.mail_outline,
                            ),
                            errorMaxLines: 1,
                          ),
                          //if e-mail is empty
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "check your E-mail";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            // this method to make animation looking left
                            if (value.isNotEmpty &&
                                value.length < 13 &&
                                !isLookingLeft) {
                              addLookLeftController();
                            }
                            // this method to make animation looking right
                            else if (value.isNotEmpty &&
                                value.length > 13 &&
                                !isLookingRight) {
                              addLookRightController();
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        // This method for space between textFormField
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 45,
                        ),
                        // This method for Password TextFormField
                        TextFormField(
                          controller: passwordController,
                          focusNode: focusNode,
                          cursorColor: myDefaultColor,

                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                25,
                              ),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                cubit.changePasswordMode();
                              },
                              icon: Icon(
                                cubit.isPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                            prefixIcon: const Icon(Icons.lock_outline),
                          ),
                          obscureText: cubit.isPassword,
                          keyboardType: TextInputType.visiblePassword,
                          // if password is empty
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "check your Password";
                            }
                            return null;
                          },
                        ),
                        // this method for space between textFormField and login button
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 35,
                        ),
                        // this method for login Button
                        state is LoginLoadingState
                            ? const Center(child: CircularProgressIndicator())
                            : defaultButtonBuilder(
                                condition: State is! LoginLoadingState,
                                function: () {
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    if (formKey.currentState!.validate()) {
                                      cubit.userLogin(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                    } else {
                                      addFailController();
                                    }
                                  });
                                  focusNode.unfocus();
                                },
                                text: "Login",
                                fontSize: 18.0,
                                doubleWidth: double.infinity,
                              ),
                        // this method for space between ForgetPassword button and login button
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 50,
                        ),
                        // this method for forget password button
                        Center(
                          child: defaultTextButton(
                            function: () {},
                            text: "Forget Password?",
                            textAlign: TextAlign.end,
                            context: context,
                            fontSize: 14.0,
                            color: myDefaultColor,
                          ),
                        ),
                        // this method for space between forget password button and register button
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 100,
                        ),
                        // this method for register button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account ?",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: 14.0,
                                  ),
                            ),
                            defaultTextButton(
                              function: () {
                                navigateTo(context, RegisterScreen());
                              },
                              text: "Register Now",
                              context: context,
                              fontSize: 15.0,
                              color: myDefaultColor,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight(context) / 90,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 1,
                              width: screenWidth(context) / 4,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: screenWidth(context) / 40,
                            ),
                            const Text("Or continue with"),
                            SizedBox(
                              width: screenWidth(context) / 60,
                            ),
                            Container(
                              height: 1,
                              width: screenWidth(context) / 4.5,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight(context) / 60,
                        ),
                        // ------------------This method used for sign in with google and facebook------------------
                        Padding(
                          padding: const EdgeInsets.only(bottom: 60),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  await signInWithGoogle();
                                },
                                child: const Image(
                                    image: AssetImage(
                                        'assets/Images/google_icon.png')),
                              ),
                              SizedBox(
                                width: screenWidth(context) / 20,
                              ),
                              IconButton(
                                  onPressed: () async {
                                    await signInWithFacebook();
                                  },
                                  icon: Icon(
                                    Icons.facebook,
                                    size: 39,
                                    color: myDefaultColor,
                                  ))
                            ],
                          ),
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
