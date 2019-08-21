var keyMirror = require('keymirror');

export const CKContainerConfiguration = {
  IDENTIFIER:     '',
  APITOKEN:       '',
  ENVIRONMENT:    ''
};

export const PayloadSources = keyMirror({
  SERVER_ACTION: null,
  VIEW_ACTION: null
});

export const ActionTypes = keyMirror({
  LOAD_EVENTS: null,
  RECEIVE_EVENTS: null
});
