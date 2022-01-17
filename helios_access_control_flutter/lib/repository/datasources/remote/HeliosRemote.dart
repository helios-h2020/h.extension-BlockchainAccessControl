import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:helios_access_control_ui/extensions/extensions.dart';
import 'package:helios_access_control_ui/model/Authentication.dart';
import 'package:helios_access_control_ui/model/Content.dart';
import 'package:helios_access_control_ui/model/Group.dart';
import 'package:helios_access_control_ui/model/Notifications.dart';
import 'package:helios_access_control_ui/model/Request.dart';
import 'package:helios_access_control_ui/model/Resource.dart';
import 'package:helios_access_control_ui/repository/datasources/file/ResourceFileInteractor.dart';
import 'package:helios_access_control_ui/repository/datasources/remote/DioClient.dart';
import 'package:helios_access_control_ui/repository/datasources/remote/Remote.dart';
import 'package:helios_access_control_ui/repository/datasources/remote/dto/authentication/UserLoginRequestDto.dart';
import 'package:helios_access_control_ui/repository/datasources/remote/dto/authentication/UserLoginResponseDto.dart';
import 'package:helios_access_control_ui/repository/datasources/remote/dto/authentication/UserRegisterRequestDto.dart';
import 'package:helios_access_control_ui/repository/datasources/remote/dto/authentication/UserRegisterResponseDto.dart';
import 'package:helios_access_control_ui/repository/datasources/remote/dto/groups/CreateGroupRequestDto.dart';
import 'package:helios_access_control_ui/repository/datasources/remote/dto/groups/DeleteGroupRequestDto.dart';
import 'package:helios_access_control_ui/repository/datasources/remote/dto/groups/GroupsListDto.dart';
import 'package:helios_access_control_ui/repository/datasources/remote/dto/request/CreateAccessRequestDto.dart';
import 'package:helios_access_control_ui/repository/datasources/remote/dto/request/GetAccessRequestResponseDto.dart';
import 'package:helios_access_control_ui/repository/datasources/remote/dto/resources/GetResourceResponseDto.dart';
import 'package:helios_access_control_ui/repository/datasources/remote/dto/resources/ResourcesListDto.dart';

import 'dto/request/CreateRequestResponseDto.dart';

class HeliosRemoteImpl implements HeliosRemote {
  final DioClient dioClient;
  final ResourceFilesInteractor resourceFileInteractor;

  static const String HELIOS_ENDPOINT = "http://192.168.1.128:8080";

  //static const String HELIOS_ENDPOINT = "http://192.168.1.136:8080";

  HeliosRemoteImpl(this.dioClient, this.resourceFileInteractor);

  static const String REGISTER_URL = "$HELIOS_ENDPOINT/register";
  static const String LOGIN_URL = "$HELIOS_ENDPOINT/login";
  static const String GET_ALL_RESOURCES_URL = "$HELIOS_ENDPOINT/resource";
  static const String CREATE_RESOURCE_URL = "$HELIOS_ENDPOINT/resource";
  static const String CREATE_GROUP_URL = "$HELIOS_ENDPOINT/group";
  static const String DELETE_GROUP_URL = "$HELIOS_ENDPOINT/group";
  static const String GET_ALL_GROUPS_URL = "$HELIOS_ENDPOINT/group";
  static const String CREATE_ACCESS_REQUEST_URL = "$HELIOS_ENDPOINT/request";
  static const String GET_ACCESS_REQUESTS_URL = "$HELIOS_ENDPOINT/request";
  static const String GET_RESOURCE_URL = "$HELIOS_ENDPOINT/resource";

  String _grantAccessRequestUrl(int requestId) {
    return "$HELIOS_ENDPOINT/request/$requestId/grant";
  }

  String _rejectAccessUrl(int requestId) {
    return "$HELIOS_ENDPOINT/request/$requestId/deny";
  }

