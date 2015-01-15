$(document).ready(function(){
  headingTabs();

  $("#menu-toggle").click(function(e) {
        e.preventDefault();
        $("#wrapper").toggleClass("active");
  });

  $('[data-toggle="tooltip"]').tooltip()

});


headingTabs = function(){

  var n = $(".nav-tabs li").length;
  var w = (100/n);
  // $('body').css('background-color', 'red');
  $(".nav-tabs li").css("width", w+'%');
  if(w == 100) {
    $('.nav-tabs li a').addClass('single');
    $('.nav-tabs li').css({ "border-bottom" : "1px solid #EDEFF0" });
  }
}