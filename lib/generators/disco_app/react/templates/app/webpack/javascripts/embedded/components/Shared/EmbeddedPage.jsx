import _ from 'lodash';
import * as PropTypes from 'prop-types';
import React from 'react';
import ReactRouterPropTypes from 'react-router-prop-types';
import { History } from '@shopify/app-bridge/actions';
import { Page } from '@shopify/polaris';

class EmbeddedPage extends React.Component {
  static contextTypes = {
    polaris: PropTypes.object
  };

  static propTypes = {
    children: PropTypes.node.isRequired,
    history: ReactRouterPropTypes.history.isRequired,
    location: ReactRouterPropTypes.location.isRequired,
    title: PropTypes.string.isRequired
  };

  componentDidMount() {
    window.addEventListener('message', this.handleMessage);

    this.pushHistory();
  }

  componentDidUpdate(prevProps) {
    if (prevProps.location.pathname !== this.props.location.pathname) {
      this.pushHistory();
    }
  }

  componentWillUnmount() {
    window.removeEventListener('message', this.handleMessage);
  }

  pushHistory = () => {
    const history = History.create(this.context.polaris.appBridge);

    history.dispatch(History.Action.PUSH, this.props.history.location.pathname);
  };

  handleMessage = e => {
    if (e.isTrusted) {
      if (_.isString(e.data)) {
        const json = JSON.parse(e.data);

        if (json.message === 'Shopify.API.setWindowLocation') {
          const url = new URL(json.data);
          this.props.history.push(url.pathname);
        }
      }
    }
  };

  pushHistory = () => {
    const history = History.create(this.context.polaris.appBridge);

    history.dispatch(History.Action.PUSH, this.props.history.location.pathname);
  };

  render() {
    return (
      <Page title={this.props.title} {...this.props}>
        {this.props.children}
      </Page>
    );
  }
}

export default EmbeddedPage;
