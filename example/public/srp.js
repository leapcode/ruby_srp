$(document).ready(function(){
  $('#login-btn').click(on_login);
  $('#signup-btn').click(on_signup);
});

function on_login(event) {
  srp = new SRP();
  srp.success= on_authenticated;
  srp.identify();
  event.preventDefault();
}

function on_signup(event) {
  srp = new SRP();
  srp.registered_user = on_registered;
  srp.register();
  event.preventDefault();
}

function on_registered() {
  window.location = '/';
}

function on_authenticated() {
  window.location = '/';
}
