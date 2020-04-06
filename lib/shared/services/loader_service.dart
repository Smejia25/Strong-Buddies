import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Loader {
  final ProgressDialog _pr;

  Loader(BuildContext context) : this._pr = ProgressDialog(context);

  Future<void> showLoader() async {
    await _pr.show();
  }

  void dismissLoader() {
    return _pr.dismiss();
  }
}
