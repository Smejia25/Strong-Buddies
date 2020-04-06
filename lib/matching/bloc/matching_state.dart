part of 'matching_bloc.dart';

abstract class MatchingState extends Equatable {
  const MatchingState();
}

class MatchingInitial extends MatchingState {
  @override
  List<Object> get props => [];
}

class BuddyLoaded extends MatchingState {
  final User buddy;
  final User currentUser;

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
