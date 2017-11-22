var React = require('react');
var ReactDOM = require('react-dom');
var Router = require('react-router').Router;
var Route = require('react-router').Route;
var IndexRoute = require('react-router').IndexRoute;
var Redirect = require('react-router').Redirect;
var NavBar = require('./components/nav/nav_bar');
var QuestionsIndex = require('./components/questions/index');
var hashHistory = require('react-router').hashHistory;
var QuestionShow = require('./components/questions/show');
var QuestionsForm = require('./components/questions/form');
var QuestionEdit = require('./components/questions/edit');
var UsersIndex = require('./components/users/index');
var TagsIndex = require('./components/tags/index');
var UserShow = require('./components/users/show');
var BadgesIndex = require('./components/badges/index');
var BadgeShow = require('./components/badges/show');
var Search = require('./components/search/search');
var UserRecoverAccount = require('./components/users/recover_account');
var TermsOfService = require('./components/static_pages/terms_of_service');
var PrivacyPolicy = require('./components/static_pages/privacy_policy');
var ContactUs = require('./components/static_pages/contact_us');
var AboutUs = require('./components/static_pages/about_us');

var App = (
  <Router history={hashHistory}>
    <Route path='/' component={NavBar}>
      <IndexRoute component={QuestionsIndex} />
      <Route path='users/account-recovery(/:query)' component={UserRecoverAccount} />
      <Route path='questions' component={QuestionsIndex} />
      <Route path='questions/tagged/:tagName' component={QuestionsIndex} />
      <Route path='questions/:questionId(/answer/:answerId)' component={QuestionShow} />
      <Route path='questions/:questionId(/comment/:commentId)' component={QuestionShow} />
      <Route path='questions/:questionId/edit' component={QuestionEdit} />
      <Route path='ask' component={QuestionsForm} />
      <Route path='users' component={UsersIndex} />
      <Route path='users/:userId(/:tab)' component={UserShow} />
      <Route path='tags' component={TagsIndex} />
      <Route path='awards' component={BadgesIndex} />
      <Route path='awards/:badgeId' component={BadgeShow} />
      <Route path='search(/:query)' component={Search} />
      <Route path='terms_of_service' component={TermsOfService} />
      <Route path='privacy_policy' component={PrivacyPolicy} />
      <Route path='contact_us' component={ContactUs} />
      <Route path='about_us' component={AboutUs} />
    </Route>
  </Router>
);

// IDEAL GOAL
// var App = (
//   <Router>
//     <Route path='/' component={NavBar}>
//       <IndexRoute component={Home}/>
//       <Route path='questions/' component={QuestionsIndex} />
//       <Route path='tags/' component={TagsIndex}/>
//     </Route>
//   </Router>
// );

document.addEventListener('DOMContentLoaded', function() {
  var root = document.getElementById('root');
  if (root) {
    ReactDOM.render(App, document.getElementById('root'));
  }
});
