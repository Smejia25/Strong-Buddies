part of 'chatlist_bloc.dart';

abstract class ChatlistState extends Equatable {
  const ChatlistState();

  @override
  List<Object> get props => [];
}

class ChatlistLoading extends ChatlistState {}

class ChatlistLoaded extends ChatlistState {
  final List<Match> matches;
  final List<Match> filteredMatches;

  const ChatlistLoaded(this.matches, this.filteredMatches);

  @override
  List<Object> get props => [matches, filteredMatches];

  @override
  String toString() {
    return 'FilteredTodosLoaded { filteredTodos: $matches }';
  }
}
