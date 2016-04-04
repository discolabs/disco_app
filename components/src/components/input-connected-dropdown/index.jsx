import React from 'react';

const InputConnectedDropdown = (props) => {

  const {
    defaultInputValue,
    defaultSelectValue,
    inputName,
    inputOnChange,
    label,
    options,
    selectName,
    selectOnChange,
    value
  } = props;

  const inputChangeHandler = (e) => {
    inputOnChange(e.target.value);
  };

  const selectChangeHandler = (e) => {
    selectOnChange(e.target.value);
  };

  return (
    <div className="next-input-wrapper">

      <label className="next-label" htmlFor={label}>{label}</label>

      <div className="next-field__connected-wrapper">

        <input
          className="next-field--connected next-input"
          size="30"
          type="text"
          defaultValue={defaultInputValue}
          name={inputName}
          onChange={inputChangeHandler}
          id={label}/>

        <label
          className="next-label helper--visually-hidden"
          htmlFor={selectName}>
          {selectName}
        </label>

        <div
          className="next-select__wrapper next-field--connected next-field--connected--no-flex next-input--has-content">

          <select
            className="next-select"
            defaultValue={defaultSelectValue}
            name={selectName}
            onChange={selectChangeHandler}
            id={selectName}>
            {options.map((opt, index) => {
               return <option key={index} value={opt}>{opt}</option>;
             })}
          </select>

        </div>

      </div>

    </div>
  );
};

InputConnectedDropdown.propTypes = {
  defaultInputValue: React.PropTypes.string,
  defaultSelectValue: React.PropTypes.string,
  inputName: React.PropTypes.string.isRequired,
  inputOnChange: React.PropTypes.func.isRequired,
  label: React.PropTypes.string.isRequired,
  options: React.PropTypes.arrayOf(
    React.PropTypes.string
  ).isRequired,
  selectName: React.PropTypes.string.isRequired,
  selectOnChange: React.PropTypes.func.isRequired
}
InputConnectedDropdown.defaultProps = {
}

export default InputConnectedDropdown;
