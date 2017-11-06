var AppDispatcher = require('../dispatcher/dispatcher');
var Store = require('flux/utils').Store;
// var TagConstants = require('../constants/tag');
var Util = require('../util/util');
var _categories;
var CategoryStore = new Store(AppDispatcher);


CategoryStore.all = function() {
  if (!_categories) {
    return;
  }
};

module.exports = TagStore;
