var marks_count = 0;

function addMark(mytable)
{
    marks_count++;
    $table = document.getElementById(mytable);
    mytr = document.createElement("tr");
    mytr.setAttribute('id','mark_'+marks_count);
    mytd1 = document.createElement("td");
    mytd2 = document.createElement("td");
    input1 = document.createElement("input");
    input1.setAttribute('type', 'text');
    input1.setAttribute('name', 'mark_system[marks[presentation_'+marks_count+']]');
    input2 = document.createElement("input");
    input2.setAttribute('type', 'text');
    input2.setAttribute('name', 'mark_system[marks[percent_'+marks_count+']]');

    mytd1.appendChild(input1);
    mytd2.appendChild(input2);
    mytr.appendChild(mytd1);
    mytr.appendChild(mytd2);
    $table.appendChild(mytr);
}

function delMark(mytable){
    var mark = document.getElementById('mark_'+marks_count);
    mark.parentNode.removeChild(mark);
    marks_count--;
}
function setMarksCount(count){ marks_count = count; }