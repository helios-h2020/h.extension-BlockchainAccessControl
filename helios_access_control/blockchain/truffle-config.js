const HDWalletProvider = require("@truffle/hdwallet-provider");
require('dotenv').config();

module.exports = {
    compilers: {
        solc: {
            version: "0.7.5+commit.eb77ed08.Emscripten.clang",
            settings: {
                optimizer: {
                    enabled: true,
                    runs: 200
                }
            }
        }
    },
    networks: {
        development: {
            host: "192.168.1.128",
            port: 8545,
            network_id: "*",
            gasPrice: 0,
        },
        alastria: {
            provider: () => new HDWalletProvider(process.env.ALASTRIA_MNEMONIC, process.env.ALASTRIA_URL),
            network_id: "83584648538",
            gasPrice: 0,
            type: "quorum"
        },
    }
};