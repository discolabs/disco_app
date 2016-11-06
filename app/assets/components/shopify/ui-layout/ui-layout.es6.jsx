const UILayout = ({ children }) => {
  return (
    <div className="ui-layout">
      {children}
    </div>
  );
};

UILayout.propTypes = {
  children: React.PropTypes.node
};
