part of 'matching_bloc.dart';

abstract class MatchingState extends Equatable {
  const MatchingState();
}

class MatchingInitial extends MatchingState {
  @override
  List<Object> get props => [];
}

class BuddyLoaded extends MatchingState {
  final Map<String, dynamic> buddy;

  const BuddyLoaded(this.buddy);

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
