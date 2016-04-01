import React from 'react';
import IconExclamation from 'components/icon-exclamation';
import IconFlag from 'components/icon-flag';
import IconStop from 'components/icon-stop';

const UIBanner = ({ title, description, type }) => {

  const typeClass = () => {
    switch(type) {
      case 'warning':
        return 'ui-banner--status-warning';
      case 'error':
        return 'ui-banner--status-error';
      default:
        return "";
    }
  };

  const typeIcon = () => {
    switch(type) {
      case 'warning':
        return <IconExclamation/>;
      case 'error':
        return <IconStop/>;
      default:
        return <IconFlag/>;
    }
  };

  return (
    <div className={"ui-banner ui-banner--default-vertical-spacing " + typeClass()}>

    <div className="ui-banner__ribbon">
      {typeIcon()}
    </div>

    <div className="ui-banner__content">

    <h2 className="next-heading next-heading--small next-heading--no-margin">
    {title}
        </h2>

        <p>{description}</p>

      </div>

    </div>
  );
}

export default UIBanner;
