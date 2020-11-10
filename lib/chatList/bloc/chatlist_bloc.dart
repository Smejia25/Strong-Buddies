import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:strong_buddies_connect/shared/models/match_model.dart';
import 'package:bloc/bloc.dart';
import 'package:strong_buddies_connect/shared/services/auth/auth_service.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';

part 'chatlist_event.dart';
part 'chatlist_state.dart';

class ChatlistBloc extends Bloc<ChatListEvent, ChatlistState> {
  final UserCollection _userRepository;
  StreamSubscription _matchesSubscription;
  final AuthService auth;

  ChatlistBloc(UserCollection userRepository, this.auth)
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  ChatlistState get initialState => ChatlistLoading();

  @override
  Stream<ChatlistState> mapEventToState(
    ChatListEvent event,
  ) async* {
    if (event is UpdateFilter) {
      yield* _mapUpdateFilterToState(event);
    } else if (event is LoadMatches) {
      yield* _mapLoadMatchesToState();
    } else if (event is UpdateMatches) {
      yield* _mapTodosUpdateToState(event);
    }
  }

  Stream<ChatlistState> _mapUpdateFilterToState(
    UpdateFilter event,
  ) async* {
    final currentState = state;
    if (currentState is ChatlistLoaded) {
      yield ChatlistLoaded(
        currentState.matches,
        _mapChatsToFilteredChats(currentState.matches, event.filter),
      );
    }
  }

  Stream<ChatlistState> _mapLoadMatchesToState() async* {
    _matchesSubscription?.cancel();
    final user = await this.auth.getCurrentUser();
    _matchesSubscription = _userRepository.matches(user.uid).listen(
          (matches) => add(UpdateMatches(matches)),
        );
  }

  Stream<ChatlistState> _mapTodosUpdateToState(UpdateMatches event) async* {
    yield ChatlistLoaded(event.matches, event.matches);
  }

  List<Match> _mapChatsToFilteredChats(List<Match> matches, String filter) {
    final newMatches = matches
        .where((match) =>
            match.displayName.toLowerCase().contains(filter.toLowerCase()))
        .toList();
    if (newMatches.length > 0)
      return newMatches;
    else
      return matches;
  }

  @override
  Future<void> close() {
    _matchesSubscription?.cancel();
    return super.close();
  }
}
