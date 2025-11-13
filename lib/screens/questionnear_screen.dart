import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/questionnear/questionnear_bloc.dart';
import '../widgets/audio_record_widget.dart';
import '../widgets/video_record_widget.dart';
import '../widgets/audio_player_widget.dart';
import '../widgets/video_player_widget.dart';
import '../widgets/progress_indicator_widget.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: ProgressIndicatorWidget(
            currentStep: 1,
            totalSteps: 5,
          ),
        ),
      ),
      body: BlocBuilder<QuestionnaireBloc, QuestionnaireState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Why do you want to host with us?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tell us about your intent and what motivates you to create experiences.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(state),
                      if (state.audioPath != null)
                        AudioPlayerWidget(
                          audioPath: state.audioPath!,
                          onDelete: () {
                            context.read<QuestionnaireBloc>().add(SetAudioPath(null));
                          },
                        ),
                      if (state.videoPath != null)
                        VideoPlayerWidget(
                          videoPath: state.videoPath!,
                          onDelete: () {
                            context.read<QuestionnaireBloc>().add(SetVideoPath(null));
                          },
                        ),
                    ],
                  ),
                ),
              ),
              _buildBottomControls(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextField(QuestionnaireState state) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _controller,
        maxLength: 600,
        maxLines: 6,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: '/ Start typing here',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          counterStyle: TextStyle(color: Colors.grey),
        ),
        onChanged: (value) {
          context.read<QuestionnaireBloc>().add(UpdateAnswer(value));
        },
      ),
    );
  }

  Widget _buildBottomControls(QuestionnaireState state) {
    final showAudioButton = state.audioPath == null;
    final showVideoButton = state.videoPath == null;
    final showBothButtons = showAudioButton && showVideoButton;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showBothButtons)
            Row(
              children: [
                Expanded(
                  child: _buildIconButton(
                    icon: Icons.mic,
                    label: 'Audio',
                    onPressed: () => _showAudioRecorder(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildIconButton(
                    icon: Icons.videocam,
                    label: 'Video',
                    onPressed: () => _showVideoRecorder(context),
                  ),
                ),
              ],
            ),
          if (!showBothButtons && (showAudioButton || showVideoButton))
            _buildIconButton(
              icon: showAudioButton ? Icons.mic : Icons.videocam,
              label: showAudioButton ? 'Audio' : 'Video',
              onPressed: () => showAudioButton
                  ? _showAudioRecorder(context)
                  : _showVideoRecorder(context),
            ),
          const SizedBox(height: 12),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                print('Answer: ${state.answer}');
                print('Audio: ${state.audioPath}');
                print('Video: ${state.videoPath}');

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Response submitted! Check console for details.'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }

  void _showAudioRecorder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: context.read<QuestionnaireBloc>(),
        child: const AudioRecorderWidget(),
      ),
    );
  }

  void _showVideoRecorder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: context.read<QuestionnaireBloc>(),
        child: const VideoRecorderWidget(),
      ),
    );
  }
}