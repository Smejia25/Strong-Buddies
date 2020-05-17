import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:strong_buddies_connect/routes.dart';
import 'package:strong_buddies_connect/shared/components/primary_button.dart';
import 'package:strong_buddies_connect/shared/components/tappable_wrapper.dart';
import 'package:strong_buddies_connect/shared/services/auth/auth_service.dart';
import 'package:strong_buddies_connect/shared/services/loader_service.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';
import 'package:strong_buddies_connect/shared/services/user_storage.dart';
import 'package:strong_buddies_connect/shared/utils/form_util.dart';
import 'package:strong_buddies_connect/shared/utils/list_utils.dart';

import 'bloc/register_bloc.dart';
import 'models/registration_user.dart';

class RegisterPageNew extends StatefulWidget {
  RegisterPageNew({Key key}) : super(key: key);

  @override
  _RegisterPageNewState createState() => _RegisterPageNewState();
}

class _RegisterPageNewState extends State<RegisterPageNew> {
  final RegistrationUser _user = RegistrationUser();
  final auth = AuthService();
  Loader _loader;

  @override
  void initState() {
    super.initState();
    _loader = Loader(context);
    auth.getCurrentUser().then((user) {
      setState(() {
        _user.email = user.email;
        _user.displayName = _user.name = user.displayName;
        _user.id = user.uid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            color: Color(0xff262628),
            onPressed: () async {
              await auth.singOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.loginPage, (_) => false);
            }),
        brightness: Brightness.light,
        backgroundColor: Color(0xffEAEAEA),
        title: Text(
          'Register',
          style: TextStyle(
              color: Color(0xff262628),
              fontSize: ScreenUtil().setSp(17),
              fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => RegisterBloc(
            FirebaseMessaging(),
            UserCollection(),
            UserStorage(),
          ),
          child: BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state is RegisterInProcess)
                _loader.showLoader();
              else if (state is RegisterError) {
                _loader.dismissLoader();
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              } else if (state is RegisterSucessful) {
                _loader.dismissLoader();
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.matchPage, (_) => false);
              }
            },
            child: Container(
              child: ListView(
                children: <Widget>[
                  UploadPictures(
                      onChanged: (assets) => _user.uploadedPictures = assets),
                  UserForm(user: _user)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserForm extends StatefulWidget {
  final RegistrationUser user;
  const UserForm({Key key, this.user}) : super(key: key);

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final form = GlobalKey<FormState>();

  bool isUserValid() {
    final user = widget.user;
    return user.name != null &&
        user.email != null &&
        user.preferTimeWorkout != null &&
        user.gender != null &&
        user.gymMemberShip != null &&
        user.targetGender != null &&
        user.workoutTypes != null &&
        user.displayName != null &&
        user.uploadedPictures != null;
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
        key: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RegisterInputForm(
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
              label: 'Nickname',
              validator: (String value) =>
                  value.isEmpty ? 'Please, enter your nickname' : null,
              onSaved: (val) => widget.user.displayName = val,
            ),
            RegisterInputForm(
              hint: 'Tell us about yourself',
              label: 'About you',
              isMultiline: true,
              validator: (String value) =>
                  value.isEmpty ? 'Please, give an small info about you' : null,
              onSaved: (val) => widget.user.aboutMe = val,
            ),
            RegisterSelectForm(
              hint: 'Let us know your gender',
              onChange: (List<String> selectedOptions) {
                try {
                  widget.user.gender = selectedOptions.first;
                } catch (e) {
                  widget.user.gender = null;
                }
              },
              label: 'What is your gender?',
              options: ['Women', 'Man', 'Others'],
            ),
            RegisterSelectForm(
              hint: 'What genders are you looking for?',
              allowMultipleSelect: true,
              onChange: (List<String> selectedOptions) {
                widget.user.targetGender =
                    selectedOptions.length == 0 ? null : selectedOptions;
              },
              label: 'Looking For',
              options: ['Women', 'Man', 'Others'],
            ),
            RegisterSelectForm(
              onChange: (List<String> selectedOptions) {
                try {
                  widget.user.preferTimeWorkout = selectedOptions.first;
                } catch (e) {
                  widget.user.preferTimeWorkout = null;
                }
              },
              label: 'What is your favorite workout time?',
              options: ['Morning', 'Midday', 'Night'],
            ),
            RegisterSelectForm(
              onChange: (List<String> selectedOptions) {
                try {
                  widget.user.gymMemberShip = selectedOptions.first;
                } catch (e) {
                  widget.user.gymMemberShip = null;
                }
              },
              label: 'Do you have a gym membership?',
              options: ['Yes', 'No'],
            ),
            RegisterSelectForm(
              allowMultipleSelect: true,
              onChange: (List<String> selectedOptions) {
                widget.user.workoutTypes =
                    selectedOptions.length == 0 ? null : selectedOptions;
              },
              label: "What kind of workout you're interested on?",
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
                "Rowing"
              ],
            ),
            PrimaryButton.text(
                text: 'Register',
                onTap: () {
                  if (!form.currentState.validate()) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'All the fields are not filled, please fill them all and select the pictures')));
                    return;
                  }
                  form.currentState.save();
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

class RegisterSelectForm extends StatefulWidget {
  final void Function(List<String>) onChange;
  final bool allowMultipleSelect;
  final List<String> options;
  final String label;
  final String hint;

  const RegisterSelectForm({
    Key key,
    this.allowMultipleSelect = false,
    @required this.options,
    @required this.onChange,
    this.label,
    this.hint,
  }) : super(key: key);

  @override
  _RegisterSelectFormState createState() => _RegisterSelectFormState();
}

class _RegisterSelectFormState extends State<RegisterSelectForm> {
  List<String> selected = [];

  @override
  Widget build(BuildContext context) {
    return FormOptionWrapper(
      hint: widget.hint,
      label: widget.label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: ScreenUtil().setHeight(27)),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 10,
            runSpacing: 10,
            children:
                turnListToWidgetList<String>(widget.options, (index, value) {
              return SelectOption(
                isItemSelected: selected.indexOf(value) != -1,
                name: value,
                onTap: (newState) {
                  setState(() {
                    if (newState && !widget.allowMultipleSelect) {
                      selected = [value];
                    } else if (newState && widget.allowMultipleSelect) {
                      selected.add(value);
                    } else {
                      selected.remove(value);
                    }
                    widget.onChange(selected);
                  });
                },
              );
            }),
          ),
          SizedBox(height: ScreenUtil().setHeight(22)),
        ],
      ),
    );
  }
}

class SelectOption extends StatelessWidget {
  final bool isItemSelected;
  final void Function(bool) onTap;

