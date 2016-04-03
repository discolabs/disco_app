import React from 'react';
import IconCheckmark from 'components/icon-checkmark';
import IconExclamation from 'components/icon-exclamation';
import IconFlag from 'components/icon-flag';
import IconStop from 'components/icon-stop';

const UIBanner = ({ type, children }) => {

  const typeClass = () => {
    switch(type) {
      case 'success':
        return 'ui-banner--status-success';
      case 'info':
        return 'ui-banner--status-info';
      case 'warning':
        return 'ui-banner--status-warning';
      case 'error':
        return 'ui-banner--status-error';
      default:
        return '';
    }
  };

  const typeIcon = () => {
    switch(type) {
      case 'success':
        return <IconCheckmark size={24}/>;
      case 'info':
        return <IconFlag size={24}/>;
      case 'warning':
        return <IconExclamation size={24}/>;
      case 'error':
        return <IconStop size={24}/>;
      default:
        return <IconFlag size={24}/>;
    }
  };

  return (
    <div className={"ui-banner ui-banner--default-vertical-spacing " + typeClass()}>

      <div className="ui-banner__ribbon">
        {typeIcon()}
      </div>

    <div className="ui-banner__content">
      {children}
    </div>

    </div>
  );
};

UIBanner.propTypes = {
  children: React.PropTypes.node,
  type: React.PropTypes.oneOf(['success', 'info', 'error', 'warning']).isRequired
};

export default UIBanner;
