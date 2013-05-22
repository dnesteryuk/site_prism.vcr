$(document).ready(function() {
  $result = $('<div id="result"></div>');

  var addResponse2ResDiv = function(data) {
    $result.append('<div class="' + data.resp.toLowerCase() + '">' + data.resp + '</div>');
    $('#console').append($result);
  };

  var fetchOctocat = function(fn) {
    $.getJSON('/octocat.json', fn || addResponse2ResDiv);
  };

  var fetchMartian = function() {
    $.getJSON('/martian.json', addResponse2ResDiv);
  };

  $('#link_with_one_request').click(function() {
    fetchOctocat();

    return false;
  });

  $('#link_with_one_request_and_delay').click(function() {
    setTimeout(function() {
      fetchOctocat();
    }, 200);

    return false;
  });

  $('#link_with_2_requests').click(function() {
    $result.html('');

    fetchOctocat();

    setTimeout(function() {
      fetchMartian();
    }, 50);

    return false;
  });
});