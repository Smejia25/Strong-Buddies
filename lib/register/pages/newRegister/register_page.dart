import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as provider;
import 'package:strong_buddies_connect/register/pages/components/upload_pictures.dart';
import 'package:strong_buddies_connect/register/pages/components/user_form.dart';
import 'package:strong_buddies_connect/routes.dart';
import 'package:strong_buddies_connect/shared/models/current_user_notifier.dart';
import 'package:strong_buddies_connect/shared/services/auth/auth_service.dart';
import 'package:strong_buddies_connect/shared/services/loader_service.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';
import 'package:strong_buddies_connect/shared/services/user_storage.dart';
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
  final _form = GlobalKey<FormState>();
  final _bloc = RegisterBloc(
    FirebaseMessaging(),
    UserCollection(),
    UserStorage(),
  );

  CurrentUserNotifier userNotifier;
  bool _isEditingProfile = false;
  Loader _loader;

  @override
  void initState() {
    super.initState();
    _loader = Loader(context);
    setUserInfo();
  }

  void setUserInfo() {
    userNotifier =
        provider.Provider.of<CurrentUserNotifier>(context, listen: false);
    if (userNotifier.user == null)
      auth.getCurrentUser().then((user) {
        setState(() {
          _user.email = user.email;
          _user.displayName = _user.name = user.displayName;
          _user.id = user.uid;
        });
      });
    else {
      setState(() {
        _isEditingProfile = true;
        _user.email = userNotifier.user.email;
        _user.name = userNotifier.user.name;
        _user.gender = userNotifier.user.gender;
        _user.displayName = userNotifier.user.displayName;
        _user.aboutMe = userNotifier.user.aboutMe;
        _user.targetGender = userNotifier.user.targetGender;
        _user.preferTimeWorkout = userNotifier.user.preferTimeWorkout;
        _user.gymMemberShip = userNotifier.user.gymMemberShip;
        _user.workoutTypes = userNotifier.user.workoutTypes;
        _user.pictures = userNotifier.user.pictures;
        _user.id = userNotifier.user.id;
      });
    }
  }

  void logOut() async {
    userNotifier.user = null;
    auth.preLogOut(true);
    Navigator.pushNamedAndRemoveUntil(
        context, Routes.reLoginPage, (_) => false);
  }

  bool isUserValid() {
    return _user.name != null &&
        _user.email != null &&
        _user.gender != null &&
        _user.targetGender != null &&
        _user.displayName != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onSelected: (_) => logOut(),
            itemBuilder: (context) => [
              PopupMenuItem(child: Text('Log out'), value: 'sxs'),
            ],
          )
        ],
        bottomOpacity: 0.0,
        elevation: 0.8,
        centerTitle: false,
        leading: _isEditingProfile
            ? null
            : BackButton(color: Color(0xff262628), onPressed: logOut),
        brightness: Brightness.light,
        backgroundColor: Color(0xffEAEAEA),
        title: Text(
          _isEditingProfile ? 'Profile Info' : 'Complete your info',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Color(0xFF262628),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      backgroundColor: Color(0xffF2F2F2),
      floatingActionButton: !_isEditingProfile
          ? null
          : FloatingActionButton(
              backgroundColor: Color(0xffFF8960),
              foregroundColor: Colors.white,
              child: Icon(Icons.check),
              onPressed: () {
                if (!_form.currentState.validate()) return;
                _form.currentState.save();
                if (!isUserValid())
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'All the fields are not filled, please fill them all and select the pictures')));
                else
                  _bloc.add(CreateUser(_user));
              }),
      body: SafeArea(
        child: BlocProvider.value(
          value: _bloc,
          child: BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state is RegisterInProcess)
                _loader.showLoader();
              else if (state is RegisterError) {
                _loader.dismissLoader();
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              } else if (state is RegisterSucessful) {
                if (_isEditingProfile) {
                  _loader.dismissLoader();
                  userNotifier.user = _user;
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Changes Saved')));
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.matchPage, (route) => false);
                }
              }
            },
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    UploadPictures(
                        pictures: _user?.pictures,
                        isEditingExistingProfile: _isEditingProfile,
                        onChanged: (assets) => _user.uploadedPictures = assets),
                    UserForm(
                      formKeyState: _form,
                      user: _user,
                      isEditingExistingProfile: _isEditingProfile,
                      onLogOut: logOut,
                    )
                  ],
                ),
              ),
            ),
          ),
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
  final List<String> previouslySelected;

  const RegisterSelectForm({
    Key key,
    this.allowMultipleSelect = false,
    @required this.options,
    @required this.onChange,
    this.label,
    this.hint,
    this.previouslySelected = const [],
  }) : super(key: key);

  @override
  _RegisterSelectFormState createState() => _RegisterSelectFormState();
}

class _RegisterSelectFormState extends State<RegisterSelectForm> {
  List<String> selected = [];

  @override
  void initState() {
    super.initState();
    try {
      selected = List.from(widget.previouslySelected);
    } catch (e) {}
  }

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
