var CurrentUserActions = require('../actions/current_user');
var CurrentUserConstants = require('../constants/current_user');
var QuestionActions = require('../actions/question');
var UserActions = require('../actions/user');
var TagActions = require('../actions/tag');
var BadgeActions = require('../actions/badge');
var SearchActions = require('../actions/search');
var hashHistory = require('react-router').hashHistory;
var CurrentUserStore = require('../stores/current_user');

function requireCurrentUser(callback) {
  if (CurrentUserStore.fetch().id) {
    callback();
  } else {
    CurrentUserActions.toggleSignupModalOn(true);
  }
}

module.exports = {
  // GETs

  fetchCurrentUser: function() {
    $.ajax({
      method: 'GET',
      url: '/api/users/current',
      dataType: 'json',
      success: CurrentUserActions.receiveCurrentUser,
      error: function() {
        debugger
      }
    });
  },
  fetchQuestions: function() {
    $.ajax({
      method: 'GET',
      url: 'api/questions',
      dataType: 'json',
      success: QuestionActions.receiveQuestions,
      error: function() {
        debugger
      }
    });
  },
  fetchCategories: function(){
    $.ajax({
      method: 'GET',
      url: 'api/questions/category_index',
      dataType: 'json',
      success: QuestionActions.receiveCategory,
      error: function() {
        debugger
      }
    });
  },
  fetchQuestion: function(questionId) {
    $.ajax({
      method: 'GET',
      url: 'api/questions/' + questionId,
      dataType: 'json',
      success: QuestionActions.receiveQuestion,
      error: function() {
        debugger
      }
    });
  },
  fetchTags: function() {
    $.ajax({
      method: 'GET',
      url: 'api/tags/',
      dataType: 'json',
      success: TagActions.receiveTags,
      error: function() {
        debugger;
      }
    });
  },
  fetchQuestionsTag: function(tagName) {
    if (tagName) {
      $.ajax({
        method: 'GET',
        url: 'api/tags/' + tagName,
        dataType: 'json',
        success: QuestionActions.receiveQuestionsTag,
        error: function() {
          debugger
        }
      });
    } else {
      QuestionActions.receiveQuestionsTag(tagName);
    }
  },
  fetchFilteredQuestions: function(filterVal){    
    $.ajax({
      method: 'GET',
      url: '/api/questions/search',
      data: { search: filterVal },
      dataType: 'json',
      success: QuestionActions.receiveQuestions,
      error: function() {
        debugger
      }
    });
  },
  fetchUser: function(userId) {
    $.ajax({
      method: 'GET',
      url: '/api/users/' + userId,
      dataType: 'json',
      success: UserActions.receiveUser,
      error: function() {
        debugger
      }
    });
  },
  fetchBadges: function() {
    $.ajax({
      method: 'GET',
      url: '/api/badges',
      dataType: 'json',
      success: BadgeActions.receiveBadges
    });
  },
  fetchBadge: function(badgeId) {
    $.ajax({
      method: 'GET',
      url: '/api/badges/' + badgeId,
      dataType: 'json',
      success: BadgeActions.receiveBadge
    });
  },
  searchPosts: function(query) {
    $.ajax({
      method: 'GET',
      url: 'api/search/query',
      data: { q: query },
      dataType: 'json',
      success: SearchActions.receivePosts,
      error: function() {
        debugger
      }
    });
  },
  fetchUserByAccountRecoverToken: function (token) {
    $.ajax({
      method: 'GET',
      url: '/api/users/password/edit?reset_password_token='+token,
      dataType: 'json',
      success: function (user) {
        CurrentUserActions.receiveCurrentUser(user);
      },
      error: function (response) {
        CurrentUserActions.receiveCurrentUser(JSON.parse(response.responseText));
      }
    });
  },

  // UPDATE

  updateCurrentUser: function(currentUserDetails) {
    var formData = new FormData();
    formData.append('[user][avatar]', currentUserDetails.profileImage);
    formData.append('[user][avatar]', currentUserDetails.profileImage);
    formData.append('[user][display_name]', currentUserDetails.displayName);
    formData.append('[user][email]', currentUserDetails.email);
    formData.append('[user][location]', currentUserDetails.location);
    formData.append('[user][bio]', currentUserDetails.bio);
    formData.append('[user][password]', currentUserDetails.password);

    $.ajax({
      method: 'PATCH',
      url: '/api/users/' + currentUserDetails.id,
      data: formData,
      processData: false,
      contentType: false,
      dataType: 'json',
      success: CurrentUserActions.receiveCurrentUserUpdateStatusOK,
      error: CurrentUserActions.receiveCurrentUserUpdateStatusBAD
    });
  },

  markItemRead: function(item) {
    var url = '/api/' + (item.category === 'Answer' ? 'answers' : 'comments') +
      '/' + item.id;

    var data = { 'current_user_update': true };
    if (item.category === 'Answer') {
      data['[answer][unread]'] = false;
    } else {
      data['[comment][unread]'] = false;
    }

    $.ajax({
      method: 'PATCH',
      url: url,
      data: data,
      dataType: 'json',
      success: CurrentUserActions.receiveCurrentUser,
      error: function() {
        debugger
      }
    });
  },

  updateQuestion: function(question) {
    var data = {
      '[question][title]': question.title,
      '[question][content]': question.content,
      '[question][tag_names]': question.tags,
      '[question][category_id]': question.category_id
    };
    $.ajax({
      method: 'PATCH',
      url: '/api/questions/' + question.id,
      data: data,
      dataType: 'json',
      success: function(question) {
        QuestionActions.receiveQuestion(question);
        hashHistory.push('/questions/' + question.id);
      },
      error: function() {
        debugger
      }
    });
  },

  updateAnswer: function(answer) {
    var data = {
      '[answer][content]': answer.content
    };
    $.ajax({
      method: 'PATCH',
      url: '/api/answers/' + answer.id,
      data: data,
      dataType: 'json',
      success: function(question) {
        QuestionActions.receiveAnswerUpdateOK(question);
        // var path = '/questions/' + question.id + '/answer/' + answer.id;
        // hashHistory.push(path);
      },
      error: function() {
        debugger
      }
    });
  },
  recoverAccount: function (userInfo) {
    var data = {
      '[user][password]': userInfo.password,
      '[user][password_confirmation]': userInfo.confirmPassword,
      '[user][reset_password_token]': userInfo.token,
    };
    $.ajax({
      method: 'PUT',
      url: '/api/users/password',
      data: data,
      dataType: 'json',
      success: function (user) {
        CurrentUserActions.receiveCurrentUser(user);
        alert("Password updated successfully!");
        hashHistory.push('/');
      },
      error: function (obj) {
        CurrentUserActions.receiveCurrentUser(JSON.parse(obj.responseText));
      }
    });
  },

  // POST and DELETE
  createUser: function(userInfo) {
    var data = {
      '[user][display_name]': userInfo.displayName,
      '[user][email]': userInfo.email,
      '[user][password]': userInfo.password,
    };
    $.ajax({
      method: 'POST',
      url: '/api/users',
      data: data,
      dataType: 'json',
      success: function(user) {
        CurrentUserActions.receiveCurrentUser(user);
      },
      error: function(obj) {
        CurrentUserActions.receiveCurrentUser(JSON.parse(obj.responseText));
      }
    });
  },
  createSession: function(userInfo) {
    var data = {
      '[user][email]': userInfo.email,
      '[user][password]': userInfo.password,
    };
    $.ajax({
      method: 'POST',
      url: '/api/session',
      data: data,
      dataType: 'json',
      success: function(user) {
        CurrentUserActions.receiveCurrentUser(user);
        CurrentUserActions.toggleSignupModalOn();
      },
      error: function(obj) {
        CurrentUserActions.receiveCurrentUser(JSON.parse(obj.responseText));
      }
    });
  },
  forgotPassword: function(userInfo) {
    var data = {
      '[user][email]': userInfo.email,
    };
    $.ajax({
      method: 'POST',
      url: '/api/users/password',
      data: data,
      dataType: 'json',
      success: function(response) {
        CurrentUserActions.successForgotPassword(response);
      },
      error: function(response) {
        alert(JSON.parse(response.responseText));
      }
    });
  },
  destroySession: function() {
    $.ajax({
      method: 'DELETE',
      url: '/api/session',
      success: CurrentUserActions.receiveCurrentUser,
      error: function() {
        debugger
      }
    });
  },
  createTag: function(tag) {
    var data = {
      '[tag][name]': tag.tagString,
      '[tag][description]': tag.newTagDescription,
    };
    $.ajax({
      method: 'POST',
      url: '/api/tags/',
      data: data,
      dataType: 'json',
      success: TagActions.receiveTag,
      error: function() {
        debugger
      }
    });
  },
  createVote: function(vote) {
    requireCurrentUser($.ajax.bind(null, {
      method: 'POST',
      url: '/api/votes',
      data: vote,
      dataType: 'json',
      success: QuestionActions.receiveQuestion,
      error: function() {
        debugger
      }
    }));
  },
  destroyVote: function(voteId) {
    $.ajax({
      method: 'DELETE',
      url: '/api/votes/' + voteId,
      dataType: 'json',
      success: QuestionActions.receiveQuestion,
      error: function() {
        debugger
      }
    });
  },
  createFavorite: function(questionId) {
    requireCurrentUser($.ajax.bind(null, {
      method: 'POST',
      url: '/api/favorites',
      data: { 'favorite[question_id]': questionId },
      dataType: 'json',
      success: QuestionActions.receiveQuestion,
      error: function() {
        debugger
      }
    }));
  },
  destroyFavorite: function(favoriteId) {
    $.ajax({
      method: 'DELETE',
      url: '/api/favorites/' + favoriteId,
      dataType: 'json',
      success: QuestionActions.receiveQuestion,
      error: function() {
        debugger
      }
    });
  },
  createComment: function(comment, callback) {
    requireCurrentUser($.ajax.bind(null, {
      method: 'POST',
      url: '/api/comments',
      data: comment,
      dataType: 'json',
      success: function(question) {
        QuestionActions.receiveQuestion(question);
        callback();
      },
      error: function() {
        debugger
      }
    }));
  },
  destroyComment: function(commentId) {
    $.ajax({
      method: 'DELETE',
      url: '/api/comments/' + commentId,
      dataType: 'json',
      success: QuestionActions.receiveQuestion,
      error: function() {
        debugger
      }
    });
  },
  createQuestion: function(question) {    
    var data = {
      '[question][title]': question.title,
      '[question][content]': question.content,
      '[question][tag_names]': question.tags,
      '[question][category_id]': question.category_id
    };    
    requireCurrentUser($.ajax.bind(null, {
      method: 'POST',
      url: 'api/questions',
      data: data,
      dataType: 'json',
      success: function(question) {
        QuestionActions.receiveQuestion(question);
        hashHistory.push('/questions/' + question.id);
      },
      error: function() {
        debugger
      }
    }));
  },
  createAnswer: function(answer, callback) {
    requireCurrentUser($.ajax.bind(null, {
      method: 'POST',
      url: '/api/answers',
      data: answer,
      dataType: 'json',
      success: function(question) {
        QuestionActions.receiveQuestion(question);
        callback();
      },
      error: function() {
        debugger
      }
    }));
  },
  destroyQuestion: function(questionId, callback) {
    $.ajax({
      method: 'DELETE',
      url: '/api/questions/' + questionId,
      dataType: 'json',
      success: function(questions) {
        callback();
        QuestionActions.receiveQuestions(questions);
      },
      error: function() {
        debugger;
      }
    });
  },
  destroyAnswer: function(answerId) {
    $.ajax({
      method: 'DELETE',
      url: '/api/answers/' + answerId,
      dataType: 'json',
      success: QuestionActions.receiveQuestion,
      error: function() {
        debugger;
      }
    });
  },
  fetchUsers: function() {
    $.ajax({
      method: 'GET',
      url: '/api/users',
      dataType: 'json',
      success: UserActions.receiveUsers,
      error: function() {
        debugger
      }
    });
  },
  contactToAdmin: function(form) {
    var data = {
      '[contact_us][name]': form.name,
      '[contact_us][email]': form.email,
      '[contact_us][subject]': form.subject,
      '[contact_us][message]': form.message
    };
    $.ajax({
      method: 'POST',
      url: '/api/contact_us/',
      data: data,
      dataType: 'json',
      success: function(response) {
        alert(response.messages.join(','));
      },
      error: function(response) {
        alert(JSON.parse(response.responseText));
      }
    });
  }
};
