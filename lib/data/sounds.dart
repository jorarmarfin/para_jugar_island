import 'package:flutter/material.dart';

class SoundItem {
  const SoundItem({
    required this.id,
    required this.label,
    required this.emoji,
    required this.color,
  });

  final String id;
  final String label;
  final String emoji;
  final Color color;

  String get assetPath => 'assets/sounds/$id.mp3';

  /// Ruta relativa a `assets/` que espera `AssetSource`.
  String get sourcePath => 'sounds/$id.mp3';
}

const List<SoundItem> kSounds = [
  SoundItem(id: 'shark', label: 'Tiburón', emoji: '🦈', color: Color(0xFF00B4D8)),
  SoundItem(id: 'kayak', label: 'Kayak', emoji: '🛶', color: Color(0xFFFF9F1C)),
  SoundItem(id: 'volcano', label: 'Volcán', emoji: '🌋', color: Color(0xFFFF3B30)),
  SoundItem(id: 'earthquake', label: 'Terremoto', emoji: '💥', color: Color(0xFF8E44AD)),
  SoundItem(id: 'waves', label: 'Olas', emoji: '🌊', color: Color(0xFF1E90FF)),
  SoundItem(id: 'raft', label: 'Balsa', emoji: '🪵', color: Color(0xFF2ECC71)),
  SoundItem(id: 'running', label: 'Corriendo', emoji: '🏃', color: Color(0xFFFFD60A)),
  SoundItem(id: 'screaming', label: 'Gritando', emoji: '😱', color: Color(0xFFFF2D95)),
];
