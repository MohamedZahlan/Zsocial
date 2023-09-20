import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../modules/social_login/login_screen.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../network/local/cache_helper.dart';
import 'components.dart';

//Facebook UI = https://www.figma.com/file/K6Hdp4jOoptQS3SY869ic2/Facebook_2020-(Community)?node-id=0%3A1&t=GCwdQ6RHy0HTxPXM-0
String? uId = '';
void signOut(context) {
  Cache_Helper.removeData(key: 'uId').then((value) {
    navigateToFinish(
      context,
      const SocialLoginScreen(),
    );
  });
}

void whatsapp(context) async {
  var url = "${SocialCubit.get(context).userModel!.whatsapp}";
  if (!await launch(url)) throw 'Could not launch $url';
}

void instagram(context) async {
  var url = "${SocialCubit.get(context).userModel!.instagram}";
  if (!await launch(url)) throw 'Could not launch $url';
}

void linkedin(context) async {
  var url = "${SocialCubit.get(context).userModel!.linkedIn}";
  if (await launch(url)) throw 'could not launch $url ';
}

void facebook(context) async {
  var url = "${SocialCubit.get(context).userModel!.facebook}";

  if (!await launch(url)) throw "couldn't launch $url ";
}

String getTimeDifferenceFromNow(DateTime dateTime) {
  Duration difference = DateTime.now().difference(dateTime);
  if (difference.inSeconds < 5) {
    return "Just now";
  } else if (difference.inMinutes < 1) {
    return "${difference.inSeconds}s ago";
  } else if (difference.inHours < 1) {
    return "${difference.inMinutes}m ago";
  } else if (difference.inHours < 24) {
    return "${difference.inHours}h ago";
  } else {
    return "${difference.inDays}d ago";
  }
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<UserCredential> signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance.login();

  // Create a credential from the access token
  final OAuthCredential facebookAuthCredential =
      FacebookAuthProvider.credential(loginResult.accessToken!.token);

  // Once signed in, return the UserCredential
  return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
}
