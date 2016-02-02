var ShopFilterTab = React.createClass({

    /**
     * Handle a click event on the individual tab link.
     * @param e
     */
    handleClick: function(e) {
        e.preventDefault();

        // Don't do anything if this is already the currently selected tab.
        if(this.isActive()) return;

        this.props.onFilterTabSelected(this.props.filterTab);
    },

    /**
     * Return true if this is the currently active tab, determined by whether the filter values for this tab match the
     * currently active filter.
     * @returns {boolean}
     */
    isActive: function() {
        return (JSON.stringify(this.props.filterTab.filter) == JSON.stringify(this.props.filter));
    },

    render: function() {
        var tabClassName = this.isActive() ? 'next-tab next-tab--is-active' : 'next-tab';
        return (
            <li role="presentation">
                <a href="#" className={tabClassName} onClick={this.handleClick}>{this.props.filterTab.label}</a>
            </li>
        )
    }

});
