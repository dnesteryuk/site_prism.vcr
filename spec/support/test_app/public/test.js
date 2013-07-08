$(document).ready(function() {
  $result = $('<div id="result"></div>');

  var addResponse2ResDiv = function(data) {
    $result.append('<div class="' + data.cat_name.toLowerCase() + ' '
      + data.cat_owner.toLowerCase().replace(/\s/, '_') + '">' + data.cat_owner + '</div>');

    $('#console').append($result);
  };

  var fetchMaxsOwner = function(fn) {
    $.getJSON('/max.json', fn || addResponse2ResDiv);
  };

  var fetchFelixsOwner = function() {
    $.getJSON('/felix.json', addResponse2ResDiv);
  };

  $('#link_with_one_request').click(function() {
    fetchMaxsOwner();

    return false;
  });

  $('#link_with_one_request_and_delay').click(function() {
    setTimeout(function() {
      fetchMaxsOwner();
    }, 200);

    return false;
  });

  $('#link_with_2_requests').click(function() {
    $result.html('');

    fetchMaxsOwner();

    setTimeout(function() {
      fetchFelixsOwner();
    }, 50);

    return false;
  });
});