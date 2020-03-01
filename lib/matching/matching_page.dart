import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:strong_buddies_connect/matching/bloc/matching_bloc.dart';

class UserInfoPage extends StatefulWidget {
  UserInfoPage({Key key}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final controller = PageController(initialPage: 1);
  final _bloc = MatchingBloc();
  ProgressDialog _pr;

  @override
  void initState() {
    super.initState();
    _bloc.add(RequestBuddies());
    _bloc.listen((onData) {
      if (onData is Loading && _pr != null) {
        _pr.show();
      }
      if (onData is BuddyLoaded && _pr != null && _pr.isShowing()) {
        _pr.hide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _pr = ProgressDialog(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocBuilder<MatchingBloc, MatchingState>(
              bloc: _bloc,
              builder: (context, state) {
                if (state is BuddyLoaded)
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          "${state.buddy['firstName']} ${state.buddy['lastName']}"),
                      Container(
                        height: 200,
                        child: PageView(
                            controller: controller,
                            children: (state.buddy['pictures'] as List<dynamic>)
                                .map((f) {
                              return Image.network(f);
                            }).toList()),
                      ),
                      Text((state.buddy["workoutType"] as List<dynamic>)
                          .reduce((acum, current) => "$acum, $current"))
                    ],
                  );
                else if (state is OutOfBuddies)
                  return Center(
                      child:
                          Text("We're out of buddies, please try again later"));
                else
                  return Container();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    _bloc.add(RejectBuddy());
                  },
                  child: Text("Reject"),
                ),
                RaisedButton(
                  onPressed: () {
                    _bloc.add(MatchWithBuddy());
                  },
                  child: Text("Match"),
                )
              ],
            )
          ],
        )),
      ),
    );
  }
}
