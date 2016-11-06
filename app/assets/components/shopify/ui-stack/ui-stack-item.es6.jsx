const UIStackItem = ({ children, fill }) => {
  const className = classNames({
    'ui-stack-item': true,
    'ui-stack-item--fill': fill
  });

  return (
    <div className={className}>
      {children}
    </div>
  );
};

UIStackItem.propTypes = {
  children: React.PropTypes.node,
  fill: React.PropTypes.bool
};

UIStackItem.defaultProps = {
  fill: false
};
