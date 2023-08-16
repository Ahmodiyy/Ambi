import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:environment_sensors/environment_sensors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sensors/flutter_sensors.dart';

class AmbientScreen extends ConsumerStatefulWidget {
  const AmbientScreen({super.key});

  @override
  ConsumerState createState() => _AmbientScreenState();
}

class _AmbientScreenState extends ConsumerState<AmbientScreen> {
  bool tempAvailable = false;
  double tempValue = 0;

  bool isAvailable = false;
  StreamSubscription? _lightSubscription;
  List<double> _lightData = [];

  Future<void> initPlatformState() async {
// Checking if is available.
    isAvailable =
        await SensorManager().isSensorAvailable(Sensors.ACCELEROMETER);
// Initialize a stream to receive the updates.
    debugPrint("show availability   $isAvailable");
    final stream = await SensorManager().sensorUpdates(
        sensorId: Sensors.ACCELEROMETER, interval: Sensors.SENSOR_DELAY_UI);
    _lightSubscription = stream.listen((sensorEvent) {
      setState(() {
        _lightData = sensorEvent.data;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    checkForAmbientSensor();
  }

  checkForAmbientSensor() async {
    final environmentSensors = EnvironmentSensors();
    tempAvailable = await environmentSensors
        .getSensorAvailable(SensorType.AmbientTemperature);

    if (tempAvailable == true) {
      environmentSensors.temperature.listen((temp) {
        setState(() {
          tempValue = temp;
          debugPrint(temp.toString());
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              AutoSizeText(
                "Environment temperature",
                maxLines: 1,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              AutoSizeText(
                "Measures air temperature",
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 60,
              ),
              tempAvailable
                  //isAvailable
                  ? Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AutoSizeText(
                                  //'${tempValue.toStringAsFixed(2)}°',
                                  '${_lightData.last.toStringAsFixed(2)}°',
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontSize: 50,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'censuis',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: RadialGradient(
                                  center: Alignment
                                      .center, // The center of the gradient (usually set to Alignment.center)
                                  radius:
                                      1.5, // The radius of the circle within which the gradient will be drawn (0.0 to 1.0)
                                  colors: [
                                    Color(0xffd8d6d6), // Start color
                                    Colors.white, // End color
                                  ],
                                  stops: [
                                    0.0,
                                    1.0
                                  ], // The position of each color in the gradient (0.0 to 1.0)
                                  focal: Alignment
                                      .center, // The focal point of the gradient (usually set to Alignment.center)
                                  focalRadius:
                                      0.2, // The radius of the focal point (0.0 to 1.0)
                                ),
                              ),
                              child: CustomPaint(
                                foregroundPainter:
                                    RulerPainter(tempValue - 5, tempValue + 5),
                                // _lightData.last.round() - 5,
                                //_lightData.last.round() + 5),
                                size: const Size(
                                  double.infinity,
                                  double.infinity,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            "Your phone does not have the necessary sensor "
                            "to measure the environmental temperature.",
                            textAlign: TextAlign.center,
                          ),
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

class RulerPainter extends CustomPainter {
  RulerPainter(this.startMark, this.endMark);
  final double startMark;
  final double endMark;
  final double largeMarkSize = 20.0;
  final double smallMarkSize = 10.0;
  final double textMarginLeft = 5.0;
  final double fontSize = 12.0;
  final TextStyle textStyle = const TextStyle(
    color: Colors.black,
    fontSize: 12.0,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double totalMarks = endMark - startMark; // 20 to 30 (inclusive)
    final double unitHeight = height / totalMarks;

    final linePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < totalMarks; i++) {
      double yPos = i * unitHeight;
      double currentMark = startMark + i;

      if (currentMark % 5 == 0) {
        canvas.drawLine(
            Offset(0, yPos), Offset(largeMarkSize, yPos), linePaint);
        textPainter.text = TextSpan(text: '$currentMark', style: textStyle);
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(largeMarkSize + textMarginLeft, yPos - textPainter.height / 2),
        );
      } else {
        canvas.drawLine(
            Offset(0, yPos), Offset(smallMarkSize, yPos), linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
