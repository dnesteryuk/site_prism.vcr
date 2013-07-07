$(document).ready(function() {
  $result = $('<div id="result"></div>');

  var addResponse2ResDiv = function(data) {
    $result.append('<div class="' + data.resp.toLowerCase() + '">' + data.resp + '</div>');
    $('#console').append($result);
  };

  var fetchMax = function(fn) {
    $.getJSON('/max.json', fn || addResponse2ResDiv);
  };

  var fetchFelix = function() {
    $.getJSON('/felix.json', addResponse2ResDiv);
  };

  $('#link_with_one_request').click(function() {
    fetchMax();

    return false;
  });

  $('#link_with_one_request_and_delay').click(function() {
    setTimeout(function() {
      fetchMax();
    }, 200);

    return false;
  });

  $('#link_with_2_requests').click(function() {
    $result.html('');

    fetchMax();

    setTimeout(function() {
      fetchFelix();
    }, 50);

    return false;
  });
});