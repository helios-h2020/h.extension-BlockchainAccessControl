package com.accesscontrol.contract

import com.accesscontrol.contract.HeliosAccessControl.*
import io.reactivex.Flowable
import io.reactivex.functions.Function
import org.web3j.abi.EventEncoder
import org.web3j.abi.TypeReference
import org.web3j.abi.datatypes.Address
import org.web3j.abi.datatypes.Event
import org.web3j.abi.datatypes.Type
import org.web3j.abi.datatypes.Utf8String
import org.web3j.abi.datatypes.generated.Uint8
import org.web3j.crypto.Credentials
import org.web3j.protocol.Web3j
import org.web3j.protocol.core.DefaultBlockParameter
import org.web3j.protocol.core.RemoteCall
import org.web3j.protocol.core.methods.request.EthFilter
import org.web3j.protocol.core.methods.response.Log
import org.web3j.protocol.core.methods.response.TransactionReceipt
import org.web3j.tx.Contract
import org.web3j.tx.Contract.EventValuesWithLog
import org.web3j.tx.TransactionManager
import org.web3j.tx.gas.ContractGasProvider
import java.math.BigInteger
import java.util.*

/**
 *
 * Auto generated code.
 *
 * **Do not modify!**
 *
 * Please use the [web3j command line tools](https://docs.web3j.io/command_line.html),
 * or the org.web3j.codegen.SolidityFunctionWrapperGenerator in the
 * [codegen module](https://github.com/web3j/web3j/tree/master/codegen) to update.
 *
 *
 * Generated with web3j version 3.6.0.
 */
