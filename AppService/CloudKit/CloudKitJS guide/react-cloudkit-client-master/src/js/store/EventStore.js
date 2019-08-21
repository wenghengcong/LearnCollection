import Store from './Store';
import AppDispatcher from '../dispatcher/AppDispatcher';
import { ActionTypes } from '../constants/AppConstants';

var _events = [];

function reset() {
  //_events = [];
}

class EventStoreClass extends Store {

  constructor() {
    super();
  }

  getAllEvents() {
    return _events;
  }
}

const EventStore = new EventStoreClass();

EventStore.dispatchToken = AppDispatcher.register((action) => {
  switch (action.type) {
    case ActionTypes.LOAD_EVENTS:
      reset();
      break;
      /* falls through */

    case ActionTypes.RECEIVE_EVENTS:
      _events = action.events;
      break;

    // case ActionTypes.APP_RESET:
    //   reset();
    //   break;

    // case ActionTypes.POUCH_ERROR:
    //   appState.message = 'Local database error: ' + action.error.message;
    //   break;

    default:
      return;
  }

  EventStore.emitChange();

});

export default EventStore;
