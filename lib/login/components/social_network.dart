import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strong_buddies_connect/login/bloc/login_bloc.dart';
import 'package:strong_buddies_connect/shared/utils/form_util.dart';

class SocialNetworkLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LoginBloc bloc = BlocProvider.of<LoginBloc>(context);
    return BlocBuilder(
      bloc: bloc,
      builder: (context, state) {
        final isThereAnotherLoginInProcess = (state is PerformingLoading);
        return Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                  color: Theme.of(context).accentColor,
                  textColor: Theme.of(context).primaryColor,
                  onPressed: FormUtil.getFunctionDependingOnEnableState(
                      isThereAnotherLoginInProcess,
                      () => bloc.add(PerformLoginWithGoogle())),
                  child: const Text('Google')),
            ),
            SizedBox(width: 12),
            Expanded(
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                textColor: Theme.of(context).primaryColor,
                onPressed: FormUtil.getFunctionDependingOnEnableState(
                    isThereAnotherLoginInProcess,
                    () => bloc.add(PerformLoginWithFacebook())),
                child: const Text('Facebook'),
              ),
            ),
          ],
        );
      },
    );
  }
}
