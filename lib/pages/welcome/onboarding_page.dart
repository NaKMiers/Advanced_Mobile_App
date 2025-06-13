import 'dart:convert';

import 'package:advanced_mobile_app/components/onboarding/slide1.dart';
import 'package:advanced_mobile_app/components/onboarding/slide2.dart';
import 'package:advanced_mobile_app/components/onboarding/slide3.dart';
import 'package:advanced_mobile_app/components/onboarding/slide4.dart';
import 'package:advanced_mobile_app/components/onboarding/slide5.dart';
import 'package:advanced_mobile_app/components/onboarding/slide6.dart';
import 'package:advanced_mobile_app/components/page_wapper.dart';
import 'package:advanced_mobile_app/requests/index.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int curSlide = 0;

  List<dynamic> form = [];

  // go to next slide
  void nextSlide() {
    if (curSlide < slides.length - 1) {
      setState(() {
        curSlide++;
      });
    }
  }

  late List<Widget> slides;

  @override
  void initState() {
    super.initState();
    slides = [
      Slide1(
        onChange: (value) {
          setState(() {
            curSlide = 1;
            form.isEmpty ? form.add(value) : form[0] = value;
          });
        },
      ),
      Slide2(
        onChange: (value) {
          setState(() {
            form.length <= 1 ? form.add(value) : form[1] = value;
            curSlide = 2;
          });
        },
      ),
      Slide3(
        onChange: (value) {
          setState(() {
            form.length <= 2 ? form.add(value) : form[2] = value;
            curSlide = 3;
          });
        },
      ),
      Slide4(
        onChange: (value) async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('currency', jsonEncode(value));
          setState(() {
            curSlide = 4;
          });
        },
      ),
      Slide5(
        onChange: (value) async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('personality', jsonEncode(value));
          setState(() {
            curSlide = 5;
          });
        },
      ),
      Slide6(
        onPress: () async {
          final prefs = await SharedPreferences.getInstance();

          // Get currency and personality from SharedPreferences
          final currency = prefs.getString('currency');
          final personality = prefs.getString('personality');

          print(currency);
          print(personality);
          print(form);

          try {
            await sendReportApi(form);

            // Set onboarding
            await prefs.setString('onboarding', jsonEncode(form));
          } catch (err) {
            print('Error: $err');
          }
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLarge = screenWidth > 768;

    return Scaffold(
      body: PageWrapper(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 21, vertical: 8),
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: curSlide > 0
                    ? () {
                        setState(() {
                          curSlide--;
                        });
                      }
                    : null,
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 4,
                      width: screenWidth * (curSlide + 1) / slides.length,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.restart_alt),
                onPressed: () {
                  setState(() {
                    curSlide = 0;
                    form.clear();
                  });
                },
              ),
            ],
          ),

          Expanded(child: slides[curSlide]),
        ],
      ),
    );
  }
}
