const CardHeader = ({ title, subheading, children }) => {

  // If children were provided, insert them as the "action" item on the right
  // hand side of the header.
  let actionStackItem = null;
  if(children) {
    actionStackItem = (
      <UIStackItem>
        {children}
      </UIStackItem>
    )
  }

  return (
    <header className="next-card__header">
      <UIStack>
        <UIStackItem fill={true}>
          <UIHeading subheading={subheading}>{title}</UIHeading>
        </UIStackItem>
        {actionStackItem}
      </UIStack>
    </header>
  );
};

CardHeader.propTypes = {
  title: React.PropTypes.string.isRequired,
  subheading: React.PropTypes.bool,
  children: React.PropTypes.node
};

CardHeader.defaultProps = {
  subheading: false
};
