const UIFormGroup = ({ children }) => {
  return (
    <div className="ui-form__group">
      {children}
    </div>
  );
};

UIFormGroup.propTypes = {
  children: React.PropTypes.node
};
