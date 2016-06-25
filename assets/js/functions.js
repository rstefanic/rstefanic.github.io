var $overlay = $('<div id="overlay"></div>');
var $image = $('<img>');
var $caption = $('<p></p>');

//Create the overlay, append it to the overlay and body
$overlay.append($image);
$overlay.append($caption);
$("body").append($overlay);

function getImgs(setID) {
  var URL = "https://api.flickr.com/services/rest/" + //secure API request
    "?method=flickr.photosets.getPhotos" +  // method
    "&api_key=c2cd90d25f639c4a6bea9bbb0e0fa39b" + // api key
    "&photoset_id=" + setID + // album name
    "&privacy_filter=1" +
    "&per_page=20" + // how many pictures
    "&format=json&nojsoncallback=1";

  $.getJSON(URL, function(data){
    $.each(data.photoset.photo, function(i, item){
      //build the img url
      var img_src = "http://farm" + item.farm + ".static.flickr.com/" + item.server + "/" + item.id + "_" + item.secret + "_m.jpg";
      //build full sized picture
      var img_full = "http://farm" + item.farm + ".static.flickr.com/" + item.server + "/" + item.id + "_" + item.secret + "_h.jpg";
      //build the thumbnail
      var img = $("<a>").attr("href", img_full).attr("target", "_blank");
      var img_thumb = $("<img/>").attr("src", img_src).css("margin", "8px");
      $(img).html(img_thumb);
      $(img).appendTo("#flickr-images");
    });
  }) ;
}

$( document ).ready(function() {
  var album;
  $('.travel').click(function() {
    $('.travel').removeClass("selected");
    $('#flickr-images').html("");
    $(this).addClass("selected");
    album = $(this).text();
    switch(album) {
      case "Iceland":
      $('#flickr-images').html("<h2>Leaving on June 29th. Pictures" +
        " coming soon.</h2>");
        break;
      case "China":
        getImgs("72157669186566650");
        break;
      case "Holland":
        getImgs("72157669186626940");
        break;
      case "Belgium":
        getImgs("72157667436906833");
        break;
      case "Poland":
        getImgs("72157667437036013");
        break;
    }
  }); // end click

// Click on image, blow it up (spotlight)
  $("#flickr-images a").click(function( event ) {
    console.log("Hi");
    event.preventDefault();

    var imageLocation = $(this).attr("href");
    $image.attr("src", imageLocation);
    console.log($image);

    $overlay.show();
  }) ; // end spotlight

// If the image is up, click the overlay to hide it
  $overlay.click(function() {
    $overlay.hide();
  });

}); // end ready
