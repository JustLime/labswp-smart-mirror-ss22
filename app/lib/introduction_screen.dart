import 'dart:async';

import 'package:app/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// Creates an Introduction Screen, to represent what the App can do.
class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  late Timer timer;
  int index = 0;

  List titles = [
    "Arrangeable Widgets on your Mirror",
    "Widgets on your Mirror",
    "Live Widgets",
  ];

  @override
  void initState() {
    timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        if (index < titles.length - 1) {
          setState(() {
            index++;
          });
        } else {
          setState(() {
            index = 0;
          });
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Widget buildPage({
    required String title,
    required String subtitle,
  }) =>

      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 72, 153, 233),
              Color.fromARGB(255, 65, 219, 119)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            Image.asset(
              'assets/logo_name.png',
              fit: BoxFit.cover,
            ),

            /// Header Text and Description Text
            AnimatedSwitcher(
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              duration: const Duration(seconds: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, top: 30),
                    child: Text(
                      titles[index],
                      key: ValueKey(titles[index]),
                      textAlign: TextAlign.left,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 30,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 20,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),

                  /// Dots on the Page, to navigate between the Pages.
                  Center(
                    child: AnimatedSmoothIndicator(
                      activeIndex: index,
                      count: 3,
                      effect: const SlideEffect(
                          dotWidth: 8.0,
                          dotHeight: 8.0,
                          spacing: 10,
                          dotColor: Colors.white38,
                          activeDotColor: Colors.white),
                    
                    ),
                  ),

                  /// Get Started Button.
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextButton(
                              child: Image.asset(
                                'assets/get_started.png',
                                height: 100,
                                width: 200,
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Home()));
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  /// Fill Page with content and unable to scroll.
  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        buildPage(
            title: titles[0],
            subtitle: 'Arrange your Widgets the way you want.'),
        buildPage(
            title: titles[1],
            subtitle: 'Check out the weather or the time with our widget.'),
        buildPage(
            title: titles[2],
            subtitle: 'A live clock. Check it out!'),
      ],
    );
  }
}
