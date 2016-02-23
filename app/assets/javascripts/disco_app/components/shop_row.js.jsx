var ShopRow = (props) => {

    var shop = props.shop,
        editShopUrl = props.editShopUrl.replace(':id', shop.id),
        shopifyDomain = shop.attributes['shopify-domain'],
        countryName = shop.attributes['country-name'],
        currency = shop.attributes['currency'],
        domainName = shop.attributes['domain'],
        planName = shop.attributes['plan-display-name'],
        createdDate = shop.attributes['created-at']

    return (
        <tr>
            <td><a href={editShopUrl}>#{shop.id}</a></td>
            <td>{shopifyDomain}</td>
            <td>{shop.attributes.status}</td>
            <td>{shop.attributes.email}</td>
            <td>{countryName}</td>
            <td>{shop.attributes.currency}</td>
            <td>{shop.attributes.domain}</td>
            <td>{planName}</td>
            <td>{createdDate}</td>
        </tr>
    )
};
