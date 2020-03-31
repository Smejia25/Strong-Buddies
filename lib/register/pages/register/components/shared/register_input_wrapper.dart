import 'package:flutter/material.dart';
import 'register_container_wrapper.dart';

class RegisterInputWrapper extends StatefulWidget {
  const RegisterInputWrapper({
    Key key,
    this.builder,
    this.onChange,
    this.reason,
  }) : super(key: key);

  final Widget Function(TextEditingController controller) builder;
  final void Function(String newValue) onChange;
  final String reason;

  @override
  _RegisterInputWrapperState createState() => _RegisterInputWrapperState();
}

class _RegisterInputWrapperState extends State<RegisterInputWrapper> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _listenToInputChanges();
  }

  void _listenToInputChanges() {
    _controller.addListener(() {
      if (!_formKey.currentState.validate()) return;
      widget.onChange(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RegisterContainerWrapper(
      reason: widget.reason,
      child: Form(
        key: _formKey,
        child: widget.builder(_controller),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
