import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';

class EditingController extends TextEditingController {
  Error error = new Error();
}

class Error {
  String text = null;
}
