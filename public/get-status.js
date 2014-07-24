function getLineStatus (){
  $.getJSON('http://londonlayout-line-status.herokuapp.com/', function(data){
    return data;
  });
}