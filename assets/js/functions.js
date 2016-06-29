function getImgs(setID) {
  var URL = "https://api.flickr.com/services/rest/" + //secure API request
    "?method=flickr.photosets.getPhotos" +  // method
    "&api_key=c2cd90d25f639c4a6bea9bbb0e0fa39b" + // api key
    "&photoset_id=" + setID + // album name
    "&privacy_filter=1" +
    "&per_page=100" + // how many pictures
    "&format=json&nojsoncallback=1";

  $.getJSON(URL, function(data){
    $.each(data.photoset.photo, function(i, item){
      //build the img url
      var img_src = "http://farm" + item.farm + ".static.flickr.com/" + item.server + "/" + item.id + "_" + item.secret + "_m.jpg";
      //build full sized picture
      var img_full = "http://farm" + item.farm + ".static.flickr.com/" + item.server + "/" + item.id + "_" + item.secret + "_h.jpg";
      //build the thumbnail
      var img = $("<a>").attr("href", img_full).attr("target", "_blank");
      var img_thumb = $("<img/>").attr("src", img_src).addClass("spotlight").css("margin", "8px");
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
      getImgs("72157669367596230");
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
}); // end ready
