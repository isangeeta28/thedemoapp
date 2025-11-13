import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../models/experience_model.dart';
import '../../service/api_services.dart';

// ============ EVENTS ============
abstract class ExperienceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadExperiences extends ExperienceEvent {}

class ToggleExperience extends ExperienceEvent {
  final Experience experience;
  ToggleExperience(this.experience);
  @override
  List<Object?> get props => [experience];
}

class UpdateDescription extends ExperienceEvent {
  final String description;
  UpdateDescription(this.description);
  @override
  List<Object?> get props => [description];
}

// ============ STATES ============
abstract class ExperienceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExperienceInitial extends ExperienceState {}

class ExperienceLoading extends ExperienceState {}

class ExperienceLoaded extends ExperienceState {
  final List<Experience> experiences;
  final List<int> selectedIds;
  final String description;

  ExperienceLoaded({
    required this.experiences,
    this.selectedIds = const [],
    this.description = '',
  });

  ExperienceLoaded copyWith({
    List<Experience>? experiences,
    List<int>? selectedIds,
    String? description,
  }) {
    return ExperienceLoaded(
      experiences: experiences ?? this.experiences,
      selectedIds: selectedIds ?? this.selectedIds,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [experiences, selectedIds, description];
}

class ExperienceError extends ExperienceState {
  final String message;
  ExperienceError(this.message);
  @override
  List<Object?> get props => [message];
}

// ============ BLOC ============
class ExperienceBloc extends Bloc<ExperienceEvent, ExperienceState> {
  final ApiService apiService;

  ExperienceBloc({required this.apiService}) : super(ExperienceInitial()) {
    on<LoadExperiences>(_onLoadExperiences);
    on<ToggleExperience>(_onToggleExperience);
    on<UpdateDescription>(_onUpdateDescription);
  }

  Future<void> _onLoadExperiences(
      LoadExperiences event,
      Emitter<ExperienceState> emit,
      ) async {
    emit(ExperienceLoading());
    try {
      final experiences = await apiService.getExperiences();
      emit(ExperienceLoaded(experiences: experiences));
    } catch (e) {
      emit(ExperienceError(e.toString()));
    }
  }

  void _onToggleExperience(
      ToggleExperience event,
      Emitter<ExperienceState> emit,
      ) {
    if (state is ExperienceLoaded) {
      final currentState = state as ExperienceLoaded;
      final selectedIds = List<int>.from(currentState.selectedIds);

      if (selectedIds.contains(event.experience.id)) {
        selectedIds.remove(event.experience.id);
      } else {
        selectedIds.add(event.experience.id);
      }

      emit(currentState.copyWith(selectedIds: selectedIds));
    }
  }

  void _onUpdateDescription(
      UpdateDescription event,
      Emitter<ExperienceState> emit,
      ) {
    if (state is ExperienceLoaded) {
      final currentState = state as ExperienceLoaded;
      emit(currentState.copyWith(description: event.description));
    }
  }
}