const UIAnnotatedSection = ({ title, description, children }) => {

  return (
    <section className="ui-annotated-section">

      <div className="ui-annotated-section__annotation">
        <div className="ui-annotated-section__title">
          <h2 className="next-heading next-heading--no-margin">{title}</h2>
        </div>

        <div className="ui-annotated-section__description">
          {typeof description == 'string' ? <p>{description}</p> : description}
        </div>
      </div>

      <div className="ui-annotated-section__content">
        {children}
      </div>

    </section>
  );

};

UIAnnotatedSection.propTypes = {
  title: React.PropTypes.string.isRequired,
  description: React.PropTypes.node,
  children: React.PropTypes.node
};
