/**
 * Base class providing helper method for deciding if an input contains errors.
 * Expects subclasses to have `name` and `errors`  props.
 **/
class BaseInput extends React.Component {

  /**
   * Checks if the component has associated errors or not
   **/
  hasError() {
    if (!(this.props && this.props.name)) {
      return false;
    }
    var fieldName = this.props.name.substring(this.props.name.lastIndexOf("[") + 1, this.props.name.lastIndexOf("]")); 
    return (fieldName &&
            this.props.errors && 
            this.props.errors.errors &&
            this.props.errors.errors.indexOf(fieldName) > -1);
  }
}
