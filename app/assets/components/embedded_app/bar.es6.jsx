class EmbeddedAppBar extends React.Component {

  componentDidMount() {
    const { title, icon, buttons, breadcrumb } = this.props;
    const TitleBar = AppBridge.actions.TitleBar;
    TitleBar.create(
      app,
      {
        title: title || DiscoApp.INITIAL_TITLE,
        icon: icon || DiscoApp.INITIAL_ICON,
        buttons: buttons,
        breadcrumb: breadcrumb
      }
    );
  }

  render() {
    return null;
  }

}

EmbeddedAppBar.propTypes = {
  title: React.PropTypes.string,
  icon: React.PropTypes.string,
  buttons: React.PropTypes.object,
  breadcrumbs: React.PropTypes.object
};

EmbeddedAppBar.defaultProps = {
  title: undefined,
  icon: undefined,
  buttons: {},
  breadcrumbs: undefined
};
