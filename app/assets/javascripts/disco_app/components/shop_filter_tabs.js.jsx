var ShopFilterTabs = React.createClass({

    onFilterTabSelected: function(filterTab) {
        this.props.onFilterReplace(filterTab.filter);
    },

    render: function() {
        var filterTabNodes = this.props.filterTabs.map(function(filterTab) {
            return (
                <ShopFilterTab key={filterTab.label} filter={this.props.filter} filterTab={filterTab} onFilterTabSelected={this.onFilterTabSelected} />
            )
        }, this);

        return (
            <ul className="next-tab__list">
                {filterTabNodes}
            </ul>
        )
    }

});
