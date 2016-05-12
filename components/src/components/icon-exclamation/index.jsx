import React from 'react';

const IconExclamation = ({ size }) => {
  const svgClasses = `next-icon next-icon--${size}`;
  return (
    <svg className={svgClasses} viewBox="0 0 24 24">
      <path d="M13.5 0h-2c-.8 0-1.5.7-1.5 1.5v14c0 .8.7 1.5 1.5 1.5h2c.8 0 1.5-.7 1.5-1.5v-14c0-.8-.7-1.5-1.5-1.5z"></path><circle cx="12.5" cy="21.5" r="2.5"></circle>
    </svg>
  );
};

IconExclamation.propTypes = {
  size: React.PropTypes.number
};

IconExclamation.defaultProps = {
  size: 10
};

export default IconExclamation;
