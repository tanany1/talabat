import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../phone_registration/phone_registration_screen.dart';

class CorrectAnswerScreen extends StatelessWidget {
  const CorrectAnswerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final confettiController = ConfettiController(duration: const Duration(seconds: 5));

    // Start confetti animation when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      confettiController.play();
    });

    return Scaffold(
      body: Stack(
        children: [
          Container(
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
                  GestureDetector(
                    onTap: () {
                      int firstQuestionIndex = (DateTime.now().millisecond % 7); // Random question from index 0-6
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhoneRegistrationScreen(),
                        ),
                            (route) => false, // Removes all previous routes
                      );
                    },
                    child: Image.asset(
                      'assets/img/start_over.png', // Replace with your image path
                      fit: BoxFit.contain, // Adjust how the image fits in the container
                      width: 900, // Adjust based on your design
                      height: 150, // Adjust based on your design
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              maxBlastForce: 60,
              numberOfParticles: 300,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: true,
              colors: const [
                Colors.orange,
              ],
            ),
          ),
        ],
      ),
    );
  }
}