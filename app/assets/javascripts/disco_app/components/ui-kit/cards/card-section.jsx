const CardSection = ({ title, children, wrappable }) => {

  const className = classNames({
    'next-card__section': true,
    'wrappable': wrappable,
    'wrappable--half-spacing': wrappable
  });

  const showTitle = () => {
    if (title) {
      return <CardSectionTitle title={title}/>;
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
