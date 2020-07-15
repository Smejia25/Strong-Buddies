part of 'chatlist_bloc.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object> get props => [];
}

class UpdateFilter extends ChatListEvent {
  final String filter;

  const UpdateFilter(this.filter);

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'UpdateFilter { filter: $filter }';
}

class LoadMatches extends ChatListEvent {}

class UpdateMatches extends ChatListEvent {
  final List<Match> matches;

  const UpdateMatches(this.matches);

  @override
  List<Object> get props => [matches];

  @override
  String toString() => 'UpdateTodos { todos: $matches }';
}
