import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strong_buddies_connect/matching/bloc/matching_bloc.dart';
import 'package:strong_buddies_connect/shared/models/buddy_pojo.dart';
import 'package:strong_buddies_connect/shared/services/auth/auth_service.dart';
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
                        final buddy = state.buddies;
                        return PotentialMatches(
                          bloc: _bloc,
                          buddies: buddy,
                          requestMoreBuddies: () {
                            return [];
                          },
                        );
                      } else if (state is OutOfBuddies) {
                        return Card(
                          child: Stack(
                            children: [
                              Opacity(
                                opacity: 0.3,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white30,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              'assets/images/28954.jpg'))),
                                ),
                              ),
                              Center(
                                child: FractionallySizedBox(
                                  widthFactor: 0.85,
                                  child: Text(
                                    "We're out of buddies. Come back later.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black26,
                                        height: 1.5,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
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

class PotentialMatches extends StatefulWidget {
  const PotentialMatches({
    Key key,
    @required this.buddies,
    @required this.requestMoreBuddies,
    @required this.bloc,
  }) : super(key: key);

  final MatchingBloc bloc;
  final List<Buddy> buddies;
  final List<Buddy> Function() requestMoreBuddies;

  @override
  _PotentialMatchesState createState() => _PotentialMatchesState();
}

class _PotentialMatchesState extends State<PotentialMatches>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation _translateAnimation;
  final swipper = GlobalKey<_SwipeAnimationContainerState>();

  List<Buddy> buddiesToAnalyze;

  @override
  void initState() {
    super.initState();

    buddiesToAnalyze = [...widget.buddies];

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _translateAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _animationController.value = 0;
          buddiesToAnalyze.removeAt(0);
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animationController,
              child: buddiesToAnalyze.length > 3
                  ? MatchCard(
                      onMatch: (_) {},
                      onReject: (_) {},
                      potentialMatch: buddiesToAnalyze[3],
                    )
                  : Container(),
              builder: (_, child) {
                return Transform.translate(
                    offset: Offset(0, -60 + _translateAnimation.value * 20),
                    child: Transform.scale(
                        scale: 0.85 + _translateAnimation.value * 0.05,
                        child: Opacity(
                          child: child,
                          opacity: _translateAnimation.value,
                        )));
              },
            ),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animationController,
              child: buddiesToAnalyze.length > 2
                  ? MatchCard(
                      onMatch: (_) {},
                      onReject: (_) {},
                      potentialMatch: buddiesToAnalyze[2],
                    )
                  : Container(),
              builder: (_, child) {
                return Transform.translate(
                    offset: Offset(0, -40 + _translateAnimation.value * 20),
                    child: Transform.scale(
                        scale: 0.9 + _translateAnimation.value * 0.05,
                        child: child));
              },
            ),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animationController,
              child: buddiesToAnalyze.length > 1
                  ? MatchCard(
                      onMatch: (_) {},
                      onReject: (_) {},
                      potentialMatch: buddiesToAnalyze[1],
                    )
                  : Container(),
              builder: (_, child) {
                return Transform.translate(
                    offset: Offset(0, -20 + _translateAnimation.value * 20),
                    child: Transform.scale(
                        scale: 0.95 + _translateAnimation.value * 0.05,
                        child: child));
              },
            ),
          ),
          SwipeAnimationContainer(
            key: swipper,
            onMatch: () {
              widget.bloc.add(MatchWithBuddy(buddiesToAnalyze[0]));
              _animationController.forward();
            },
            onRejection: () {
              widget.bloc.add(RejectBuddy(buddiesToAnalyze[0]));
              _animationController.forward();
            },
            child: buddiesToAnalyze.length > 0
                ? MatchCard(
                    onMatch: (_) {
                      swipper.currentState.matchBuddy();
                      widget.bloc.add(MatchWithBuddy(buddiesToAnalyze[0]));
                      _animationController.forward();
                    },
                    onReject: (_) {
                      swipper.currentState.rejectBuddy();
                      widget.bloc.add(RejectBuddy(buddiesToAnalyze[0]));
                      _animationController.forward();
                    },
                    potentialMatch: buddiesToAnalyze[0],
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}

class SwipeAnimationContainer extends StatefulWidget {
  SwipeAnimationContainer({Key key, this.child, this.onRejection, this.onMatch})
      : super(key: key);

  final Widget child;
  final VoidCallback onRejection;
  final VoidCallback onMatch;

  @override
  _SwipeAnimationContainerState createState() =>
      _SwipeAnimationContainerState();
}

enum SwipeAnimations { BackToOrigin, Dissmiss }

class _SwipeAnimationContainerState extends State<SwipeAnimationContainer>
    with TickerProviderStateMixin {
  final angle = pi / 6;
  double halfScreen;
  double decisionZone;

  SwipeAnimations animation;

  AnimationController _animationController;
  Animation<double> tweenAnimation;

  Offset dragOffset = Offset(0.0, 0.0);
  double rotationAngle = 0.0;

  Offset auxDragOffset = Offset(0.0, 0.0);
  double auxRotationAngle = 0.0;

  bool animationOnProgress = false;

  int _factor = 1;

  void rejectBuddy() {
    _factor = -1;
    _animationController.forward();
  }

  void matchBuddy() {
    _factor = 1;
    _animationController.forward();
  }

  @override
  void didUpdateWidget(SwipeAnimationContainer oldWidget) {
    if (oldWidget.child != widget.child) {
      _animationController.value = 0;
      dragOffset = Offset(0.0, 0.0);
      rotationAngle = 0.0;
      animationOnProgress = false;
      auxDragOffset = Offset(0.0, 0.0);
      auxRotationAngle = 0.0;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    tweenAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.addStatusListener(handleAnimationStatusChanged);

    tweenAnimation.addListener(() {
      if (animation == SwipeAnimations.BackToOrigin) {
        final percentageOfAnimationInversed = 1 - tweenAnimation.value;
        setState(() {
          rotationAngle = auxRotationAngle * percentageOfAnimationInversed;
          dragOffset = Offset(
            auxDragOffset.dx * percentageOfAnimationInversed,
            auxDragOffset.dy * percentageOfAnimationInversed,
          );
        });
      } else {
        setState(() {
          rotationAngle = auxRotationAngle +
              (angle * _factor - auxRotationAngle) * tweenAnimation.value;
          dragOffset = Offset(
            auxDragOffset.dx +
                (MediaQuery.of(context).size.width * 2 * _factor -
                        auxDragOffset.dx) *
                    tweenAnimation.value,
            auxDragOffset.dy + (20 - auxDragOffset.dy) * tweenAnimation.value,
          );
        });
      }
    });
  }

  void handleAnimationStatusChanged(status) {
    switch (status) {
      case AnimationStatus.completed:
        animationOnProgress = false;
        if (animation == SwipeAnimations.BackToOrigin) handleAnimation();
        break;
      case AnimationStatus.forward:
        animationOnProgress = true;
        break;
      default:
    }
  }

  void handleAnimation() {
    auxDragOffset = Offset(0.0, 0.0);
    auxRotationAngle = 0.0;
    _animationController.value = 0;
    animation = SwipeAnimations.Dissmiss;
  }

  void handlePan(DragUpdateDetails detail) {
    setState(() {
      auxDragOffset = dragOffset = Offset(
          dragOffset.dx + detail.delta.dx, dragOffset.dy + detail.delta.dy);

      auxRotationAngle = rotationAngle = angle * dragOffset.dx / halfScreen;
    });
  }

  @override
  void dispose() {
    tweenAnimation.removeListener(handleAnimation);
    _animationController.removeStatusListener(handleAnimationStatusChanged);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    halfScreen = MediaQuery.of(context).size.width / 2;
    decisionZone = halfScreen / 2;

    return Container(
      child: Stack(
        children: [
          Transform.translate(
            child: Transform.rotate(
              child: widget.child,
              angle: rotationAngle,
              alignment: Alignment.bottomCenter,
            ),
            offset: Offset(dragOffset.dx, dragOffset.dy),
          ),
          Positioned.fill(
            child: IgnorePointer(
              ignoring: animationOnProgress,
              child: GestureDetector(
                onPanEnd: (pan) {
                  animation = SwipeAnimations.Dissmiss;
                  if (dragOffset.dx > decisionZone) {
                    _factor = 1;
                    widget.onMatch();
                  } else if (dragOffset.dx < -decisionZone) {
                    _factor = -1;
                    widget.onRejection();
                  } else {
                    animation = SwipeAnimations.BackToOrigin;
                  }
                  _animationController.forward();
                },
                onPanUpdate: handlePan,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
