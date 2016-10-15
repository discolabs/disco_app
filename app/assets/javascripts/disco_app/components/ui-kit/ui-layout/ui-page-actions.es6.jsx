const UIPageActions = ({ primary, secondary }) => {
  return (
    <div className="ui-page-actions">
      <UIPageActionsButtons primary={false} buttons={secondary} />
      <UIPageActionsButtons primary={true} buttons={primary} />
    </div>
  );
};

UIPageActions.propTypes = {
  primary: React.PropTypes.array.isRequired,
  secondary: React.PropTypes.array.isRequired
};
