class EmbeddedAppBar extends React.Component {

  componentDidMount() {
    const { title, icon, buttons, breadcrumb } = this.props;
    ShopifyApp.Bar.initialize({
      title: title,
      icon: icon || DiscoApp.INITIAL_ICON,
      buttons: buttons,
      breadcrumb: breadcrumb
    });
  }

  render() {
    return null;
  }

}

EmbeddedAppBar.propTypes = {
  title: React.PropTypes.string.isRequired,
  icon: React.PropTypes.string,
  buttons: React.PropTypes.object,
  breadcrumbs: React.PropTypes.object
};

EmbeddedAppBar.defaultProps = {
  icon: undefined,
  buttons: {},
  breadcrumbs: undefined
};
