import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:strong_buddies_connect/register/pages/register/models/user_pojo.dart';
import 'package:strong_buddies_connect/shared/services/auth_service.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';

part 'matching_event.dart';
part 'matching_state.dart';

class MatchingBloc extends Bloc<MatchingEvent, MatchingState> {
  User currentUser;
  List<User> _buddies = [];
  int _init = 0;
  final UserCollection userCollection;
  final AuthService auth;

  MatchingBloc(this.userCollection, this.auth);

  @override
  MatchingState get initialState => MatchingInitial();

  @override
  Stream<MatchingState> mapEventToState(
    MatchingEvent event,
  ) async* {
    if (event is RequestBuddies) {
      yield Loading();
      try {
        currentUser =
            await userCollection.getUser((await auth.getCurrentUser()).email);
        _buddies = (await userCollection.getBuddies()).where((buddy) =>
            buddy.email != currentUser.email &&
            !currentUser.matches.any((match) => match == buddy.email)).toList();
        if (_buddies.length == 0)
          yield OutOfBuddies();
        else
          yield BuddyLoaded(_buddies[_init], currentUser);
      } catch (e) {
        print(e);
      }
    } else {
      await userCollection.setBuddyInTheRejectionList(
          currentUser, _buddies[_init].email);

      _init++;
      if (_init >= _buddies.length)
        yield OutOfBuddies();
      else
        yield BuddyLoaded(_buddies[_init], currentUser);
    }
  }
}
