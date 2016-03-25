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
