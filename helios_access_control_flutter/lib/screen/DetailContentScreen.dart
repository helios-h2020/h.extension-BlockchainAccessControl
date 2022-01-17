import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:helios_access_control_ui/di/DI.dart';
import 'package:helios_access_control_ui/model/Content.dart';
import 'package:helios_access_control_ui/viewmodel/DetailContentViewModel.dart';
import 'package:loading_overlay/loading_overlay.dart';

class DetailContentScreen extends StatefulWidget {
  @override
  _DetailContentScreenState createState() => _DetailContentScreenState();
}

class _DetailContentScreenState extends State<DetailContentScreen> {
  final DetailContentViewModel _model =
      Get.put(DetailContentViewModel(DI.navigator));

  @override
  void initState() {
    super.initState();
    final Content content = Get.arguments;
    _model.loadContent(content);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return LoadingOverlay(
        isLoading: _model.requestAccessInProgress.value,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: DI.topBarItemsColor,
            ),
            backgroundColor: DI.topBarBackgroundColor,
            title: Text(
              "Request",
              style: TextStyle(
                color: DI.topBarItemsColor,
                fontSize: 20,
                fontWeight: DI.robotoMedium,
              ),
            ),
          ),
          body: Obx(
            () {
              return Column(
                children: [
                  imageSection(context),
                  SizedBox(height: 16),
                  headerSection(),
                  SizedBox(height: 24),
                  privateContentSection(),
                  SizedBox(height: 16),
                  currentStatusSection(),
                ],
              );
            },
          ),
          persistentFooterButtons: [
            Obx(
              () {
                return Visibility(
                  visible: !_model.isResourceLoading.value,
                  child: _model.hasAccess.value
                      ? seeContentButton(context)
                      : requestAccessButton(context),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget imageSection(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      color: _model.currentContent.value.getContentColor(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            _model.currentContent.value.getContentIcon(),
            width: 120,
            height: 120,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget headerSection() {
    return Row(
      children: [
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _model.currentContent.value.title,
              style: TextStyle(
                color: DI.detailContentTitleColor,
                fontWeight: DI.robotoMedium,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _model.currentContent.value.id,
              style: TextStyle(
                fontWeight: DI.robotoRegular,
                fontSize: 16,
                color: DI.detailContentIdColor,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget privateContentSection() {
    if (_model.hasAccess.value) {
      return loadResourceWidget();
    } else {
      return noAccessWidget();
    }
  }

  Widget loadResourceWidget() {
    return _model.isResourceLoading.value
        ? Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  )
                ],
              ),
              SizedBox(height: 16),
              Text(
                "Checking access",
                style: TextStyle(
                  color: DI.detailPrivateColor,
                  fontSize: 16,
                  fontWeight: DI.robotoBold,
                ),
              ),
            ],
          )
        : Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 96, color: Colors.green)
                ],
              ),
              SizedBox(height: 16),
              Text(
                "Resource ready",
                style: TextStyle(
                  color: DI.detailPrivateColor,
                  fontSize: 16,
                  fontWeight: DI.robotoBold,
                ),
              ),
            ],
          );
  }

  Widget noAccessWidget() {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: DI.detailCircleColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/icon/ic_candado.svg",
                color: DI.detailLockIconColor,
                width: 34,
                height: 49,
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Text(
          "Private content",
          style: TextStyle(
            color: DI.detailPrivateColor,
            fontSize: 16,
            fontWeight: DI.robotoBold,
          ),
        ),
        SizedBox(height: 4),
        Visibility(
          visible: _model.currentContent.value.accessType == AccessType.GROUP,
          child: Text(
            "Only available for group members",
            style: TextStyle(
              color: DI.detailPrivateColor,
              fontSize: 16,
              fontWeight: DI.robotoRegular,
            ),
          ),
        ),
      ],
    );
  }

  Widget seeContentButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: DI.detailAccessButton,
        borderRadius: BorderRadius.all(
          Radius.circular(3),
        ),
      ),
      child: TextButton(
        onPressed: () {
          _model.openResource();
        },
        child: Text(
          "SEE CONTENT",
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: DI.robotoRegular,
          ),
        ),
      ),
    );
  }

  Widget requestAccessButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: DI.detailAccessButton,
        borderRadius: BorderRadius.all(
          Radius.circular(3),
        ),
      ),
      child: TextButton(
        onPressed: () {
          _model.onAccessRequested();
        },
        child: Text(
          _model.requestText(),
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: DI.robotoRegular,
          ),
        ),
      ),
    );
  }

  Widget currentStatusSection() {
    return Obx(
      () => Visibility(
        visible: _model.accessRequested.value,
        child: Center(
          child: Text(
            "Pending approval",
            style: TextStyle(
              color: DI.detailPendingApprovalColor,
              fontSize: 18,
              fontWeight: DI.robotoMedium,
            ),
          ),
        ),
      ),
    );
  }
}
