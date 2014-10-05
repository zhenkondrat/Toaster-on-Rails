var subject_id = -1;
function subject_selected(){
    mysel = document.getElementById('select_to_create');
    subject_id = mysel.value;
    my_a = document.getElementById('rm_subject');
    my_a.setAttribute('href', my_a.href+"?id=" + subject_id);
}