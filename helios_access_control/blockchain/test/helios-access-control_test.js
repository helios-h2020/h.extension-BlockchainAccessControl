const HeliosAccessControl = artifacts.require("HeliosAccessControl");
const truffleAssert = require("truffle-assertions");

contract("HeliosAccessControl", accounts => {
    const requester = accounts[0];
    const owner = accounts[1];
    const contentProvider = accounts[2];
    const fakeOwner = accounts[3];
    const resourceUri = "cc5843e636526f5283bd9eca0d08d726879da1edb711d52443dbd2253cb813d6";
    const incorrectUri = "cc5843e636526f5283bd9eca0d08";
    const accessKey = "accessKey";
    const incorrectKey = "incorrectKey";
    const errors = {
        REQUEST_ALREADY_EXISTS: 0,
        REQUEST_NOT_EXISTS: 1,
        REQUEST_OTHER_GRANTER: 2,
        REQUEST_ALREADY_ACCEPTED: 3,
        REQUEST_ALREADY_REJECTED: 4,
        REQUEST_ACCEPTED_OTHER_GRANTER: 5,
        REQUEST_REJECTED_OTHER_GRANTER: 6,
        ACCESS_KEY_INCORRECT_KEY: 7
    };
    const events = {
        RequestCreated: "RequestCreated",
        RequestAccepted: "RequestAccepted",
        RequestRejected: "RequestRejected",
        AccessKeyUpdated: "AccessKeyUpdated"
    };
    const status = {
        PENDING: 0,
        ACCEPTED: 1,
        REJECTED: 2
    }
    let instance;

    before(async () => {
        instance = await HeliosAccessControl.deployed();
    });

    it("should set an access key", async () => {
        let transaction = await instance.setAccessKey(accessKey, { from: requester });

        truffleAssert.eventEmitted(transaction, events.AccessKeyUpdated, (event) => {
            return event.from === requester;
        });
    });

    it("should create an access request", async () => {
        let transaction = await instance.createAccessRequest(resourceUri, { from: requester });

        truffleAssert.eventEmitted(transaction, events.RequestCreated, (event) => {
            return event.requester === requester;
        });
    });

    it("should raise an already exists error when creating a request", async () => {
        try {
            await instance.createAccessRequest(resourceUri, { from: requester });
        } catch (error) {
            assert(error, "Expected an error but did not get one");
            assert(error.message.includes("revert " + errors.REQUEST_ALREADY_EXISTS), "Expected error " + errors.REQUEST_ALREADY_EXISTS + " but got: " + error.message);
        }
    });

    it("should check if access request is pending", async () => {
        let state = await instance.checkAccessRequest(requester, owner, resourceUri, accessKey, { from: contentProvider });
        assert(state == status.PENDING, "Expected status " + status.PENDING + " but got: " + state);
    });

    it("should raise an incorrect key error when checking a request", async () => {
        try {
            await instance.checkAccessRequest(requester, owner, resourceUri, incorrectKey, { from: contentProvider });
        } catch (error) {
            assert(error, "Expected an error but did not get one");
            assert(error.message.includes("revert " + errors.ACCESS_KEY_INCORRECT_KEY), "Expected error " + errors.ACCESS_KEY_INCORRECT_KEY + " but got: " + error.message);
        }
    });

    it("should raise a not exists error when checking a request", async () => {
        try {
            await instance.checkAccessRequest(requester, owner, incorrectUri, accessKey, { from: contentProvider });
        } catch (error) {
            assert(error, "Expected an error but did not get one");
            assert(error.message.includes("revert " + errors.REQUEST_NOT_EXISTS), "Expected error " + errors.REQUEST_NOT_EXISTS + " but got: " + error.message);
        }
    });

    it("should raise an other granter error when checking a request", async () => {
        try {
            await instance.checkAccessRequest(requester, fakeOwner, resourceUri, accessKey, { from: contentProvider });
        } catch (error) {
            assert(error, "Expected an error but did not get one");
            assert(error.message.includes("revert " + errors.REQUEST_OTHER_GRANTER), "Expected error " + errors.REQUEST_OTHER_GRANTER + " but got: " + error.message);
        }
    });

    it("should accept a request", async () => {
        let transaction = await instance.acceptAccessRequest(requester, resourceUri, { from: owner });

        truffleAssert.eventEmitted(transaction, events.RequestAccepted, (event) => {
            return event.granter === owner && event.requester === requester;
        });
    });

    it("should raise a not exists error when accepting a request", async () => {
        try {
            await instance.acceptAccessRequest(requester, incorrectUri, { from: owner });
        } catch (error) {
            assert(error, "Expected an error but did not get one");
            assert(error.message.includes("revert " + errors.REQUEST_NOT_EXISTS), "Expected error " + errors.REQUEST_NOT_EXISTS + " but got: " + error.message);
        }
    });

    it("should raise an already accepted error when accepting a request", async () => {
        try {
            await instance.acceptAccessRequest(requester, resourceUri, { from: owner });
        } catch (error) {
            assert(error, "Expected an error but did not get one");
            assert(error.message.includes("revert " + errors.REQUEST_ALREADY_ACCEPTED), "Expected error " + errors.REQUEST_ALREADY_ACCEPTED + " but got: " + error.message);
        }
    });

    it("should check if access request is accepted", async () => {
        let state = await instance.checkAccessRequest(requester, owner, resourceUri, accessKey, { from: contentProvider });
        assert(state == status.ACCEPTED, "Expected status " + status.ACCEPTED + " but got: " + state);
    });

    it("should raise an accepted by other granter error when rejecting a request", async () => {
        try {
            await instance.rejectAccessRequest(requester, resourceUri, { from: fakeOwner });
        } catch(error) {
            assert(error, "Expected an error but did not get one");
            assert(error.message.includes("revert " + errors.REQUEST_ACCEPTED_OTHER_GRANTER), "Expected error " + errors.REQUEST_ACCEPTED_OTHER_GRANTER + " but got: " + error.message);
        }
    });

    it("should reject a request", async () => {
        let transaction = await instance.rejectAccessRequest(requester, resourceUri, { from: owner });

        truffleAssert.eventEmitted(transaction, events.RequestRejected, (event) => {
            return event.granter === owner && event.requester === requester;
        });
    });

    it("should raise a not exists error when rejecting a request", async () => {
        try {
            await instance.rejectAccessRequest(requester, incorrectUri, { from: owner });
        } catch(error) {
            assert(error, "Expected an error but did not get one");
            assert(error.message.includes("revert " + errors.REQUEST_NOT_EXISTS), "Expected error " + errors.REQUEST_NOT_EXISTS + " but got: " + error.message);
        }
    });

    it("should raise an already rejected error when rejecting a request", async () => {
        try {
            await instance.rejectAccessRequest(requester, resourceUri, { from: owner });
        } catch(error) {
            assert(error, "Expected an error but did not get one");
            assert(error.message.includes("revert " + errors.REQUEST_ALREADY_REJECTED), "Expected error " + errors.REQUEST_ALREADY_REJECTED + " but got: " + error.message);
        }
    });

    it("should check if access request is rejected", async () => {
        let state = await instance.checkAccessRequest(requester, owner, resourceUri, accessKey, { from: contentProvider });
        assert(state == status.REJECTED, "Expected status " + status.REJECTED + " but got: " + state);
    });

    it("should raise a rejected by other granted error when accepting a request", async () => {
        try {
            await instance.acceptAccessRequest(requester, resourceUri, { from: fakeOwner });
        } catch (error) {
            assert(error, "Expected an error but did not get one");
            assert(error.message.includes("revert " + errors.REQUEST_REJECTED_OTHER_GRANTER), "Expected error " + errors.REQUEST_REJECTED_OTHER_GRANTER + " but got: " + error.message);
        }
    });

    it("should reset a request", async () => {
        let transaction = await instance.resetAccessRequest(resourceUri, { from: requester });

        truffleAssert.eventEmitted(transaction, events.RequestCreated, (event) => {
            return event.requester === requester;
        });
    });

    it("should check if reset request is pending", async () => {
        let state = await instance.checkAccessRequest(requester, owner, resourceUri, accessKey, { from: contentProvider });
        assert(state == status.PENDING, "Expected status " + status.PENDING + " but got: " + state);
    });

    it("should accept a reset request", async () => {
        let transaction = await instance.acceptAccessRequest(requester, resourceUri, { from: owner });

        truffleAssert.eventEmitted(transaction, events.RequestAccepted, (event) => {
            return event.granter === owner && event.requester === requester;
        });
    });

});
