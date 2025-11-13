import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// ============ EVENTS ============
abstract class QuestionnaireEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateAnswer extends QuestionnaireEvent {
  final String answer;
  UpdateAnswer(this.answer);
  @override
  List<Object?> get props => [answer];
}

class SetAudioPath extends QuestionnaireEvent {
  final String? path;
  SetAudioPath(this.path);
  @override
  List<Object?> get props => [path];
}

class SetVideoPath extends QuestionnaireEvent {
  final String? path;
  SetVideoPath(this.path);
  @override
  List<Object?> get props => [path];
}

class StartRecording extends QuestionnaireEvent {
  final bool isAudio;
  StartRecording(this.isAudio);
  @override
  List<Object?> get props => [isAudio];
}

class StopRecording extends QuestionnaireEvent {}

class CancelRecording extends QuestionnaireEvent {}

// ============ STATE ============
class QuestionnaireState extends Equatable {
  final String answer;
  final String? audioPath;
  final String? videoPath;
  final bool isRecording;
  final bool isAudioRecording;

  const QuestionnaireState({
    this.answer = '',
    this.audioPath,
    this.videoPath,
    this.isRecording = false,
    this.isAudioRecording = false,
  });

  QuestionnaireState copyWith({
    String? answer,
    String? audioPath,
    String? videoPath,
    bool? isRecording,
    bool? isAudioRecording,
  }) {
    return QuestionnaireState(
      answer: answer ?? this.answer,
      audioPath: audioPath,
      videoPath: videoPath,
      isRecording: isRecording ?? this.isRecording,
      isAudioRecording: isAudioRecording ?? this.isAudioRecording,
    );
  }

  @override
  List<Object?> get props => [answer, audioPath, videoPath, isRecording, isAudioRecording];
}

// ============ BLOC ============
class QuestionnaireBloc extends Bloc<QuestionnaireEvent, QuestionnaireState> {
  QuestionnaireBloc() : super(const QuestionnaireState()) {
    on<UpdateAnswer>(_onUpdateAnswer);
    on<SetAudioPath>(_onSetAudioPath);
    on<SetVideoPath>(_onSetVideoPath);
    on<StartRecording>(_onStartRecording);
    on<StopRecording>(_onStopRecording);
    on<CancelRecording>(_onCancelRecording);
  }

  void _onUpdateAnswer(UpdateAnswer event, Emitter<QuestionnaireState> emit) {
    emit(state.copyWith(answer: event.answer));
  }

  void _onSetAudioPath(SetAudioPath event, Emitter<QuestionnaireState> emit) {
    emit(state.copyWith(audioPath: event.path));
  }

  void _onSetVideoPath(SetVideoPath event, Emitter<QuestionnaireState> emit) {
    emit(state.copyWith(videoPath: event.path));
  }

  void _onStartRecording(StartRecording event, Emitter<QuestionnaireState> emit) {
    emit(state.copyWith(
      isRecording: true,
      isAudioRecording: event.isAudio,
    ));
  }

  void _onStopRecording(StopRecording event, Emitter<QuestionnaireState> emit) {
    emit(state.copyWith(isRecording: false, isAudioRecording: false));
  }

  void _onCancelRecording(CancelRecording event, Emitter<QuestionnaireState> emit) {
    emit(state.copyWith(isRecording: false, isAudioRecording: false));
  }
}