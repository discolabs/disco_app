/**
 * Base class for form components that provides helper methods
 * for rendering errors associated with the form
 **/
class BaseForm extends React.Component {

  /**
   * check if the field parameter has errors associated.
   * if no parameters are given, it checks if there's at least an error at all
   **/
  hasErrors(field) {
    if ((arguments.length === 0 && this.errorKeys().length > 0) ||
        (this.props.errors && this.props.errors.errors.indexOf(field) > -1)) {
      return true;
    }
    return false;
  }

  /**
   * returns a list of fields that contain errors
   **/
  errorKeys() {
    return this.props.errors.errors;
  }

  /**
   * returns the type of resource associate with this error
   **/
  errorType() {
    return this.props.errors.type;
  }

  /**
   * returns the error messages
   **/
  errorMessages() {
    return this.props.errors.messages;
  }

  /**
   * renders basic form errors
   **/
  renderErrors() {
    if (!this.hasErrors()) {
      return null;
    }

    var title = "There " + (this.errorMessages().length == 1 ? "is" : "are") + " " + this.errorMessages().length + " error" + (this.errorMessages().length > 1 ? "s" : "") + " for this " + this.errorType() + ":";
    var errorMessages = this.errorMessages().map(function(message) {
      return <li>{message}</li>;
    });

    return (
      <div className="ui-banner ui-banner--status-error ui-banner--default-vertical-spacing ui-banner--default-horizontal-spacing">
        <div className="ui-banner__ribbon">
          <svg className="next-icon next-icon--24" viewBox="0 0 24 24">
            <path d="M12 0C5.4 0 0 5.4 0 12s5.4 12 12 12 12-5.4 12-12S18.6 0 12 0zm0 4c1.4 0 2.7.4 3.9 1L12 8.8 8.8 12 5 15.9c-.6-1.1-1-2.5-1-3.9 0-4.4 3.6-8 8-8zm0 16c-1.4 0-2.7-.4-3.9-1l3.9-3.9 3.2-3.2L19 8.1c.6 1.1 1 2.5 1 3.9 0 4.4-3.6 8-8 8z"></path>
          </svg>
        </div>
        <div className="ui-banner__content">
          <h2 className="ui-banner__title">
            {title}
          </h2>
          <ul>
            {errorMessages}
          </ul>
        </div>
      </div>
    )
  }

}
