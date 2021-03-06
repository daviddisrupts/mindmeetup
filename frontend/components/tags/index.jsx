var React = require('react');
var SortNav = require('../shared/sort_nav');
var UserStore = require('../../stores/user');
var UserActions = require('../../actions/user');
var ApiUtil = require('../../util/api_util');
var TagsIndexItem = require('./index_item');
var SubSearch = require('../shared/sub_search');
var TagStore = require('../../stores/tag');
var TagActions = require('../../actions/tag');

var TAG_SORT_TYPES = ['popular', 'name'];

var _callbackId;

var TagsIndex = React.createClass({
  getInitialState: function() {
    return {
      tags: TagStore.all(),
      sortBy: TagStore.getSortBy(),
      search: '',
      indexLoaded: TagStore.getIndexLoaded()
    };
  },
  componentDidMount: function() {
    _callbackId = TagStore.addListener(this.onChange);
    ApiUtil.fetchTags();
  },
  componentWillUnmount: function() {
    TagActions.resetTagStoreSettings();
    _callbackId.remove();
  },
  handleSortChange: function(sortBy) {
    TagActions.changeTagSort(sortBy);
  },
  onChange: function() {
    this.setState({
      tags: TagStore.all(),
      sortBy: TagStore.getSortBy(),
      indexLoaded: TagStore.getIndexLoaded()
    });
  },
  handleSearchChange: function(e) {
    var searchValue = e.currentTarget.value;
    TagActions.changeTagSearchTerm(searchValue);
    this.setState({ search: searchValue });
  },
  render: function() {
    var tags = this.state.tags.map(function(tag) {
      return (
        <TagsIndexItem
          tag={tag}
          sortBy={this.state.sortBy}
          key={'tag-' + tag.id}/>
      );
    }.bind(this));
    return (
      <div className='tags-index-container'>
        <SortNav
          tabShift='right'
          links={TAG_SORT_TYPES}
          active={this.state.sortBy}
          header='Tags'
          handleSortChange={this.handleSortChange}/>
        <SubSearch
          indexLoaded={this.state.indexLoaded}
          search={this.state.search}
          handleSearchChange={this.handleSearchChange}/>
        <div className='tags-index-item-container'>
          {tags}
        </div>
      </div>
    );
  }
});

module.exports = TagsIndex;
