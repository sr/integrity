$(document).ready(function () {
  if (window.location.pathname !== "/" || !window.webkitNotifications) {
    return;
  }

  var cache = [];
  var start = new Date().toISOString();

  $("#new").append("<span id=separator> / </span>")
  $("#new").append("<a id=notify>Enable notifications</a>");

  $("#notify").click(function() {
    if (window.webkitNotifications.checkPermission() !== 0) {
      window.webkitNotifications.requestPermission();
    } else {
      $("#separator").remove();
      $("#notify").remove();
      $("#content").
        append("<small style='font-size:x-small'>polling...</small>");
    }
  });

  function poll() {
    $.getJSON("/poll", {"t": start}, function (data) {
      data.forEach(function (build) {
        if (cache.indexOf(build.id) == -1) {
          cache.push(build.id);
          var title   = "Integrity: " + build.project;
          var content = build.status;
          window.webkitNotifications.createNotification(
            "", title, content).show();
        }
      });
    });
    setTimeout(poll, 3000);
  }

  poll();
});
