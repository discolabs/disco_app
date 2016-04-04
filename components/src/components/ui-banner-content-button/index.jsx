import React from 'react';

const UIBannerContentButton = ({ title, buttonText, onButtonClick, onHelpClick, helpText }) => {
  const buttonHandler = (e) => {
    e.preventDefault();
    onButtonClick(e);
  };

  const helpHandler = (e) => {
    e.preventDefault();
    onHelpClick(e);
  };

  return (
    <div className="wrappable wrappable--vertically-centered">

      <div className="wrappable__item">
        <h2 className="next-heading next-heading--small next-heading--no-margin">Change [Setting]</h2>
        <p>To use [Sales channel] channel, your [setting] must be [state].</p>
      </div>

      <div className="wrappable__item wrappable__item--no-flex">
        <div className="button-group">
          <a className="btn btn--outline" onClick={buttonHandler}>{buttonText}</a>
          <a className="btn btn--link" onClick={helpHandler}>{helpText}</a>
        </div>
      </div>

    </div>
  );
};

UIBannerContentButton.propTypes = {
  buttonText: React.PropTypes.string.isRequired,
  helpText: React.PropTypes.string.isRequired,
  onButtonClick: React.PropTypes.func.isRequired,
  onHelpClick: React.PropTypes.func.isRequired,
  title: React.PropTypes.string.isRequired
};

export default UIBannerContentButton;
