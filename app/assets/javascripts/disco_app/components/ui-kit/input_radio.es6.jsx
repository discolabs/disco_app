const InputRadio = ({ label, name, value, checked, onChange }) => {

  const id = `${name}[${value}]`;

  const handleChange = (e) => {
    onChange(e.target.value);
  };

  return(
    <div className="next-input-wrapper next-input-wrapper--halved">
      <label htmlFor={id} className="next-label next-label--switch">{label}</label>
      <input id={id} className="next-radio" type="radio" value={value} name={name} checked={checked} onChange={handleChange} />
      <span className="next-radio--styled" />
    </div>
  )

};
