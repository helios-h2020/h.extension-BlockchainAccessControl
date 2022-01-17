enum RequestStatus {
  PENDING,
  APPROVED,
  REJECTED,
  UNKNOWN
}

class CreateRequestResponse {
  int id;
  String resourceId;
  String owner;
  String requester;
  RequestStatus status;

  CreateRequestResponse({
    this.id,
    this.resourceId,
    this.owner,
    this.requester,
    this.status,
  });

  static CreateRequestResponse failedResponse() {
    return CreateRequestResponse(
      id: 0,
      resourceId: "",
      owner: "",
      requester: "",
      status: RequestStatus.UNKNOWN,
    );
  }

  bool isSuccess() {
    return resourceId.isNotEmpty &&
        owner.isNotEmpty &&
        requester.isNotEmpty
        && status != RequestStatus.UNKNOWN;
  }
}
