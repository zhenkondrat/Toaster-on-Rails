/**
 * Created by kris on 15.10.14.
 */
var a = ["red", "green", "yellow", "white", "grey", "rosybrown", "chocolate"];
var lcolor = "none";
function change_color(idspan){
    i = 0;
    myspan = document.getElementById(idspan);
    if (lcolor != "none")
        i = a.indexOf(lcolor);
    i++;
    if (i > 7) i = 0;
    lcolor = a[i];
    myspan.setAttribute('style', 'padding: 4px; border-radius: 15px; margin-bottom: 15px; background-color: '+ a[i] +';');
    myhidden = document.getElementById('u'+idspan);
    myhidden.setAttribute('value', i);
}