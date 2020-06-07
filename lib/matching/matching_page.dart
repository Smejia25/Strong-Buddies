import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:strong_buddies_connect/chatList/chatList.dart';
import 'package:strong_buddies_connect/profile/profile_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strong_buddies_connect/home/home_page.dart';
import 'package:strong_buddies_connect/matching/bloc/matching_bloc.dart';
import 'package:strong_buddies_connect/routes.dart';
import 'package:strong_buddies_connect/shared/models/buddy_pojo.dart';
import 'package:strong_buddies_connect/shared/models/current_user_pojo.dart';
import 'package:strong_buddies_connect/shared/services/auth/auth_service.dart';
import 'package:strong_buddies_connect/shared/services/loader_service.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';
import 'package:shimmer/shimmer.dart';

import 'components/match_card.dart';

class MatchComponent extends StatefulWidget {
  const MatchComponent({
    Key key,
  }) : super(key: key);

  @override
  _MatchComponentState createState() => _MatchComponentState();
}

class _MatchComponentState extends State<MatchComponent> {
  final _bloc = MatchingBloc(UserCollection(), AuthService());

  @override
  void initState() {
    super.initState();
    _bloc.add(RequestBuddies());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffFF8960), Color(0xffFF62A5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomLeft,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setHeight(16),
              horizontal: ScreenUtil().setWidth(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Discover',
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(27),
                      letterSpacing: 0.32,
                    ),
              ),
              SizedBox(height: ScreenUtil().setHeight(19)),
              Expanded(
                child: BlocBuilder<MatchingBloc, MatchingState>(
                    bloc: _bloc,
                    builder: (context, state) {
                      if (state is Loading) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13)),
                          ),
                        );
                      } else if (state is BuddyLoaded) {
                        final buddy = state.buddy;
                        return Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            MatchCard(
                              onMatch: (_) => _bloc.add(MatchWithBuddy()),
                              onReject: (_) => _bloc.add(RejectBuddy()),
                              potentialMatch: buddy,
                            ),
                          ],
                        );
                      } else if (state is OutOfBuddies) {
                        return Card(
                          child: Center(
                            child: Text(
                              "We're out of buddies right now",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(20),
                                letterSpacing: 0.32,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
              ),
              SizedBox(height: ScreenUtil().setHeight(39)),
            ],
          ),
        ),
      ),
    );
  }
}
