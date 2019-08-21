import './EventListItem.scss';

import React, { Component, PropTypes } from 'react';

export default class EventListItem extends Component {

  static propTypes = {
    shortGUID: PropTypes.string.isRequired,
    title: PropTypes.string.isRequired
  };

  render () {
    return (
      <li className="friendListItem">
        <div className="friendInfos">
          <div><span>{this.props.title}</span></div>
        </div>
      </li>
    );
  }
}
