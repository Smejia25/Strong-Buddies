import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:strong_buddies_connect/register/user_data/model/register_user.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';

part 'matching_event.dart';
part 'matching_state.dart';

class MatchingBloc extends Bloc<MatchingEvent, MatchingState> {
  List _buddies = [];
  int _init = 0;
  final userCollection = UserCollection();

  @override
  MatchingState get initialState => MatchingInitial();

  @override
  Stream<MatchingState> mapEventToState(
    MatchingEvent event,
  ) async* {
    if (event is RequestBuddies) {
      yield Loading();
      _buddies = (await userCollection.getBuddies())
          .documents
          .map((document) => document.data)
          .toList();
      yield BuddyLoaded(_buddies[_init]);
    }
    if (event is RejectBuddy) {
      _init++;

      if (_init >= _buddies.length)
        yield OutOfBuddies();
      else
        yield BuddyLoaded(_buddies[_init]);
    }
  }
}
