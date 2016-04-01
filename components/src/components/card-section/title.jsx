import React from 'react';

const CardSectionTitle = ({ title }) => {
  return <h3 className="next-heading">{title}</h3>;
};

CardSectionTitle.propTypes = {
  title: React.PropTypes.string
};

export default CardSectionTitle;
