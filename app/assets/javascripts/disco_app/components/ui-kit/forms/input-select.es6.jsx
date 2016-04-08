const InputSelect = ({ id, label, labelHidden, name, options, value, onChange }) => {

  const optionElements = options.map((option) => {
    return <option key={option.value} value={option.value}>{option.label}</option>;
  });

  const labelClassName = classNames({
    'next-label': true,
    'helper--visually-hidden': labelHidden
  });

  const handleChange = (e) => {
    onChange(e.target.value);
  };

  return(
    <div className="next-input-wrapper">
      <label className={labelClassName} htmlFor={id}>{label}</label>
      <div className="next-select__wrapper next-input--has-content">
        <select id={id} className="next-select rule-field">
          {optionElements}
        </select>
        <NextIcon name="next-chevron-down" size={12} />
      </div>
    </div>
  )

};

InputSelect.propTypes = {
  label: React.PropTypes.string.isRequired,
  name: React.PropTypes.string,
  options: React.PropTypes.arrayOf(
    React.PropTypes.shape({
      label: React.PropTypes.string.isRequired,
      value: React.PropTypes.string.isRequired
    })
  ).isRequired
};
