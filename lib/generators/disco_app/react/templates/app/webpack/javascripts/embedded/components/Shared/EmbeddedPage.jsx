import _ from 'lodash';
import * as PropTypes from 'prop-types';
import React from 'react';
import ReactRouterPropTypes from 'react-router-prop-types';
import { Page } from '@shopify/polaris';

class EmbeddedPage extends React.Component {
  static propTypes = {
    children: PropTypes.node.isRequired,
    history: ReactRouterPropTypes.history.isRequired,
    title: PropTypes.string.isRequired
  };

  static contextTypes = {
    easdk: PropTypes.object
  };

  componentDidMount() {
    window.addEventListener('message', this.handleMessage);

    this.context.easdk.pushState(this.props.history.location.pathname);
  }

  componentWillUnmount() {
    window.removeEventListener('message', this.handleMessage);
  }

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

  render() {
    return (
      <Page title={this.props.title} {...this.props}>
        {this.props.children}
      </Page>
    );
  }
}

export default EmbeddedPage;
