import React from 'react';
import classNames from 'classnames';

const InputText = ({
  defaultValue,
  disabled,
  error,
  helpMessage,
  label,
  name,
  onChange,
  placeholder
}) => {

  const wrapperClasses = classNames({
    'next-input-wrapper': true,
    'next-input-wrapper--is-error': error
  });

  const handleChange = (e) => {
    onChange(e.target.value);
  };

  return (
    <div className={wrapperClasses}>

      <label className="next-label" htmlFor={name}>{label}</label>
      <input
        className="next-input"
        disabled={disabled}
        defaultValue={defaultValue}
        name={name}
        onChange={handleChange}
        placeholder={placeholder}
        type="text"/>

      <p className="next-input__help-text">{helpMessage}</p>
    </div>
  );
}

InputText.propTypes = {
  label: React.PropTypes.string.isRequired,
  name: React.PropTypes.string.isRequired,
  onChange: React.PropTypes.func.isRequired,
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
