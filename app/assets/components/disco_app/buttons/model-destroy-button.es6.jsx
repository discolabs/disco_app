const ModelDestroyButton = ({ label, modelName, modelUrl, modelsUrl }) => {

  const openModal = () => {
    var Modal = AppBridge.actions.Modal;
    var Button = AppBridge.actions.Button;
    var okButton = Button.create(app, {label: 'Delete ' + modelName});
    okButton.subscribe(Button.Action.CLICK, () => {
      $.ajax({
        url: modelUrl,
        method: 'DELETE',
        contentType: 'application/json',
        dataType: 'json',
        success: function() {
          window.location.href = modelsUrl;
        }
      });
    });
    var cancelButton = Button.create(app, {label: 'Cancel'});
    Modal.create(
      app,
      {
        title: 'Delete ' + modelName + '?',
        message: 'Are you sure you want to delete this ' + modelName + '?',
        size: Modal.SIZE.SMALL,
        footer: {
          buttons: {
            primary: okButton,
            secondary: [cancelButton],
          }
        }
      }
    );
  };

  return (
    <Button destroy={true} onClick={openModal}>{label}</Button>
  );

};
