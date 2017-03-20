const InputCheckbox = ({ label, name, checked, inline, isLast, onChange, disabled = false }) => {

  const id = name;

  const wrapperClassName = classNames({
    'next-input-wrapper': true,
    'inline': inline,
    'sr': !isLast
  });

  const labelClassName = classNames({
    'next-label': true,
    'next-label--switch': true,
    'inline': inline,
    'fw-normal': inline
  });

  const handleChange = (e) => {
    onChange && onChange(e.target.checked);
  };

  return(
    <div className={wrapperClassName}>
      <label htmlFor={id} className={labelClassName}>{label}</label>
      <input type="hidden" value="0" name={name} />
      <input id={id} className="next-checkbox" type="checkbox" value="1" name={name} checked={checked} onChange={handleChange} disabled={disabled} />
      <span className="next-checkbox--styled">
        <svg className="next-icon next-icon--size-10 next-icon--blue checkmark">
          <use xmlns="http://www.w3.org/1999/xlink" xlinkHref="#next-checkmark" />
        </svg>
      </span>
    </div>
  )

};
