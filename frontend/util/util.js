module.exports = {
  capitalize: function(string) {
    return string[0].toUpperCase() + string.slice(1);
  },

  handleSigularize: function(string, count) {
    if (count === 1 && string[string.length - 1] === 's') {
      return string.slice(0, (string.length - 1));
    } else {
      return string;
    }
  },

  // NOTE: defaults to ascending
  sortBy: function(items, sortType, isDescending, sortType2, isDescending2) {    
      if (sortType === 'rank') {
        items.sort(function(a, b) {
          if (a.rank === 'bronze' && b.rank === 'silver' ||
              a.rank === 'bronze' && b.rank === 'gold' ||
              a.rank === 'silver' && b.rank === 'gold') {
            return isDescending ? 1 : -1;
          } else if (a.rank === 'gold' && b.rank === 'silver' ||
              a.rank === 'gold' && b.rank === 'bronze' ||
              a.rank === 'silver' && b.rank === 'bronze') {
            return isDescending ? -1 : 1;
          } else if (a.rank === b.rank) {
            if (sortType2) {
              if (a[sortType2] < b[sortType2]) {
                return isDescending2 ? 1 : -1;
              } else if (a[sortType2] > b[sortType2]) {
                return isDescending2 ? -1 : 1;
              } else if (a[sortType2] === b[sortType2]) {
                return 0;
              }

            } else {
              return 0;
            }
          }
        });
      } else {
        items.sort(function(a, b) {          
          if (a[sortType] < b[sortType]) {
            return isDescending ? 1 : -1;
          } else if (a[sortType] > b[sortType]) {
            return isDescending ? -1 : 1;
          } else if (a[sortType] === b[sortType]) {

            if (sortType2) {
              if (a[sortType2] < b[sortType2]) {
                return isDescending2 ? 1 : -1;
              } else if (a[sortType2] > b[sortType2]) {
                return isDescending2 ? -1 : 1;
              } else if (a[sortType2] === b[sortType2]) {
                return 0;
              }

            } else {
              return 0;
            }
          }
        });
      }      
  },

  filterBy: function(items, sortType){    
    if (sortType === 'unanswer') {     
      items = items.filter(function(item) {
          return item.answer_count == 0;
        });          
    }
   if (sortType === 'monthly') {
      items = items.filter( item => ( (item.created_at).getMonth() == (new Date).getMonth() ));
    }
    if (sortType === 'weekly') {
        var curr = new Date(); // get current date        
        curr.setHours(0,0,0,0);
        var first = curr.getDate() - curr.getDay(); // First day is the day of the month - the day of the week
        var last = first + 6; // last day is the first day + 6

        var firstday = new Date(curr.setDate(first))
        var lastday = new Date(firstday.getTime() + 60 * 60 *24 * 6 * 1000)
        lastday.setHours(23,59,0,0);
        items = items.filter( item => ( ((item.created_at >= firstday) && (item.created_at <= lastday)) ))
    }
    return items;      
  },
  formatDateHelper: function (item) {
    if (item.created_at) {
      item.created_at = new Date(item.created_at);
    }
    if (item.updated_at) {
      item.updated_at = new Date(item.updated_at);
    }
  },
  snakeCaseToCamelSpace: function(string) {
    words = string.split('_');
    words = words.map(this.capitalize);
    return words.join(' ');
  },
  handleTagTitleAttr: function(tag) {
    var title = [];
    var questionWord = tag.question_count === 1 ? 'question' : 'questions';
    var answerWord = tag.answer_count === 1 ? 'answer' : 'answers';
    if (tag.question_count) {
      title.push('Asked ' + tag.question_count + ' ' + questionWord +
        ' with a total score of ' + tag.question_reputation + '.');
    }
    if (tag.answer_count) {
      title.push('Gave ' + tag.answer_count + ' ' + answerWord +
        ' with a total score of ' + tag.answer_reputation + '.');
    }
    return title.join(' ');
  },

  // DRY avatar image src for easier source modification
  avatarSrc: function(userId) {
    return 'https://robohash.org/' + userId + '?bgset=any';
  }
};
