import 'package:flutter/material.dart';

const _styleInputDecoration = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 20,
    color: Color(0xFF007DBC));
const _styleHint = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 17,
    color: Color.fromRGBO(105, 105, 115, 1));
const _styleMenuItem = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 17,
    color: Color.fromRGBO(0, 0, 0, 0.87));
const _styleMenuItemSelected = TextStyle(
    fontWeight: FontWeight.normal, fontSize: 17, color: _colorItemSelected);
const _colorItemSelected = Color.fromRGBO(28, 28, 28, 1);
const _colorUnderline = Color.fromRGBO(209, 209, 209, 1);

class CustomDropDown extends StatelessWidget {
  final String currentValue;
  final String label;
  final List<String> values;
  final Function onChanged;
  final String Function(String) validator;

  CustomDropDown({
    Key key,
    @required this.currentValue,
    @required this.label,
    @required this.values,
    @required this.onChanged,
    @required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _colorUnderline)),
          labelText: currentValue != null ? label : "",
          labelStyle: _styleInputDecoration),
      dropdownColor: Colors.white,
      isExpanded: true,
      value: currentValue,
      items: values.map((value) {
        return DropdownMenuItem(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                textAlign: TextAlign.start,
                style: currentValue == value
                    ? _styleMenuItemSelected
                    : _styleMenuItem,
              ),
              Visibility(
                  visible: currentValue == value,
                  child: Icon(
                    (Icons.check),
                    color: _colorItemSelected,
                  ))
            ],
          ),
          value: value,
        );
      }).toList(),
      validator: (value) {
        return validator(value);
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      selectedItemBuilder: (BuildContext context) {
        return values.map<Widget>((String item) {
          return Text(item, style: _styleMenuItemSelected);
        }).toList();
      },
      onChanged: onChanged,
      hint: Text(
        label,
        style: _styleHint,
        textAlign: TextAlign.start,
      ),
      style: TextStyle(color: Colors.black, decorationColor: Colors.red),
    );
  }
}
