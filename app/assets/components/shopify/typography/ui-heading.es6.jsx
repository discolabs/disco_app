const UIHeading = ({ children, subheading }) => {
  if(subheading) {
    return <h3 className="ui-subheading">{children}</h3>;
  }

  return <h2 className="ui-heading">{children}</h2>;
};

UIHeading.propTypes = {
  children: React.PropTypes.node.isRequired,
  subheading: React.PropTypes.bool
};

UIHeading.defaultProps = {
  subheading: false
};
