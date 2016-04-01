import React from 'react';
import IconCheckmark from 'components/icon-checkmark';

const InputCheckbox = ({ label, name, onChange, checked }) => {

  const handleChange = (e) => {
    onChange(e.target.checked);
  };

  return (
    <div className="next-input-wrapper">

      <label
        className="next-label next-label--switch"
        htmlFor={name}>
        {label}
      </label>

      <input name={name} type="hidden" value={0}/>
      <input
        className="next-checkbox"
        defaultChecked={checked}
        name={name}
        onChange={handleChange}
        type="checkbox"/>

      <span className="next-checkbox--styled">
        <IconCheckmark/>
      </span>

    </div>
  );
};

InputCheckbox.propTypes = {
  checked: React.PropTypes.bool,
  label: React.PropTypes.string.isRequired,
  name: React.PropTypes.string.isRequired,
  onChange: React.PropTypes.func.isRequired
};

InputCheckbox.defaultProps = {
  checked: false
};

export default InputCheckbox;
