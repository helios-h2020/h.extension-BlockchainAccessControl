import 'package:access_control/access_control.dart';
import 'package:access_control_example/di/DI.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HeliosStatusItem lastOperationStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Helios Access Control Demo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RaisedButton(
                  child: const Text("Setup Access Key"),
                  onPressed: () async {
                    final response = await DI.heliosAccessControlRepository
                        .createAccessRequest(uri: "", privateKey: "");
                    if (response.success) {
                      lastOperationStatus = HeliosStatusItem(
                          lastOperation: "Setup Access Key", success: true);
                    } else {
                      lastOperationStatus = HeliosStatusItem(
                          lastOperation: "Setup Access Key", success: false);
                    }
                    setState(() {});
                  }),
              RaisedButton(
                  child: const Text("Create access request"),
                  onPressed: () async {
                    final response = await DI.heliosAccessControlRepository
                        .createAccessRequest(uri: "", privateKey: '');
                    if (response.success) {
                      lastOperationStatus = HeliosStatusItem(
                          lastOperation: "Create access request",
                          success: true);
                    } else {
                      lastOperationStatus = HeliosStatusItem(
                          lastOperation: "Create access request",
                          success: false);
                    }
                    setState(() {});
                  }),
              RaisedButton(
                  child: const Text("Accept access request"),
                  onPressed: () async {
                    final response = await DI.heliosAccessControlRepository
                        .acceptAccessRequest(
                            uri: "", requester: "", privateKey: "");
                    if (response.success) {
                      lastOperationStatus = HeliosStatusItem(
                          lastOperation: "Accept access request",
                          success: true);
                    } else {
                      lastOperationStatus = HeliosStatusItem(
                          lastOperation: "Accept access request",
                          success: false);
                    }
                    setState(() {});
                  }),
              RaisedButton(
                  child: const Text("Reject access request"),
                  onPressed: () async {
                    final response = await DI.heliosAccessControlRepository
                        .rejectAccessRequest(uri: "", requester: "", privateKey: "");
                    if (response.success) {
                      lastOperationStatus = HeliosStatusItem(
                          lastOperation: "Reject access request",
                          success: true);
                    } else {
                      lastOperationStatus = HeliosStatusItem(
                          lastOperation: "Reject access request",
                          success: false);
                    }
                    setState(() {});
                  }),
              RaisedButton(
                  child: const Text("Check access request"),
                  onPressed: () async {
                    final response = await DI.heliosAccessControlRepository
                        .checkAccessRequest(
                      owner: "",
                      uri: "",
                      accessKey: "",
                      privateKey: '',
                      requester: '',
                    );
                    if (response.success) {
                      lastOperationStatus = HeliosStatusItem(
                          lastOperation: "Check access request",
                          success: true,
                          requestStatus: response.requestStatus);
                    } else {
                      lastOperationStatus = HeliosStatusItem(
                          lastOperation: "Check access request",
                          success: false);
                    }
                    setState(() {});
                  }),
              RaisedButton(
                  child: const Text("Reset access request"),
                  onPressed: () async {
                    final response = await DI.heliosAccessControlRepository
                        .resetAccessRequest(uri: "", privateKey: "");
                    if (response.success) {
                      lastOperationStatus = HeliosStatusItem(
                          lastOperation: "Reset access request", success: true);
                    } else {
                      lastOperationStatus = HeliosStatusItem(
                          lastOperation: "Reset access request",
                          success: false);
                    }
                    setState(() {});
                  }),
              HeliosStatusSection(lastOperationStatus),
            ],
          ),
        ),
      ),
    );
  }
}

class HeliosStatusSection extends StatelessWidget {
  final HeliosStatusItem lastOperationStatus;

  HeliosStatusSection(this.lastOperationStatus);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.info),
              title: const Text('Status'),
            ),
            Text(
              'Check the status of the last operation',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
            SizedBox(height: 10),
            if (lastOperationStatus != null)
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Last operation",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Text(lastOperationStatus.lastOperation),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Result"),
                      SizedBox(width: 8),
                      lastOperationStatus.success
                          ? Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                            )
                          : Icon(Icons.close_outlined, color: Colors.red),
                    ],
                  ),
                  SizedBox(height: 10),
                  Visibility(
                    visible: lastOperationStatus != null &&
                        lastOperationStatus.success &&
                        lastOperationStatus.requestStatus != null,
                    child: Row(
                      children: [
                        Text(
                          "Request Status",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        if (lastOperationStatus != null &&
                            lastOperationStatus.requestStatus != null)
                          Text(getRequestStatus(
                              lastOperationStatus.requestStatus))
                      ],
                    ),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }

  String getRequestStatus(RequestStatus requestStatus) {
    String description;
    switch (requestStatus) {
      case RequestStatus.PENDING:
        description = "Pending";
        break;
      case RequestStatus.ACCEPTED:
        description = "Accepted";
        break;
      case RequestStatus.REJECTED:
        description = "Rejected";
        break;
      case RequestStatus.UNKNOWN:
        description = "Unknown";
        break;
    }
    return description;
  }
}

class HeliosStatusItem {
  String lastOperation;
  bool success;
  RequestStatus requestStatus;

  HeliosStatusItem({
    @required this.lastOperation,
    @required this.success,
    this.requestStatus,
  });
}