  @override
  Future<UserRegisterResponse> registerUser(
      UserRegisterRequest userRegisterRequest) async {
    String bodyJsonRequest =
        json.encode(UserRegisterRequestDto.fromModel(userRegisterRequest));

    UserRegisterResponse userRegisterResponse;
    try {
      var remoteResponse = await dioClient.post(REGISTER_URL,
          body: bodyJsonRequest,
          options: Options(
            headers: {
              "Content-Type": "application/json",
            },
          ));
      if (remoteResponse.statusCode == HttpStatus.ok) {
        userRegisterResponse =
            UserRegisterResponseDto.fromJson(remoteResponse.data).toModel();
      } else {
        userRegisterResponse = UserRegisterResponse.registerFailedResponse();
      }
    } catch (e) {
      userRegisterResponse = UserRegisterResponse.registerFailedResponse();
    }
    return Future.value(userRegisterResponse);
  }

  @override
  Future<UserLoginResponse> login(UserLoginRequest userLoginRequest) async {
    String bodyJsonRequest =
        json.encode(UserLoginRequestDto.fromModel(userLoginRequest));

    UserLoginResponse userLoginResponse;
    try {
      var remoteResponse = await dioClient.post(LOGIN_URL,
          body: bodyJsonRequest,
          options: Options(
            headers: {
              "Content-Type": "application/json",
            },
          ));
      if (remoteResponse.statusCode == HttpStatus.ok) {
        userLoginResponse =
            UserLoginResponseDto.fromJson(remoteResponse.data).toModel();
      } else {
        userLoginResponse = UserLoginResponse.loginFailedResponse();
      }
    } catch (e) {
      userLoginResponse = UserLoginResponse.loginFailedResponse();
    }
    return Future.value(userLoginResponse);
  }

  @override
  Future<List<Content>> getContents() async {
    List<Content> contentList = [];
    try {
      var remoteResponse = await dioClient.get(GET_ALL_RESOURCES_URL,
          options: Options(
            headers: {
              "requiresToken": "true",
            },
          ));
      if (remoteResponse.statusCode == HttpStatus.ok) {
        contentList = ResourcesListDto.fromJson(remoteResponse.data).toModel();
      }
    } catch (e) {
      print(e);
    }
    return contentList;
  }

  @override
  Future<Resource> getResource(Content content) async {
    Resource resource;
    try {
      String resourcesDir =
          await resourceFileInteractor.createResourcesPathIfNotExists();
      String localPath = "${resourcesDir}/${content.id}";
      Response remoteResponse =
          await dioClient.download("$GET_RESOURCE_URL/${content.id}", localPath,
              options: Options(
                headers: {
                  "requiresToken": "true",
                },
                responseType: ResponseType.bytes,
              ));
      if (remoteResponse.statusCode == HttpStatus.ok) {
        String contentType = remoteResponse.headers.value("Content-Type");
        String fileExtension = extensionFromMime(contentType);
        File file =
            await File(localPath).rename("${localPath}.${fileExtension}");
        resource = GetResourceResponseDto(localPath: file.path).toModel();
      }
    } catch (e) {
      resource = Resource.notAccessible();
    }
    return resource;
  }

  @override
  Future<List<Group>> getAllGroups() async {
    List<Group> contentList = [];
    try {
      var remoteResponse = await dioClient.get(GET_ALL_GROUPS_URL,
          options: Options(
            headers: {
              "requiresToken": "true",
            },
          ));
      if (remoteResponse.statusCode == HttpStatus.ok) {
        contentList = GroupsListDto.fromJson(remoteResponse.data).toModel();
      }
    } catch (e) {
      print(e);
    }
    return contentList;
  }

  @override
  Future<CreateRequestResponse> createAccessRequest(Content content) async {
    String bodyJsonRequest =
        json.encode(CreateAccessRequestDto.fromModel(content));

    CreateRequestResponse createRequestResponse;
    try {
      var remoteResponse = await dioClient.post(CREATE_ACCESS_REQUEST_URL,
          body: bodyJsonRequest,
          options: Options(
            headers: {
              "requiresToken": "true",
              "Content-Type": "application/json",
            },
          ));
      if (remoteResponse.statusCode == HttpStatus.ok) {
        createRequestResponse =
            CreateRequestResponseDto.fromJson(remoteResponse.data).toModel();
      }
    } catch (e) {
      print(e);
      createRequestResponse = CreateRequestResponse.failedResponse();
    }
    return createRequestResponse;
  }

