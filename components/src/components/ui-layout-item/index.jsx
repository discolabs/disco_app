import React from 'react';

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

export default UILayoutItem;
