class ModelForm extends BaseForm {

  render() {
    const { modelName, modelUrl, modelsUrl, children, authenticityToken } = this.props;
    const errors = this.renderErrors();

    return(
      <form action={modelUrl ? modelUrl : modelsUrl} acceptCharset="UTF-8" method="POST" data-shopify-app-submit="ea.save">
        <input type="hidden" name="utf8" value="✓"/>
        <input type="hidden" name="_method" value={modelUrl ? 'patch' : 'post'} />
        <input type="hidden" name="authenticity_token" value={authenticityToken}/>

        {(() => {
          if (!errors) return false;
          return (
            {errors}
          );
        })()}

        {children}

        <ModelFormPageActions modelName={modelName} modelUrl={modelUrl} modelsUrl={modelsUrl} />
      </form>
    )
  }
}

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
