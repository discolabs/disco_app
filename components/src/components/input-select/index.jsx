import React from 'react';

const InputSelect = ({ label, name, options, value, onChange }) => {

  const id = name;

  const optionElements = options.map((option) => {
    return <option key={option.value} value={option.value}>{option.label}</option>;
  });

  const handleChange = (e) => {
    onChange(e.target.value);
  };

  return(
    <div className="next-input-wrapper next-input-wrapper--halved">
      <select id={id} name={name} value={value} onChange={handleChange}>
        {optionElements}
      </select>
    </div>
  )

};

InputSelect.propTypes = {
  label: React.PropTypes.string.isRequired,
  name: React.PropTypes.string.isRequired,
  options: React.PropTypes.arrayOf(
    React.PropTypes.shape({
      label: React.PropTypes.string.isRequired,
      value: React.PropTypes.string.isRequired
    })
  ).isRequired
};

export default InputSelect;
