import React from 'react';
import { Route, IndexRoute, Redirect } from 'react-router';

import App from './components/App';
import EventListApp from './containers/EventListApp/EventListApp';
import NotFoundView from './views/NotFoundView';

export default (
  <Route path="/" component={App}>
    <IndexRoute component={EventListApp} />
    <Route path="/events" component={EventListApp} />
    <Route path="404" component={NotFoundView} />
    <Redirect from="*" to="404" />
  </Route>
);
