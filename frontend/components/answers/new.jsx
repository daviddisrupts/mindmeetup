var React = require('react');
var ApiUtil = require('../../util/api_util');

function renderHeader(userAnswered, hidden) {
  if (userAnswered) {
    return (
      <span onClick={this.toggleHidden} className='question-new-toggle-hidden'>
        Give Another Answer?
      </span>
    );
  } else {
    return 'Your Answer';
  }
}

var AnswersNew = React.createClass({
  getInitialState: function() {
    return { content: '', hidden: true };
  },
  handleChange: function(e) {
    this.setState ({ content: e.currentTarget.value });
  },
  handleSubmit: function() {
    if (this.state.content.length) {
      ApiUtil.createAnswer({
        'answer[content]': this.state.content,
        'answer[question_id]': this.props.question.id
      }, this.resetState);
    }
  },
  toggleHidden: function() {
    if (this.state.hidden) {
      this.setState({ hidden: false });
    } else {
      this.setState({ hidden: true });
    }
  },
  resetState: function() {
    this.setState({ content: '', hidden: true });
  },
  render: function() {
    var buttonClass = '', textAreaClass=' item-content-input';
    if (!this.state.content.length) {
      buttonClass += ' button-disabled';
    }
    if (this.state.hidden && this.props.question.user_answered) {
      buttonClass += ' hidden';
      textAreaClass += ' hidden';
    }
    return (
      <div className='item-new-double-main'>
        <div className='answer-new-header'>
          {renderHeader.call(
            this, this.props.question.user_answered, this.state.hidden
          )}
        </div>
        <textarea
          value={this.state.content}
          onChange={this.handleChange}
          className={textAreaClass} />
        <button
          className={buttonClass}
          onClick={this.handleSubmit}>
          Post Answer
        </button>
      </div>
    );
  }
});

module.exports = AnswersNew;