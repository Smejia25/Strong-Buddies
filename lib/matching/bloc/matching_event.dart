part of 'matching_bloc.dart';

abstract class MatchingEvent extends Equatable {
  const MatchingEvent();
}

class RejectBuddy extends MatchingEvent {
  @override
  List<Object> get props => [];
}

class MatchWithBuddy extends MatchingEvent {
  @override
  List<Object> get props => [];
}

class RequestBuddies extends MatchingEvent {
  @override
  List<Object> get props => [];
}
