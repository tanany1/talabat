import 'package:flutter/material.dart';
import '../phone_registration/phone_registration_screen.dart';

class CorrectAnswerScreen extends StatelessWidget {
  const CorrectAnswerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/Winner-screen.jpg'), // Background for correct answer screen
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 250),
              ElevatedButton(
                onPressed: () {
                  // Restart the quiz with a random question from index 0 to 6
                  int firstQuestionIndex = (DateTime.now().millisecond % 7); // Random question from index 0-6
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhoneRegistrationScreen(),
                    ),
                        (route) => false, // Removes all previous routes
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6200), // Orange background color
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Padding for button size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), side: const BorderSide(color: Colors.white , width: 5), // Rounded corners (similar to the image)
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Start Over',
                      style: TextStyle(
                        fontSize: 60,
                        color: Colors.white, // White text
                        fontWeight: FontWeight.bold, // Bold text
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_ios_rounded, // Arrow icon similar to the image
                      color: Color(0xFF0066FF),
                      size: 50,// Blue color for the arrow
                    ), // Circular arrow icon
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}