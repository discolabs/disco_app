import React from 'react';

const UILayoutSections = ({ children }) => {
  return (
    <div className="ui-layout__sections">
      {children}
    </div>
  );
};

UILayoutSections.propTypes = {
  children: React.PropTypes.node
};

export default UILayoutSections;
