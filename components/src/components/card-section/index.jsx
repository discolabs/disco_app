import React from 'react';

const CardSection = ({ title, children }) => {
  return (
    <div className="next-card__section">
      <h3 className="next-heading">{title}</h3>
      {children}
    </div>
  );
}

CardSection.propTypes = {
  title: React.PropTypes.string
};

export default CardSection;
