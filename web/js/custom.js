function printeee(id) {
   /*window.frames[id].focus();
   window.frames[id].print();*/
    //window.print();

   // document.body.innerHTML = document.body.innerHTML + "";

   $("#meFrame").contents().find("body").append('<button onclick="window.print()">Print</button>');
    alert('asdsadsadsadsad');
/*   var doc = document.getElementById(id).contentWindow.document;
   doc.open();
   doc.write('<button onclick="window.print()">Print</button>');
   doc.close();*/
}