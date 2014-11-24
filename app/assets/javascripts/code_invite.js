/**
 * Created by kris on 24.11.14.
 */
$(function(){
    $("#get_token").click(function () {
        $.getJSON(root_path + 'invite_code', function (result) {
            $('#admin_token').text(result.admin);
            $('#user_token').text(result.user);
        });
    });
});