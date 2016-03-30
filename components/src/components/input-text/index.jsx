import React from 'react';
import classNames from 'classnames';

const InputText = ({ label, name, placeholder, helpMessage, error, disabled, onChange }) => {

  const wrapperClasses = classNames({
    'next-input-wrapper': true,
    'next-input-wrapper--is-error': error
  });

  return (
    <div className={wrapperClasses}>

      <label className="next-label">{label}</label>
      <input
        className="next-input"
        disabled={disabled}
        placeholder={placeholder}
        type="text"/>

      <p className="next-input__help-text">{helpMessage}</p>
    </div>
  );
}

InputText.propTypes = {
  label: React.PropTypes.string,
  name: React.PropTypes.string,
  placeholder: React.PropTypes.string,
  helpMessage: React.PropTypes.string,
  error: React.PropTypes.bool,
  disabled: React.PropTypes.bool
};

InputText.defaultProps = {
  error: false,
  disabled: false
};

export default InputText;
