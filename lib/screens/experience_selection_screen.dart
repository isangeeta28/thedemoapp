import 'package:demoapp/screens/questionnear_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/experience/experience_bloc.dart';
import '../widgets/experience_card.dart';

class ExperienceSelectionScreen extends StatefulWidget {
  const ExperienceSelectionScreen({super.key});

  @override
  State<ExperienceSelectionScreen> createState() => _ExperienceSelectionScreenState();
}

class _ExperienceSelectionScreenState extends State<ExperienceSelectionScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
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
      ),
      body: BlocBuilder<ExperienceBloc, ExperienceState>(
        builder: (context, state) {
          if (state is ExperienceLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          }

          if (state is ExperienceError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is ExperienceLoaded) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'What kind of hotspots do you want to host?',
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
                        _buildExperienceGrid(state),
                        const SizedBox(height: 24),
                        _buildTextField(state),
                      ],
                    ),
                  ),
                ),
                _buildNextButton(state),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildExperienceGrid(ExperienceLoaded state) {
    final sortedExperiences = List.from(state.experiences);
    sortedExperiences.sort((a, b) {
      final aSelected = state.selectedIds.contains(a.id);
      final bSelected = state.selectedIds.contains(b.id);
      if (aSelected && !bSelected) return -1;
      if (!aSelected && bSelected) return 1;
      return 0;
    });

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: sortedExperiences.length,
      itemBuilder: (context, index) {
        final experience = sortedExperiences[index];
        final isSelected = state.selectedIds.contains(experience.id);

        return ExperienceCard(
          experience: experience,
          isSelected: isSelected,
          onTap: () {
            context.read<ExperienceBloc>().add(ToggleExperience(experience));
          },
        );
      },
    );
  }

  Widget _buildTextField(ExperienceLoaded state) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            maxLength: 250,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: '/ Start typing here',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              counterStyle: TextStyle(color: Colors.grey),
            ),
            onChanged: (value) {
              context.read<ExperienceBloc>().add(UpdateDescription(value));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton(ExperienceLoaded state) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            print('Selected IDs: ${state.selectedIds}');
            print('Description: ${state.description}');

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QuestionnaireScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
    );
  }
}