var React = require('react');
var ApiUtil = require('../../util/api_util');

var ContactUs = React.createClass({
	getInitialState: function() {
    return {
      Name: '',
      email: '',
      subject: '',
      message: '',
      errors: [],
      messages: []
    };
  },
  handleChange: function(type, e) {
    switch (type) {
      case 'name':
        this.setState({ name: e.currentTarget.value });
        break;
      case 'email':
        this.setState({ email: e.currentTarget.value });
        break;
      case 'subject':
        this.setState({ subject: e.currentTarget.value });
        break;
      case 'message':
        this.setState({ message: e.currentTarget.value });
        break;
    }
  },
  handleSubmit: function() {
	  this.setState({ Name: '', email: '', subject: '', message: '', errors: [], messages: []});
	  $('input, textarea').val('');
	  ApiUtil.contactToAdmin(this.state);
	},
  render: function() {
  	var alert;
  	if (this.state.errors.length) {
      alert = (
        <div className='auth-form-errors'>
          <ul>
            {this.state.errors.map(function(error, idx){
              return (<li key={'error-' + idx}>{error + '.'}</li>);
            })}
          </ul>
        </div>
      );
    } else if(this.state.messages.length) {
    	alert = (
        <div className='auth-form-messages'>
          <ul>
            {this.state.errors.map(function(error, idx){
              return (<li key={'message-' + idx}>{error + '.'}</li>);
            })}
          </ul>
        </div>
      );
    }

    return (
    	<div className="contact-us-wrapper">
    		<h1 className="static-page-title">Contact us</h1>
	    	<div className="contact-us-form">
		      {alert}
		      <div>
		      	<div className='auth-form-label'>
		          Your Name
		        </div>
		        <input type='text' placeholder="Name" id="auth-email" onChange={this.handleChange.bind(this, 'name')} />
		        <div className='auth-form-label'>
		          Email
		        </div>
		        <input type='email' placeholder="Email" id="auth-email" onChange={this.handleChange.bind(this, 'email')} />
		        <div className='auth-form-label'>
		          Subject
		        </div>
		        <input type='text' placeholder="Subject" id="auth-email" onChange={this.handleChange.bind(this, 'subject')} />
		        <div className='auth-form-label'>
		          Message
		        </div>
		        <textarea id="auth-email" placeholder="Message" onChange={this.handleChange.bind(this, 'message')}></textarea>
		      </div>
		      <button onClick={this.handleSubmit} id="auth-submit">Send</button>
		    </div>
	    	<div className="contact-us-sample">
		      <div>
						<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
							tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
							quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
							consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
							cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
							proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
					</div>
		    </div>
		  </div>
    );
  }
});

module.exports = ContactUs;
