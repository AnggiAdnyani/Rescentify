import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uts/screens/login_page.dart';
import 'package:uts/widgets/custom_scaffold.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 20.0,
              ),
              child: Column(
                children: [
                  const Image(image: AssetImage('assets/images/Logo.png')),
                  Center(
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: const TextSpan(children: [
                        TextSpan(
                            text:
                                '\n"Turn On Your Feels with Aromatherapy Candle"',
                            style: TextStyle(
                              fontFamily: 'InriaSerif',
                              fontSize: 30,
                              // height: 0,
                            ))
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: Get.width,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBD946D),
                    padding: const EdgeInsets.symmetric(
                        vertical: 17, horizontal: 32),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100))),
                child: const Text(
                  'Explore More',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: Get.width,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 17, horizontal: 32),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100))),
                child: const Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFC67C4E),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ),
            ),
            const Text(
              'Find your scent preferences and contribute\nfor environment with Rescentify',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFA8A8A8),
                fontSize: 10,
                fontFamily: 'Sora',
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
