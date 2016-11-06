const UILayoutItem = ({ children }) => {
  return (
    <div className="ui-layout__item">
      {children}
    </div>
  );
};

UILayoutItem.propTypes = {
  children: React.PropTypes.node
};
