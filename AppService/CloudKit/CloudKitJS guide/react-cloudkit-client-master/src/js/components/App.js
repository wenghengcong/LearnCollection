import React, { PropTypes } from 'react';

export default class App extends React.Component {

  static propTypes = {
    children: PropTypes.element.isRequired
  };

  render() {
    return (<div className="page-container">
        <h1>Page Container</h1>
        {this.props.children}
      </div>);
  }
}
