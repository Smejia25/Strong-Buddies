import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:strong_buddies_connect/routes.dart';
import 'package:flutter/material.dart';
import 'package:validate/validate.dart';
import 'bloc/registerbloc_bloc.dart';
import 'model/register_user.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final user = RegisterUser();
  final _bloc = RegisterBloc();
  ProgressDialog _pr;

  final workoutTimes = ['Morning', 'Midday', 'Night'];
  final gender = ['Female', 'Male', 'Other'];
  final targetGender = ['Female', 'Male', 'Other', 'Any'];
  final gymMember = ['Yes', 'No'];
  final workoutType = [
    "Running",
    "Free Weights",
    "Powerlifting",
    "Bodybuilding",
    "Swimming",
    "Tennis",
    "Soccer",
    "Basketball",
    "Crossfit",
    "Golf",
    "Gymnastics",
    "Football",
    "Circuit Training",
    "Indoor Cardio",
    "Yoga",
    "Martial Arts",
    "Brazilian Jiu-Jitsu",
    "Outdoor Events",
    "Hiking",
    "Outdoor Biking",
    "Spin Class",
    "Rowing"
  ];

  @override
  Widget build(BuildContext context) {
    _pr = _pr == null ? ProgressDialog(context) : _pr;
    return Scaffold(
      body: BlocListener<RegisterBloc, RegisterblocState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is UserCreated) {
            if (_pr != null && _pr.isShowing()) {
              _pr.dismiss();
            }
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.picturePage, (_) => false);
          } else if (state is RegisterWithError) {
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('The email is already beeing used')));
          } else if (state is RegisterInProcess && _pr != null) {
            _pr.show();
          }
        },
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            height: double.infinity,
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      TextFormField(
                        onSaved: (val) => user.email = val,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (String value) {
                          if (value.isEmpty)
                            return 'Please, enter a valid email';
                          try {
                            Validate.isEmail(value);
                          } catch (e) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _passController,
                        onSaved: (val) => user.password = val,
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'Password'),
                        validator: (String value) {
                          if (value.isEmpty)
                            return 'Please, enter your password';
                          else if (value.length < 6)
                            return 'The password is too short';
                          return null;
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        validator: (String value) {
                          if (value.isEmpty)
                            return 'Please, enter your password';
                          else if (_passController.text != value)
                            return 'The passwords do not match';
                          return null;
                        },
                      ),
                      TextFormField(
                        onSaved: (val) => user.firstName = val,
                        decoration: InputDecoration(labelText: 'First Name'),
                        validator: (String value) {
                          if (value.isEmpty)
                            return 'Please, enter your first name';
                          return null;
                        },
                      ),
                      TextFormField(
                        onSaved: (val) => user.lastName = val,
                        decoration: InputDecoration(labelText: 'Last Name'),
                        validator: (String value) {
                          if (value.isEmpty)
                            return 'Please, enter your last name';
                          return null;
                        },
                      ),
                      DropdownButton<String>(
                        items: workoutTimes.map((workoutTime) {
                          return DropdownMenuItem<String>(
                            child: Text(workoutTime),
                            value: workoutTime,
                          );
                        }).toList(),
                        hint: Text('Workout time'),
                        onChanged: (String val) {
                          setState(() {
                            user.preferTimeToWorkout = val;
                          });
                        },
                        value: user.preferTimeToWorkout,
                      ),
                      DropdownButton<String>(
                        items: gender.map((gender) {
                          return DropdownMenuItem<String>(
                            child: Text(gender),
                            value: gender,
                          );
                        }).toList(),
                        hint: Text('Gender'),
                        onChanged: (String val) {
                          setState(() {
                            user.gender = val;
                          });
                        },
                        value: user.gender,
                      ),
                      DropdownButton<String>(
                        items: targetGender.map((gender) {
                          return DropdownMenuItem<String>(
                            child: Text(gender),
                            value: gender,
                          );
                        }).toList(),
                        hint: Text('What Gender are you looking for?'),
                        onChanged: (String val) {
                          setState(() {
                            user.targetGender = val;
                          });
                        },
                        value: user.targetGender,
                      ),
                      Container(
                        height: 300,
                        child: ListView.builder(
                          itemCount: workoutType.length,
                          itemBuilder: (BuildContext context, int index) {
                            final workType = workoutType[index];
                            return Row(
                              children: <Widget>[
                                Text(workType),
                                WorkoutType(
                                  onChanged: (val) {
                                    if (val)
                                      user.workoutType.add(workType);
                                    else
                                      user.workoutType.remove(workType);
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RaisedButton(
                            color: Theme.of(context).accentColor,
                            textColor: Theme.of(context).primaryColor,
                            onPressed: () async {
                              if (!_formKey.currentState.validate()) return;
                              _formKey.currentState.save();
                              _bloc.add(CreateUserEvent(user));
                            },
                            child: Text('Register'),
                          ),
                          RaisedButton(
                            color: Theme.of(context).accentColor,
                            textColor: Theme.of(context).primaryColor,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WorkoutType extends StatefulWidget {
  final Function(bool val) onChanged;
  const WorkoutType({
    Key key,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _WorkoutTypeState createState() => _WorkoutTypeState();
}

class _WorkoutTypeState extends State<WorkoutType> {
  bool isOn = false;
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isOn,
      onChanged: (bool val) {
        setState(() {
          isOn = !isOn;
        });
        widget.onChanged(isOn);
      },
    );
  }
}
