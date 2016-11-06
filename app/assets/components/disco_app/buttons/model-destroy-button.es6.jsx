const ModelDestroyButton = ({ label, modelName, modelUrl, modelsUrl }) => {

  const openModal = () => {
    ShopifyApp.Modal.confirm({
      title: 'Delete ' + modelName + '?',
      message: 'Are you sure you want to delete this ' + modelName + '?',
      okButton: 'Delete ' + modelName,
      cancelButton: 'Cancel',
      style: 'danger'
    }, handleModalResult);
  };

  const handleModalResult = (result) => {
    if(result) {
      $.ajax({
        url: modelUrl,
        method: 'DELETE',
        contentType: 'application/json',
        dataType: 'json',
        success: function() {
          window.location.href = modelsUrl;
        }
      });
    }
  };

  return (
    <Button destroy={true} onClick={openModal}>{label}</Button>
  );

};
