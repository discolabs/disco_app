import bugsnag from 'bugsnag-js';
import createPlugin from 'bugsnag-react';
import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter as Router } from 'react-router-dom';
import { AppProvider } from '@shopify/polaris';
import App from './components/App';
import ScrollToTop from './components/Shared/ScrollToTop';
import withApi from './components/withApi';

const app = document.getElementById('app');

const bugsnagClient = bugsnag({
  apiKey: app.dataset.bugsnagApiKey,
  appVersion: app.dataset.version,
  releaseStage: app.dataset.environment
});

const ErrorBoundary = bugsnagClient.use(createPlugin(React));

const AppWithApi = withApi(App);

ReactDOM.render(
  <ErrorBoundary>
    <Router>
      <AppProvider
        apiKey={app.dataset.apiKey}
        debug={app.dataset.debug}
        forceRedirect={app.dataset.forceRedirect}
        shopOrigin={app.dataset.shopOrigin}
      >
        <ScrollToTop>
          <AppWithApi bugsnagClient={bugsnagClient} />
        </ScrollToTop>
      </AppProvider>
    </Router>
  </ErrorBoundary>,
  app
);
