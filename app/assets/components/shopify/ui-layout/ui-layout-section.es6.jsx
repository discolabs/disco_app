const UILayoutSection = ({ children, secondary }) => {

  const className = classNames({
    'ui-layout__section': true,
    'ui-layout__section--primary': !secondary,
    'ui-layout__section--secondary': secondary
  });

  return (
    <div className={className}>
      {children}
    </div>
  );
};

UILayoutSection.propTypes = {
  children: React.PropTypes.node,
  secondary: React.PropTypes.bool
};
