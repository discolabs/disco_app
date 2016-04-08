const UIEmptyState = ({ title, subtitle, image, href, label }) => {

  let imageSubsection = null;
  if(image) {
    imageSubsection = (
      <div className="ui-empty-state__subsection">
        <div className="ui-empty-state__items ui-empty-state__items--odd-queries ui-empty-state__items--quantity-queries">
          <div className="ui-empty-state__item">
            <div className="ui-empty-state__subitems">
              <div className="ui-empty-state__subitem">
                <img src={image} alt={title} />
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }

  return(
    <div className="ui-empty-state">
      <div className="ui-empty-state__section">
        <div className="ui-empty-state__subsection">
          <h1 className="next-heading next-heading--xl">{title}</h1>
          <h2 className="next-heading next-heading--subdued">{subtitle}</h2>
        </div>
        {imageSubsection}
        <div className="ui-empty-state__subsection">
          <a className="btn btn-large btn-primary" href={href}>{label}</a>
        </div>
      </div>
    </div>
  )

};
