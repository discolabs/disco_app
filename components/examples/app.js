import React from 'react';
import ReactDOM from 'react-dom';
import appStyle from './app.scss';
import shopifyStyle from './../../app/assets/stylesheets/disco_app/vendor/channels-ui-kit_0.3.0.scss';
import Forms from './forms';


/**
 * Hot module replacement currently doesn't work with stateless components
 * as the root as of 03/29/2016.
 * https://github.com/gaearon/babel-plugin-react-transform/issues/57
 */
class App extends React.Component {
  render() {

    return (
      <div>
        <Forms/>
      </div>
    );
  }
}

ReactDOM.render(<App/>, document.getElementById('react-app'));
