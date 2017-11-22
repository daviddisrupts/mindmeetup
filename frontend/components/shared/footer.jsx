var React = require('react');
var Link = require('react-router').Link;

var Footer = React.createClass({
  render: function() {
    return (
      <footer className='footer-container'>
        <div className="inner-container">
          <ul>
            <li className="footer-item"><Link to="/terms_of_service">Terms of Service</Link></li>
            <li className="footer-item"><Link to="/privacy_policy">Privacy Policy</Link></li>
            <li className="footer-item"><Link to="/contact_us">Contact Us</Link></li>
            <li className="footer-item"><Link to="/about_us">About Us</Link></li>
          </ul>
          <ul>
            <li className="footer-item social-link"><a target="_blank" href="https://www.twitter.com/restartreality">Twitter</a></li>
            <li className="footer-item social-link"><a target="_blank" href="https://www.facebook.com/restartreality">Facebook</a></li>
            <li className="footer-item social-link"><a target="_blank" href="https://www.instagram.com/restartreality">Instagram</a></li>
          </ul>
        </div>
      </footer>
    );
  }
});

module.exports = Footer;
