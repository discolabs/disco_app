const UIPageActionsButtons = ({ primary, buttons }) => {

  const className = classNames({
    'ui-page-actions__primary': primary,
    'ui-page-actions__secondary': !primary
  });

  const buttonGroupClassName = classNames({
    'button-group': true,
    'button-group--right-aligned': primary
  });

  return (
    <div className={className}>
      <div className={buttonGroupClassName}>
        {buttons.map((button, index) => {
          return React.cloneElement(button, { key: index});
        })}
      </div>
    </div>
  );
};

UIPageActionsButtons.propTypes = {
  primary: React.PropTypes.bool.isRequired,
  buttons: React.PropTypes.array.isRequired
};
