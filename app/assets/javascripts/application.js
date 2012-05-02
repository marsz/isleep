// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap

$(document).ready(function(){
  $('.modal').each(function(){
    $(this).modal({
      show:false
    });
  });
  $('[data-type=hover]').each(function(){
    var show = $(this).attr('data-show');
    var el = this;
    if(show) {
      $(el).on('mouseover', function(){
        $(show, el).css('visibility', 'visible');
      });
      $(el).on('mouseout', function(){
        $(show, el).css('visibility', 'hidden');
      });
    }
  });
});