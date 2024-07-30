import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app_flutter/screens/home_screen.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: LottieBuilder.asset("assets/lottie/anim2.json"),
            ),
          ),
        ],
      ),
      nextScreen: const HomeScreen(),
      backgroundColor: Colors.indigo,
      splashIconSize: 350,
      duration:3000
    );
  }
}
