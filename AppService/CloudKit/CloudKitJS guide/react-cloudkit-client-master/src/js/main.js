import '../styles/bootstrap.min.css';
import '../styles/styles.scss';

import React from 'react';
import { render } from 'react-dom';
import { Router, browserHistory } from 'react-router';

import routes from './routes';

// Render the React application to the DOM
render((
  <Router history={browserHistory} routes={routes} />
), document.getElementById('app'));
