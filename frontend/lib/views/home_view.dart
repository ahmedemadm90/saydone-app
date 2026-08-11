import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final user = provider.user;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white, surfaceTintColor: Colors.white,
        title: const Text('SayDone', style: TextStyle(fontWeight: FontWeight.w900)),
        actions: [IconButton(onPressed: provider.refreshTasks, icon: const Icon(Icons.refresh_rounded))],
      ),
      body: Column(children: [
        if (user != null) _UsageHeader(user: user),
        Expanded(child: provider.loading && provider.tasks.isEmpty ? const Center(child: CircularProgressIndicator()) : _TaskList(provider: provider)),
      ]),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => _showVoiceSheet(context),
        backgroundColor: const Color(0xFF5865F2),
        child: const Icon(Icons.mic_rounded, color: Colors.white, size: 36),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showVoiceSheet(BuildContext context) {
    showModalBottomSheet(context: context, builder: (context) => const _VoiceSheet());
  }
}

class _UsageHeader extends StatelessWidget {
  const _UsageHeader({required this.user});
  final dynamic user;
  @override
  Widget build(BuildContext context) => Container(color: Colors.white, padding: const EdgeInsets.fromLTRB(20, 10, 20, 20), child: Row(children: [
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Hello, ${user.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      const Text('Free plan • 5 tasks/day', style: TextStyle(fontSize: 12, color: Colors.black54)),
    ]),
    const Spacer(),
    CircularProgressIndicator(value: user.isAdmin ? 0 : user.dailyCount / 5, strokeWidth: 6, backgroundColor: Colors.black12, color: const Color(0xFF5865F2)),
  ]));
}

class _TaskList extends StatelessWidget {
  const _TaskList({required this.provider});
  final AppProvider provider;
  @override
  Widget build(BuildContext context) {
    if (provider.tasks.isEmpty) return const Center(child: Text('No tasks yet. Tap the mic to record.'));
    return ListView.builder(padding: const EdgeInsets.all(16), itemCount: provider.tasks.length, itemBuilder: (context, i) {
      final task = provider.tasks[i];
      return Card(elevation: 0, margin: const EdgeInsets.only(bottom: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.black12)), child: ListTile(
        leading: Checkbox(value: task.isCompleted, onChanged: (_) => provider.toggleTask(task)),
        title: Text(task.title, style: TextStyle(fontWeight: FontWeight.w700, decoration: task.isCompleted ? TextDecoration.lineThrough : null)),
        subtitle: task.transcription != null ? Text(task.transcription!, maxLines: 1, overflow: TextOverflow.ellipsis) : null,
      ));
    });
  }
}

class _VoiceSheet extends StatefulWidget {
  const _VoiceSheet();
  @override
  State<_VoiceSheet> createState() => _VoiceSheetState();
}

class _VoiceSheetState extends State<_VoiceSheet> {
  bool _recording = false;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(40), width: double.infinity, child: Column(mainAxisSize: MainAxisSize.min, children: [
    const Text('Listening...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
    const SizedBox(height: 20),
    GestureDetector(
      onTap: () => setState(() => _recording = !_recording),
      child: Container(width: 100, height: 100, decoration: BoxDecoration(color: _recording ? Colors.red : const Color(0xFF5865F2), borderRadius: BorderRadius.circular(50)), child: Icon(_recording ? Icons.stop_rounded : Icons.mic_rounded, color: Colors.white, size: 40)),
    ),
    const SizedBox(height: 20),
    const Text('Say something like: "Remind me to call Ahmed at 5 PM"', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
    const SizedBox(height: 20),
    if (!_recording) TextButton(onPressed: () {
      context.read<AppProvider>().createTaskFromVoice('Call Ahmed at 5 PM');
      Navigator.pop(context);
    }, child: const Text('Simulate AI Recognition')),
  ]));
}
