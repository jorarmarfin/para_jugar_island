import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../controllers/soundboard_controller.dart';
import '../widgets/sound_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.controller});

  final SoundboardController? controller;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late final SoundboardController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? SoundboardController();
    WidgetsBinding.instance.addObserver(this);
    WakelockPlus.enable().catchError((_) {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      _controller.stopAll();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable().catchError((_) {});
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🏝️ PARA JUGAR ISLAND',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            final sounds = _controller.sounds;
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.95,
                    ),
                    itemCount: sounds.length,
                    itemBuilder: (context, i) {
                      final s = sounds[i];
                      return SoundButton(
                        sound: s,
                        isPlaying: _controller.isPlaying(s.id),
                        volume: _controller.volume(s.id),
                        onToggle: () => _controller.toggle(s),
                        onVolumeChanged: (v) => _controller.setVolume(s.id, v),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: FilledButton.icon(
                      key: const Key('stop_all'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFF1744),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: _controller.stopAll,
                      icon: const Icon(Icons.stop_circle, size: 30),
                      label: const Text(
                        'PARAR TODO',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
