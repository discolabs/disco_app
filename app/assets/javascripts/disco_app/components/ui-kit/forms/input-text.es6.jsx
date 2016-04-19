const InputText = ({ name, value, disabled, error, helpMessage, label, labelHidden, onChange, placeholder }) => {

  const wrapperClassName = classNames({
    'next-input-wrapper': true,
    'next-input-wrapper--is-error': error
  });

  const labelClassName = classNames({
    'next-label': true,
    'helper--visually-hidden': labelHidden
  });

  const handleChange = (e) => {
    onChange(e.target.value);
  };

  let helpElement = null;
  if(helpMessage) {
    helpElement = <p className="next-input__help-text">{helpMessage}</p>;
  }

  return (
    <div className={wrapperClassName}>
      <label className={labelClassName} htmlFor={name}>{label}</label>
      <input
        id={name}
        className="next-input"
        disabled={disabled}
        value={value}
        name={name}
        onChange={handleChange}
        placeholder={placeholder}
        type="text"
      />
      {helpElement}
    </div>
  );
};

InputText.propTypes = {
  label: React.PropTypes.string.isRequired,
  name: React.PropTypes.string,
  onChange: React.PropTypes.func,
  placeholder: React.PropTypes.string,
  helpMessage: React.PropTypes.string,
  error: React.PropTypes.bool,
  disabled: React.PropTypes.bool
};

InputText.defaultProps = {
  error: false,
  disabled: false
};
