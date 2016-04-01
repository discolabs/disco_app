import React from 'react';

const Card = ({ children }) => {
  return (
    <div className="next-card">{children}</div>
  );
};

Card.PropTypes = {
  children: React.PropTypes.node
};

export default Card;
