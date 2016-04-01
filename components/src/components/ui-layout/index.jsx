import React from 'react';

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

export default UILayout;
