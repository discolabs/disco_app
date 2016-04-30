var ShopRow = (props) => {

    var shop = props.shop,
        editShopUrl = props.editShopUrl.replace(':id', shop.id),
        domainName = shop.attributes['domain'],
        countryName = shop.attributes['country-name'],
        currency = shop.attributes['currency'],
        planName = shop.attributes['plan-display-name'],
        editSubscriptionUrl = props.editSubscriptionUrl
          .replace(':shop_id', shop.id)
          .replace(':id', shop.attributes['current-subscription-id']),
        subscriptionPlan = shop.attributes['current-subscription-display-plan'],
        subscriptionAmount = shop.attributes['current-subscription-display-amount'],
        installedDuration = shop.attributes['installed-duration'];

    var subscriptionContent = null;
    if(shop.attributes['current-subscription-id']) {
      subscriptionContent = <a href={editSubscriptionUrl}>{subscriptionPlan} ({subscriptionAmount})</a>;
    } else {
      subscriptionContent = <span>{subscriptionPlan} ({subscriptionAmount})</span>;
    }

    return (
        <tr>
            <td><a href={editShopUrl}>{domainName}</a></td>
            <td>{shop.attributes.email}</td>
            <td>{shop.attributes.status}</td>
            <td>{countryName}</td>
            <td>{planName}</td>
            <td>{subscriptionContent}</td>
            <td>{installedDuration}</td>
        </tr>
    )
};
