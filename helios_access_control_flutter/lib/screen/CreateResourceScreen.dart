import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:helios_access_control_ui/di/DI.dart';
import 'package:helios_access_control_ui/model/Content.dart';
import 'package:helios_access_control_ui/model/Resource.dart';
import 'package:helios_access_control_ui/viewmodel/CreateResourceViewModel.dart';
import 'package:helios_access_control_ui/widgets/forms/AppButtonWithIcon.dart';
import 'package:helios_access_control_ui/widgets/forms/AppDropDown.dart';
import 'package:helios_access_control_ui/widgets/forms/AppTextField.dart';
import "package:build_context/build_context.dart";
import 'package:loading_overlay/loading_overlay.dart';

final TextStyle _uploadDescriptionStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.normal,
  color: Color(0xFF666666),
);

final TextStyle _documentStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Color(0xFF666666),
);

class CreateResourceScreen extends StatefulWidget {
  @override
  _CreateResourceScreenState createState() => _CreateResourceScreenState();
}

class _CreateResourceScreenState extends State<CreateResourceScreen> {
  final CreateResourceViewModel _model =
      Get.put(CreateResourceViewModel(DI.navigator));

  final _formKey = GlobalKey<FormState>();

  UploadResource _uploadResource = UploadResource();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return LoadingOverlay(
        isLoading: _model.isLoading.value,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: DI.topBarItemsColor,
            ),
            backgroundColor: DI.topBarBackgroundColor,
            title: Text(
              "Create your resource",
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
            child: Form(
              key: _formKey,
              child: ListView(children: [
                InputFieldWidget(
                  inputField: AppTextField(
                    label: "Title",
                    onChange: (String value) {
                      setState(() {
                        _uploadResource =
                            _uploadResource.copyWith(title: value);
                      });
                    },
                    onSaved: (value) {
                      //TODO
                    },
                    validator: (String value) {
                      if (value == null || value.isEmpty) {
                        return "Mandatory field";
                      }
                      return null;
                    },
                  ),
                ),
                RadioGroup<AccessType>.builder(
                  groupValue: _model.accessType.value,
                  onChanged: (value) {
                    _model.onAccessTypeChanged(value);
                  },
                  items: [AccessType.INDIVIDUAL, AccessType.GROUP],
                  itemBuilder: (item) => RadioButtonBuilder(
                    item.getDescription(),
                  ),
                ),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: Obx(() {
                      String dropDownValue =
                          _model.currentGroupLabel.value.isEmpty
                              ? null
                              : _model.currentGroupLabel.value;

                      return _model.groupsLoading.value
                          ? Center(child: CircularProgressIndicator())
                          : Visibility(
                              visible: _model.accessType == AccessType.GROUP,
                              child: AppDropDown(
                                  currentValue: dropDownValue,
                                  label: "Group",
                                  values: _model.groups.values.toList(),
                                  readOnly: false,
                                  onChanged: (String value) {
                                    _model.onGroupChanged(value);
                                  },
                                  validator: (String value) {
                                    return null;
                                  }),
                            );
                    })),
                UploadResourceSection(
                    filePickerClosed: (UploadResource newUploadedResource) {
                  setState(() {
                    _uploadResource = _uploadResource.copyWith(
                        platformFile: newUploadedResource.platformFile,
                        pathPreview: newUploadedResource.pathPreview);
                  });
                }),
              ]),
            ),
          ),
          persistentFooterButtons: [
            Visibility(
              visible: _uploadResource.isValid(),
              child: createResourceButton(),
            )
          ],
        ),
      );
    });
  }

  Widget createResourceButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: DI.createResourceButtonColor,
        borderRadius: BorderRadius.all(
          Radius.circular(3),
        ),
      ),
      child: TextButton(
        onPressed: () async {
          await _model.createResource(_uploadResource);
        },
        child: Text(
          "CREATE RESOURCE",
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: DI.robotoRegular,
          ),
        ),
      ),
    );
  }
}

class InputFieldWidget extends StatelessWidget {
  const InputFieldWidget({
    Key key,
    this.inputField,
  }) : super(key: key);

  final Widget inputField;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          SizedBox(height: 20),
          inputField,
        ],
      ),
    );
  }
}

class UploadResourceSection extends StatefulWidget {
  final Function(UploadResource) filePickerClosed;

  const UploadResourceSection({
    Key key,
    this.filePickerClosed,
  }) : super(key: key);

  @override
  UploadResourceSectionState createState() => UploadResourceSectionState();
}

class UploadResourceSectionState extends State<UploadResourceSection> {
  UploadResource uploadResource = UploadResource();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Select an image, a video or document to upload",
                textAlign: TextAlign.center,
                style: _uploadDescriptionStyle,
              ),
              SizedBox(height: 10),
              if (uploadResource.hasImagePreview())
                Expanded(
                  flex: 1,
                  child: Image.file(
                    File(uploadResource.pathPreview),
                    frameBuilder: (BuildContext context, Widget child,
                        int frame, bool wasSynchronouslyLoaded) {
                      return wasSynchronouslyLoaded
                          ? child
                          : AnimatedOpacity(
                              child: frame == null
                                  ? Center(child: CircularProgressIndicator())
                                  : child,
                              opacity: frame == null ? 0 : 1,
                              duration: const Duration(seconds: 2),
                              curve: Curves.easeOut,
                            );
                    },
                    fit: BoxFit.cover,
                  ),
                ),
              if (uploadResource.hasTextPreview())
                Container(
                    height: 50,
                    child: Text(
                      uploadResource.pathPreview,
                      style: _documentStyle,
                    )),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                child: AppButtonWithIcon(
                    icon: Icon(Icons.upload_file),
                    label: "Upload",
                    onTap: () {
                      _openFilePicker();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openFilePicker() async {
    List<PlatformFile> _paths;
    try {
      _paths = (await FilePicker.platform.pickFiles(
        allowMultiple: false,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    UploadResource uploadResource = UploadResource(platformFile: _paths.first);
    await uploadResource.generatePreview();
    widget.filePickerClosed(
      uploadResource,
    );
    setState(() {
      this.uploadResource = uploadResource;
    });
  }
}
