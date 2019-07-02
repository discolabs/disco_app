import axios from 'axios';
import * as PropTypes from 'prop-types';
import React from 'react';
import { Route, Switch } from 'react-router-dom';
import HomePage from './HomePage';
import withApi from './withApi';

const HomePageWithApi = withApi(HomePage);

class App extends React.Component {
  static propTypes = {
    api: PropTypes.func.isRequired,
    parseApiResponse: PropTypes.func.isRequired
  };

  static childContextTypes = {
    shop: PropTypes.shape({
      id: PropTypes.string,
      name: PropTypes.string,
      shopifyDomain: PropTypes.string,
      timeZone: PropTypes.string
    }),
    user: PropTypes.shape({
      id: PropTypes.string,
      email: PropTypes.string,
      firstName: PropTypes.string,
      initials: PropTypes.string,
      lastName: PropTypes.string
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
    const { api, parseApiResponse } = this.props;

    axios
      .all([
        api.get('/embedded/api/shop'),
        api.get('/embedded/api/users/current')
      ])
      .then(
        axios.spread(
          async (shopResponse, usersResponse) => {
            this.setState({
              shop: await parseApiResponse(shopResponse),
              user: await parseApiResponse(usersResponse)
            });
          }
        )
      );
  }

  render() {
    const { user } = this.state;

    if (!user) return <div />;

    return (
      <Switch>
        <Route exact path="/" component={HomePageWithApi} />
      </Switch>
    );
  }
}

export default App;
