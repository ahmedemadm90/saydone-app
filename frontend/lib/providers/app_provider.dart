import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_models.dart';
import '../services/saydone_api.dart';

class AppProvider extends ChangeNotifier {
  AppProvider({SaydoneApi? api}) : _api = api ?? SaydoneApi();
  final SaydoneApi _api;
  final List<SayDoneTask> _tasks = [];
  SayDoneUser? _user;
  bool _loading = false;
  bool _onboardingComplete = false;
  String? _error;

  List<SayDoneTask> get tasks => List.unmodifiable(_tasks);
  SayDoneUser? get user => _user;
  bool get loading => _loading;
  bool get onboardingComplete => _onboardingComplete;
  String? get error => _error;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _onboardingComplete = prefs.getBool('onboarding_done') ?? false;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    _onboardingComplete = true;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _api.login(email, password);
      await refreshTasks();
    } catch (error) {
      _error = error.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refreshTasks() async {
    if (_user == null) return;
    _tasks..clear()..addAll(await _api.tasks());
    notifyListeners();
  }

  Future<void> createTaskFromVoice(String text) async {
    if (_user == null) return;
    _loading = true;
    notifyListeners();
    try {
      await _api.createTask(title: text, transcription: text);
      await refreshTasks();
    } catch (error) {
      _error = error.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> toggleTask(SayDoneTask task) async {
    final newStatus = task.isCompleted ? 'pending' : 'completed';
    await _api.updateTask(task.id, status: newStatus);
    await refreshTasks();
  }
}
