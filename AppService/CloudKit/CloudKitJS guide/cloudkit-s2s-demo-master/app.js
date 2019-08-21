const fetch = require('node-fetch');
const CloudKit = require('./cloudkit');
const containerConfig = require('./config');

//CloudKit configuration
CloudKit.configure({
    services: {
        fetch: fetch,
        logger: console
    },
    containers: [ containerConfig ]
});

const container = CloudKit.getDefaultContainer();
const database = container.publicCloudDatabase;

function request() {
    const url = "https://api.coinmarketcap.com/v1/ticker/?limit=0";
    
    Promise.all([fetch(url), container.setUpAuth()]).then(function(response) {
        let firstV = response[0].json();
        let query = { recordType: 'CryptoCurrency' };
        let secondV = database.performQuery(query);
        return Promise.all([firstV, secondV]);
    }).then(function(response) {
        let responseRecords = convert(response[0]);
        let queryRecords = response[1].records;

        console.log('.......');
        console.log('response count ' + responseRecords.length + '; query count ' + queryRecords.length);
        console.log('.......');

        let records = responseRecords.map(function(responseRecord) {
            let r = responseRecord;
            for (let queryRecord of queryRecords) {
                if (queryRecord.recordName === r.recordName) {
                    r.recordChangeTag = queryRecord.recordChangeTag;
                    break;
                }
            }
            return database.saveRecords(r);;
        });
        return Promise.all(records);
    }).then(function(response) {
        console.log('.......');
        console.log('success' + response.length);
        console.log('.......');
    }).catch(error => {
        console.log('.......');
        console.log(error);
        console.log('.......');
    });
}

function convert(json) {
    return json.map(function(ticker) {
        return {
            recordType: 'CryptoCurrency',
            recordName: ticker.id,
            fields: {
                id: { value: ticker.id },
                name: { value: ticker.name },
                symbol: { value: ticker.symbol },
                rank: { value: parseFloat(ticker.rank) },
                marketCapUSD: { value: ticker.market_cap_usd === null ? 0 : parseFloat(ticker.market_cap_usd) },
                volumeUSD24h: { value: ticker['24h_volume_usd'] === null ? 0 : parseFloat(ticker['24h_volume_usd']) },
                availableSupply: { value: ticker.available_supply === null ? 0 : parseFloat(ticker.available_supply) },
                totalSupply: { value: ticker.total_supply === null ? 0 : parseFloat(ticker.total_supply) },
                maxSupply: { value: ticker.max_supply === null ? null : parseFloat(ticker.max_supply) },
                lastUpdated: { value: parseFloat(ticker.last_updated) * 1000 },
                percentChange1h: { value: ticker.percent_change_1h === null ? 0 : parseFloat(ticker.percent_change_1h) },
                percentChange24h: { value: ticker.percent_change_24h === null ? 0 : parseFloat(ticker.percent_change_24h) },
                percentChange7d: { value: ticker.percent_change_7d === null ? 0 : parseFloat(ticker.percent_change_7d) },
                priceBTC: { value: ticker.price_btc === null ? 0 : parseFloat(ticker.price_btc) },
                priceUSD: { value: ticker.price_usd === null ? 0 : parseFloat(ticker.price_usd) },
            }
        };
    });
}

setInterval(request, 60000);
