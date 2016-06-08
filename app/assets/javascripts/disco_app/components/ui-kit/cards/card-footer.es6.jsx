const CardFooter = ({ children }) => {
  return (
    <div className="next-card__footer">
      {children}
    </div>
  );
};

CardFooter.propTypes = {
  children: React.PropTypes.node.isRequired
};
