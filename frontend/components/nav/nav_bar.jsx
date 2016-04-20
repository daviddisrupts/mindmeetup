var React = require('react');
var CurrentUserStore = require('../../stores/current_user');
var ApiUtil = require('../../util/api_util');
var hashHistory = require('react-router').hashHistory;
var NavHeaderLink = require('./header_link');

var HEADERS = ['questions', 'jobs', 'tags', 'users', 'badges', 'ask'];

var _callbackId;
var NavBar = React.createClass({
  getInitialState: function() {
    return { currentUser: CurrentUserStore.fetch() };
  },
  componentDidMount: function() {
    _callbackId = CurrentUserStore.addListener(this.onChange);
    ApiUtil.fetchCurrentUser();
  },
  componentWillUnmount: function() {
    _callbackId.remove();
  },
  onChange: function() {
    this.setState({ currentUser: CurrentUserStore.fetch() });
  },
  navigate: function(destination) {
    hashHistory.push(destination);
  },
  render: function() {
    var NavHeaderLinks = HEADERS.map(function(name) {
      return (
        <NavHeaderLink
          key={'header-' + name}
          link={name}
          navigate={this.navigate}
          currentPath={this.props.location.pathname} />);
    }.bind(this));
    var currentUser = this.state.currentUser;
    return (
      <div>
        <div className='nav-container'>
          <div className='main-content group'>
            <ul className='nav-left-container base'>
              <li>SnackOverflow</li>
              <li>Inbox</li>
              <li>Notifications</li>
            </ul>
            <ul className='nav-right-container base'>
              <li>{currentUser.display_name + ' ' + currentUser.reputation}
              </li>
              <li>help</li>
              <li id='nav-search-container'>
                <input className='nav-search' type='text' placeholder="? Search"/>
              </li>
            </ul>
          </div>
        </div>

        <div className='nav-header main-content group'>
          <ul className='nav-left-container base'>
            <li onClick={this.navigate.bind(null, '/')}>
              <h1 className='logo'>SnackOverflow</h1>
            </li>
          </ul>
          <ul className='nav-right-container base'>
            {NavHeaderLinks}
          </ul>
        </div>

        <main className='main-content group'>
          {this.props.children}
        </main>
      </div>
    );
  }
});

module.exports = NavBar;
