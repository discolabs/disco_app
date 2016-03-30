import React from 'react';
import ReactDOM from 'react-dom';

import appStyle from './app.scss';
import uiStyle from './../../app/assets/stylesheets/disco_app/vendor/channels-ui-kit_0.3.0.scss';

import InputRadio from 'components/input-radio';
import InputSelect from 'components/input-select';

/**
 * Hot module replacement currently doesn't work with stateless components
 * as the root as of 03/29/2016.
 * https://github.com/gaearon/babel-plugin-react-transform/issues/57
 */
class App extends React.Component {
  render() {
    return (
      <div className="container">
      <h2>Form Components</h2>

        <Component
          title="Input Radio"
          path="components/input-radio">
          <InputRadio/>
        </Component>

        <Component
          title="Input Select"
          path="components/input-select">
          <InputSelect
            label="Select"
            name="select"
            options={[ { label: 'select 1', value: '1'}, { label: 'select 2', value: '2' } ]}
          />
        </Component>
      </div>
    );
  }
}

const Component = ({ title, path, children }) => {
  return (
    <div className="component-wrapper">
      <div>
        <h3>{title}</h3>
        <pre>{path}</pre>
      </div>

      {children}
    </div>
  );
}
ReactDOM.render(<App/>, document.getElementById('react-app'));
