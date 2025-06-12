import 'package:flutter/material.dart';

class Slide5 extends StatefulWidget {
  final void Function(List<String>) onChange;

  const Slide5({Key? key, required this.onChange}) : super(key: key);

  @override
  State<Slide5> createState() => _Slide5State();
}

class _Slide5State extends State<Slide5> {
  dynamic selected;
  final List<Map<String, dynamic>> personalities = [
    {
      'id': 'toughLoveMom',
      'title': 'Tough Love Mom',
      'image': 'assets/personalities/tough_love_mom.png',
    },
    {
      'id': 'friendlyBuddy',
      'title': 'Friendly Buddy',
      'image': 'assets/personalities/friendly_buddy.png',
    },
    {
      'id': 'caringLover',
      'title': 'Caring Lover',
      'image': 'assets/personalities/caring_lover.png',
    },
    {
      'id': 'angryBigSister',
      'title': 'Angry Big Sister',
      'image': 'assets/personalities/angry_big_sister.png',
    },
    {
      'id': 'gentleDad',
      'title': 'Gentle Dad',
      'image': 'assets/personalities/gentle_dad.png',
    },
    {
      'id': 'moodyCat',
      'title': 'Moody Cat',
      'image': 'assets/personalities/moody_cat.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    selected = personalities[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Pick a personality for Deewas assistant?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 24),
                child: Center(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 16,
                    children: personalities.map((item) {
                      bool isSelected = selected['id'] == item['id'];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selected = item;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 24,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 100,
                                    padding: const EdgeInsets.all(8),
                                    child: Image.asset(
                                      item['image'],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  if (isSelected)
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                    ),
                                ],
                              ),
                              Text(
                                item['title'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: selected != null
                    ? () {
                        widget.onChange([selected['id']]);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: const StadiumBorder(),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
