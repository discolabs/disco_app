class ModelForm extends BaseForm {

  render() {
    const { modelTitle, modelName, modelUrl, modelsUrl, children, authenticityToken } = this.props;
    const errorsElement = this.getErrorsElement();

    return(
      <form action={modelUrl ? modelUrl : modelsUrl} acceptCharset="UTF-8" method="POST" data-shopify-app-submit="ea.save">
        <input type="hidden" name="utf8" value="✓"/>
        <input type="hidden" name="_method" value={modelUrl ? 'patch' : 'post'} />
        <input type="hidden" name="authenticity_token" value={authenticityToken}/>

        {errorsElement}

        {children}

        <ModelFormEmbeddedAppBar modelTitle={modelTitle} modelsUrl={modelsUrl} />
        <ModelFormPageActions modelName={modelName} modelUrl={modelUrl} modelsUrl={modelsUrl} />
      </form>
    )
  }
}

const ModelFormEmbeddedAppBar = ({ modelTitle, modelsUrl }) => {
  const buttons = {
    primary: {
      label: "Save",
      message: "ea.save"
    },
    secondary: [{
      label: "Cancel",
      href: modelsUrl
    }]
  };

  return (
    <EmbeddedAppBar title={modelTitle} buttons={buttons} />
  );
};

const ModelFormPageActions = ({ modelName, modelUrl, modelsUrl }) => {
  const primary = [
    <a href={modelsUrl} className="btn">Cancel</a>,
    <Button type="submit" primary={true}>{'Save' + (modelUrl ? '' : ' ' + modelName)}</Button>
  ];

  const secondary = modelUrl ? [
    <ModelDestroyButton
      label={'Delete ' + modelName}
      modelName={modelName}
      modelUrl={modelUrl}
      modelsUrl={modelsUrl}
    />
  ] : [];

  return (
    <UIPageActions primary={primary} secondary={secondary} />
  );
};
