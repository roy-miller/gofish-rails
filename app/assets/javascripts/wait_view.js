var WaitView = function WaitView(logging) {
  this.userId = null;
  if(logging) {
    Pusher.log = function(message) {
     if (window.console && window.console.log) {
       window.console.log(message);
     }
    }
  }
}

WaitView.prototype.start = function(matchId) {
  window.location = "/matches/" + matchId + "/users/" + this.userId;
}

$(document).ready(function() {
  var waitView = new WaitView(false);

  if(document.getElementById('player')) {
    var pusher = new Pusher('9d7c66d1199c3c0e7ca3', { encrypted: true });
    var userId = document.getElementById('player').getAttribute('data-userid');
    waitView.userId = userId;
    var waitChannel = pusher.subscribe('wait_channel_' + userId);
    waitChannel.bind('match_start_event', function(data) {
      try {
        waitView.start(data['match_id']);
      }
      catch (exception) {
        console.log("exception starting waitView with " + data['match_id'] + ":");
        console.dir(exception);
      }
    });
  }
});
