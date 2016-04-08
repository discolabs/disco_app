class InlineRadioOptions extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      value: props.value
    }
  }

  onChange(value) {
    this.setState({
      value: value
    })
  }

  render() {
    const { name, label, options } = this.props;

    const optionElements = options.map((option, optionIndex) => {
      return (
        <InputRadio
          key={option.value}
          name={name}
          value={option.value}
          label={option.label}
          inline={true}
          isLast={optionIndex === (options.length - 1)}
          checked={option.value === this.state.value}
          onChange={this.onChange.bind(this)}
        />
      );
    });

    return (
      <CardSection wrappable={true}>
        <div className="wrappable__item wrappable__item--no-flex">
          <span>{label}</span>
        </div>
        <div className="wrappable__item">
          {optionElements}
        </div>
      </CardSection>
    );
  }

}

InlineRadioOptions.propTypes = {
  name: React.PropTypes.string,
  options: React.PropTypes.arrayOf(
    React.PropTypes.shape({
      label: React.PropTypes.string.isRequired,
      value: React.PropTypes.oneOfType([
        React.PropTypes.string,
        React.PropTypes.bool
      ]).isRequired
    })
  ).isRequired
};