class HeliosAccessControl : Contract {
    companion object {
        private const val BINARY =
            "0x608060405234801561001057600080fd5b50610ec0806100206000396000f3fe608060405234801561001057600080fd5b50600436106100625760003560e01c80630ef0cc73146100675780632ea6a108146100e75780634d8f2e3b146101df57806383ae78441461024d578063a3bb6c21146102cb578063e936ea4a14610339575b600080fd5b6100e56004803603604081101561007d57600080fd5b6001600160a01b038235169190810190604081016020820135600160201b8111156100a757600080fd5b8201836020820111156100b957600080fd5b803590602001918460018302840111600160201b831117156100da57600080fd5b5090925090506103a7565b005b6101be600480360360808110156100fd57600080fd5b6001600160a01b038235811692602081013590911691810190606081016040820135600160201b81111561013057600080fd5b82018360208201111561014257600080fd5b803590602001918460018302840111600160201b8311171561016357600080fd5b919390929091602081019035600160201b81111561018057600080fd5b82018360208201111561019257600080fd5b803590602001918460018302840111600160201b831117156101b357600080fd5b50909250905061061d565b604051808260028111156101ce57fe5b815260200191505060405180910390f35b6100e5600480360360208110156101f557600080fd5b810190602081018135600160201b81111561020f57600080fd5b82018360208201111561022157600080fd5b803590602001918460018302840111600160201b8311171561024257600080fd5b509092509050610803565b6100e56004803603604081101561026357600080fd5b6001600160a01b038235169190810190604081016020820135600160201b81111561028d57600080fd5b82018360208201111561029f57600080fd5b803590602001918460018302840111600160201b831117156102c057600080fd5b509092509050610932565b6100e5600480360360208110156102e157600080fd5b810190602081018135600160201b8111156102fb57600080fd5b82018360208201111561030d57600080fd5b803590602001918460018302840111600160201b8311171561032e57600080fd5b509092509050610b63565b6100e56004803603602081101561034f57600080fd5b810190602081018135600160201b81111561036957600080fd5b82018360208201111561037b57600080fd5b803590602001918460018302840111600160201b8311171561039c57600080fd5b509092509050610bca565b6001600160a01b038316600090815260016020526040808220905184908490808383808284379190910194855250506040519283900360200190922080549093506001600160a01b031615159150610402905060015b610d0c565b9061048b5760405162461bcd60e51b81526004018080602001828103825283818151815260200191508051906020019080838360005b83811015610450578181015183820152602001610438565b50505050905090810190601f16801561047d5780820380516001836020036101000a031916815260200191505b509250505060405180910390fd5b506001600382015460ff1660028111156104a157fe5b14156104ad60036103fd565b906104f95760405162461bcd60e51b8152602060048201818152835160248401528351909283926044909101919085019080838360008315610450578181015183820152602001610438565b506002600382015460ff16600281111561050f57fe5b141561057d5760018101546001600160a01b0316331461052f60066103fd565b9061057b5760405162461bcd60e51b8152602060048201818152835160248401528351909283926044909101919085019080838360008315610450578181015183820152602001610438565b505b600180820180546001600160a01b0319163317905560038201805460ff191682800217905550836001600160a01b0316336001600160a01b03167feb283bc03cfe297cfa787201f0cace835d1bd1124b6606b981ac1e7b84aad7c8858560405180806020018281038252848482818152602001925080828437600083820152604051601f909101601f19169092018290039550909350505050a350505050565b6000808383604051602001808383808284376040805191909301818103601f19018252835280516020918201206001600160a01b038f166000908152918290529290205491955050841492506106779150600790506103fd565b906106c35760405162461bcd60e51b8152602060048201818152835160248401528351909283926044909101919085019080838360008315610450578181015183820152602001610438565b506001600160a01b038816600090815260016020526040808220905188908890808383808284379190910194855250506040519283900360200190922080549093506001600160a01b03161515915061071e905060016103fd565b9061076a5760405162461bcd60e51b8152602060048201818152835160248401528351909283926044909101919085019080838360008315610450578181015183820152602001610438565b506000600382015460ff16600281111561078057fe5b146107f05760018101546001600160a01b038981169116146107a260026103fd565b906107ee5760405162461bcd60e51b8152602060048201818152835160248401528351909283926044909101919085019080838360008315610450578181015183820152602001610438565b505b6003015460ff1698975050505050505050565b33600090815260016020526040808220905184908490808383808284379190910194855250506040519283900360200190922080549093506001600160a01b0316159150610853905060006103fd565b9061089f5760405162461bcd60e51b8152602060048201818152835160248401528351909283926044909101919085019080838360008315610450578181015183820152602001610438565b5080546001600160a01b031916331781556108be600282018484610de9565b5060038101805460ff19169055604080516020808252810184905233917fcb8fbe75484f182e2f46d0c1bb9e850905f96eb5329dea6164077f3b3e25c04091869186919081908101848480828437600083820152604051601f909101601f19169092018290039550909350505050a2505050565b6001600160a01b038316600090815260016020526040808220905184908490808383808284379190910194855250506040519283900360200190922080549093506001600160a01b03161515915061098c905060016103fd565b906109d85760405162461bcd60e51b8152602060048201818152835160248401528351909283926044909101919085019080838360008315610450578181015183820152602001610438565b506002600382015460ff1660028111156109ee57fe5b14156109fa60046103fd565b90610a465760405162461bcd60e51b8152602060048201818152835160248401528351909283926044909101919085019080838360008315610450578181015183820152602001610438565b506001600382015460ff166002811115610a5c57fe5b1415610aca5760018101546001600160a01b03163314610a7c60056103fd565b90610ac85760405162461bcd60e51b8152602060048201818152835160248401528351909283926044909101919085019080838360008315610450578181015183820152602001610438565b505b600181018054336001600160a01b0319909116811790915560038201805460ff1916600217905560408051602080825281018590526001600160a01b03871692917fd3c338e661400613dffc24cfa33da16e08eaef6d70f2f823fdb35ca019a2051b91879187919081908101848480828437600083820152604051601f909101601f19169092018290039550909350505050a350505050565b8181604051602001808383808284376040805191909301818103601f19018252808452815160209283012033600081815293849052948320559295507f8b95f9aed76851c8b68947ffa03bca9be6de7b7bfcb36dec06c3a0a7e7af7b489450925050a25050565b33600090815260016020526040808220905184908490808383808284379190910194855250506040519283900360200190922080549093506001600160a01b031615159150610c1b905060016103fd565b90610c675760405162461bcd60e51b8152602060048201818152835160248401528351909283926044909101919085019080838360008315610450578181015183820152602001610438565b5080546001600160a01b03191633178155610c86600282018484610de9565b5060038101805460ff191690556001810180546001600160a01b0319169055604080516020808252810184905233917fcb8fbe75484f182e2f46d0c1bb9e850905f96eb5329dea6164077f3b3e25c04091869186919081908101848480828437600083820152604051601f909101601f19169092018290039550909350505050a2505050565b606081610d3157506040805180820190915260018152600360fc1b6020820152610de4565b8160005b8115610d4957600101600a82049150610d35565b60608167ffffffffffffffff81118015610d6257600080fd5b506040519080825280601f01601f191660200182016040528015610d8d576020820181803683370190505b50859350905060001982015b8315610dde57600a840660300160f81b82828060019003935081518110610dbc57fe5b60200101906001600160f81b031916908160001a905350600a84049350610d99565b50925050505b919050565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282610e1f5760008555610e65565b82601f10610e385782800160ff19823516178555610e65565b82800160010185558215610e65579182015b82811115610e65578235825591602001919060010190610e4a565b50610e71929150610e75565b5090565b5b80821115610e715760008155600101610e7656fea264697066735822122049587e6449dceec5c2eaa0862207e5a915c0717dc4f0abb50561acd8de8e7fd564736f6c63430007050033"
        const val FUNC_SETACCESSKEY = "setAccessKey"
        const val FUNC_CREATEACCESSREQUEST = "createAccessRequest"
        const val FUNC_CHECKACCESSREQUEST = "checkAccessRequest"
        const val FUNC_ACCEPTACCESSREQUEST = "acceptAccessRequest"
        const val FUNC_REJECTACCESSREQUEST = "rejectAccessRequest"
        const val FUNC_RESETACCESSREQUEST = "resetAccessRequest"
        val ACCESSKEYUPDATED_EVENT = Event(
            "AccessKeyUpdated",
            Arrays.asList<TypeReference<*>>(object : TypeReference<Address?>(true) {})
        )
        val REQUESTACCEPTED_EVENT = Event(
            "RequestAccepted",
            Arrays.asList<TypeReference<*>>(
                object : TypeReference<Address?>(true) {},
                object : TypeReference<Address?>(true) {},
                object : TypeReference<Utf8String?>() {})
        )
        val REQUESTCREATED_EVENT = Event(
            "RequestCreated",
            Arrays.asList<TypeReference<*>>(
                object : TypeReference<Address?>(true) {},
                object : TypeReference<Utf8String?>() {})
        )
        val REQUESTREJECTED_EVENT = Event(
            "RequestRejected",
            Arrays.asList<TypeReference<*>>(
                object : TypeReference<Address?>(true) {},
                object : TypeReference<Address?>(true) {},
                object : TypeReference<Utf8String?>() {})
        )
        protected var _addresses: HashMap<String, String>? = null
        fun deploy(
            web3j: Web3j?,
            credentials: Credentials?,
            contractGasProvider: ContractGasProvider?
        ): RemoteCall<HeliosAccessControl> {
            return deployRemoteCall(
                HeliosAccessControl::class.java,
                web3j,
                credentials,
                contractGasProvider,
                BINARY,
                ""
            )
        }

        @Deprecated("")
        fun deploy(
            web3j: Web3j?,
            credentials: Credentials?,
            gasPrice: BigInteger?,
            gasLimit: BigInteger?
        ): RemoteCall<HeliosAccessControl> {
            return deployRemoteCall(HeliosAccessControl::class.java, web3j, credentials, gasPrice, gasLimit, BINARY, "")
        }

        fun deploy(
            web3j: Web3j?,
            transactionManager: TransactionManager?,
            contractGasProvider: ContractGasProvider?
        ): RemoteCall<HeliosAccessControl> {
            return deployRemoteCall(
                HeliosAccessControl::class.java,
                web3j,
                transactionManager,
                contractGasProvider,
                BINARY,
                ""
            )
        }

        @Deprecated("")
        fun deploy(
            web3j: Web3j?,
            transactionManager: TransactionManager?,
            gasPrice: BigInteger?,
            gasLimit: BigInteger?
        ): RemoteCall<HeliosAccessControl> {
            return deployRemoteCall(
                HeliosAccessControl::class.java,
                web3j,
                transactionManager,
                gasPrice,
                gasLimit,
                BINARY,
                ""
            )
        }

        @Deprecated("")
        fun load(
            contractAddress: String?,
            web3j: Web3j?,
            credentials: Credentials?,
            gasPrice: BigInteger?,
            gasLimit: BigInteger?
        ): HeliosAccessControl {
            return HeliosAccessControl(contractAddress, web3j, credentials, gasPrice, gasLimit)
        }

        @Deprecated("")
        fun load(
            contractAddress: String?,
            web3j: Web3j?,
            transactionManager: TransactionManager?,
            gasPrice: BigInteger?,
            gasLimit: BigInteger?
        ): HeliosAccessControl {
            return HeliosAccessControl(contractAddress, web3j, transactionManager, gasPrice, gasLimit)
        }

        fun load(
            contractAddress: String?,
            web3j: Web3j?,
            credentials: Credentials?,
            contractGasProvider: ContractGasProvider?
        ): HeliosAccessControl {
            return HeliosAccessControl(contractAddress, web3j, credentials, contractGasProvider)
        }

        fun load(
            contractAddress: String?,
            web3j: Web3j?,
            transactionManager: TransactionManager?,
            contractGasProvider: ContractGasProvider?
        ): HeliosAccessControl {
            return HeliosAccessControl(contractAddress, web3j, transactionManager, contractGasProvider)
        }

        fun getPreviouslyDeployedAddress(networkId: String): String? {
            return _addresses!![networkId]
        }

        init {
            _addresses = HashMap()
            _addresses?.let {
                it["123456"] = "0x3E8F8b081528A00A34c77A23a1D101411715B4b9"
            }
        }
    }

