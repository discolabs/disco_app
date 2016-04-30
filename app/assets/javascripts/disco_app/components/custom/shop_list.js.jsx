var ShopList = React.createClass({

    getDefaultProps: function() {
        return {
            pageSize: 20
        }
    },

    getInitialState: function() {
        return {
            shops: [],
            page: 1
        }
    },

    componentDidMount: function() {
        this.getShops();
        $(document).on('shops.changed', this.onShopsChanged);
    },

    componentWillUnmount: function() {
      $(document).off('shops.changed', this.onShopsChanged);
    },

    componentDidUpdate: function (prevProps, prevState) {
        if(prevProps.filter != this.props.filter) {
            this.getShops();
        }
        if(prevState.page != this.state.page) {
            this.getShops();
        }
    },

    onPageChanged: function(increment) {
        this.setState({page: this.state.page + increment});
    },

    onShopsChanged: function() {
        this.setState({page: 1});
        this.getShops();
    },

    getShops: function() {
        //ShopifyApp.Bar.loadingOn();

        // Set up request data with filter and pagination parameters.
        var data = $.extend({
            'page[size]': this.props.pageSize,
            'page[number]': this.state.page
        }, this.props.filter);

        // Make the request to fetch the order list.
        $.getJSON(this.props.shopsUrl, data, function(result) {
            if(this.isMounted()) {
                this.setState({
                    shops: result.data
                });
            }
        }.bind(this))
        .always(function() {
            //ShopifyApp.Bar.loadingOff();
        });
    },

    render: function() {
        var shopRows = this.state.shops.map(function(shop, index) {
            if ((index >= ((this.state.page - 1) * this.props.pageSize)) && (index <  this.state.page * this.props.pageSize)) {
            return (
                <ShopRow shop={shop} editShopUrl={this.props.editShopUrl} editSubscriptionUrl={this.props.editSubscriptionUrl} key={shop.id} />
            )
            } else {
              return null;
            }
        }.bind(this));

        return (
            <div>
                <div className="next-card__section">
                    <table className="table-hover expanded">
                        <thead>
                            <tr>
                                <th>Shop</th>
                                <th>Status</th>
                                <th>Country</th>
                                <th>Shopify Plan</th>
                                <th>Subscription</th>
                                <th>Source</th>
                                <th>Installed for</th>
                            </tr>
                        </thead>
                        <tbody>
                            {shopRows}
                        </tbody>
                    </table>
                </div>
                <div className="next-card__section">
                    <div className="next-grid next-grid--no-padding next-grid--center-aligned">
                        <div className="next-grid__cell next-grid__cell--no-flex">
                            <ShopList.Paginator page={this.state.page} pageSize={this.props.pageSize} items={this.state.shops} onPageChanged={this.onPageChanged} />
                        </div>
                    </div>
                </div>
            </div>
        )
    }

});

/**
 * Paginator.
 */
ShopList.Paginator = React.createClass({

    handlePreviousClick: function(e) {
        this.props.onPageChanged(-1);
    },

    handleNextClick: function(e) {
        this.props.onPageChanged(1);
    },

    render: function() {
        return (
            <div className="btn-group" role="group">
                <ShopList.PaginatorButton label="&lsaquo;" isDisabled={this.props.page < 2} onClick={this.handlePreviousClick} />
                <ShopList.PaginatorButton label="&rsaquo;" isDisabled={this.props.items.length < this.props.pageSize * this.props.page} onClick={this.handleNextClick} />
            </div>
        )
    }

});

/**
 * Individual button within a paginator.
 */
ShopList.PaginatorButton = (props) => {
    var className = 'btn btn-default' + (props.isDisabled ? ' disabled' : '');
    return (
        <button className={className} disabled={props.isDisabled} onClick={props.onClick}>{props.label}</button>
    )
};
