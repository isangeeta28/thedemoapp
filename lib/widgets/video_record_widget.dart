import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../blocs/questionnear/questionnear_bloc.dart';

class VideoRecorderWidget extends StatefulWidget {
  const VideoRecorderWidget({super.key});

  @override
  State<VideoRecorderWidget> createState() => _VideoRecorderWidgetState();
}

class _VideoRecorderWidgetState extends State<VideoRecorderWidget> {
  CameraController? _controller;
  bool _isRecording = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      if (await Permission.camera.request().isGranted &&
          await Permission.microphone.request().isGranted) {
        final cameras = await availableCameras();
        if (cameras.isEmpty) return;

        _controller = CameraController(
          cameras.first,
          ResolutionPreset.high,
          enableAudio: true,
        );

        await _controller!.initialize();

        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      await _controller!.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      print('Error starting video recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (_controller == null || !_controller!.value.isRecordingVideo) return;

    try {
      final file = await _controller!.stopVideoRecording();

      if (mounted) {
        context.read<QuestionnaireBloc>().add(SetVideoPath(file.path));
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error stopping video recording: $e');
    }
  }

  Future<void> _cancelRecording() async {
    if (_isRecording) {
      await _controller?.stopVideoRecording();
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: _isInitialized && _controller != null
                ? Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CameraPreview(_controller!),
                ),
                if (_isRecording)
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.fiber_manual_record,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Recording',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isRecording)
                        IconButton(
                          onPressed: _cancelRecording,
                          icon: const Icon(Icons.close, size: 32),
                          color: Colors.red,
                        ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _isRecording ? _stopRecording : _startRecording,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isRecording ? Colors.green : Colors.red,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(24),
                        ),
                        child: Icon(
                          _isRecording ? Icons.stop : Icons.videocam,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
                : const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}