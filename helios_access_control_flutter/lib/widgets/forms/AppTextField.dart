import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:helios_access_control_ui/di/DI.dart';

final _styleInputDecoration = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 16,
    color: DI.inputDecorationColor);

final _styleEmptyValue = TextStyle(
    fontWeight: FontWeight.normal, fontSize: 16, color: DI.emptyValueColor);

final _styleInputText = TextStyle(
    fontWeight: FontWeight.normal, fontSize: 16, color: DI.inputTextColor);
final _styleErrorText = TextStyle(
    fontWeight: FontWeight.normal, fontSize: 16, color: DI.errorTextColor);

class AppTextField extends StatefulWidget {
  final String defaultValue;

  final TextInputType textInputType;

  final TextInputAction textInputAction;

  final bool obscureText;

  final String label;

  final String helperText;

  final int maxLines;

  final int minLines;

  final int maxLenght;

  final TextEditingController controller;

  final Function(String) onChange;

  final Function(String) onSaved;

  final double marginLeft;
  final double marginRight;

  final String Function(String) validator;

  const AppTextField({
    Key key,
    this.defaultValue,
    this.textInputAction = TextInputAction.done,
    this.textInputType = TextInputType.multiline,
    this.obscureText = false,
    this.label,
    this.helperText,
    this.maxLines,
    this.minLines = 1,
    this.maxLenght,
    this.onChange,
    this.controller,
    this.onSaved,
    this.validator,
    this.marginLeft = 0,
    this.marginRight = 0,
  }) : super(key: key);

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  String _currentValue = "";
  bool _hasError;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.defaultValue;
    _hasError = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: widget.marginLeft, right: widget.marginRight),
      child: TextFormField(
        controller: widget.controller,
        key: Key(widget.defaultValue),
        style: _styleInputText,
        cursorColor: DI.inputTextColor,
        maxLength: widget.maxLenght,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        initialValue:
            widget.controller == null ? widget.defaultValue: null,
        keyboardType: widget.textInputType,
        textInputAction: widget.textInputAction,
        obscureText: widget.obscureText,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: DI.underlineColor)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: DI.underlineFocusedColor)),
            labelStyle: _getInputDecorationLabelStyle(),
            labelText: widget.label,
            contentPadding: EdgeInsets.zero,
            helperText: widget.helperText),
        onChanged: (value) {
          setState(() {
            _hasError = false;
            _currentValue = value;
            if (widget.onChange != null) {
              widget.onChange(value);
            }
          });
        },
        validator: (value) {
          String errorString = widget.validator(value);
          bool hasError = errorString != null && errorString.isNotEmpty;
          if (_hasError != hasError) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                _hasError = hasError;
              });
            });
          }
          return hasError ? errorString : null;
        },
        onSaved: (value) {
          if (widget.onSaved != null) {
            widget.onSaved(value);
          }
        },
      ),
    );
  }

  bool get hasValue => _currentValue != null && _currentValue.isNotEmpty;

  TextStyle _getInputDecorationLabelStyle() {
    TextStyle textStyle;
    if (_hasError) {
      textStyle = _styleErrorText;
    } else if (hasValue) {
      textStyle = _styleInputDecoration;
    } else {
      textStyle = _styleEmptyValue;
    }
    return textStyle;
  }
}
