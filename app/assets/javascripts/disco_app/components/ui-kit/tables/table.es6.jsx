const Table = ({ children, scrollable, sticky }) => {

  const className = classNames({
    'table-wrapper': true,
    'table-wrapper--scrollable': scrollable,
    'table-wrapper--sticky': sticky
  });

  return (
    <div className={className}>
      <table className="expanded">
        {children}
      </table>
    </div>
  );
};

Table.PropTypes = {
  children: React.PropTypes.node.isRequired,
  scrollable: React.PropTypes.bool,
  sticky: React.PropTypes.bool
};

Table.defaultProps = {
  scrollable: false,
  sticky: false
};
