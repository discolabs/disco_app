import * as PropTypes from 'prop-types';
import React from 'react';
import { Banner, TextStyle } from '@shopify/polaris';

const ErrorBanner = ({ errors, prologue }) => {
  const errorKeys = () => Object.keys(errors).sort();

  const errorCount = () => errorKeys().length;

  const errorMessage = () => {
    let msg = '1 field needs changes';

    if (errorCount() > 1) {
      msg = `${errorCount()} fields need changes`;
    }

    return msg;
  };

  const separator = index => {
    if (index === 0) return ' ';

    if (index === errorCount() - 1) return ' and ';

    return ', ';
  };

  if (errorCount() === 0) return null;

  return (
    <Banner status="critical">
      <p>
        {prologue},{errorMessage()}:
        {errorKeys().map((key, index) => (
          <span>
            {separator(index)}
            <TextStyle key="error-{index}" variation="strong">
              {key}
            </TextStyle>
          </span>
        ))}
        .
      </p>
    </Banner>
  );
};

ErrorBanner.defaultProps = {
  errors: {},
  prologue: 'To save this form'
};

ErrorBanner.propTypes = {
  errors: PropTypes.shape({}),
  prologue: PropTypes.string
};

export default ErrorBanner;
