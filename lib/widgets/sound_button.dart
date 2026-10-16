import 'package:flutter/material.dart';

import '../data/sounds.dart';

class SoundButton extends StatelessWidget {
  const SoundButton({
    super.key,
    required this.sound,
    required this.isPlaying,
    required this.volume,
    required this.onToggle,
    required this.onVolumeChanged,
  });

  final SoundItem sound;
  final bool isPlaying;
  final double volume;
  final VoidCallback onToggle;
  final ValueChanged<double> onVolumeChanged;

  @override
  Widget build(BuildContext context) {
    final color = sound.color;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: isPlaying ? color : color.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isPlaying ? Colors.white : Colors.transparent,
          width: 5,
        ),
        boxShadow: isPlaying
            ? [BoxShadow(color: color, blurRadius: 24, spreadRadius: 2)]
            : const [],
      ),
      child: Column(
        children: [
          Expanded(
            child: InkWell(
              key: Key('sound_${sound.id}'),
              borderRadius: BorderRadius.circular(24),
              onTap: onToggle,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedScale(
                      scale: isPlaying ? 1.2 : 1.0,
                      duration: const Duration(milliseconds: 180),
                      child: Text(sound.emoji, style: const TextStyle(fontSize: 52)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      sound.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                      ),
                    ),
                    Text(
                      isPlaying ? 'SONANDO · toca para parar' : 'toca para sonar',
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 10),
              const Icon(Icons.volume_up, color: Colors.white, size: 18),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.white38,
                    thumbColor: Colors.white,
                  ),
                  child: Slider(
                    key: Key('volume_${sound.id}'),
                    value: volume,
                    onChanged: onVolumeChanged,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
