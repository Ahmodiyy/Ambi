import 'package:auto_size_text/auto_size_text.dart';
import 'package:environment_sensors/environment_sensors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AmbientScreen extends ConsumerStatefulWidget {
  const AmbientScreen({super.key});

  @override
  ConsumerState createState() => _AmbientScreenState();
}

class _AmbientScreenState extends ConsumerState<AmbientScreen> {
  late final bool tempAvailable;
  @override
  void initState() {
    super.initState();
    checkForAmbientSensor();
  }

  checkForAmbientSensor() async {
    final environmentSensors = EnvironmentSensors();
    tempAvailable =
        await environmentSensors.getSensorAvailable(SensorType.Pressure);
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
                  ? Expanded(
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AutoSizeText(
                                  '44°',
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 50,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
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
                            child: CustomPaint(
                              foregroundPainter: RulerPainter(),
                              size: const Size(
                                double.infinity,
                                double.infinity,
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
  final int startMark = 20;
  final int endMark = 30;
  final double largeMarkSize = 20.0;
  final double smallMarkSize = 10.0;
  final double textMarginLeft = 5.0;
  final double fontSize = 12.0;
  final TextStyle textStyle = TextStyle(
    color: Colors.black,
    fontSize: 12.0,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final int totalMarks = endMark - startMark + 1; // 20 to 30 (inclusive)
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
      int currentMark = startMark + i;

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
