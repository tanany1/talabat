import 'package:flutter/material.dart';
import '../phone_registration/phone_registration_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final int currentQuestionIndex;

  const WelcomeScreen({super.key, this.currentQuestionIndex = 0});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/bg.jpg'), // Add background image here
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/Talabat-Logo.png',
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height * 0.22,
                width: MediaQuery.of(context).size.width * 0.75,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.06),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhoneRegistrationScreen(),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/img/start.png',
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.12,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}