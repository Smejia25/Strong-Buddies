import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:strong_buddies_connect/register/pages/newRegister/bloc/register_bloc.dart';
import 'package:strong_buddies_connect/register/pages/newRegister/models/registration_user.dart';
import 'package:strong_buddies_connect/register/pages/newRegister/register_page.dart';
import 'package:strong_buddies_connect/shared/components/primary_button.dart';
import 'package:strong_buddies_connect/shared/utils/form_util.dart';

class UserForm extends StatefulWidget {
  final VoidCallback onLogOut;
  final RegistrationUser user;
  final bool isEditingExistingProfile;
  final GlobalKey<FormState> formKeyState;
  const UserForm({
    Key key,
    this.user,
    this.isEditingExistingProfile,
    this.onLogOut,
    this.formKeyState,
  }) : super(key: key);

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  bool isUserValid() {
    final user = widget.user;
    return user.name != null &&
        user.email != null &&
        // user.preferTimeWorkout != null &&
        user.gender != null &&
        // user.gymMemberShip != null &&
        user.targetGender != null &&
        // user.workoutTypes != null &&
        user.displayName != null &&
        user.uploadedPictures != null;
  }

  bool isUserValidForEdit() {
    final user = widget.user;
    return user.name != null &&
        user.email != null &&
        user.gender != null &&
        user.targetGender != null &&
        user.displayName != null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtil().setHeight(22),
        horizontal: ScreenUtil().setWidth(16),
      ),
      child: Form(
        key: widget.formKeyState,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RegisterInputForm(
              keyboardType: TextInputType.emailAddress,
              initialValue: widget.user.email,
              hint: 'We need your email to contact you',
              label: 'Email',
              validator: (String value) {
                if (value.isEmpty)
                  return 'Please, enter your email';
                else if (!FormUtil.isEmailValid(value))
                  return 'Please, enter a valid email';
                return null;
              },
              onSaved: (val) => widget.user.email = val,
            ),
            RegisterInputForm(
              initialValue: widget.user.name,
              hint: 'We need your name',
              label: 'Name',
              validator: (String value) =>
                  value.isEmpty ? 'Please, enter your name' : null,
              onSaved: (val) => widget.user.name = val,
            ),
            RegisterInputForm(
              initialValue: widget.user.displayName,
              hint: 'This is the name other people gonna watch',
              label: 'Username',
              validator: (String value) =>
                  value.isEmpty ? 'Please, enter your nickname' : null,
              onSaved: (val) => widget.user.displayName = val,
            ),
            RegisterInputForm(
              initialValue: widget.user.aboutMe,
              hint: 'Tell us about yourself',
              label: 'About you (Optional)',
              isMultiline: true,
              onSaved: (val) => widget.user.aboutMe = val,
            ),
            RegisterSelectForm(
              hint: 'Let us know your gender',
              previouslySelected:
                  widget.user.gender != null ? [widget.user.gender] : [],
              onChange: (List<String> selectedOptions) {
                try {
                  widget.user.gender = selectedOptions.first;
                } catch (e) {
                  widget.user.gender = null;
                }
              },
              label: 'What is your gender?',
              options: ['Woman', 'Man', 'Other'],
            ),
            RegisterSelectForm(
              hint: 'What genders are you looking for?',
              previouslySelected: widget.user.targetGender,
              allowMultipleSelect: true,
              onChange: (List<String> selectedOptions) {
                widget.user.targetGender =
                    selectedOptions.length == 0 ? null : selectedOptions;
              },
              label: 'Workout Buddy Gender Preference',
              options: ['Women', 'Man', 'Others'],
            ),
            RegisterSelectForm(
              allowMultipleSelect: true,
              previouslySelected: widget.user.preferTimeWorkout,
              onChange: (List<String> selectedOptions) {
                widget.user.preferTimeWorkout =
                    selectedOptions.length == 0 ? null : selectedOptions;
              },
              label: 'What is your favorite workout time? (Optional)',
              options: ['Morning', 'Midday', 'Night'],
            ),
            RegisterSelectForm(
              previouslySelected: widget.user.gymMemberShip != null
                  ? [widget.user.gymMemberShip]
                  : [],
              onChange: (List<String> selectedOptions) {
                try {
                  widget.user.gymMemberShip = selectedOptions.first;
                } catch (e) {
                  widget.user.gymMemberShip = null;
                }
              },
              label: 'Do you have a gym membership? (Optional)',
              options: ['Yes', 'No'],
            ),
            RegisterSelectForm(
              allowMultipleSelect: true,
              previouslySelected: widget.user.workoutTypes,
              onChange: (List<String> selectedOptions) {
                widget.user.workoutTypes =
                    selectedOptions.length == 0 ? null : selectedOptions;
              },
              label: "What kind of workout you're interested on? (Optional)",
              options: [
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
                "Rowing",
                "Sprint Lifting"
              ],
            ),
            if (!widget.isEditingExistingProfile)
              PrimaryButton.text(
                  text: 'Register',
                  onTap: () {
                    if (!widget.formKeyState.currentState.validate()) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'All the fields are not filled, please fill them all and select the pictures')));
                      return;
                    }
                    widget.formKeyState.currentState.save();
                    if (!isUserValid())
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'All the fields are not filled, please fill them all and select the pictures')));
                    else {
                      final bloc = BlocProvider.of<RegisterBloc>(context);
                      bloc.add(CreateUser(widget.user));
                    }
                  })
          ],
        ),
      ),
    );
  }
}
