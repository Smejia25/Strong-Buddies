import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:strong_buddies_connect/matching/models/matched_buddy_pojo.dart';
import 'package:strong_buddies_connect/shared/models/buddy_pojo.dart';
import 'package:strong_buddies_connect/shared/models/current_user_pojo.dart';

import 'package:strong_buddies_connect/shared/services/auth/auth_service.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';

part 'matching_event.dart';
part 'matching_state.dart';

class MatchingBloc extends Bloc<MatchingEvent, MatchingState> {
  CurrentUser currentUser;
  List<Buddy> _buddies = [];
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
        currentUser = await userCollection
            .getCurrentUserInfo((await auth.getCurrentUser()).uid);

        final analyzedBuddies = await userCollection
            .getAlreadyAnalizedBuddies((await auth.getCurrentUser()).uid);

        _buddies = (await userCollection.getBuddies())
            .where((buddy) =>
                buddy.id != currentUser.id &&
                analyzedBuddies.indexOf(buddy.id) == -1)
            .toList();

        if (_buddies.length == 0)
          yield OutOfBuddies();
        else
          yield BuddyLoaded(_buddies[_init], currentUser);
      } catch (e) {
        print(e);
      }
    } else {
      if (event is MatchWithBuddy)
        await userCollection.setBuddyInTheRejectionList(
            currentUser.id, _buddies[_init].id, true);
      else
        await userCollection.setBuddyInTheRejectionList(
            currentUser.id, _buddies[_init].id, false);

      _init++;
      if (_init >= _buddies.length)
        yield OutOfBuddies();
      else
        yield BuddyLoaded(_buddies[_init], currentUser);
    }
  }
}
