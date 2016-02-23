var FilterableShopList = React.createClass({

    getDefaultProps: function() {
        return {
            filterTabs: [
                { label: 'All Shops', filter: {} },
                { label: 'Never Installed', filter: { 'filter[status]': 'never_installed' } },
                { label: 'Awaiting Install', filter: { 'filter[status]': 'awaiting_install' } },
                { label: 'Installing', filter: { 'filter[status]': 'installing' } },
                { label: 'Installed', filter: { 'filter[status]': 'installed' } },
                { label: 'Awaiting Uninstall', filter: { 'filter[status]': 'awaiting_uninstall' } },
                { label: 'Uninstalling', filter: { 'filter[status]': 'uninstalling' } },
                { label: 'Uninstalled', filter: { 'filter[status]': 'uninstalled' } }
            ],
            availableFilters: {
                'filter[status]': {
                    getLabel: function(value) {
                        return 'Status is ' + value;
                    }
                }
            }
        }
    },

    getInitialState: function() {
        return {
            filter: {}
        };
    },

    onFilterReplace: function(filter) {
        this.setState({
            filter: filter
        });
    },

    onFilterSet: function(name, value) {
        this.onFiltersSet([{
            name: name,
            value: value
        }]);
    },

    onFiltersSet: function(filters) {
        var nextFilter = $.extend({}, this.state.filter);
        filters.forEach(function(filter) {
            if(!filter.value) {
                delete nextFilter[filter.name];
            } else {
                nextFilter[filter.name] = filter.value;
            }
        });
        this.onFilterReplace(nextFilter);
    },

    render: function() {
        return (
            <div className="next-card">
              <ShopFilterTabs filterTabs={this.props.filterTabs} filter={this.state.filter} onFilterReplace={this.onFilterReplace} />
              <ShopList shopsUrl={this.props.shopsUrl} editShopUrl={this.props.editShopUrl} filter={this.state.filter} />
            </div>
        );
    }

});