    @Deprecated("")
    protected constructor(
        contractAddress: String?,
        web3j: Web3j?,
        credentials: Credentials?,
        gasPrice: BigInteger?,
        gasLimit: BigInteger?
    ) : super(
        BINARY, contractAddress, web3j, credentials, gasPrice, gasLimit
    ) {
    }

    protected constructor(
        contractAddress: String?,
        web3j: Web3j?,
        credentials: Credentials?,
        contractGasProvider: ContractGasProvider?
    ) : super(
        BINARY, contractAddress, web3j, credentials, contractGasProvider
    ) {
    }

    @Deprecated("")
    protected constructor(
        contractAddress: String?,
        web3j: Web3j?,
        transactionManager: TransactionManager?,
        gasPrice: BigInteger?,
        gasLimit: BigInteger?
    ) : super(
        BINARY, contractAddress, web3j, transactionManager, gasPrice, gasLimit
    ) {
    }

    protected constructor(
        contractAddress: String?,
        web3j: Web3j?,
        transactionManager: TransactionManager?,
        contractGasProvider: ContractGasProvider?
    ) : super(
        BINARY, contractAddress, web3j, transactionManager, contractGasProvider
    ) {
    }

    fun getAccessKeyUpdatedEvents(transactionReceipt: TransactionReceipt?): List<AccessKeyUpdatedEventResponse> {
        val valueList = extractEventParametersWithLog(ACCESSKEYUPDATED_EVENT, transactionReceipt)
        val responses = ArrayList<AccessKeyUpdatedEventResponse>(valueList.size)
        for (eventValues in valueList) {
            val typedResponse = AccessKeyUpdatedEventResponse()
            typedResponse.log = eventValues.log
            typedResponse.from = eventValues.indexedValues[0].value as String
            responses.add(typedResponse)
        }
        return responses
    }

