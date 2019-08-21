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

window.addEventListener('cloudkitloaded', function() {
  console.log("listening for cloudkitloaded");
  CloudKit.configure({
    containers: [{
      // To use your own container, replace containerIdentifier and apiToken
      containerIdentifier: 'iCloud.com.raywenderlich.TIL',
      apiToken: '3da8d1d050638ba51c8622056f102afe37d84f83d594273096dcdc257a9d3d83',
      environment: 'development'
    }]
  });
  console.log("cloudkitloaded");
                        
  function TILViewModel() {
    var self = this;
    console.log("get default container");
    var container = CloudKit.getDefaultContainer();
    
    console.log("set publicDB");
    var publicDB = container.publicCloudDatabase;
    self.items = ko.observableArray();
    
    // Fetch public records
    self.fetchRecords = function() {
      console.log("fetching records from " + publicDB);
      var query = { recordType: 'Acronym', sortBy: [{ fieldName: 'short'}] };
      
      // Execute the query.
      return publicDB.performQuery(query).then(function(response) {
        if(response.hasErrors) {
          console.error(response.errors[0]);
          return;
        }
        var records = response.records;
        var numberOfRecords = records.length;
        if (numberOfRecords === 0) {
          console.error('No matching items');
          return;
        }
         
        console.log(records.length + " records")
        self.items(records);
      });
    };
    
    self.newShort = ko.observable('');
    self.newLong = ko.observable('');
    self.saveButtonEnabled = ko.observable(true);
    self.newItemVisible = ko.observable(false);
    
    // Save new record
    self.saveNewItem = function() {
      if (self.newShort().length > 0 && self.newLong().length > 0) {
        self.saveButtonEnabled(false);
        var record = { recordType: "Acronym",
            fields: { short: { value: self.newShort() },
              long: { value: self.newLong() }}
        };
        publicDB.saveRecord(record).then(function(response) {
          if (response.hasErrors) {
            console.error(response.errors[0]);
            self.saveButtonEnabled(true);
            return;
          }
          var createdRecord = response.records[0];
          self.items.push(createdRecord);
          self.newShort("");
          self.newLong("");
          self.saveButtonEnabled(true);
        });
      } else {
        alert('Acronym must have short and long forms');
      }
    };
    
    self.displayUserName = ko.observable('Unauthenticated User');
    
    // Authenticated state: new-item form, subscription & notification
    self.gotoAuthenticatedState = function(userInfo) {
      self.newItemVisible(true);
      
      var querySubscription = {
        subscriptionType: 'query',
        subscriptionID: userInfo.userRecordName,
        firesOn: ['create', 'update', 'delete'],
        query: { recordType: 'Acronym', sortBy: [{ fieldName: 'short'}] }
      };
       
      publicDB.fetchSubscriptions([querySubscription.subscriptionID]).then(function(response) {
        if(response.hasErrors) {  // subscription doesn't exist, so save it
          publicDB.saveSubscriptions(querySubscription).then(function(response) {
            if (response.hasErrors) {
              console.error(response.errors[0]);
              throw response.errors[0];
            } else {
              console.log("successfully saved subscription")
            }
          });
        }
      });
       
      container.registerForNotifications();
      container.addNotificationListener(function(notification) {
        console.log(notification);
        self.fetchRecords();
      });
      
      if(userInfo.isDiscoverable) {
        self.displayUserName(userInfo.firstName + ' ' + userInfo.lastName);
      } else {
        self.displayUserName('User Who Must Not Be Named');
      }
   
      container
      .whenUserSignsOut()
      .then(self.gotoUnauthenticatedState);
    };
  
    // Unauthenticated state
    self.gotoUnauthenticatedState = function(error) {
      self.newItemVisible(false);
      self.displayUserName('Unauthenticated User');
     
      container
      .whenUserSignsIn()
      .then(self.gotoAuthenticatedState)
      .catch(self.gotoUnauthenticatedState);
    };
    
    container.setUpAuth().then(function(userInfo) {
      console.log("setUpAuth");
      self.fetchRecords();  // Don't need user auth to fetch public records
      if(userInfo) {
        self.gotoAuthenticatedState(userInfo);
      } else {
        self.gotoUnauthenticatedState();
      }
    });
    
  }
  
  ko.applyBindings(new TILViewModel());
});
