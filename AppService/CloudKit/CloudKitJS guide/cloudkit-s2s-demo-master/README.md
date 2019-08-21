在 2014 年 Apple 推出了 **CloudKit**，能让开发者们直接使用一系列接口来创建基于 iCloud 托管数据的 app，但是一开始推出 CloudKit 只能允许开发者们通过使用 CloudKit framework 来使用 CloudKit 接口，随后，Apple 又继续推出 **CloudKit Web Services**，允许直接通过 HTTPS+JSON 的方式来访问 CloudKit 接口，再然后，Apple 还提供了 **CloudKit JS**，允许开发者直接使用 CloudKit JS 提供的一些 REST API 来直接操作 CloudKit 数据库，轻松创建基于 iCloud 的 Web app. 它所提供的功能除了基本的对数据库的 CRUD 操作之外，还提供了使用 iCloud 账号体系的能力，同时包括对 CloudKit 数据库操作的一些订阅和通知功能。再随后，随之 CloudKit 支持 **server-to-server** 的操作，便能够有这个想法的诞生，让你可以通过 CloudKit 来存储区块链加密货币的实时行情数据。

区块链现在有多火自然不用说，绝大部分现在的行情都是用了 [CoinmarketCap](https://coinmarketcap.com) 的数据，之前我用 Swift 对其提供的 API 进行了一下简单的封装（具体代码可以在 [Github](https://github.com/iCell/CryptoCurrencyKit) 上见到），也直接使用这个 API 自己写了个 macOS 的行情 app 叫做 [Pistis](https://itunes.apple.com/tr/app/pistis/id1290746332?mt=12&ign-mpt=uo%3D2)，不过这次我们就直接用 **CloudKit JS** 来写一个实时抓取 [CoinmarketCap](https://coinmarketcap.com) 行情数据并存储到 **CloudKit** 数据库上的脚本。

### 准备工作

想使用 **CloudKit**，自然是需要一个 Apple Developer 的账户的。然后呢随意创建一个 macOS 或者 iOS 的 app，在 Capability 中打开 iCloud 功能，然后创建一个 **CloudKit Container**，然后进入 Dashboard 进行操作（具体关于 CloudKit 的一些概念这里就不多说了，这次主要讲 CloudKit JS，如有不清楚可先查看一些 [CloudKit](https://developer.apple.com/documentation/cloudkit) 文档）。我们在 Dashboard 进入 Data 选项，在 Record Type 一栏创建新的 Record，这里取名叫 ```CryptoCurrency```，然后增加一些 Field，然后对某些需要进行索引、查询、排序的字段增加相应的操作权限，我所做的操作如下图所示：

然后呢，我们既然是写脚本来操作 **CloudKit** 数据库，肯定是要获取权限的。在 Dashboard 的 API Access 中，生成一个 server-to-server 的 key，生成 key 的过程中会有一个 eckey.pem 的文件，保留这个文件之后要用到。

紧接着在 Data 中的 Security Roles 一栏中，要将刚刚创建的 ```CryptoCurrency``` 增加访问权限，在 **CloudKit** 中有三种不同的访问类别，分别是：

* **World**：代表不管你是不是 iCloud 用户，所有人都能访问
* **Authenticated**：只有登陆了 iCloud 的用户才能访问
* **Creator**：登陆了 iCloud 的用户，只能查看自己所创建的数据库纪录，别人创建的数据库纪录是没有查看权限的

这里因为我们的行情数据是想让所有人都能看到，所以选择了 World. 至此，准备工作就绪。

### 创建项目

我们创建一个 JS 的项目，可以直接执行 `npm init` 命令，然后在 `package.json` 文件中的 `scripts` 下增加一个脚本：


```JavaScript
"scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "install-cloudkit-js": "curl https://cdn.apple-cloudkit.com/ck/1/cloudkit.js > src/cloudkit.js"
  },
```

然后在命令行中输入 `npm run install-cloudkit-js` 即可将 ```cloudkit.js``` 文件下载到我们的项目中。

使用 **CloudKit JS** 都是直接使用 ```Promise``` 的方式进行 API 的请求的，另外我们需要使用 CoinmarketCap 提供的 API 数据，所以我们需要使用 ```fetch``` 来作为网络库：

```
npm install --save node-fetch
```

然后呢，我们把之前生成 server-to-server key 中的 ```eckey.pem``` 文件保存到项目的根目录中来，继续创建一个名为 `config.js` 的文件，作为 CloudKit JS 的配置文件：

``` JavaScript
module.exports = {
  containerIdentifier:'iCloud.xxx.xxx',

  environment: 'development',

  serverToServerKeyAuth: {
    keyID: 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
    privateKeyFile: __dirname + '/eckey.pem'
  }
};
```

上面的 containerIdentifier 是用一开始创建 macOS 或者 iOS app 是生成 ```Container``` 是的那个名称，必须是以 iCloud 开头的，keyID 的话就用之前在 Dashboard 中生成的 key.

我们继续再创建一个文件叫做 ```app.js``` ，用来编写我们该脚本的实现代码。在 ```app.js``` 中我们先 import 所需要的一些库和文件：

``` JavaScript
const fetch = require('node-fetch');
const CloudKit = require('./cloudkit');
const containerConfig = require('./config');
```

至此，项目创建且配置完成。

### 项目实现

#### 获取 CoinmarketCap 数据

这个很简单，直接使用 `fetch` 即可：

```
const url = "https://api.coinmarketcap.com/v1/ticker/?limit=0";
//return Promise
fetch(url);
```

#### 获取 CloudKit 授权：

我们需要根据 `config.js` 中的配置信息，获取到 **CloudKit** 的授权：

``` JavaScript
//1
CloudKit.configure({
    services: {
        fetch: fetch,
        logger: console
    },
    containers: [ containerConfig ]
});

const container = CloudKit.getDefaultContainer();
const database = container.publicCloudDatabase;

//2
container.setUpAuth()
```

1. 直接使用 CloudKit 提供的 configure 方法，传入相应的参数即可；
2. 调用 setUpAuth 方法，获取授权，此方法返回的是一个 Promise；

#### 数据库操作

必须要获取授权后，才能执行数据库操作，这里先简单介绍一下几个常用的操作。首先是查询：

```
let query = { recordType: 'CryptoCurrency' };
// return Promise
database.performQuery(query);
```

然后是保存 record 操作，必须要按下列的格式进行 JSON 数据的封装，recordType 可以理解为表的名字，recordName 为每个 record 的唯一 id，fields 中是每个 record 的自定义信息，每条信息需要将值封装在 value 字段中：

```
let record = {
            recordType: 'CryptoCurrency',
            recordName: 'Name',
            fields: {
                id: { value: 'id' },
                name: { value: 'name' },
                symbol: { value: 'symbol' },
            }
//return Promise
database.saveRecords(record)
```

如果是修改操作的话，需要先进行查询操作，查询返回的 records 结果中，每一条 record 会有一个 ```recordChangeTag``` 字段，需要将该字段作为 key 添加到要更新的数据中。类似下面方法来更新数据：

```
let queriedRecord = {
            recordType: 'CryptoCurrency',
            recordChangeTag: 'a tag'
            recordName: 'Name',
            fields: {
                id: { value: 'id' },
                name: { value: 'old name' },
                symbol: { value: 'old symbol' },
            }
let newRecord = {
            recordType: 'CryptoCurrency',
            recordChangeTag: 'a tag'
            recordName: 'Name',
            fields: {
                id: { value: 'id' },
                name: { value: 'new name' },
                symbol: { value: 'new symbol' },
            }
//return Promise
database.saveRecords(newRecord)
```

#### 最终实现

有了上面几个方法的铺垫，我们实现起来就很简单了。我们是从 CoinmarketCap 中获取到数据，再存储到 **CloudKit** 数据库中，由于两者数据格式不太一致，所以我们先写一个方法对数据做一下处理：

```JavaScript
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
```

然后获取 **CloudKit** 授权，同时获取 CoinmarketCap 的数据：

```JavaScript
const url = "https://api.coinmarketcap.com/v1/ticker/?limit=0";
    
Promise.all([fetch(url), container.setUpAuth()]).then(function(response) {
    let firstV = response[0].json();
    let query = { recordType: 'CryptoCurrency' };
    let secondV = database.performQuery(query);
    return Promise.all([firstV, secondV]);
})
...
```

再获取到数据之后，我们执行了 query 操作，然后：

```JavaScript
...
.then(function(response) {
        let responseRecords = convert(response[0]);
        let queryRecords = response[1].records;

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
    })
```

然后我们对 query 所返回的结果同 CoinmarketCap 获取到的结果进行匹配，拿到 recordChangeTag，对数据做更新，然后通过 Promise.all 对所有的数据进行保存。这样就能够将所有的数据添加到 CloudKit 的数据库中了。我们这个时候可以去 Dashboard 中的 Records 一栏进行查询操作，看看数据是否成功保存。