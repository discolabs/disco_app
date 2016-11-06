const Button = ({ children, disabled, name=false, onClick = ()=>{}, primary = false, destroy = false, type = 'button' }) => {

  const className = classNames({
    'btn': true,
    'btn-primary': primary,
    'btn-destroy': destroy
  });

  return(
    <button type={type} name={name} disabled={disabled} className={className} onClick={onClick}>
      {children}
    </button>
  )

};
