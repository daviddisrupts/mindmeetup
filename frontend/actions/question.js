var QuestionConstants = require('../constants/question');
var CategoryConstants = require('../constants/category');
var AppDispatcher = require('../dispatcher/dispatcher');

module.exports = {
  receiveQuestions: function(questions) {
    AppDispatcher.dispatch({
      action: questions,
      actionType: QuestionConstants.RECEIVE_QUESTIONS
    });
  },
  receiveCategory: function(categories){
    AppDispatcher.dispatch({
      action: categories,
      actionType: CategoryConstants.RECEIVE_CATEGORIES
    });
  },
  changeQuestionSort: function(sortBy) {    
    AppDispatcher.dispatch({
      action: sortBy,
      actionType: QuestionConstants.CHANGE_QUESTION_SORT
    });
  },
  changeQuestionFilter: function(sortBy) {       
    AppDispatcher.dispatch({
      action: sortBy,
      actionType: QuestionConstants.CHANGE_QUESTION_FILTER
    });
  },
  receiveQuestion: function(question) {
    AppDispatcher.dispatch({
      action: question,
      actionType: QuestionConstants.RECEIVE_QUESTION
    });
  },
  changeAnswerSort: function(sortBy) {
    AppDispatcher.dispatch({
      action: sortBy,
      actionType: QuestionConstants.CHANGE_ANSWER_SORT
    });
  },
  receiveQuestionsTag: function(tag) {
    AppDispatcher.dispatch({
      action: tag,
      actionType: QuestionConstants.RECEIVE_QUESTIONS_TAG
    });
  },
  receiveAnswerUpdateOK: function(question) {
    AppDispatcher.dispatch({
      action: question,
      actionType: QuestionConstants.RECEIVE_ANSWER_UPDATE_OK
    });
  }
};
