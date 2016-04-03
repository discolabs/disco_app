import React from 'react';

const UIBannerContent = ({ title, children }) => {
  return (
    <div>
      <h2 className="next-heading next-heading--small next-heading--no-margin">
        {title}
      </h2>
      <p>{children}</p>
    </div>
  );
};

UIBannerContent.propTypes = {
  title: React.PropTypes.string.isRequired,
  children: React.PropTypes.node
};

export default UIBannerContent;
