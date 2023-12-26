import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensors Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0x9f4376f8),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentValue = 500;
  AccelerometerEvent? acceleration;
  late StreamSubscription<AccelerometerEvent> _streamSubscription;

 

  @override
void initState() {
 super.initState();
 _streamSubscription = accelerometerEventStream(
          samplingPeriod: const Duration(milliseconds: 200))
      .listen((event) {
    setState(() {
      acceleration = event;
      _updateValue();
    });
 });
}

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

 

  void _updateValue() {
 if (acceleration != null) {
    // Adjust the sensitivity based on your preference
    const sensitivity = 0.02;

    // Calculate the change in value based on the accelerometer data
    final delta = (acceleration!.y * sensitivity).round();

    // Update the current value with the calculated delta
    setState(() {
      currentValue = (currentValue - delta).clamp(1, 1000);
    });
 }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tilt Scroller'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(1000, (index) {
            final value = index + 1;
            final isEven = value.isEven;
            return ListTile(
              title: Center(child: Text('$value')),
              tileColor: isEven ? Colors.green : Colors.purple,
              hoverColor: isEven ? Colors.greenAccent : Colors.redAccent,
              onTap: () {
                setState(() {
                  currentValue = value;
                });
              },
            );
          }),
        ),
      ),
    );
  }
}
