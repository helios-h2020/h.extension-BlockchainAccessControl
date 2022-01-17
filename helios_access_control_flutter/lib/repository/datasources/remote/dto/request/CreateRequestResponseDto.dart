import 'package:helios_access_control_ui/model/Request.dart';

class CreateRequestResponseDto {
  CreateRequestResponseDto({
    this.id,
    this.resourceId,
    this.owner,
    this.requester,
    this.status,
  });

  int id;
  String resourceId;
  String owner;
  String requester;
  String status;

  factory CreateRequestResponseDto.fromJson(Map<String, dynamic> json) => CreateRequestResponseDto(
        id: json["id"],
        resourceId: json["resourceId"],
        owner: json["owner"],
        requester: json["requester"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "resourceId": resourceId,
        "owner": owner,
        "requester": requester,
        "status": status,
      };

  CreateRequestResponse toModel() {
    return CreateRequestResponse(
      id: id,
      resourceId: resourceId,
      owner: owner,
      requester: requester,
      status: _getRequestStatus(status),
    );
  }

  RequestStatus _getRequestStatus(String status) {
    RequestStatus requestStatus;
    switch(status) {
      case "PENDING":
        requestStatus = RequestStatus.PENDING;
        break;
      case "APPROVED":
        requestStatus = RequestStatus.APPROVED;
        break;
      case "REJECTED":
        requestStatus = RequestStatus.REJECTED;
        break;
      default:
        requestStatus = RequestStatus.UNKNOWN;
    }
    return requestStatus;
  }
}
