/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See APPLE_LICENSE.txt for this sample’s licensing information

 Abstract:
 This node script uses a server-to-server key to make public database calls with CloudKit JS
 */

/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";

(function() {
  var fetch = require('node-fetch');

  var CloudKit = require('./cloudkit');
  var containerConfig = require('./config');

  // A utility function for printing results to the console.
  var println = function(key,value) {
    console.log("--> " + key + ":");
    console.log(value);
    console.log();
  };

  //CloudKit configuration
  CloudKit.configure({
    services: {
      fetch: fetch,
      logger: console
    },
    containers: [ containerConfig ]
  });


  var container = CloudKit.getDefaultContainer();
  var database = container.publicCloudDatabase; // We'll only make calls to the public database.

  // Sign in using the keyID and public key file.
  container.setUpAuth()
    .then(function(userInfo){
      println("userInfo",userInfo);

      return database.performQuery({ recordType: 'Acronym', sortBy: [{ fieldName: 'short' }] });
    })
    .then(function(response) {
      var count;
      for (count = 0; count < response.records.length; count++){
        var record = response.records[count];
        var short = record.fields.short.value
        var long = record.fields.long.value
        var date = new Date(record.created.timestamp)
        console.log("--> " + short + ": " + long);
        console.log("Created " + date);
      }

      console.log("Done");
      process.exit();
    })
    .catch(function(error) {
      console.warn(error);
      process.exit(1);
    });

})();
