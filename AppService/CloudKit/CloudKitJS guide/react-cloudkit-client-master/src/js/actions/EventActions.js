import AppDispatcher from '../dispatcher/AppDispatcher';
import { CKContainerConfiguration, ActionTypes }from '../constants/AppConstants';

CloudKit.configure({
  containers: [{

    // Change this to a container identifier you own.
    containerIdentifier: CKContainerConfiguration.IDENTIFIER,

    apiTokenAuth: {
      // And generate a web token through CloudKit Dashboard.
      apiToken: CKContainerConfiguration.APITOKEN,

      persist: true // Sets a cookie.
    },

    environment: CKContainerConfiguration.ENVIRONMENT
  }]
});

export function loadEvents() {
  AppDispatcher.dispatch({ type: ActionTypes.LOAD_EVENTS });

  var container = CloudKit.getDefaultContainer();
  var publicDB = container.publicCloudDatabase;

  var query = { recordType: 'Items' };
  publicDB.performQuery(query)
    .then(function (response) {
      if (!response.hasErrors) {
        let objs = response.records.map(function (event) {
          var fields = event.fields;
          return { shortGUID: event.recordName, title: fields['name'].value };
        });

        AppDispatcher.dispatch({
          type: ActionTypes.RECEIVE_EVENTS,
          events: objs
        });
      }
    });
}