    fun accessKeyUpdatedEventFlowable(filter: EthFilter?): Flowable<AccessKeyUpdatedEventResponse> {
        return web3j.ethLogFlowable(filter).map(object : Function<Log?, AccessKeyUpdatedEventResponse> {
            override fun apply(t: Log): AccessKeyUpdatedEventResponse {
                val eventValues = extractEventParametersWithLog(ACCESSKEYUPDATED_EVENT, t)
                val typedResponse = AccessKeyUpdatedEventResponse()
                typedResponse.log = t
                typedResponse.from = eventValues.indexedValues[0].value as String
                return typedResponse
            }

        })
    }

    fun accessKeyUpdatedEventFlowable(
        startBlock: DefaultBlockParameter?,
        endBlock: DefaultBlockParameter?
    ): Flowable<AccessKeyUpdatedEventResponse> {
        val filter = EthFilter(startBlock, endBlock, getContractAddress())
        filter.addSingleTopic(EventEncoder.encode(ACCESSKEYUPDATED_EVENT))
        return accessKeyUpdatedEventFlowable(filter)
    }

    fun getRequestAcceptedEvents(transactionReceipt: TransactionReceipt?): List<RequestAcceptedEventResponse> {
        val valueList = extractEventParametersWithLog(REQUESTACCEPTED_EVENT, transactionReceipt)
        val responses = ArrayList<RequestAcceptedEventResponse>(valueList.size)
        for (eventValues in valueList) {
            val typedResponse = RequestAcceptedEventResponse()
            typedResponse.log = eventValues.log
            typedResponse.granter = eventValues.indexedValues[0].value as String
            typedResponse.requester = eventValues.indexedValues[1].value as String
            typedResponse.resourceUri = eventValues.nonIndexedValues[0].value as String
            responses.add(typedResponse)
        }
        return responses
    }

