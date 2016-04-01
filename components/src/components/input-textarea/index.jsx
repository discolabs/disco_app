import React from 'react';

const InputTextarea = ({
  defaultValue,
  label,
  name,
  onChange,
  placeholder
}) => {

  const handleChange = (e) => {
    onChange(e.target.value);
  };

  return (
    <div className="next-input-wrapper">

      <label className="next-label" htmlFor={name}>{label}</label>
      <textarea
        className="next-textarea"
        defaultValue={defaultValue}
        name={name}
        onChange={handleChange}
        placeholder={placeholder}/>

    </div>
  );
};

InputTextarea.propTypes = {
  defaultValue: React.PropTypes.string,
  label: React.PropTypes.string.isRequired,
  name: React.PropTypes.string.isRequired,
  onChange: React.PropTypes.func,
  placeholder: React.PropTypes.string
};

export default InputTextarea;
