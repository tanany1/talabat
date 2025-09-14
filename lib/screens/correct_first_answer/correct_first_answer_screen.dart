import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../home_screen/home.dart';

class CorrectFirstAnswerScreen extends StatelessWidget {
  const CorrectFirstAnswerScreen({super.key});

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
                image: AssetImage('assets/img/win.jpg'), // Background for correct answer screen
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/img/correct.png', fit: BoxFit.contain,width: 250,height: 250,),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      int nextQuestionIndex = 7 + (DateTime.now().millisecond % 2);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(currentQuestionIndex: nextQuestionIndex),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/img/next.png', // Replace with your image path
                      fit: BoxFit.contain, // Adjust how the image fits in the container
                      width: 900, // Adjust based on your design
                      height: 150, // Adjust based on your design
                    ),
                  )
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
                Colors.orange
              ],
            ),
          ),
        ],
      ),
    );
  }
}