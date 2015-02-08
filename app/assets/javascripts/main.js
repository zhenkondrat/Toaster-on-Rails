/**
 * Created by kris on 24.11.14.
 */

$(function(){

/* code invite button */

  $(".btn.btn-warning.key-gen").click(function () {
    $.getJSON('/invite_code', function (result) {
      $('#admin_token').text('Admin: '+result.admin);
      $('#user_token').text('User: '+result.user);
    });
  });

/* search toast button */


});