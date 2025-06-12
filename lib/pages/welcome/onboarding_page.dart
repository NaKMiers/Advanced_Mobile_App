import 'package:advanced_mobile_app/components/onboarding/Slide1.dart';
import 'package:advanced_mobile_app/components/onboarding/Slide2.dart';
import 'package:advanced_mobile_app/components/onboarding/Slide3.dart';
import 'package:advanced_mobile_app/components/onboarding/Slide4.dart';
import 'package:advanced_mobile_app/components/onboarding/Slide5.dart';
import 'package:advanced_mobile_app/components/onboarding/Slide6.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentSlide = 0;
  List<dynamic> _formData = [];

  @override
  void initState() {
    super.initState();
    _formData = List<dynamic>.filled(6, null, growable: false);
  }

  Future<void> _handleSendReport() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('onboarding', _formData.toString());
    // Add your sendReportApi logic here
    print('Sending report: $_formData');
  }

  void _nextSlide() {
    if (_currentSlide < 5) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _prevSlide() {
    if (_currentSlide > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.of(context).pop(); // Go back
    }
  }

  void _resetSlides() {
    _pageController.jumpToPage(0);
  }

  void _updateForm(int index, dynamic value) {
    setState(() {
      _formData[index] = value;
    });
    _nextSlide();
  }

  List<Widget> _buildSlides() {
    return [
      Slide1(onChange: (value) => _updateForm(0, value)),
      Slide2(onChange: (value) => _updateForm(1, value)),
      Slide3(onChange: (value) => _updateForm(2, value)),
      Slide4(
        onChange: (value) async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('currency', value.toString());
          _nextSlide();
        },
      ),
      Slide5(
        onChange: (value) async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('personalities', value.toString());
          _nextSlide();
        },
      ),
      Slide6(onPress: _handleSendReport),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final slides = _buildSlides();

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21.0),
          child: Column(
            children: [
              // Progress Bar & Buttons
              Row(
                children: [
                  IconButton(
                    onPressed: _prevSlide,
                    icon: const Icon(Icons.chevron_left, size: 30),
                  ),
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: (_currentSlide + 1) / slides.length,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _resetSlides,
                    icon: const Icon(Icons.refresh, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 21),

              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: slides.length,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() => _currentSlide = index);
                  },
                  itemBuilder: (_, index) => slides[index],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
