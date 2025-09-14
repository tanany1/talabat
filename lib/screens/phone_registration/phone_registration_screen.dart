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
  int firstQuestionIndex = 0;

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
            _phoneController.text.substring(0, _phoneController.text.length - 1);
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
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
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
                      ),
                      const SizedBox(width: 20,),
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.zero,
                            backgroundColor: const Color(0xffff5900),
                          ),
                          onPressed: _clearLastDigit,
                          child: const Icon(Icons.backspace, size: 24 , color: Color(0xfff7ece0),),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Keypad for digits
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.0,
                        mainAxisExtent: 80,
                      ),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        if (index == 9) {
                          return Center(
                            child: SizedBox(
                              width: 450, // Span the width of 3 buttons
                              height: 80,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: EdgeInsets.zero,
                                  backgroundColor: Colors.grey[100],
                                ),
                                onPressed: () => _addDigit('0'),
                                child: const Text('0', style: TextStyle(fontSize: 40)),
                              ),
                            ),
                          );
                        } else {
                          return Center(
                            child: SizedBox(
                              width: 150,
                              height: 80,
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
                                  style: const TextStyle(fontSize: 40),
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
                      GestureDetector(
                        onTap: () {
                          int firstQuestionIndex = (DateTime.now().millisecond % 7);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(currentQuestionIndex: firstQuestionIndex),
                            ),
                                (route) => false,
                          );
                        },
                        child: const Text("Skip", style: TextStyle(fontSize: 20, color: Color(0xff4a1518), fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 50),
                      GestureDetector(
                        onTap: () {
                          _submitPhoneNumber();
                          int firstQuestionIndex = (DateTime.now().millisecond % 7);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(currentQuestionIndex: firstQuestionIndex),
                            ),
                                (route) => false,
                          );
                        },
                        child: Image.asset(
                          'assets/img/continue_button.png',
                          fit: BoxFit.contain,
                          width: 260,
                          height: 50,
                        ),
                      )
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