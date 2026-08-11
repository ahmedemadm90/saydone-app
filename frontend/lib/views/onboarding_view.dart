import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});
  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _pageController = PageController();
  int _index = 0;

  final List<Map<String, String>> _pages = [
    {'title': 'Speak your mind', 'body': 'Record your thoughts in Arabic or English. SayDone understands both formal and slang.'},
    {'title': 'Organized tasks', 'body': 'We automatically extract tasks, priorities, and descriptions from your voice notes.'},
    {'title': 'Stay focused', 'body': 'Manage your daily goals with a clean, distraction-free interface.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Column(children: [
        Expanded(child: PageView.builder(controller: _pageController, onPageChanged: (v) => setState(() => _index = v), itemCount: _pages.length, itemBuilder: (context, i) => Padding(padding: const EdgeInsets.all(40), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 200, height: 200, decoration: BoxDecoration(color: const Color(0xFFF0F2FF), borderRadius: BorderRadius.circular(100)), child: const Icon(Icons.mic_none_rounded, size: 80, color: Color(0xFF5865F2))),
          const SizedBox(height: 40),
          Text(_pages[i]['title']!, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF1A1D1E))),
          const SizedBox(height: 16),
          Text(_pages[i]['body']!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.5)),
        ])))),
        Padding(padding: const EdgeInsets.all(24), child: Row(children: [
          Row(children: List.generate(_pages.length, (i) => Container(margin: const EdgeInsets.only(right: 6), width: _index == i ? 24 : 8, height: 8, decoration: BoxDecoration(color: _index == i ? const Color(0xFF5865F2) : Colors.black12, borderRadius: BorderRadius.circular(4))))),
          const Spacer(),
          FilledButton(onPressed: () { if (_index < _pages.length - 1) { _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease); } else { context.read<AppProvider>().completeOnboarding(); } }, child: Text(_index == _pages.length - 1 ? 'Get Started' : 'Next')),
        ])),
      ])),
    );
  }
}
