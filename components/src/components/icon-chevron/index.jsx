import React from 'react';
import classNames from 'classnames';

const IconChevron = ({ direction, disabled }) => {

  const directionClass = direction === 'previous' ? true : false;

  const iconClasses = classNames({
    "next-icon": true,
    "next-icon--12": true,
    "next-icon--blue": disabled === false,
    "next-icon--sky-darker": disabled,
    "next-icon--rotate-180": directionClass
  });

  return (
    <svg
      aria-labelledby="next-chevron"
      role="img"
      className={iconClasses}
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 28 28">

      <path
        d="M7,3.8l10.5,10.5L7,24.7l2.7,2.7L23,14.3L9.7,1C9.7,1,7,3.8,7,3.8z"/>

    </svg>
  );
};

IconChevron.propTypes = {
  direction: React.PropTypes.oneOf(['next', 'previous']).isRequired,
  disabled: React.PropTypes.bool
};

IconChevron.defaultProps = {
  disabled: false
};

export default IconChevron;
