import 'dart:ui';
import 'package:flutter/material.dart';

class CanvaPage extends StatefulWidget {
  const CanvaPage({Key? key}) : super(key: key);

  @override
  State<CanvaPage> createState() => _CanvaPageState();
}

class _CanvaPageState extends State<CanvaPage> {
  Color selectedColor = Colors.black;
  double strokeWidth = 5;
  List<DrawingPoint> drawingPoints = [];
  List<Color> colors = [
    Colors.red,
    Colors.pink,
    Colors.green,
    Colors.black,
    Colors.orange,
    Colors.brown,
    Colors.yellow,
    Colors.greenAccent,
    Colors.lightGreen,
    Colors.lightGreenAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: (details) {
              setState(() {
                drawingPoints.add(DrawingPoint(
                  details.localPosition,
                  Paint()
                    ..color = selectedColor
                    ..isAntiAlias = true
                    ..strokeWidth = strokeWidth
                    ..strokeCap = StrokeCap.round,
                ));
              });
            },
            onPanUpdate: (details) {
              setState(() {
                drawingPoints.add(DrawingPoint(
                  details.localPosition,
                  Paint()
                    ..color = selectedColor
                    ..isAntiAlias = true
                    ..strokeWidth = strokeWidth
                    ..strokeCap = StrokeCap.round,
                ));
              });
            },
            onPanEnd: (details) {
              setState(() {
                drawingPoints.add(DrawingPoint(null, null));
              });
            },
            child: CustomPaint(
              painter: _DrawingPainter(drawingPoints),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          Positioned(
              top: 40,
              right: 30,
              left: 30,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Slider(
                      min: 0,
                      max: 40,
                      value: strokeWidth,
                      onChanged: (value) {
                        setState(() {
                          strokeWidth = value;
                        });
                      },
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          drawingPoints = [];
                        });
                      },
                      icon: Icon(Icons.delete),
                      label: Text("Clear Board"),
                    )
                  ],
                ),
              ))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.grey[300],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              colors.length,
              (index) => _buildColorChoose(colors[index]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorChoose(Color color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        height: isSelected ? 50 : 40,
        width: isSelected ? 50 : 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(
                  color: Colors.white,
                  width: 3,
                )
              : null,
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingPoint> drawingPoints;

  _DrawingPainter(this.drawingPoints);

  List<Offset> offsetList = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length - 1; i++) {
      if (drawingPoints[i].offset != null &&
          drawingPoints[i + 1].offset != null) {
        canvas.drawLine(
          drawingPoints[i].offset!,
          drawingPoints[i + 1].offset!,
          drawingPoints[i].paint!,
        );
      } else if (drawingPoints[i].offset != null &&
          drawingPoints[i + 1].offset == null) {
        offsetList.clear();
        offsetList.add(drawingPoints[i].offset!);

        canvas.drawPoints(
            PointMode.points, offsetList, drawingPoints[i].paint!);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingPoint {
  Offset? offset;
  Paint? paint;

  DrawingPoint(this.offset, this.paint);
}