  @override
  Future<bool> grantAccessRequest(AppNotification appNotification) async {
    bool granted = false;
    try {
      Response remoteResponse =
          await dioClient.put(_grantAccessRequestUrl(appNotification.id),
              options: Options(
                headers: {
                  "requiresToken": "true",
                },
              ));
      if (remoteResponse.statusCode == HttpStatus.ok) {
        granted = true;
      }
    } catch (e) {
      //Not granted
    }
    return granted;
  }

  @override
  Future<bool> rejectAccessResponse(AppNotification appNotification) async {
    bool rejected = false;
    try {
      Response remoteResponse =
          await dioClient.put(_rejectAccessUrl(appNotification.id),
              options: Options(
                headers: {
                  "requiresToken": "true",
                },
              ));
      if (remoteResponse.statusCode == HttpStatus.ok) {
        rejected = true;
      }
    } catch (e) {
      //Not rejected
    }
    return rejected;
  }

  @override
  Future<List<AppNotification>> getNotifications(
      NotificationStatus notificationStatus) async {
    List<AppNotification> accessRequests = [];
    try {
      var remoteResponse = await dioClient.get(GET_ACCESS_REQUESTS_URL,
          options: Options(
            headers: {
              "requiresToken": "true",
            },
          ),
          queryParameters: {
            "status": notificationStatus.asString,
          });
      if (remoteResponse.statusCode == HttpStatus.ok) {
        return List<AppNotification>.from(remoteResponse.data
            .map((e) => GetAccessRequestResponseDto.fromJson(e).toModel())
            .toList());
      }
    } catch (e) {
      print(e);
    }
    return accessRequests;
  }

  @override
  Future<bool> createResource(UploadResource uploadResource) async {
    bool success = false;
    String type;
    if (uploadResource.isImage()) {
      type = "IMAGE";
    } else if (uploadResource.isVideo()) {
      type = "VIDEO";
    } else if (uploadResource.isDocument()) {
      type = "DOCUMENT";
    }

    try {
      FormData data = FormData.fromMap(
        {
          "file": await MultipartFile.fromFile(
            uploadResource.path,
            filename: uploadResource.fileName,
          ),
          "label": uploadResource.title,
          "type": type,
          "accessType":
              uploadResource.accessType.getDescription().toUpperCase(),
          "groupId": uploadResource.groupId
        },
      );

      var response = await dioClient.post(
        CREATE_RESOURCE_URL,
        body: data,
        options: Options(
          headers: {
            "requiresToken": "true",
          },
        ),
      );
      if (response.statusCode == HttpStatus.ok) {
        success = true;
      } else {
        success = false;
      }
    } catch (e) {
      success = false;
    }
    return success;
  }

  @override
  Future<bool> createGroup(Group group) async {
    String bodyJsonRequest =
        json.encode(CreateGroupRequestDto.fromModel(group));

    bool success = false;
    try {
      var remoteResponse = await dioClient.post(CREATE_GROUP_URL,
          body: bodyJsonRequest,
          options: Options(
            headers: {
              "requiresToken": "true",
              "Content-Type": "application/json",
            },
          ));
      if (remoteResponse.statusCode == HttpStatus.ok) {
        success = true;
      } else {
        success = false;
      }
    } catch (e) {
      success = false;
    }
    return success;
  }

  @override
  Future<bool> deleteGroupById(String groupId) async {
    String bodyJsonRequest =
        json.encode(DeleteGroupRequestDto.fromModel(groupId));

    bool success = false;
    try {
      var remoteResponse = await dioClient.delete(DELETE_GROUP_URL,
          body: bodyJsonRequest,
          options: Options(
            headers: {
              "requiresToken": "true",
              "Content-Type": "application/json",
            },
          ));
      if (remoteResponse.statusCode == HttpStatus.ok) {
        success = true;
      } else {
        success = false;
      }
    } catch (e) {
      success = false;
    }
    return success;
  }
}