    fun requestAcceptedEventFlowable(filter: EthFilter?): Flowable<RequestAcceptedEventResponse> {
        return web3j.ethLogFlowable(filter).map(object : Function<Log?, RequestAcceptedEventResponse> {
            override fun apply(t: Log): RequestAcceptedEventResponse {
                val eventValues = extractEventParametersWithLog(REQUESTACCEPTED_EVENT, t)
                val typedResponse = RequestAcceptedEventResponse()
                typedResponse.log = t
                typedResponse.granter = eventValues.indexedValues[0].value as String
                typedResponse.requester = eventValues.indexedValues[1].value as String
                typedResponse.resourceUri = eventValues.nonIndexedValues[0].value as String
                return typedResponse
            }

        })
    }

    fun requestAcceptedEventFlowable(
        startBlock: DefaultBlockParameter?,
        endBlock: DefaultBlockParameter?
    ): Flowable<RequestAcceptedEventResponse> {
        val filter = EthFilter(startBlock, endBlock, getContractAddress())
        filter.addSingleTopic(EventEncoder.encode(REQUESTACCEPTED_EVENT))
        return requestAcceptedEventFlowable(filter)
    }

    fun getRequestCreatedEvents(transactionReceipt: TransactionReceipt?): List<RequestCreatedEventResponse> {
        val valueList = extractEventParametersWithLog(REQUESTCREATED_EVENT, transactionReceipt)
        val responses = ArrayList<RequestCreatedEventResponse>(valueList.size)
        for (eventValues in valueList) {
            val typedResponse = RequestCreatedEventResponse()
            typedResponse.log = eventValues.log
            typedResponse.requester = eventValues.indexedValues[0].value as String
            typedResponse.resourceUri = eventValues.nonIndexedValues[0].value as String
            responses.add(typedResponse)
        }
        return responses
    }

    fun requestCreatedEventFlowable(filter: EthFilter?): Flowable<RequestCreatedEventResponse> {
        return web3j.ethLogFlowable(filter).map(object : Function<Log?, RequestCreatedEventResponse> {
            override fun apply(t: Log): RequestCreatedEventResponse {
                val eventValues = extractEventParametersWithLog(REQUESTCREATED_EVENT, t)
                val typedResponse = RequestCreatedEventResponse()
                typedResponse.log = t
                typedResponse.requester = eventValues.indexedValues[0].value as String
                typedResponse.resourceUri = eventValues.nonIndexedValues[0].value as String
                return typedResponse
            }

        })
    }

    fun requestCreatedEventFlowable(
        startBlock: DefaultBlockParameter?,
        endBlock: DefaultBlockParameter?
    ): Flowable<RequestCreatedEventResponse> {
        val filter = EthFilter(startBlock, endBlock, getContractAddress())
        filter.addSingleTopic(EventEncoder.encode(REQUESTCREATED_EVENT))
        return requestCreatedEventFlowable(filter)
    }

    fun getRequestRejectedEvents(transactionReceipt: TransactionReceipt?): List<RequestRejectedEventResponse> {
        val valueList = extractEventParametersWithLog(REQUESTREJECTED_EVENT, transactionReceipt)
        val responses = ArrayList<RequestRejectedEventResponse>(valueList.size)
        for (eventValues in valueList) {
            val typedResponse = RequestRejectedEventResponse()
            typedResponse.log = eventValues.log
            typedResponse.granter = eventValues.indexedValues[0].value as String
            typedResponse.requester = eventValues.indexedValues[1].value as String
            typedResponse.resourceUri = eventValues.nonIndexedValues[0].value as String
            responses.add(typedResponse)
        }
        return responses
    }

