var WaitView = function WaitView(logging) {
  if(logging) {
    Pusher.log = function(message) {
     if (window.console && window.console.log) {
       window.console.log(message);
     }
    }
  }
}

WaitView.prototype.start = function(url) {
  window.location = url;
}

$(document).ready(function() {
  var waitView = new WaitView(false);

  if(document.getElementById('player')) {
    var pusher = new Pusher('9d7c66d1199c3c0e7ca3', { encrypted: true });
    var user_id = document.getElementById('player').getAttribute('data-userid');
    var waitChannel = pusher.subscribe('wait_channel_' + user_id);
    waitChannel.bind('match_start_event', function(data) {
      try {
        waitView.start(data['message']);
      }
      catch (exception) {
        console.log("exception starting waitView with " + data['message'] + ":");
        console.dir(exception);
      }
    });
  }
});
