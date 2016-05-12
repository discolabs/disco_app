import React from 'react';

const UILayoutSection = ({ children }) => {
  return (
    <div className="ui-layout__section">
      {children}
    </div>
  );
};

UILayoutSection.propTypes = {
  children: React.PropTypes.node
};

export default UILayoutSection;
