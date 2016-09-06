const Button = ({ children, disabled, name=false, onClick = ()=>{}, primary = false, type = 'button' }) => {

  const className = classNames({
    'btn': true,
    'btn-primary': primary
  });

  return(
    <button type={type} name={name} disabled={disabled} className={className} onClick={onClick}>
      {children}
    </button>
  )

};
