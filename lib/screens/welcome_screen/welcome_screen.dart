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
              Image.asset('assets/img/Talabat logo_White.png', fit: BoxFit.contain, height: 150,width: MediaQuery.of(context).size.width*0.75,), //talabat logo
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhoneRegistrationScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6200), // Orange background color
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Padding for button size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: Colors.white , width: 5), // Rounded corners (similar to the image)
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Register Now & Continue',
                      style: TextStyle(
                        fontSize: 60,
                        color: Colors.white, // White text
                        fontWeight: FontWeight.bold, // Bold text
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_ios_rounded, // Arrow icon similar to the image
                      color: Color(0xFF0066FF),// Blue color for the arrow
                      size: 50,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}