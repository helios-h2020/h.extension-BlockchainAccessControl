import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:helios_access_control_ui/di/DI.dart';
import 'package:helios_access_control_ui/model/Content.dart';
import 'package:helios_access_control_ui/viewmodel/HomeViewModel.dart';

class HomeScreen extends StatelessWidget {
  final HomeViewModel _model = Get.put(HomeViewModel(DI.navigator));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: DI.topBarBackgroundColor,
        title: Text(
          "List of contents",
          style: TextStyle(
            color: DI.topBarItemsColor,
            fontSize: 20,
            fontWeight: DI.robotoMedium,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: DI.topBarItemsColor,
            ),
            onPressed: () {
              _model.onAddContentTapped();
            },
          )
        ],
      ),
      body: _contentCardsListView(),
    );
  }

  Widget _contentCardsListView() {
    return Obx(
      () => Stack(
        children: [
          if (_model.isLoading.value)
            Center(child: CircularProgressIndicator()),
          if (!_model.isLoading.value)
            RefreshIndicator(
              onRefresh: _getContents,
              child: ListView.separated(
                padding: EdgeInsets.only(
                  left: 8,
                  top: 8,
                  right: 8,
                  bottom: 8,
                ),
                itemCount: _model.contents.length,
                itemBuilder: (context, index) {
                  return ContentCardItem(
                    item: _model.contents[index],
                    onSeeContentTapped: () =>
                        _model.onSeeContentTapped(_model.contents[index]),
                    onInfoTapped: () =>
                        _model.onInfoTapped(_model.contents[index]),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 8,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _getContents() async {
    _model.getContents();
  }
}

class ContentCardItem extends StatelessWidget {
  const ContentCardItem({
    Key key,
    this.item,
    this.onSeeContentTapped,
    this.onInfoTapped,
  }) : super(key: key);

  final Content item;
  final Function onSeeContentTapped;
  final Function onInfoTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: item.getContentColor(),
          width: 2,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              SizedBox(
                width: 16,
              ),
              Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset(
                    item.getContentIcon(),
                    color: item.getContentColor(),
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: DI.robotoMedium,
                      color: DI.homeContentTitleColor,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    item.id,
                    style: TextStyle(
                      fontSize: 14,
                      color: DI.homeContentIdColor,
                      fontWeight: DI.robotoRegular,
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 11,
          ),
          Divider(
            color: DI.homeDividerColor,
            height: 1,
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onSeeContentTapped,
                child: Text(
                  "SEE CONTENT",
                  style: TextStyle(
                    fontSize: 14,
                    color: DI.homeContentSeeContentButtonColor,
                    fontWeight: DI.robotoMedium,
                  ),
                ),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icon/ic_info.svg",
                  color: DI.homeContentInfoButtonColor,
                ),
                onPressed: onInfoTapped,
              )
            ],
          ),
        ],
      ),
    );
  }
}
