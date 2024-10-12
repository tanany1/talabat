import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../home_screen/home.dart';

class PhoneRegistrationScreen extends StatefulWidget {
  PhoneRegistrationScreen({super.key});
  int currentQuestionIndex = 0;

  @override
  _PhoneRegistrationScreenState createState() => _PhoneRegistrationScreenState();
}

class _PhoneRegistrationScreenState extends State<PhoneRegistrationScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final String _excelFilePath = 'C:/Users/MS Store/Desktop/talabat data sheet.xlsx';
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
              width: 450,
              height: 550,
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
                      border: const OutlineInputBorder(),
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
                  const SizedBox(height: 10),
                  // Keypad for digits
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10, // Reduced spacing between rows
                        crossAxisSpacing: 10, // Reduced spacing between columns
                        childAspectRatio: 150,
                        mainAxisExtent: 80,
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        if (index == 9) {
                          return Center(
                            child: SizedBox(
                              width: 150,
                              height: 180,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: EdgeInsets.zero,
                                  backgroundColor: Colors.green[500],
                                ),
                                onPressed:_submitPhoneNumber,
                                child: const Icon(Icons.check, size: 24),
                              ),
                            ),
                          );
                        } else if (index == 10) {
                          return Center(
                            child: SizedBox(
                              width: 150,
                              height: 180,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: EdgeInsets.zero,
                                  backgroundColor: Colors.grey[100],
                                ),
                                onPressed: () => _addDigit('0'),
                                child: const Text('0', style: TextStyle(fontSize: 20)),
                              ),
                            ),
                          );
                        } else if (index == 11) {
                          return Center(
                            child: SizedBox(
                              width: 150,
                              height: 180,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: EdgeInsets.zero,
                                  backgroundColor: Colors.red[500],
                                ),
                                onPressed: _clearLastDigit,
                                child: const Icon(Icons.backspace, size: 24),
                              ),
                            ),
                          ); // Empty space
                        } else {
                          return Center(
                            child: SizedBox(
                              width: 150,
                              height: 180,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: EdgeInsets.zero,
                                  backgroundColor: Colors.grey[100],
                                ),
                                onPressed: () => _addDigit((index + 1).toString()),
                                child: Text(
                                  (index + 1).toString(),
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6200), // Orange background color
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20), // Padding for button size
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), side: const BorderSide(color: Colors.white , width: 5), // Rounded corners
                          ),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Skip & Continue',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white, // White text
                                fontWeight: FontWeight.bold, // Bold text
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward_ios_rounded, // Arrow icon similar to the image
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}