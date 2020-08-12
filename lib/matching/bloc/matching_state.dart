part of 'matching_bloc.dart';

abstract class MatchingState extends Equatable {
  const MatchingState();
}

class MatchingInitial extends MatchingState {
  @override
  List<Object> get props => [];
}

class BuddyLoaded extends MatchingState {
  final List<Buddy> buddies;
  final CurrentUser currentUser;

  const BuddyLoaded(this.buddies, this.currentUser);

  @override
  List<Object> get props => [buddies];
}

class OutOfBuddies extends MatchingState {
  @override
  List<Object> get props => [];
}

class Loading extends MatchingState {
  @override
  List<Object> get props => [];
}
