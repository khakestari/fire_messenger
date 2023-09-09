import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/auth_card.dart';
import '../main.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // void _showErrorDialog(String message) {
  //   showDialog(
  //       context: context,
  //       builder: (ctx) => AlertDialog(
  //             title: const Text('An error occurred! '),
  //             content: Text(message),
  //             actions: [
  //               TextButton(
  //                   onPressed: () {
  //                     Navigator.of(ctx).pop();
  //                   },
  //                   child: const Text('Okay'))
  //             ],
  //           ));
  // }
  bool _isLoading = false;
  void _submitAuthForm(
      String email, String password, String username, AuthMode mode) async {
    // print('$email $password');

    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      // print('waz up');
      if (mode == AuthMode.Login) {
        // print('سلام');
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else if (mode == AuthMode.Signup) {
        authResult = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instanceFor(app: app)
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'email': email,
        });
      }
    } on PlatformException catch (e) {
      var message = 'An error occurred, please check your credentials!';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      if (e.message != null) {
        message = e.message.toString();
      }
      setState(() {
        _isLoading = false;
      });
      // _showErrorDialog()
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(e.toString())));
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Center(
            child: WaveWidget(
              config: CustomConfig(
                colors: [
                  const Color(0xFFFB6334),
                  const Color(0xFF1A73E8),
                ],
                durations: [5000, 4000],
                heightPercentages: [0.65, 0.66],
              ),
              size: Size(deviceSize.width, deviceSize.height),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF00449B).withOpacity(0.5),
                  const Color(0xFF4D93E8).withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: deviceSize.width / 9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          'assets/svgs/fire-svgrepo-com.svg',
                          width: 100,
                        ),
                        const Text(
                          'Fire Messenger',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Color(0xFFFFFFD2),
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(_submitAuthForm, _isLoading),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
