import React from 'react';
import classNames from 'classnames';

const IconCheckmark = ({ size }) => {
  const svgClasses = classNames({
    'next-icon': true,
    'next-icon--blue': true,
    'checkmark': true,
    ['next-icon--' + size]: true
  });
  return (
    <svg
      className={svgClasses}
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      enableBackground="new 0 0 24 24">

      <path
        d="M23.6 5L22 3.4c-.5-.4-1.2-.4-1.7 0L8.5 15l-4.8-4.7c-.5-.4-1.2-.4-1.7 0L.3 11.9c-.5.4-.5 1.2 0 1.6l7.3 7.1c.5.4 1.2.4 1.7 0l14.3-14c.5-.4.5-1.1 0-1.6z"/>

    </svg>
  );
};

IconCheckmark.propTypes = {
  size: React.PropTypes.number
};

IconCheckmark.defaultProps = {
  size: 10
};

export default IconCheckmark;
