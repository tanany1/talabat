import 'package:flutter/material.dart';
import '../home_screen/home.dart';

class CorrectFirstAnswerScreen extends StatelessWidget {
  const CorrectFirstAnswerScreen({super.key});

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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to a random question from index 7 or 8
                  int nextQuestionIndex = 7 + (DateTime.now().millisecond % 2);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(currentQuestionIndex: nextQuestionIndex),
                    ),
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
                        'Next Question',
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
                      ),
                    ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}