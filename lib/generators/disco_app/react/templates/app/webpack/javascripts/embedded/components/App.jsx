import axios from 'axios';
import * as PropTypes from 'prop-types';
import React from 'react';
import { Route, Switch } from 'react-router-dom';
import HomePage from './HomePage';
import withApi from './withApi';

class App extends React.Component {
  static propTypes = {
    api: PropTypes.func.isRequired,
    parseApiResponse: PropTypes.func.isRequired
  };

  static childContextTypes = {
    shop: PropTypes.shape({
      id: PropTypes.string,
      name: PropTypes.string,
      plan: PropTypes.string,
      shopifyDomain: PropTypes.string
    }),
    user: PropTypes.shape({
      id: PropTypes.string,
      email: PropTypes.string,
      firstName: PropTypes.string,
      lastName: PropTypes.string,
      initials: PropTypes.string
    })
  };

  state = {
    shop: null,
    user: null
  };

  getChildContext() {
    return {
      shop: this.state.shop,
      user: this.state.user
    };
  }

  componentWillMount() {
    const { api } = this.props;

    axios
      .all([
        api.get('/embedded/api/shop'),
        api.get('/embedded/api/users/current')
      ])
      .then(
        axios.spread(
          async (shopResponse, usersResponse) => {
            this.setState({
              shop: await this.props.parseApiResponse(shopResponse),
              user: await this.props.parseApiResponse(usersResponse)
            });
          }
        )
      );
  }

  render() {
    if (!this.state.user) return <div />;

    const HomePageWithApi = withApi(HomePage);

    return (
      <Switch>
        <Route exact path="/" component={HomePageWithApi} />
      </Switch>
    );
  }
}

export default App;
