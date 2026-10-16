import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:para_jugar_island/controllers/soundboard_controller.dart';
import 'package:para_jugar_island/data/sounds.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    for (final name in ['xyz.luan/audioplayers', 'xyz.luan/audioplayers.global']) {
      messenger.setMockMethodCallHandler(MethodChannel(name), (_) async => null);
    }
  });

  test('kSounds tiene 8 sonidos con ids y colores únicos', () {
    expect(kSounds.length, 8);
    expect(kSounds.map((s) => s.id).toSet().length, 8);
    expect(kSounds.map((s) => s.color).toSet().length, 8);
  });

  test('setVolume es independiente por sonido y se limita a 0..1', () async {
    final c = SoundboardController(preload: false);
    await c.setVolume('shark', 0.3);
    await c.setVolume('kayak', 7);
    expect(c.volume('shark'), 0.3);
    expect(c.volume('kayak'), 1.0);
    expect(c.volume('waves'), 1.0);
    c.dispose();
  });

  test('stopAll deja todo inactivo', () async {
    final c = SoundboardController(preload: false);
    await c.stopAll();
    expect(c.activeCount, 0);
    c.dispose();
  });
}
