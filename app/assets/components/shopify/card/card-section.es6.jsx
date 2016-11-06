const CardSection = ({ children, wrappable, borderless }) => {
  const className = classNames({
    'next-card__section': true,
    'wrappable': wrappable,
    'wrappable--half-spacing': wrappable,
    'next-card__section--no-border': borderless,
    'next-card__section--no-top-spacing': borderless
  });

  return (
    <div className={className}>
      {children}
    </div>
  );
};

CardSection.propTypes = {
  children: React.PropTypes.node.isRequired,
  wrappable: React.PropTypes.bool,
  borderless: React.PropTypes.bool
};

CardSection.defaultProps = {
  wrappable: false,
  borderless: false
};
