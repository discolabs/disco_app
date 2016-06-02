const CardHeader = ({ title }) => {
  return (
    <div className="next-card__header">
      <CardSectionTitle title={title} />
    </div>
  );
};

CardHeader.propTypes = {
  title: React.PropTypes.string.isRequired
};
