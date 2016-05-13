const ShopFilterQuery = ({ filter, onFilterSet }) => {

  const onChange = (value) => {
    onFilterSet('filter[query]', value);
  };

  return (
    <CardSection>
      <InputText label="Search" placeholder="Start typing to search for stores..." labelHidden={true} value={filter.query} onChange={onChange} />
    </CardSection>
  );

};
