//Test to 1 way
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FacebookApp());
}

class FacebookApp extends StatefulWidget {
  const FacebookApp({Key? key}) : super(key: key);

  @override
  State<FacebookApp> createState() => _FacebookAppState();
}

class _FacebookAppState extends State<FacebookApp> {
  bool isLoggedIn = false;
  User? profileData;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Facebook Login"),
        ),
        body: Center(
          child: isLoggedIn
              ? _displayUserData(profileData)
              : _displayLoginButton(),
        ),
      ),
    );
  }

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      print('isLoggedIn: ' + isLoggedIn.toString());
      this.profileData = profileData;
      print('profileData: ' + profileData.toString());
    });
  }

  void loginButtonClicked() async {
    final result =
        await FacebookAuth.i.login(permissions: ["public_profile", "email"]);
    if (result.status == LoginStatus.success) {
      final AuthCredential facebookCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(facebookCredential);
      print('userCredential: ' + userCredential.user!.toString());
      onLoginStatusChanged(true, profileData: userCredential.user);
    }
  }

  _displayUserData(profileData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 200.0,
          width: 200.0,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(
                profileData.photoURL,
              ),
            ),
          ),
        ),
        const SizedBox(height: 28.0),
        Text(
          "Name: ${profileData.displayName}",
          style: const TextStyle(
            fontSize: 20.0,
          ),
        ),
        Text(
          "phoneNumber: ${profileData.phoneNumber}",
          style: const TextStyle(
            fontSize: 20.0,
          ),
        ),
        Text(
          "Email: ${profileData.email}",
          style: const TextStyle(
            fontSize: 20.0,
          ),
        ),
        ElevatedButton(child: const Text("Logout"), onPressed: () => _logout()),
      ],
    );
  }

  _displayLoginButton() {
    return ElevatedButton(
      child: const Text("Login with Facebook"),
      onPressed: () => loginButtonClicked(),
    );
  }

  _logout() async {
    await FacebookAuth.i.logOut();
    onLoginStatusChanged(false);
    print("Logged out");
  }
}














/**

//1 way By(firebase_auth && flutter_facebook_auth)
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const FacebookApp());
// }

// class FacebookApp extends StatefulWidget {
//   const FacebookApp({Key? key}) : super(key: key);

//   @override
//   _FacebookAppState createState() => _FacebookAppState();
// }

// class _FacebookAppState extends State<FacebookApp> {
//   Map? _userData = {};
//     bool isLoggedIn = false;
//   var profileData;
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//             title: Text(
//                 'Facebook (Logged ' + (_userData == {} ? 'Out' : 'In') + ')')),
//         body: Center(
//           child: Column(
//             children: [
//               ElevatedButton(
//                   child: const Text('Log In'),
//                   onPressed: () async {
//                     final result = await FacebookAuth.i
//                         .login(permissions: ["public_profile", "email"]);

//                     if (result.status == LoginStatus.success) {
//                       final userData = await FacebookAuth.i.getUserData(
//                         fields: "email,name",
//                       );

//                       setState(() {
//                         _userData = userData;
//                         print('userData: ' + userData.toString());
//                       });
//                       // ////////////////////
//                       final AuthCredential facebookCredential =
//                           FacebookAuthProvider.credential(
//                               result.accessToken!.token);
//                       final userCredential = await FirebaseAuth.instance
//                           .signInWithCredential(facebookCredential);
//                       print(
//                           'userCredential: ' + userCredential.user!.toString());
//                     }
//                   }),
//               ElevatedButton(
//                   child: Text('Log Out'),
//                   onPressed: () async {
//                     await FacebookAuth.i.logOut();
//                     setState(() {
//                       _userData = {};
//                     });
//                   }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




//2 way
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(LoginPage());
// }

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   bool isLoggedIn = false;
//   var profileData;

//   var facebookLogin = FacebookLogin();

//   void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
//     setState(() {
//       this.isLoggedIn = isLoggedIn;
//       print('isLoggedIn: ' + isLoggedIn.toString());
//       this.profileData = profileData;
//       print('profileData: ' + profileData.toString());
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text("Facebook Login"),
//         ),
//         body: Center(
//           child: isLoggedIn
//               ? _displayUserData(profileData)
//               : _displayLoginButton(),
//         ),
//       ),
//     );
//   }

//   void loginButtonClicked() async {
//     var facebookLoginResult =
//         await facebookLogin.logIn(['email', 'public_profile']);
//     print('value: ' + facebookLoginResult.accessToken.userId.toString());
//     print('value: ' + facebookLoginResult.accessToken.permissions.toString());
//     switch (facebookLoginResult.status) {
//       case FacebookLoginStatus.error:
//         onLoginStatusChanged(false);
//         break;
//       case FacebookLoginStatus.cancelledByUser:
//         onLoginStatusChanged(false);
//         break;
//       case FacebookLoginStatus.loggedIn:
//         print('facebookLoginResult' +
//             facebookLoginResult.accessToken.token.toString());
//         var graphResponse = await http.get(Uri.parse(
//             'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.accessToken.token}'));

//         var profile = json.decode(graphResponse.body);
//         print('graphResponse: ' + graphResponse.statusCode.toString());
//         print('profile: ' + profile.toString());
//         print('profile: ' + profile.toString());
//         print('graphResponse: ' + graphResponse.toString());
//         print('body: ' + graphResponse.body.indexOf('email').toString());

//         onLoginStatusChanged(true, profileData: profile);
//         break;
//     }
//   }

//   _displayUserData(profileData) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         Container(
//           height: 200.0,
//           width: 200.0,
//           decoration: BoxDecoration(
//             shape: BoxShape.rectangle,
//             image: DecorationImage(
//               fit: BoxFit.fill,
//               image: NetworkImage(
//                 profileData['picture']['data']['url'],
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 28.0),
//         Text(
//           "Name: ${profileData['name']}",
//           style: const TextStyle(
//             fontSize: 20.0,
//           ),
//         ),
//         Text(
//           "Email: ${profileData['email']}",
//           style: const TextStyle(
//             fontSize: 20.0,
//           ),
//         ),
//         ElevatedButton(
//           child: const Text("Logout"),
//           onPressed: () => facebookLogin.isLoggedIn
//               .then((isLoggedIn) => isLoggedIn ? _logout() : {}),
//         )
//       ],
//     );
//   }

//   _displayLoginButton() {
//     return ElevatedButton(
//       child: const Text("Login with Facebook"),
//       onPressed: () => loginButtonClicked(),
//     );
//   }

//   _logout() async {
//     await facebookLogin.logOut();
//     onLoginStatusChanged(false);
//     print("Logged out");
//   }
// }
 */