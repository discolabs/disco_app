import React from 'react';

const IconFlag = ({ size }) => {
  const svgClasses = `next-icon next-icon--${size}`;
  return (
    <svg className={svgClasses} viewBox="0 0 24 24">
      <path d="M24 10.1L20 .3c-.2-.5-.7-.6-1.1-.2C14.3 5.5 8.6 0 3.2 3.8L2.9 3C2.6 2.2 1.8 1.8 1 2 .2 2.3-.2 3.1.1 3.9l6.5 18.9c.2.6.8 1 1.4 1 .2 0 .3 0 .5-.1.8-.3 1.2-1.1.9-1.9l-2.6-7.5c5.7-3.4 12.3 2.7 17-3.4.2-.2.2-.5.2-.8z"></path>
    </svg>
  );
};

IconFlag.propTypes = {
  size: React.PropTypes.number
};

IconFlag.defaultProps = {
  size: 10
};

export default IconFlag;
