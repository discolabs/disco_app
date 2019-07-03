import * as PropTypes from 'prop-types';
import React from 'react';
import ReactRouterPropTypes from 'react-router-prop-types';
import { withRouter } from 'react-router-dom';

class ScrollToTop extends React.Component {
  static propTypes = {
    children: PropTypes.node.isRequired,
    location: ReactRouterPropTypes.location.isRequired
  };

  componentDidUpdate(prevProps) {
    if (this.props.location !== prevProps.location) {
      window.scrollTo(0, 0);
    }
  }

  render() {
    return this.props.children;
  }
}

export default withRouter(ScrollToTop);
