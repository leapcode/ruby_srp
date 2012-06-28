$(document).ready(function(){
  $('#login-btn').click(on_login);
  $('#signup-btn').click(on_signup);
});

function on_login(event) {
  srp = new SRP();
  srp.identify();
  event.preventDefault();
}

function on_signup(event) {
  srp = new SRP();
  srp.success = function() {
    alert("Signed up successfully");
  };
  srp.register();
  event.preventDefault();
}
