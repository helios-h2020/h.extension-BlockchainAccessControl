[![nps friendly](https://img.shields.io/badge/nps-friendly-blue.svg?style=flat-square)](https://github.com/kentcdodds/nps)

# Getting started

1. Go to project folder and create a configuration file .env following this example:
```properties
DEVELOPMENT_MNEMONIC="here you must place 12 different words"
DEVELOPMENT_HOST="127.0.0.1"
DEVELOPMENT_PORT=8545
DEVELOPMENT_NETWORKID=123456
```

2. Install dependencies :
```sh
npm install
```

3. Start ganache
```sh
npm start ganache_nodb
```

4. Launch automated truffle tests over smart contracts
```sh
npm start test
```

5. Launch development task in order to deploy on blockchain (ethereum) new version of contracts:
```sh
npm start development
```

# Project structure

```
build/                        Local storage for deployed contracts.
contracts/                    Contracts source code
migrations/                   Truffle migrations scripts
test/                         Truffle tests
```

# Main tasks

Task automation is based on [NPM scripts](https://docs.npmjs.com/misc/scripts).

Task | Description
-|-
`npm start ganache_nodb` | Start a local blockchain with no persistence
`npm start ganache` | Start a local blockchain with persistence
`npm start test`| Launch automated truffle test
`npm start development` | Launch development task in order to deploy on blockchain
