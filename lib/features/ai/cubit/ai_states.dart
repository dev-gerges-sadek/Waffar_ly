import '../models/ai_result.dart';

sealed class AiState {}

class AiInitial extends AiState {}

class AiLoading extends AiState {}

class AiLoaded extends AiState {
  AiLoaded({
    required this.simulatorResult,
    required this.hardwareResult,
  });

  final AiResult simulatorResult;
  final AiResult hardwareResult;
}

class AiError extends AiState {
  AiError(this.message);
  final String message;
}
