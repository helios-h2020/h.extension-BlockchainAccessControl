import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helios_access_control_ui/di/DI.dart';
import 'package:helios_access_control_ui/viewmodel/ManageGroupsViewModel.dart';
import 'package:helios_access_control_ui/widgets/forms/AppButton.dart';
import 'package:helios_access_control_ui/widgets/forms/AppDropDown.dart';
import 'package:helios_access_control_ui/widgets/forms/AppTextField.dart';
import "package:build_context/build_context.dart";
import 'package:helios_access_control_ui/widgets/forms/FormValidator.dart';

class ManageGroupsScreen extends StatefulWidget {
  @override
  _ManageGroupsScreenState createState() => _ManageGroupsScreenState();
}

class _ManageGroupsScreenState extends State<ManageGroupsScreen> {
  final _createGroupFormKey = GlobalKey<FormState>();

  final ManageGroupsViewModel _model = Get.put(
    ManageGroupsViewModel(DI.heliosRepository),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: DI.topBarBackgroundColor,
          title: Text(
            "Manage groups",
            style: TextStyle(
              color: DI.topBarItemsColor,
              fontSize: 20,
              fontWeight: DI.robotoMedium,
            ),
          ),
        ),
        body: Listener(
          onPointerDown: (_) {
            context.closeKeyboard();
          },
          child: ListView(children: [
            Form(
              key: _createGroupFormKey,
              child: ManageGroupSection(
                  inputField: AppTextField(
                    label: "Group name",
                    onSaved: (value) {
                      _model.setGroupName(value);
                    },
                    validator: (String value) {
                      if (FormValidator.isEmpty(value)) {
                        return "Mandatory field";
                      }
                      return "";
                    },
                  ),
                  actions: [
                    AppButtonWithDebounce(
                      label: "Create Group",
                      onTap: () {
                        if (_createGroupFormKey.currentState.validate()) {
                          _createGroupFormKey.currentState.save();
                          _model.onCreateGroupTapped();
                        }
                      },
                    ),
                  ]),
            ),
            manageGroupsDivider(),
            ManageGroupSection(
              inputField: Obx(() {
                String dropDownValue =
                    _model.currentGroupLabelToDelete.value.isEmpty
                        ? null
                        : _model.currentGroupLabelToDelete.value;

                return _model.deleteGroupLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : AppDropDown(
                        currentValue: dropDownValue,
                        label: "Group",
                        values: _model.groupsDeleteList.values.toList(),
                        readOnly: false,
                        onChanged: (String value) {
                          _model.onDeleteGroupChanged(value);
                        },
                        validator: (String value) {
                          return null;
                        });
              }),
              actions: [
                AppButton(
                    label: "Delete Group",
                    onTap: () {
                      _model.onDeleteGroupTapped();
                    }),
              ],
            ),
            manageGroupsDivider(),
            ManageGroupSection(
              inputField: AppTextField(
                label: "User id",
                onSaved: (value) {
                  //TODO
                },
                validator: (String value) {
                  return null;
                },
              ),
              actions: [
                AppButton(
                    label: "Revoke Access",
                    onTap: () {
                      //TODO
                    }),
              ],
            ),
          ]),
        ));
  }

  Widget manageGroupsDivider() =>
      Divider(thickness: 8, color: DI.dividerBgColor);
}

class ManageGroupSection extends StatelessWidget {
  const ManageGroupSection({
    Key key,
    this.inputField,
    this.actions,
  }) : super(key: key);

  final Widget inputField;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          SizedBox(height: 20),
          inputField,
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: actions,
          ),
        ],
      ),
    );
  }
}
