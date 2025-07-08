import 'package:equatable/equatable.dart';
import '../models/ot_request.dart';

abstract class OtState extends Equatable {
  const OtState();

  @override
  List<Object> get props => [];
}

class OtInitial extends OtState {}

class OtLoading extends OtState {}

class OtLoaded extends OtState {
  final List<OtRequest> requests;

  const OtLoaded(this.requests);

  @override
  List<Object> get props => [requests];
}

class OtError extends OtState {
  final String message;

  const OtError(this.message);

  @override
  List<Object> get props => [message];
}

class OtSubmitting extends OtState {}

class OtSubmitted extends OtState {
  final String message;

  const OtSubmitted(this.message);

  @override
  List<Object> get props => [message];
}

class OtProcessing extends OtState {}

class OtProcessed extends OtState {
  final String message;

  const OtProcessed(this.message);

  @override
  List<Object> get props => [message];
}
