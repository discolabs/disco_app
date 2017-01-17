const NextIcon = ({ size, name, additionalClassNames = '' }) => {

  const className = classNames({
    "next-icon": true,
    ['next-icon--size-' + size]: true,
    [additionalClassNames]: (additionalClassNames.length > 0)
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
