var React = require('react');
var SortNav = require('../shared/sort_nav');
var QuestionStore = require('../../stores/question');
var QuestionActions = require('../../actions/question');
var ShowItem = require('../questions/show_item');

function answerHeader(answersLength) {
  return answersLength + ' Answer' + (answersLength === 1 ? '' : 's');
}
var ANSWER_SORT_TYPES = ['active', 'oldest', 'votes'];

var AnswersIndex = React.createClass({
  handleSortChange: function(sortBy) {
    if (sortBy !== this.props.answerSortBy) {
      QuestionActions.changeAnswerSort(sortBy);
    }
  },
  render: function() {
    var AnswerIndexItems = this.props.answers.map(function(answer) {
      return (
        <ShowItem
          key={'answer-' + answer.id}
          type='Answer'
          item={answer}
          handleVote={this.props.handleVote}
          handleUserClick={this.props.handleUserClick}
          handleTagClick={this.props.handleTagClick}
          handleToolClick={this.props.handleToolClick} />
      );

    }.bind(this));
    return (
      <div className='answers-index-container'>
        <SortNav
          links={ANSWER_SORT_TYPES}
          active={this.props.answerSortBy}
          header={answerHeader(this.props.answers.length)}
          handleSortChange={this.handleSortChange} />
        {AnswerIndexItems}
      </div>
    );
  }
});

module.exports = AnswersIndex;