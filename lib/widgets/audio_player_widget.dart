import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;
  final VoidCallback onDelete;

  const AudioPlayerWidget({
    super.key,
    required this.audioPath,
    required this.onDelete,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      await _audioPlayer.setSourceDeviceFile(widget.audioPath);
      
      // Try to get duration immediately to avoid slider errors
      try {
        final duration = await _audioPlayer.getDuration();
        if (duration != null && duration.inSeconds > 0 && mounted) {
          setState(() {
            _duration = duration;
          });
        }
      } catch (e) {
        print('Could not get initial duration: $e');
      }

      _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
        if (mounted && duration.inSeconds > 0) {
          setState(() {
            _duration = duration;
          });
        }
      });

      _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
        if (mounted) {
          setState(() {
            // Clamp position to not exceed duration
            if (_duration.inSeconds > 0 && position.inSeconds > _duration.inSeconds) {
              _position = _duration;
            } else {
              _position = position;
            }
          });
        }
      });

      _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state == PlayerState.playing;
          });
        }
      });
    } catch (e) {
      print('Error initializing audio player: $e');
    }
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _togglePlayPause,
                icon: Icon(
                  _isPlaying ? Icons.pause_circle : Icons.play_circle,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Audio Recorded',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: widget.onDelete,
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Builder(
            builder: (context) {
              // Calculate safe slider values
              final durationSeconds = _duration.inSeconds.toDouble();
              final positionSeconds = _position.inSeconds.toDouble();
              
              // Ensure max is at least 1.0 to avoid assertion errors
              final maxValue = durationSeconds > 0 ? durationSeconds : 1.0;
              
              // Clamp value to be within valid range [0, maxValue]
              final clampedValue = positionSeconds.clamp(0.0, maxValue);
              
              // Only enable slider if duration is known
              final isDurationKnown = durationSeconds > 0;
              
              return SliderTheme(
                data: SliderThemeData(
                  trackHeight: 2,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                ),
                child: Slider(
                  value: clampedValue,
                  min: 0.0,
                  max: maxValue,
                  onChanged: isDurationKnown
                      ? (value) async {
                          try {
                            await _audioPlayer.seek(Duration(seconds: value.toInt()));
                          } catch (e) {
                            print('Error seeking: $e');
                          }
                        }
                      : null,
                  activeColor: Colors.blue,
                  inactiveColor: Colors.grey[800],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}