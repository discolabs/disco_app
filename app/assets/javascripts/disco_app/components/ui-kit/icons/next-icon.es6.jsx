const NextIcon = ({ size, name }) => {

  const className = classNames({
    "next-icon": true,
    ['next-icon--size-' + size]: true
  });

  return (
    <svg className={className}>
      <use xlinkHref={'#' + name} />
    </svg>
  );
};

NextIcon.propTypes = {
  size: React.PropTypes.number,
  name: React.PropTypes.string
};
