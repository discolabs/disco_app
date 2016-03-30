import React from 'react';

const Card = (props) => {
  return (
    <div className="next-card">{props.children}</div>
  );
}

export default Card;
