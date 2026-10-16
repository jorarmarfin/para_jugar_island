import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../data/sounds.dart';

class SoundboardController extends ChangeNotifier {
  SoundboardController({List<SoundItem> sounds = kSounds, bool preload = true})
      : sounds = List.unmodifiable(sounds) {
    for (final s in this.sounds) {
      _playing[s.id] = false;
      _volume[s.id] = 1.0;
      _players[s.id] = AudioPlayer(playerId: s.id)
        ..setReleaseMode(ReleaseMode.loop);
    }
    if (preload) {
      for (final s in this.sounds) {
        _players[s.id]!.setSource(AssetSource(s.sourcePath)).catchError((_) {});
      }
    }
  }

  final List<SoundItem> sounds;
  final Map<String, AudioPlayer> _players = {};
  final Map<String, bool> _playing = {};
  final Map<String, double> _volume = {};

  bool isPlaying(String id) => _playing[id] ?? false;
  double volume(String id) => _volume[id] ?? 1.0;
  int get activeCount => _playing.values.where((p) => p).length;

  Future<void> toggle(SoundItem s) async {
    if (isPlaying(s.id)) {
      await _stop(s.id);
    } else {
      await _start(s);
    }
    notifyListeners();
  }

  Future<void> _start(SoundItem s) async {
    final p = _players[s.id]!;
    _playing[s.id] = true;
    try {
      await p.setVolume(volume(s.id));
      await p.play(AssetSource(s.sourcePath));
    } catch (_) {
      _playing[s.id] = false;
    }
  }

  Future<void> _stop(String id) async {
    _playing[id] = false;
    try {
      await _players[id]!.stop();
    } catch (_) {}
  }

  Future<void> setVolume(String id, double value) async {
    _volume[id] = value.clamp(0.0, 1.0);
    notifyListeners();
    try {
      await _players[id]!.setVolume(_volume[id]!);
    } catch (_) {}
  }

  Future<void> stopAll() async {
    await Future.wait(sounds.map((s) => _stop(s.id)));
    notifyListeners();
  }

  @override
  void dispose() {
    for (final p in _players.values) {
      p.dispose();
    }
    super.dispose();
  }
}
