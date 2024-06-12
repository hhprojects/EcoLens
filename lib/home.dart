import 'package:camera/camera.dart';
import 'package:eco_lens_draft/dashboard.dart';
import 'package:eco_lens_draft/settings.dart';
import 'package:flutter/material.dart';
import 'package:eco_lens_draft/constants.dart';
import 'package:eco_lens_draft/display_page.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const HomePage({
    super.key,
    required this.cameras,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      DisplayPage(widget.cameras),
      const DashboardPage(),
      const SettingsPage(),
    ];
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: tabs[currentIndex],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              width: size.width,
              height: 80,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: Size(size.width, 80),
                    painter: BNBCustomPainter(),
                  ),
                  Center(
                    heightFactor: 0.6,
                    child: FloatingActionButton(
                        backgroundColor: primaryColor,
                        elevation: 0.1,
                        onPressed: () {
                          setBottomBarIndex(0);
                        },
                        child: const Icon(Icons.camera_alt)),
                  ),
                  SizedBox(
                    width: size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.home,
                            color: currentIndex == 1
                                ? primaryColor
                                : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            setBottomBarIndex(1);
                          },
                          splashColor: Colors.white,
                        ),
                        Container(
                          width: size.width * 0.20,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.notifications,
                              color: currentIndex == 2
                                  ? const Color(0xFFFFBF00)
                                  : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setBottomBarIndex(2);
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: const Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
