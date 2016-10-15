const CardSectionTitle = ({ title, small }) => {

  const className = classNames({
    'next-heading': true,
    'next-heading--small': small,
    'next-heading--half-margin': small
  });

  return (
    <h2 className={className}>{title}</h2>
  );
};

CardSectionTitle.propTypes = {
  title: React.PropTypes.string.isRequired,
  small: React.PropTypes.bool
};
