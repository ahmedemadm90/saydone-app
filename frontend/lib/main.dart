import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'views/onboarding_view.dart';
import 'views/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SayDoneApp());
}

class SayDoneApp extends StatelessWidget {
  const SayDoneApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider()..init(),
      child: MaterialApp(
        title: 'SayDone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5865F2)),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
        ),
        home: Consumer<AppProvider>(
          builder: (context, provider, _) {
            if (!provider.onboardingComplete) return const OnboardingView();
            if (provider.user == null) return const _AuthGateway();
            return const HomeView();
          },
        ),
      ),
    );
  }
}

class _AuthGateway extends StatefulWidget {
  const _AuthGateway();
  @override
  State<_AuthGateway> createState() => _AuthGatewayState();
}

class _AuthGatewayState extends State<_AuthGateway> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('Welcome back', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
      const SizedBox(height: 32),
      TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email', filled: true)),
      const SizedBox(height: 16),
      TextField(controller: _pass, obscureText: true, decoration: const InputDecoration(labelText: 'Password', filled: true)),
      const SizedBox(height: 32),
      SizedBox(width: double.infinity, height: 56, child: FilledButton(onPressed: () => context.read<AppProvider>().login(_email.text, _pass.text), child: const Text('Sign In'))),
      const SizedBox(height: 16),
      const Text('Demo: user@example.com / password', style: TextStyle(color: Colors.black38, fontSize: 12)),
    ])),
  );
}
