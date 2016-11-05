const UIStack = ({ children, wrap, center }) => {
  const className = classNames({
    'ui-stack': true,
    'ui-stack--wrap': wrap,
    'ui-stack--alignment-center': center
  });

  return (
    <div className={className}>
      {children}
    </div>
  );
};

UIStack.propTypes = {
  children: React.PropTypes.node,
  wrap: React.PropTypes.bool,
  center: React.PropTypes.bool
};

UIStack.defaultProps = {
  wrap: true,
  center: true
};
