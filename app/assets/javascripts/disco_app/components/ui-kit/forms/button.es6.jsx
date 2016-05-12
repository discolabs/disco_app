const Button = ({ children, disabled, onClick }) => {

  const className = classNames({
    'btn': true
  });

  return(
    <button type="button" disabled={disabled} className={className} onClick={onClick}>
      {children}
    </button>
  )

};