    fun requestRejectedEventFlowable(filter: EthFilter?): Flowable<RequestRejectedEventResponse> {
        return web3j.ethLogFlowable(filter).map(object : Function<Log?, RequestRejectedEventResponse> {
            override fun apply(t: Log): RequestRejectedEventResponse {
                val eventValues = extractEventParametersWithLog(REQUESTREJECTED_EVENT, t)
                val typedResponse = RequestRejectedEventResponse()
                typedResponse.log = t
                typedResponse.granter = eventValues.indexedValues[0].value as String
                typedResponse.requester = eventValues.indexedValues[1].value as String
                typedResponse.resourceUri = eventValues.nonIndexedValues[0].value as String
                return typedResponse
            }
        })
    }

    fun requestRejectedEventFlowable(
        startBlock: DefaultBlockParameter?,
        endBlock: DefaultBlockParameter?
    ): Flowable<RequestRejectedEventResponse> {
        val filter = EthFilter(startBlock, endBlock, getContractAddress())
        filter.addSingleTopic(EventEncoder.encode(REQUESTREJECTED_EVENT))
        return requestRejectedEventFlowable(filter)
    }

    fun setAccessKey(accessKey: String?): RemoteCall<TransactionReceipt> {
        val function = org.web3j.abi.datatypes.Function(
            FUNC_SETACCESSKEY,
            Arrays.asList<Type<*>>(Utf8String(accessKey)), emptyList()
        )
        return executeRemoteCallTransaction(function)
    }

    fun createAccessRequest(resourceUri: String?): RemoteCall<TransactionReceipt> {
        val function = org.web3j.abi.datatypes.Function(
            FUNC_CREATEACCESSREQUEST,
            Arrays.asList<Type<*>>(Utf8String(resourceUri)), emptyList()
        )
        return executeRemoteCallTransaction(function)
    }

    fun checkAccessRequest(
        requester: String?,
        resourceOwner: String?,
        resourceUri: String?,
        requesterAccessKey: String?
    ): RemoteCall<BigInteger> {
        val function = org.web3j.abi.datatypes.Function(
            FUNC_CHECKACCESSREQUEST,
            Arrays.asList<Type<*>>(
                Address(requester),
                Address(resourceOwner),
                Utf8String(resourceUri),
                Utf8String(requesterAccessKey)
            ),
            Arrays.asList<TypeReference<*>>(object : TypeReference<Uint8?>() {})
        )
        return executeRemoteCallSingleValueReturn(function, BigInteger::class.java)
    }

    fun acceptAccessRequest(requester: String?, resourceUri: String?): RemoteCall<TransactionReceipt> {
        val function = org.web3j.abi.datatypes.Function(
            FUNC_ACCEPTACCESSREQUEST,
            Arrays.asList<Type<*>>(
                Address(requester),
                Utf8String(resourceUri)
            ), emptyList()
        )
        return executeRemoteCallTransaction(function)
    }

    fun rejectAccessRequest(requester: String?, resourceUri: String?): RemoteCall<TransactionReceipt> {
        val function = org.web3j.abi.datatypes.Function(
            FUNC_REJECTACCESSREQUEST,
            Arrays.asList<Type<*>>(
                Address(requester),
                Utf8String(resourceUri)
            ), emptyList()
        )
        return executeRemoteCallTransaction(function)
    }

    fun resetAccessRequest(resourceUri: String?): RemoteCall<TransactionReceipt> {
        val function = org.web3j.abi.datatypes.Function(
            FUNC_RESETACCESSREQUEST,
            Arrays.asList<Type<*>>(Utf8String(resourceUri)), emptyList()
        )
        return executeRemoteCallTransaction(function)
    }

    override fun getStaticDeployedAddress(networkId: String): String {
        return _addresses!![networkId]!!
    }

    class AccessKeyUpdatedEventResponse {
        var log: Log? = null
        var from: String? = null
    }

    class RequestAcceptedEventResponse {
        var log: Log? = null
        var granter: String? = null
        var requester: String? = null
        var resourceUri: String? = null
    }

    class RequestCreatedEventResponse {
        var log: Log? = null
        var requester: String? = null
        var resourceUri: String? = null
    }

    class RequestRejectedEventResponse {
        var log: Log? = null
        var granter: String? = null
        var requester: String? = null
        var resourceUri: String? = null
    }
}