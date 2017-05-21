/**
 * Base class for form components that provides helper methods
 * for rendering errors associated with the form
 **/
class BaseForm extends React.Component {

  /**
   * Returns the JSX required to render a list of errors.
   *
   * @returns {*}
   */
  getErrorsElement() {
    const { errors } = this.props;

    // Don't render anything if no errors present.
    if(!errors || !errors.errors || (errors.errors.length == 0)) {
      return null;
    }

    const errorCount = errors.errors.length;
    const singleError = (errorCount == 1);

    return (
      <div className="ui-banner ui-banner--status-error ui-banner--default-vertical-spacing ui-banner--default-horizontal-spacing">
        <div className="ui-banner__ribbon">
          <svg className="next-icon next-icon--24" viewBox="0 0 24 24">
            <use xmlns="http://www.w3.org/1999/xlink" xlinkHref="#next-error" />
          </svg>
        </div>
        <div className="ui-banner__content">
          <h2 className="ui-banner__title">
            There {singleError ? 'is' : 'are'} {errorCount} error{singleError ? '' : 's'} for this {errors.type}:
          </h2>
          <ul>
            {errors.messages.map((message, i) => {
              return <li key={i}>{message}</li>;
            })}
          </ul>
        </div>
      </div>
    )
  }

}
