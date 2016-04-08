const CardSection = ({ title, children }) => {

  const showTitle = () => {
    if (title) {
      return <CardSectionTitle title={title}/>;
    } else {
      return null;
    }
  };

  return (
    <div className="next-card__section">

      {showTitle()}

      {children}

    </div>
  );
};

CardSection.propTypes = {
  title: React.PropTypes.string,
  children: React.PropTypes.node
};
