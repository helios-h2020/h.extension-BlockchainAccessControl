// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.5;

import "@openzeppelin/contracts/utils/Strings.sol";

contract HeliosAccessControl {

    using Strings for uint;

    enum RequestStatus {
        PENDING, // 0
        ACCEPTED, // 1
        REJECTED  // 2
    }

    enum ErrorCode {
        REQUEST_ALREADY_EXISTS, // 0
        REQUEST_NOT_EXISTS, // 1
        REQUEST_OTHER_GRANTER, // 2
        REQUEST_ALREADY_ACCEPTED, // 3
        REQUEST_ALREADY_REJECTED, // 4
        REQUEST_ACCEPTED_OTHER_GRANTER, // 5
        REQUEST_REJECTED_OTHER_GRANTER, // 6
        ACCESS_KEY_INCORRECT_KEY        // 7
    }

    struct AccessRequest {
        address requester;
        address granter;
        RequestStatus status;
    }

    mapping (address => bytes32) internal _accessKeysMap;
    mapping (address => mapping (bytes32 => AccessRequest)) internal _accessRequestsMap;

    event RequestCreated(address indexed requester);
    event RequestAccepted(address indexed granter, address indexed requester);
    event RequestRejected(address indexed granter, address indexed requester);
    event AccessKeyUpdated(address indexed from);

    function setAccessKey(string calldata accessKey) external {
        _accessKeysMap[msg.sender] = keccak256(abi.encodePacked(accessKey));

        emit AccessKeyUpdated(msg.sender);
    }

    function createAccessRequest(string calldata resourceUri) external {
        bytes32 hashedResourceUri = keccak256(abi.encodePacked(resourceUri));
        AccessRequest storage accessRequest = _accessRequestsMap[msg.sender][hashedResourceUri];
        require(accessRequest.requester == address(0), uint(ErrorCode.REQUEST_ALREADY_EXISTS).toString());
        accessRequest.requester = msg.sender;
        accessRequest.status = RequestStatus.PENDING;

        emit RequestCreated(msg.sender);
    }

    function checkAccessRequest(address requester, address resourceOwner, string calldata resourceUri, string calldata requesterAccessKey) external view returns (RequestStatus) {
        bytes32 hashedAccessKey = keccak256(abi.encodePacked(requesterAccessKey));
        bytes32 hashedResourceUri = keccak256(abi.encodePacked(resourceUri));
        require(hashedAccessKey == _accessKeysMap[requester], uint(ErrorCode.ACCESS_KEY_INCORRECT_KEY).toString());
        AccessRequest storage accessRequest = _accessRequestsMap[requester][hashedResourceUri];
        require(accessRequest.requester != address(0), uint(ErrorCode.REQUEST_NOT_EXISTS).toString());
        if (accessRequest.status != RequestStatus.PENDING) {
            require(accessRequest.granter == resourceOwner, uint(ErrorCode.REQUEST_OTHER_GRANTER).toString());
        }
        return accessRequest.status;
    }

    function acceptAccessRequest(address requester, string calldata resourceUri) external {
        bytes32 hashedResourceUri = keccak256(abi.encodePacked(resourceUri));
        AccessRequest storage accessRequest = _accessRequestsMap[requester][hashedResourceUri];
        require(accessRequest.requester != address(0), uint(ErrorCode.REQUEST_NOT_EXISTS).toString());
        require(accessRequest.status != RequestStatus.ACCEPTED, uint(ErrorCode.REQUEST_ALREADY_ACCEPTED).toString());
        if (accessRequest.status == RequestStatus.REJECTED) {
            require(accessRequest.granter == msg.sender, uint(ErrorCode.REQUEST_REJECTED_OTHER_GRANTER).toString());
        }
        accessRequest.granter = msg.sender;
        accessRequest.status = RequestStatus.ACCEPTED;

        emit RequestAccepted(msg.sender, requester);
    }

    function rejectAccessRequest(address requester, string calldata resourceUri) external {
        bytes32 hashedResourceUri = keccak256(abi.encodePacked(resourceUri));
        AccessRequest storage accessRequest = _accessRequestsMap[requester][hashedResourceUri];
        require(accessRequest.requester != address(0), uint(ErrorCode.REQUEST_NOT_EXISTS).toString());
        require(accessRequest.status != RequestStatus.REJECTED, uint(ErrorCode.REQUEST_ALREADY_REJECTED).toString());
        if (accessRequest.status == RequestStatus.ACCEPTED) {
            require(accessRequest.granter == msg.sender, uint(ErrorCode.REQUEST_ACCEPTED_OTHER_GRANTER).toString());
        }
        accessRequest.granter = msg.sender;
        accessRequest.status = RequestStatus.REJECTED;

        emit RequestRejected(msg.sender, requester);
    }

    function resetAccessRequest(string calldata resourceUri) external {
        bytes32 hashedResourceUri = keccak256(abi.encodePacked(resourceUri));
        AccessRequest storage accessRequest = _accessRequestsMap[msg.sender][hashedResourceUri];
        require(accessRequest.requester != address(0), uint(ErrorCode.REQUEST_NOT_EXISTS).toString());
        accessRequest.requester = msg.sender;
        accessRequest.status = RequestStatus.PENDING;
        accessRequest.granter = address(0);

        emit RequestCreated(msg.sender);
    }

}
