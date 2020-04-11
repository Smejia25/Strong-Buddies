import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/register/pages/register/models/registration_user.dart';
import 'package:strong_buddies_connect/register/pages/register/utils/update_user_util.dart';
import 'shared/register_card.dart';
import 'shared/register_container_wrapper.dart';
import 'shared/selectable_option.dart';

class RegisterWorkoutType extends StatefulWidget {
  const RegisterWorkoutType({Key key}) : super(key: key);

  @override
  _RegisterWorkoutTypeState createState() => _RegisterWorkoutTypeState();
}

class _RegisterWorkoutTypeState extends State<RegisterWorkoutType> {
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
  final _user = RegistrationUser();
  List<String> selectedWorkTypes = [];

  @override
  void initState() {
    super.initState();
    getCurrentState(context, (currentState) {
      final currentSelectedGenders = currentState.user.workoutTypes;      
      if (currentSelectedGenders != null)
        selectedWorkTypes = currentSelectedGenders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: RegisterContainerWrapper(
        labelForInput: "We need this password to confirm it is you",
        child: Expanded(
          child: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: workoutType.length,
            itemBuilder: (BuildContext context, int i) {
              final value = workoutType[i];
              return Padding(
                padding: const EdgeInsets.all(5),
                child: SelectionCard(
                  initialValue: selectedWorkTypes.indexOf(value) != -1,
                  onPressed: (isSelected) {
                    if (isSelected)
                      selectedWorkTypes.add(value);
                    else
                      selectedWorkTypes.remove(value);

                    _user.workoutTypes = selectedWorkTypes;
                    updateUserInfo(context, _user);
                  },
                  child: RegisterCard(
                    imageAsset: 'assets/images/demo_image.jpg',
                    label: value,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