  final Color colorForNonSelected = const Color(0xff4a4a4a);
  final Color colorForSelected = const Color(0xffFF689A);

  const SelectOption({
    Key key,
    @required this.name,
    this.isItemSelected,
    this.onTap,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(!isItemSelected),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(8),
          horizontal: ScreenUtil().setWidth(16),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color:
                    isItemSelected ? colorForSelected : colorForNonSelected)),
        child: Text(
          name,
          style: TextStyle(
              color: isItemSelected ? colorForSelected : colorForNonSelected,
              fontSize: ScreenUtil().setSp(16),
              height: 20 / 17,
              letterSpacing: -0.41),
        ),
      ),
    );
  }
}

class RegisterInputForm extends StatelessWidget {
  final String label;
  final void Function(String) onSaved;
  final String Function(String) validator;
  final bool isMultiline;
  final TextInputType keyboardType;
  final String hint;
  final String initialValue;

  const RegisterInputForm({
    Key key,
    @required this.onSaved,
    this.validator,
    this.isMultiline = false,
    this.keyboardType = TextInputType.text,
    this.label,
    this.hint,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormOptionWrapper(
        hint: hint,
        label: label,
        child: TextFormField(
            initialValue: initialValue,
            validator: validator,
            maxLength: isMultiline ? 150 : null,
            maxLines: isMultiline ? 4 : null,
            keyboardType: isMultiline ? TextInputType.multiline : keyboardType,
            onSaved: onSaved,
            style: TextStyle(
              color: Color(0xff262628),
              fontSize: ScreenUtil().setSp(16),
              letterSpacing: -0.41,
            ),
            decoration: InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.5,
                    color: Color(0xffefefef),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.5,
                    color: Color(0xffefefef),
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  width: 1.5,
                  color: Color(0xffefefef),
                )),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 1.5, color: Colors.redAccent),
                ),
                contentPadding: isMultiline
                    ? EdgeInsets.only(bottom: 10)
                    : EdgeInsets.zero)));
  }
}

class FormOptionWrapper extends StatefulWidget {
  final String hint;

