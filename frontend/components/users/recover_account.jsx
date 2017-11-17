var React = require('react');
var ApiUtil = require('../../util/api_util');
var CurrentUserStore = require('../../stores/current_user');

var UserRecoverAccount = React.createClass({
	 getInitialState: function() {
    return {
      password: '',
      confirmPassword: '',
      currentUser: {email: ""},
      token: null,
      token_errors: false,
      form_errors: false,
      messages: false
    };
  },
  componentDidMount: function() {
    _callbackId = CurrentUserStore.addListener(this.onChange);
  },
  onChange: function() {
    var currentUser = CurrentUserStore.fetch();
    this.setState({currentUser: currentUser})
    if (currentUser.errors) {
      if(currentUser.type === 'TOKEN_ERROR'){
      	this.setState({ token_errors: currentUser.errors });
      } else {
      	this.setState({ form_errors: currentUser.errors });
      }
    }
  },
  componentWillMount: function() {
  	const link = window.location.href.split("?")[1];
  	const params = new URLSearchParams(link);
  	const token = params.get('reset_password_token');
  	this.setState({token: token});
    ApiUtil.fetchUserByAccountRecoverToken(token);
  },
  handleChange: function(type, e) {
    switch (type) {
      case 'password':
        this.setState({ password: e.currentTarget.value });
        break;
      case 'confirmPassword':
        this.setState({ confirmPassword: e.currentTarget.value });
        break;
    }
  },
  handleSubmit: function() {
    this.setState({ form_errors: false, token_errors: false, messages: false  });
    ApiUtil.recoverAccount(this.state)
  },
  componentWillUnmount: function() {
  	_callbackId.remove();
  },
	render: function() {
		var passwordPlaceholder,confirmPasswordPlaceholder,recoverAccountButton, errors;
		passwordPlaceholder = 'new password',
		confirmPasswordPlaceholder = 'new password(again)',
		recoverAccountButton = 'Recover Account'
		if (this.state.form_errors.length || this.state.token_errors) {
      errors = (
        <div className='auth-form-errors'>
          <div className='auth-form-errors-header'>
          </div>
          <ul>
            {(this.state.form_errors || this.state.token_errors).map(function(error, idx){
              return (<li key={'error-' + idx}>{error + '.'}</li>);
            })}
          </ul>
        </div>
      );
    }
    if (this.state.messages.length) {
      messages = (
        <div className='recover-account-success'>
          <ul>
            {this.state.messages.map(function(msg, idx){
              return (<li key={'msg-' + idx}>{msg + '.'}</li>);
            })}
          </ul>
        </div>
      );
    }
		return (
			<div>
				<div className='questions-index-container group'>
	       	<p>Account Recovery</p>
	    	</div>
    		<hr/>
    		{this.state.token_errors.length ?
    			(
    				<div>
	    				{errors}
	    			</div>
    			) : (
	    			<div>
	    				{ this.state.messages.length ?
	    					(
	    						<div>
	    							{ messages }
	    						</div>
	    					) : (
	    						<div>
						    		<span>Recover account for {this.state.currentUser.email}</span>
						    		<div className='auth-form-group'>
						          <input
						            type='password'
						            placeholder={passwordPlaceholder}
						            onChange={this.handleChange.bind(this, 'password')}
						            />
						        </div>
						        <div className='auth-form-group'>
						          <input
						            type='password'
						            placeholder={confirmPasswordPlaceholder}
						            onChange={this.handleChange.bind(this, 'confirmPassword')}
						            />
						        </div>
						        <button onClick={this.handleSubmit} id="auth-submit">
						          {recoverAccountButton}
						        </button> <br />
						      	{errors}
						      </div>
	    					)
	    				}
	    			</div>
    			)
    		}
    	</div>
  	);
	}
})
module.exports = UserRecoverAccount;