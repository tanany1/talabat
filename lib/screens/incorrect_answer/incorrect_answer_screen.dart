import 'package:flutter/material.dart';
import '../home_screen/home.dart';

class IncorrectAnswerScreen extends StatelessWidget {
  const IncorrectAnswerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/Background.jpg'),
            // Background for incorrect answer screen
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/img/wrong.png', fit: BoxFit.contain,width: 250,height: 250,),
              // Add an image for incorrect answer
              const SizedBox(height: 20),
              const Text(
                'Wrong Answer! Try Again',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff4a1518),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Restart the quiz with a random question from index 0 to 6
                  int firstQuestionIndex = (DateTime.now().millisecond %
                      7); // Random question from index 0-6
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen(currentQuestionIndex: firstQuestionIndex),
                    ),
                    (route) => false, // Removes all previous routes
                  );
                },
                child: Image.asset(
                  'assets/img/try_again.png', // Replace with your image path
                  fit: BoxFit.contain,
                  // Adjust how the image fits in the container
                  width: 900,
                  // Adjust based on your design
                  height: 150, // Adjust based on your design
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
