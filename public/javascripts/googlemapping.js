
    var map = null;
    var geocoder = null;
    

    function initialize() {
      if (GBrowserIsCompatible()) {
        map = new GMap2(document.getElementById("map_canvas"));
        map.setCenter(new GLatLng(53.348867,-6.243162), 13);
        geocoder = new GClientGeocoder();
      }
    }
     function locateBusiness(address,lat,longit) {
        map.clearOverlays();

        point = new GLatLng(lat,
                            longit);
        marker = new GMarker(point);
        map.addOverlay(marker);
        map.addControl(new GLargeMapControl());
        map.setCenter(new GLatLng(lat,longit), 16);
        marker.openInfoWindowHtml(address + '<br>' +
          '<b>Country code:</b> ' + "other stuff");
      }


