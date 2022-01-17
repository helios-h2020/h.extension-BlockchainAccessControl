import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helios_access_control_ui/di/DI.dart';
import 'package:helios_access_control_ui/viewmodel/LoginViewModel.dart';
import 'package:helios_access_control_ui/widgets/forms/AppTextField.dart';
import "package:build_context/build_context.dart";
import 'package:helios_access_control_ui/widgets/forms/FormValidator.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginViewModel _model = LoginViewModel(DI.heliosRepository);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _model.isLoading,
      child: Scaffold(
          body: Listener(
        onPointerDown: (_) {
          context.closeKeyboard();
        },
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 72),
              Image.asset(
                "assets/img/img_helios_logo.png",
                width: 200,
                height: 106,
              ),
              SizedBox(height: 16),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: AppTextField(
                    label: "Username",
                    textInputAction: TextInputAction.next,
                    onChange: (value) {
                      setState(() {
                        _model.setUsername(value);
                      });
                    },
                    validator: (String value) {
                      if (FormValidator.isEmpty(value)) {
                        return "Mandatory field";
                      }
                      return null;
                    },
                  )),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: AppTextField(
                  label: "Password",
                  obscureText: true,
                  maxLines: 1,
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onChange: (value) {
                    setState(() {
                      _model.setPassword(value);
                    });
                  },
                  validator: (String value) {
                    if (value == null || value.isEmpty) {
                      return "Mandatory field";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 76,
                    decoration: BoxDecoration(
                      color: _model.loginButtonBackgroundColor(),
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          if (_model.userSelected()) _model.onLoginTapped();
                        }
                      },
                      child: Text(
                        "ENTER",
                        style: TextStyle(
                          fontSize: 14,
                          color: _model.loginButtonTextColor(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                ],
              ),
              Visibility(
                visible: _model.userSelected(),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: _model.onPasswordRecoveryTapped,
                      child: Text(
                        "Password Recovery",
                        style: TextStyle(
                          color: DI.loginButtonsColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextButton(
                      onPressed: _model.onRegisterTapped,
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: DI.loginButtonsColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 108),
            ],
          ),
        ),
      )),
    );
  }
}
