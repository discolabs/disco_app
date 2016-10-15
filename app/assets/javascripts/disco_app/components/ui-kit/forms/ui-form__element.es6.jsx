const UIFormElement = ({ helpText, children }) => {

  const className = classNames({
    'ui-form__element': true,
    'ui-form__section--help-text': helpText
  });

  return (
    <div className={className}>
      {children}
    </div>
  );
};

UIFormElement.propTypes = {
  children: React.PropTypes.node
};
