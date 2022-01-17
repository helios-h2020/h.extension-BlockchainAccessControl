require('dotenv').config();

module.exports = {
    scripts: {
        development: 'truffle migrate --reset',
        test: 'truffle test',
        ganache: 'ganache-cli -g 0 -l 100000000 --db ganache_db   -i "' + process.env.DEVELOPMENT_NETWORKID + '" -m "' + process.env.DEVELOPMENT_MNEMONIC + '" -h "' + process.env.DEVELOPMENT_HOST + '"  -p "' + process.env.DEVELOPMENT_PORT + '" ',
        ganache_nodb: 'ganache-cli -g 0 -l 100000000 -i "' + process.env.DEVELOPMENT_NETWORKID + '" -m "' + process.env.DEVELOPMENT_MNEMONIC + '" -h "' + process.env.DEVELOPMENT_HOST + '"  -p "' + process.env.DEVELOPMENT_PORT + '" '
    }
};
