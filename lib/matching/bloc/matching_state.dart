part of 'matching_bloc.dart';

abstract class MatchingState extends Equatable {
  const MatchingState();
}

class MatchingInitial extends MatchingState {
  @override
  List<Object> get props => [];
}

class BuddyLoaded extends MatchingState {
  final Buddy buddy;
  final CurrentUser currentUser;

  const BuddyLoaded(this.buddy, this.currentUser);

  @override
  List<Object> get props => [buddy];
}

class OutOfBuddies extends MatchingState {
  @override
  List<Object> get props => [];
}

class Loading extends MatchingState {
  @override
  List<Object> get props => [];
}

class MatchHappened extends MatchingState {
  final MatchedBuddy buddy;

  const MatchHappened(this.buddy);
  
  @override
  List<Object> get props => [buddy];
}
