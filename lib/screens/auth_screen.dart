// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/auth_card.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});
  static const routeName = '/auth';
  void _submitAuthForm() {}
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
                  size: Size(deviceSize.width, deviceSize.height))),
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
                    child: AuthCard(),
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
