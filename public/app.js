$(document).ready(function () {
  if (window.location.pathname !== "/" || !window.webkitNotifications) {
    return;
  }

  var cache = [];
  var start = new Date().toISOString();

  $("#content").append("<button id=notify>enable notification</button>");

  $("#notify").click(function() {
    if (window.webkitNotifications.checkPermission() !== 0) {
      window.webkitNotifications.requestPermission();
    } else {
      $("#notify").remove();
    }
  });

  setInterval(function () {
    $.getJSON("/poll", {"t": start}, function (data) {
      data.forEach(function (build) {
        if (cache.indexOf(build.id) == -1) {
          cache.push(build.id);
          var title   = "Build " + build.id;
          var content = build.status;
          window.webkitNotifications.createNotification(
            "", "Integrity", content).show();
        }
      });
    });
  }, 3000);
});
