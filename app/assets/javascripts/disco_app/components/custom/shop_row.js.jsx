var ShopRow = (props) => {

    var shop = props.shop,
        editShopUrl = props.editShopUrl.replace(':id', shop.id),
        shopifyDomain = shop.attributes['shopify_domain'],
        countryName = shop.attributes['country_name'],
        currency = shop.attributes['currency'],
        domainName = shop.attributes['domain'],
        planName = shop.attributes['plan_display_name'],
        createdDate = shop.attributes['created_at'],
        installedDuration = shop.attributes['installed_duration']

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
            <td>{installedDuration}</td>
        </tr>
    )
};
