/**
 * Created by kris on 05.10.14.
 */

var ks = 0;
var kl = 0;
var kr = 0;

function addNext(mydiv, shbl)
{
    mdiv = document.getElementById(mydiv);
    ediv = document.createElement("div");
    inp = document.createElement("input");
    inp.setAttribute('type', 'text');
    switch (mydiv)
    {
        case 'pright':
            ks++;
            inp.setAttribute('name', shbl + ks);
            inp.setAttribute('id', shbl + ks);
            inp.setAttribute('style', 'width: 160px; margin: 5px;');

            inpch = document.createElement("input");
            inpch.setAttribute('type', 'checkbox');
            inpch.setAttribute('name', 'answer_check[]');
            inpch.setAttribute('value', ks);
            inpch.setAttribute('id', 'answer_check_' + ks);
            ediv.appendChild(inpch);
            break;
        case 'compr':
            kr++;
            inp.setAttribute('name', shbl + kr);
            inp.setAttribute('id', shbl + kr);
            inp.setAttribute('style', 'width: 170px;');
            break;
        case 'compl':
            kl++;
            inp.setAttribute('name', shbl + kl);
            inp.setAttribute('id', shbl + kl);
            inp.setAttribute('style', 'width: 170px;');
            break;
    }
    inp.setAttribute('size', '25');
    ediv.appendChild(inp);
    mdiv.appendChild(ediv);
}

function delPrev(shbl)
{
    switch (shbl)
    {
        case 'answer_':
            if (ks>0)
            {
                var el = document.getElementById(shbl + ks);
                el.parentNode.removeChild(el);
                var el = document.getElementById('answer_check_' + ks);
                el.parentNode.removeChild(el);
                ks--;
            }
            break;
        case 'answer_left_':
            if (kl>0)
            {
                var el = document.getElementById(shbl + kl);
                el.parentNode.removeChild(el);
                kl--;
            }
            break;
        case 'answer_right_':
            if (kr>0)
            {
                var el = document.getElementById(shbl + kr);
                el.parentNode.removeChild(el);
                kr--;
            }
            break;
    }
}

function setParam(count){ ks = count-1; }

function setParam1(count){ kl = count-1; }

function setParam2(count){ kr = count-1; }