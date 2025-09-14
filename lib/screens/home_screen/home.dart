import 'package:flutter/material.dart';
import '../../main.dart';
import '../../modal/modal_classes.dart';
import '../correct_answer/correct_answer_screen.dart';
import '../correct_first_answer/correct_first_answer_screen.dart';
import '../incorrect_answer/incorrect_answer_screen.dart';

class HomeScreen extends StatefulWidget {
  final int currentQuestionIndex;
  const HomeScreen({super.key,  required this.currentQuestionIndex});
  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  late final int currentQuestionIndex;
  int correctCount7 = 0;
  int correctCount8 = 0;

  void onQuestionAnswered(int currentIndex) async {
    await Future.delayed(const Duration(milliseconds: 5)); // Adjust delay as needed
    String command = '';

    if (currentIndex == 7) {
      command = 'A'; // Command to operate Motor 1
      correctCount7++;
      if (correctCount7 == 8) {
        _showNotification('Slot A Nearly Empty,Please Refill');
      }
    } else if (currentIndex == 8) {
      command = 'C'; // Command to operate Motor 2
      correctCount8++;
      if (correctCount8 == 8) {
        _showNotification('Slot C Nearly Empty,Please Refill');
      }
    }
    await sendCommandToArduino(command);
  }

  void _showNotification(String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Remove the notification after a short delay
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  List<Question> questions = [
    Question(
      'Pick the Item that is NOT in the School Supplies List?',
      [
        Option('A) Notebooks', 'assets/img/notebook.png'),
        Option('B) Markers', 'assets/img/markers.png'),
        Option('C) Orange Juice', 'assets/img/orange-juice-Photoroom.png'),
        Option('D) Pencils', 'assets/img/pencil_case-Photoroom.png'),
      ],
      2,
    ),
    Question(
      'Which of these is the healthiest lunchbox item?',
      [
        Option('A) Chips', 'assets/img/chips-Photoroom.png'),
        Option('B) Carrot Sticks', 'assets/img/Carrots_Sticks-Photoroom.png'),
        Option('C) Chocolate Bar', 'assets/img/choc_bar-Photoroom.png'),
        Option('D) Cookies', 'assets/img/cookies-Photoroom.png'),
      ],
      1,
    ),
    Question(
      'Which item doesn’t belong in this school bag?',
      [
        Option('A) Textbook', 'assets/img/textbook-Photoroom.png'),
        Option('B) Eraser', 'assets/img/eraser-Photoroom.png'),
        Option('C) Ice Cream', 'assets/img/icecream-Photoroom.png'),
        Option('D) Pencil Case', 'assets/img/pencil_case-Photoroom.png'),
      ],
      2,
    ),
    Question(
      'Which of these is a great lunchbox snack?',
      [
        Option('A) Fruit Salad', 'assets/img/fruit-salad-Photoroom.png'),
        Option('B) Candy', 'assets/img/candy-Photoroom.png'),
        Option('C) Soda', 'assets/img/soda-Photoroom.png'),
        Option('D) Chips', 'assets/img/chips-Photoroom.png'),
      ],
      0,
    ),
    Question(
      'Which item is most useful for math class?',
      [
        Option('A) Ruler', 'assets/img/ruler-Photoroom.png'),
        Option('B) Highlighter', 'assets/img/highlighter-pen-Photoroom.png'),
        Option('C) Water Bottle', 'assets/img/water-Photoroom.png'),
        Option('D) Notebook', 'assets/img/notebook.png'),
      ],
      0,
    ),
    Question(
      'Which of these drinks is the healthiest?',
      [
        Option('A) Soda', 'assets/img/soda-Photoroom.png'),
        Option('B) Milk', 'assets/img/milk-Photoroom.png'),
        Option('C) Energy Drink', 'assets/img/energy_drink-Photoroom.png'),
        Option('D) Fruit Juice', 'assets/img/fruit_juice-Photoroom.png'),
      ],
      1,
    ),
    Question(
      'Which of these is essential for a school day?',
      [
        Option('A) Notebook', 'assets/img/notebook.png'),
        Option('B) Ice Cream', 'assets/img/icecream-Photoroom.png'),
        Option('C) Video Game', 'assets/img/videogame-Photoroom.png'),
        Option('D) PlayStation', 'assets/img/playstation.jpeg'),
      ],
      0,
    ),
    Question(
      'Which of these is a refreshing & nutritious \non-the-go drink for the school day?',
      [
        Option('A) Tea', 'assets/img/tea.png'),
        Option('B) Fresh Juice', 'assets/img/fresh_juice.png'),
        Option('C) Sugar Cane Juice', 'assets/img/sugercane.jpg'),
        Option('D) Soda Drink', 'assets/img/soda-Photoroom.png'),
      ],
      1,
    ),
    Question(
      'Which of these is an on-the-go snack for the school day?',
      [
        Option('A) Fish', 'assets/img/fish.jpg'),
        Option('B) Healthy Snack', 'assets/img/healthy_snack.png'),
        Option('C) Molokheya & Rice', 'assets/img/IMG_6515.jpg'),
        Option('D) Sugar Cane Juice', 'assets/img/sugercane.jpg'),
      ],
      1,
    ),
  ];

  int correctAnswers = 0;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void handleAnswer(int selectedIndex) {
    bool isCorrect = selectedIndex == questions[widget.currentQuestionIndex].correctAnswerIndex;

    if (widget.currentQuestionIndex >= 0 && widget.currentQuestionIndex <= 6) { // First question (index 0-6)
      if (!isCorrect) {
        // If the first question is wrong, navigate to IncorrectAnswerScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const IncorrectAnswerScreen(),
          ),
        );
      } else {
        // If the first question is correct, move to the next question (randomly from index 7-8)
        int secondQuestionIndex = 7 + (DateTime.now().millisecond % 2); // Randomly pick 7 or 8
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CorrectFirstAnswerScreen(),
          ),
        );
      }
    } else if (widget.currentQuestionIndex == 7 || widget.currentQuestionIndex == 8) { // Second question (index 7 or 8)
      if (isCorrect) {
        // Call the function to send command to Arduino
        onQuestionAnswered(widget.currentQuestionIndex);
        // If the second question is correct, navigate to CorrectAnswerScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CorrectAnswerScreen(),
          ),
        );
      } else {
        // If the second question is wrong, navigate to IncorrectAnswerScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const IncorrectAnswerScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var question = currentIndex == 0
        ? questions[widget.currentQuestionIndex]
        : questions[7 + (widget.currentQuestionIndex % 2)];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/Background.jpg'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.sizeOf(context).height*0.25),
              Text(
                question.text,
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff4a1518),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 100),
              Expanded(
                child: GridView.builder(
                  itemCount: question.options.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1.3,
                  ),
                  itemBuilder: (context, index) {
                    return _buildOptionCard(
                      index,
                      question.options[index].text,
                      question.options[index].imagePath,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(int index, String text, String imagePath) {
    return GestureDetector(
      onTap: () => handleAnswer(index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 200,
              width: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            Text(
              text,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xff4a1518),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}