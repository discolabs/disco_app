/**
 * ShopifyAdminLink
 *
 * Renders a link pointing to an object (such as an order or customer) inside
 * the given shop's Shopify admin. This helper makes it easy to  create links
 * to objects within the admin that support both right-clicking and opening in
 * a new tab as well as capturing a left click and redirecting to the relevant
 * object using `ShopifyApp.redirect()`.
 *
 * This component is the React equivalent to the link_to_shopify_admin helper
 * found in app/helpers/disco_app/application_helper.rb.
 */
var ShopifyAdminLink = React.createClass({

    handleClick: function(e) {
        e.preventDefault();
        ShopifyApp.redirect(this.props.href);
    },

    render: function() {
        var href = '/admin' + this.props.href;
        return (
            <a className={this.props.className} href={href} onClick={this.handleClick}>
                {this.props.label}
            </a>
        )
    }

});
