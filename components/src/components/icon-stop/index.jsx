import React from 'react';

const IconStop = ({ size }) => {
  const svgClasses = `next-icon next-icon--${size}`;

  return (
    <svg className={svgClasses} viewBox="0 0 24 24">
      <path d="M12 0C5.4 0 0 5.4 0 12s5.4 12 12 12 12-5.4 12-12S18.6 0 12 0zm0 4c1.4 0 2.7.4 3.9 1L12 8.8 8.8 12 5 15.9c-.6-1.1-1-2.5-1-3.9 0-4.4 3.6-8 8-8zm0 16c-1.4 0-2.7-.4-3.9-1l3.9-3.9 3.2-3.2L19 8.1c.6 1.1 1 2.5 1 3.9 0 4.4-3.6 8-8 8z"></path>
    </svg>
  );
};

IconStop.propTypes = {
  size: React.PropTypes.number
};

IconStop.defaultProps = {
  size: 10
};
export default IconStop;
