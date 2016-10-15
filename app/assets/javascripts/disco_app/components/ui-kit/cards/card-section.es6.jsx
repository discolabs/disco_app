const CardSection = ({ title, title_small, children, wrappable, borderless }) => {

  const className = classNames({
    'next-card__section': true,
    'wrappable': wrappable,
    'wrappable--half-spacing': wrappable,
    'next-card__section--no-border': borderless,
    'next-card__section--no-top-spacing': borderless
  });

  const showTitle = () => {
    if (title) {
      return <CardSectionTitle title={title} small={title_small} />;
    } else {
      return null;
    }
  };

  return (
    <div className={className}>
      {showTitle()}
      {children}
    </div>
  );
};

CardSection.propTypes = {
  title: React.PropTypes.string,
  children: React.PropTypes.node
};
