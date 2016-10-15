const UIFormSection = ({ children }) => {
  return (
    <div className="ui-form__section">
      {children}
    </div>
  );
};

UIFormSection.propTypes = {
  children: React.PropTypes.node
};
