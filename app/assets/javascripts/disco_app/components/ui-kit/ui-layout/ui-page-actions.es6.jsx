const UIPageActions = ({ label, disabled, secondaryHref, secondaryLabel }) => {

  const buttonClassName = classNames({
    'btn': true,
    'btn-primary': !disabled,
    'disabled': disabled
  });

  let secondaryElement = null;
  if(secondaryHref) {
    secondaryElement = (
      <div className="ui-page-actions__secondary">
        <div className="button-group">
          <a className="btn" href={secondaryHref}>{secondaryLabel}</a>
        </div>
      </div>
    );
  }

  return (
    <div className="ui-page-actions">
      {secondaryElement}
      <div className="ui-page-actions__primary">
        <div className="button-group button-group--right-aligned">
          <button name="button" type="submit" className={buttonClassName} disabled={disabled}>
            {label}
          </button>
        </div>
      </div>
    </div>
  );
};

UIPageActions.propTypes = {
  label: React.PropTypes.string.isRequired,
  disabled: React.PropTypes.bool,
  secondaryHref: React.PropTypes.string,
  secondaryLabel: React.PropTypes.string
};
