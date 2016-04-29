const InputTextArea = ({ defaultValue, label, name, onChange, placeholder, helpMessage }) => {

  const handleChange = (e) => {
    onChange(e.target.value);
  };

  let helpElement = null;
  if(helpMessage) {
    helpElement = <p className="next-input__help-text">{helpMessage}</p>;
  }

  return (
    <div className="next-input-wrapper">
      <label className="next-label" htmlFor={name}>{label}</label>
      <textarea
        className="next-textarea"
        defaultValue={defaultValue}
        name={name}
        onChange={handleChange}
        placeholder={placeholder}
      />
      {helpElement}
    </div>
  );
};

InputTextArea.propTypes = {
  defaultValue: React.PropTypes.string,
  label: React.PropTypes.string.isRequired,
  name: React.PropTypes.string.isRequired,
  onChange: React.PropTypes.func.isRequired,
  placeholder: React.PropTypes.string,
  helpMessage: React.PropTypes.string
};
