import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoggedIn = false;
  Map _userObj = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login by Facebook"),
      ),
      body: Container(
        child: _isLoggedIn
            ? Column(
                children: [
                  Image.network(_userObj["picture"]["data"]["url"]),
                  Text(_userObj["name"]),
                  Text(_userObj["email"]),
                  TextButton(
                      onPressed: () {
                        FacebookAuth.instance.logOut().then((value) {
                          setState(() {
                            _isLoggedIn = false;
                            _userObj = {};
                          });
                        });
                      },
                      child: const Text("Logout"))
                ],
              )
            : Center(
                child: ElevatedButton(
                  child: const Text("Login with Facebook"),
                  onPressed: () async {
                    //way3
                    // var result = await FacebookAuth.instance
                    //     .login(
                    //       permissions: ['public_profile', 'email', 'pages_show_list', 'pages_messaging', 'pages_manage_metadata'],
                    //     ); // by default we request the email and the public profile
                    // if (result.status == LoginStatus.success) {
                    //   // you are logged
                    //   final AccessToken accessToken = result.accessToken!;
                    // } else {
                    //   print(result.status);
                    //   print(result.message);
                    // }
                    //way2
                    // var token = await FacebookAuth.instance.login();
                    // print('token.userId.toLowerCase()');
                    // print(token.userId.toLowerCase());
                    // final OAuthCredential facebookAuthCredential =
                    //     FacebookAuthProvider.credential(token.token);

                    // // Once signed in, return the UserCredential
                    // FirebaseAuth.instance
                    //     .signInWithCredential(facebookAuthCredential)
                    //     .then((value) {
                    //   print(value.user!.displayName.toString());
                    //   setState(() {
                    //     _isLoggedIn = true;
                    //     _userObj = value.user as Map;
                    //   });
                    // });
                    //way1
                    FacebookAuth.instance.login(
                        permissions: ["public_profile", "email"]).then((value) {
                      FacebookAuth.instance.getUserData().then((userData) {
                        setState(() {
                          _isLoggedIn = true;
                          _userObj = userData;
                        });
                      });
                    }).then((value) {
                      print('SSSSSSSSSSSSSSSSSSS');
                    }).then((value) {
                      print('value');
                    }).catchError((onError) {
                      print('onError');
                      print(onError.toString());
                    });
                  },
                ),
              ),
      ),
    );
  }
}
