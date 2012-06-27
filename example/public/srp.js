$(document).ready(function(){
  $('#login-btn').click(on_login);
});

function on_login(event) {
  srp = new SRP();
  srp.identify();
  event.preventDefault();
}
