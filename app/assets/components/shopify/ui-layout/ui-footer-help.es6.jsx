const UIFooterHelp = ({ __html }) => {

  return(
    <div className="ui-footer-help">
      <div className="ui-footer-help__content">
        <div>
          <p dangerouslySetInnerHTML={{__html: __html}} />
        </div>
      </div>
    </div>
  )

};
