const Card = ({ children, aside }) => {

  const className = classNames({
    'next-card': true,
    'next-card--aside': aside
  });

  return (
    <div className={className}>{children}</div>
  );
};

Card.PropTypes = {
  children: React.PropTypes.node,
  aside: React.PropTypes.bool
};
