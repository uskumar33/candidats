/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var clone1, clone2, clone21, clone3, clone31;

 function collectAdditionalDataForOffersInHand(cstatusID)
    {
        document.getElementById('offeramountlbl').style.visibility = "hidden";
        document.getElementById('offeramount').style.visibility = "hidden";
        document.getElementById('offercompanylbl').style.visibility = "hidden";
        document.getElementById('offercompany').style.visibility = "hidden";
        switch (cstatusID)
        {
            case "Y":
                document.getElementById('offeramountlbl').style.visibility = "visible";
                document.getElementById('offeramount').style.visibility = "visible";
                document.getElementById('offercompanylbl').style.visibility = "visible";
                document.getElementById('offercompany').style.visibility = "visible";
                break;
            default:
        }
   }
   
function mytab1addRow(but) {
    var tbo1 = but.parentNode.parentNode.parentNode;
    tbo1.appendChild(clone1);
    var rows1 = tbo1.getElementsByTagName('tr');
    clone1 = rows1[rows1.length - 1].cloneNode(true);
    //orderNames(rows);
}

function mytab2addRow(but) {
    var tbo2 = but.parentNode.parentNode.parentNode;
    tbo2.appendChild(clone2);
    var rows2 = tbo2.getElementsByTagName('tr');
    clone2 = rows2[rows2.length - 1].cloneNode(true);
    //orderNames(rows);
}

function mytab21addRow(but) {
    clone21 = document.getElementById('mytab21').getElementsByTagName('tr')[0].cloneNode(true);
    var tbo21 = but.parentNode.parentNode.parentNode;
    tbo21.appendChild(clone21);
    var rows21 = tbo21.getElementsByTagName('tr');
    clone21 = rows21[rows21.length - 1].cloneNode(true);
    //orderNames(rows);
}

function mytab3addRow(but) {
    var tbo3 = but.parentNode.parentNode.parentNode;
    tbo3.appendChild(clone3);
    var rows3 = tbo3.getElementsByTagName('tr');
    clone3 = rows3[rows3.length - 1].cloneNode(true);
    //orderNames(rows);
}

function mytab31addRow(but) {
    clone31 = document.getElementById('mytab31').getElementsByTagName('tr')[0].cloneNode(true);
    var tbo31 = but.parentNode.parentNode.parentNode;
    tbo31.appendChild(clone31);
    var rows31 = tbo31.getElementsByTagName('tr');
    clone31 = rows31[rows31.length - 1].cloneNode(true);
    //orderNames(rows);
}

function removeRow(but, cTable) {
    //dont remove 1st row
    var totalrows = document.getElementById(cTable).getElementsByTagName('tr');
    if(totalrows.length > 1){
        var thisRow = but.parentNode.parentNode;
        var tbo = thisRow.parentNode;
        tbo.removeChild(thisRow);
        //var rows = tbo.getElementsByTagName('tr');
        //orderNames(rows);
    }
}

onload = function () {
    clone1 = document.getElementById('mytab1').getElementsByTagName('tr')[0].cloneNode(true);
    clone2 = document.getElementById('mytab2').getElementsByTagName('tr')[0].cloneNode(true);
    clone3 = document.getElementById('mytab3').getElementsByTagName('tr')[0].cloneNode(true);
    clone21 = document.getElementById('mytab21').getElementsByTagName('tr')[0].cloneNode(true);
    clone31 = document.getElementById('mytab31').getElementsByTagName('tr')[0].cloneNode(true);
}

