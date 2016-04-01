import React from 'react';

const InputRadio = ({ label, name, value, checked, onChange }) => {

  const id = `${name}[${value}]`;

  const handleChange = (e) => {
    onChange(e.target.value);
  };

  return(
    <div className="next-input-wrapper next-input-wrapper--halved">
      <label htmlFor={id} className="next-label next-label--switch">{label}</label>
      <input
        className="next-radio"
        defaultChecked={checked}
        id={id}
        name={name}
        onChange={handleChange}
        type="radio"
        value={value} />
      <span className="next-radio--styled" />
    </div>
  )

};

InputRadio.propTypes = {
  label: React.PropTypes.string.isRequired,
  name: React.PropTypes.string.isRequired,
  value: React.PropTypes.string.isRequired,
  checked: React.PropTypes.bool,
  onChange: React.PropTypes.func
};

export default InputRadio;
