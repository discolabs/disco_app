const IconChevron = ({ size, direction, disabled }) => {

  const iconClasses = classNames({
    "next-icon": true,
    "next-icon--blue": disabled === false,
    "next-icon--sky-darker": disabled,
    "next-icon--rotate-180": direction === 'previous',
    ['next-icon--' + size]: true
  });

  return (
    <svg
      aria-labelledby="next-chevron"
      role="img"
      className={iconClasses}
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 28 28">

      <path d="M7,3.8l10.5,10.5L7,24.7l2.7,2.7L23,14.3L9.7,1C9.7,1,7,3.8,7,3.8z" />
    </svg>
  );
};

IconChevron.propTypes = {
  direction: React.PropTypes.oneOf(['next', 'previous']).isRequired,
  disabled: React.PropTypes.bool,
  size: React.PropTypes.number
};

IconChevron.defaultProps = {
  disabled: false,
  size: 10
};
