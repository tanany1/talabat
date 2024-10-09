import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await connectToArduino();
  await WindowManager.instance.setFullScreen(true);
  runApp(const MyApp());
}

SerialPort? _serialPort;

Future<void> connectToArduino() async {
  String portName = 'COM7'; // Change this to your Arduino port
  int baudRate = 9600;

  _serialPort = SerialPort(portName);
  // Open the serial port for both reading and writing
  bool portOpened = _serialPort!.openReadWrite();

  if (portOpened) {
    _serialPort!.config.baudRate = baudRate;
    print('Connected to Arduino on $portName');
  } else {
    print('Failed to open port $portName.');
  }
}

Future<void> sendCommandToArduino(String command) async {
  _serialPort!.write(Uint8List.fromList(command.codeUnits));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

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
                      builder: (context) => HomeScreen(currentQuestionIndex: currentQuestionIndex),
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
                      'Start',
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

class HomeScreen extends StatefulWidget {
  final int currentQuestionIndex;
  const HomeScreen({super.key, required this.currentQuestionIndex});
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
      command = '1'; // Command to operate Motor 1
      correctCount7++;
      if (correctCount7 == 8) {
        _showNotification('Slot A Nearly Empty,Please Refill');
      }
    } else if (currentIndex == 8) {
      command = '3'; // Command to operate Motor 2
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
      'Which of these is a refreshing & nutritious on-the-go drink for the school day?',
      [
        Option('A) Tea', 'assets/img/tea.png'),
        Option('B) Domty Juice', 'assets/img/download.jpeg'),
        Option('C) Sugar Cane Juice', 'assets/img/sugercane.jpg'),
        Option('D) Soda Drink', 'assets/img/soda-Photoroom.png'),
      ],
      1,
    ),
    Question(
      'Which of these is an on-the-go snack for the school day?',
      [
        Option('A) Fish', 'assets/img/fish.jpg'),
        Option('B) Domty Sandwich', 'assets/img/domty.jpg'),
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.sizeOf(context).height*0.25,),
              Text(
                question.text,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              Expanded(
                child: GridView.builder(
                  itemCount: question.options.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1.5,
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
          borderRadius: BorderRadius.circular(15),
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
              height: 120,
              width: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            Text(
              text,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

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
                      'Register Now',
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

class IncorrectAnswerScreen extends StatelessWidget {
  const IncorrectAnswerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/Background.jpg'), // Background for incorrect answer screen
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/img/wrong.png'),// Add an image for incorrect answer
              const SizedBox(height: 20),
              const Text(
                'Wrong Answer! Try Again',
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Restart the quiz with a random question from index 0 to 6
                  int firstQuestionIndex = (DateTime.now().millisecond % 7); // Random question from index 0-6
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(currentQuestionIndex: firstQuestionIndex),
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
                      'Try Again',
                      style: TextStyle(
                        fontSize: 60,
                        color: Colors.white, // White text
                        fontWeight: FontWeight.bold, // Bold text
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.restart_alt, // Arrow icon similar to the image
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

class PhoneRegistrationScreen extends StatefulWidget {
   PhoneRegistrationScreen({super.key});
  int currentQuestionIndex = 0;

  @override
  _PhoneRegistrationScreenState createState() => _PhoneRegistrationScreenState();
}

class _PhoneRegistrationScreenState extends State<PhoneRegistrationScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final String _excelFilePath = 'C:/Users/MS STORE/Desktop/talabat data sheet.xlsx';
  int firstQuestionIndex =0;


  void _submitPhoneNumber() {
    String phoneNumber = _phoneController.text;
    if (phoneNumber.isNotEmpty) {
      _updateExcelFile(phoneNumber);
    }
  }
  
  void _updateExcelFile(String phoneNumber) {
    var file = File(_excelFilePath);
    var bytes = file.readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    // Assuming you are writing to the first sheet
    var sheet = excel['Sheet1'];
    sheet.appendRow([phoneNumber]);

    var fileBytes = excel.encode();
    file.writeAsBytesSync(fileBytes!);
  }

  void _addDigit(String digit) {
    setState(() {
      if (_phoneController.text.length < 11) {
        _phoneController.text += digit;
      }
    });
  }

  void _clearLastDigit() {
    setState(() {
      if (_phoneController.text.isNotEmpty) {
        _phoneController.text =
            _phoneController.text.substring(
                0, _phoneController.text.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/Background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Centered container
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 310,
              height: 540,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Enter your phone number',
                      border: OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.phone),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    keyboardType: TextInputType.none,
                    maxLength: 11,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _submitPhoneNumber,
                        child: const Text('Submit'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6200), // Orange background color
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20), // Padding for button size
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
                                fontSize: 14,
                                color: Colors.white, // White text
                                fontWeight: FontWeight.bold, // Bold text
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.restart_alt, // Arrow icon similar to the image
                              color: Color(0xFF0066FF),
                              size: 20,// Blue color for the arrow
                            ), // Circular arrow icon
                          ],
                        ),
                        onPressed:  () {
                          // Restart the quiz with a random question from index 0 to 6
                          int firstQuestionIndex = (DateTime.now().millisecond % 7); // Random question from index 0-6
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(currentQuestionIndex: firstQuestionIndex),
                            ),
                                (route) => false, // Removes all previous routes
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // Keypad for digits
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 5, // Reduced spacing between rows
                        crossAxisSpacing: 5, // Reduced spacing between columns
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        if (index == 9) {
                          return SizedBox(
                            width: 20,
                            height: 20,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.grey[100],
                              ),
                              onPressed: _clearLastDigit,
                              child: const Icon(Icons.backspace, size: 18),
                            ),
                          );
                        } else if (index == 10) {
                          return SizedBox(
                            width: 20,
                            height: 20,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.grey[100],
                              ),
                              onPressed: () => _addDigit('0'),
                              child: const Text('0', style: TextStyle(fontSize: 14)),
                            ),
                          );
                        } else if (index == 11) {
                          return const SizedBox(); // Empty space
                        } else {
                          return SizedBox(
                            width: 20,
                            height: 20,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.grey[100],
                              ),
                              onPressed: () => _addDigit((index + 1).toString()),
                              child: Text(
                                (index + 1).toString(),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          );
                        }
                      },
                    ),
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

class Question {
  final String text;
  final List<Option> options;
  final int correctAnswerIndex;

  Question(this.text, this.options, this.correctAnswerIndex);
}

class Option {
  final String text;
  final String imagePath;

  Option(this.text, this.imagePath);
}