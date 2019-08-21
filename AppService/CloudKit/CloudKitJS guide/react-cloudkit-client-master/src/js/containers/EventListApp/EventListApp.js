import './EventListApp.scss';

import React from 'react';
import { EventList } from '../../components';
import EventStore from '../../store/EventStore';
import * as EventActions from '../../actions/EventActions';

export default class EventListApp extends React.Component {
  constructor(props) {
    super(props);
    this.onChange = this.onChange.bind(this);

    this.state = { events: EventStore.getAllEvents() };
  }

  componentDidMount() {
    EventStore.addChangeListener(this.onChange);
    EventActions.loadEvents();
  }

  componentWillUnmount() {
    EventStore.removeChangeListener(this._onChange);
  }

  onChange() {
    this.setState({
      events: EventStore.getAllEvents()
    });
  }

  render () {
    return (
      <div className="friendListApp">
        <h1>Da Bro's List Again</h1>
        <EventList events={this.state.events} />
      </div>
    );
  }
}
