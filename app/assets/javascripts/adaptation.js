/**
 * Created by kris on 16.11.14.
 */

var min_screen_size = 800;
function adaptation(){
  var screen_height = document.documentElement.clientHeight;
  var footer = document.getElementById('admin_footer');

  if (footer != null){
    if (screen_height < min_screen_size){
      footer.className = 'admin_footer_no_fix';
    } else {
      footer.className = 'admin_footer';
    }
  }

  footer = document.getElementById('user_footer');
  if (footer != null){
    if (screen_height < min_screen_size){
      footer.className = 'user_footer_no_fix';
    } else {
      footer.className = 'user_footer';
    }
  }
}