  const FormOptionWrapper({
    Key key,
    @required this.label,
    @required this.child,
    this.hint,
  }) : super(key: key);

  final String label;

  final Widget child;

  @override
  _FormOptionWrapperState createState() => _FormOptionWrapperState();
}

class _FormOptionWrapperState extends State<FormOptionWrapper> {
  bool helpForInput = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: ScreenUtil().setHeight(22)),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Expanded(
            child: Text(
              widget.label,
              style: TextStyle(
                color: Color(0xff4a4a4a),
                fontWeight: FontWeight.bold,
                letterSpacing: 0.22,
                fontSize: ScreenUtil().setSp(15),
              ),
            ),
          ),
          if (widget.hint != null)
            Container(
              height: ScreenUtil().setHeight(25),
              width: ScreenUtil().setWidth(25),
              child: IconButton(
                  iconSize: ScreenUtil().setSp(14),
                  padding: EdgeInsets.all(2),
                  onPressed: () => setState(() => helpForInput = !helpForInput),
                  icon: FaIcon(
                    FontAwesomeIcons.question,
                    color: Color(0xff4a4a4a),
                    size: ScreenUtil().setSp(14),
                  )),
            )
        ]),
        // SizedBox(height: ScreenUtil().setHeight(2.5)),
        AnimatedSwitcher(
            duration: Duration(milliseconds: 250),
            child: helpForInput
                ? Column(
                    children: <Widget>[
                      SizedBox(height: ScreenUtil().setHeight(20)),
                      Text(widget.hint,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(0xff4a4a4a),
                              letterSpacing: -0.45,
                              fontSize: ScreenUtil().setSp(13))),
                    ],
                  )
                : SizedBox()),
        widget.child
      ],
    );
  }
}

class UploadPictures extends StatefulWidget {
  final void Function(List<Asset>) onChanged;

  const UploadPictures({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  _UploadPicturesState createState() => _UploadPicturesState();
}

class _UploadPicturesState extends State<UploadPictures> {
  final List<Widget> examplePictures = turnListToWidgetList(
    new List(6),
    (i, _) => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: AssetImage('assets/images/example-${i + 1}.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );

  List<Asset> _picturesSelectedFromGallery = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(16),
                vertical: ScreenUtil().setWidth(16),
              ),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: Stack(
                  children: <Widget>[
                    StaggeredGridView.count(
                      crossAxisSpacing: ScreenUtil().setWidth(12),
                      mainAxisSpacing: ScreenUtil().setHeight(12),
                      crossAxisCount: 3,
                      primary: false,
                      staggeredTiles: [
                        const StaggeredTile.count(2, 2),
                        const StaggeredTile.count(1, 1),
                        const StaggeredTile.count(1, 1),
                        const StaggeredTile.count(1, 1),
                        const StaggeredTile.count(1, 1),
                        const StaggeredTile.count(1, 1),
                      ],
                      children: _picturesSelectedFromGallery != null &&
                              _picturesSelectedFromGallery.isNotEmpty
                          ? _picturesSelectedFromGallery
                              .map(
                                (e) => ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: AssetThumb(
                                    quality: 100,
                                    asset: e,
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                              )
                              .toList()
                          : examplePictures,
                    ),
                    TappableWrapper(
                      onTap: () async {
                        try {
                          final pictures = await MultiImagePicker.pickImages(
                            maxImages: 6,
                            enableCamera: true,
                          );
                          setState(
                              () => _picturesSelectedFromGallery = pictures);
                          widget.onChanged(_picturesSelectedFromGallery);
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: _picturesSelectedFromGallery != null &&
                              _picturesSelectedFromGallery.isNotEmpty
                          ? Container()
                          : Container(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FaIcon(
                                      FontAwesomeIcons.camera,
                                      size: ScreenUtil().setSp(36),
                                      color: Color(0xff545455),
                                    ),
                                    SizedBox(
                                        height: ScreenUtil().setHeight(14)),
                                    Text(
                                      'Upload Your\nPictures',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xff545455),
                                        fontSize: ScreenUtil().setSp(23),
                                        height: 1.2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(242, 242, 242, 0.9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        FractionallySizedBox(
          widthFactor: 0.85,
          child: Text(
            'You can upload up to 6 pictures. Tap the pictures if you want to select different ones',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(15),
                height: 1.35,
                color: Color(0xff545455),
                letterSpacing: -0.45),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(15)),
      ],
    );
  }
}
