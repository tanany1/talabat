import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:vending_machine/screens/welcome_screen/welcome_screen.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await connectToArduino();
  await WindowManager.instance.setFullScreen(true);
  runApp(const MyApp());
}

SerialPort? _serialPort;

Future<void> connectToArduino() async {
  String portName = 'COM8'; // Change this to your Arduino port
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