import './EventList.scss';

import React, { Component, PropTypes } from 'react';
import EventListItem from '../EventListItem/EventListItem';

export default class EventList extends Component {

  static propTypes = {
    events: PropTypes.array.isRequired
  };

  renderList() {
    return this.props.events.map((anEvent) =>
      (
        <EventListItem
          key={anEvent['shortGUID']}
          shortGUID={anEvent['shortGUID']}
          title={anEvent['title']} />
      )
    );
  }

  render () {
    return (
      <div>
        <ul className="friendList">
          {this.renderList()}
        </ul>
      </div>
    );
  }
}
