var infowindow, map;

function attachClickToMarker(marker, apt) {
    google.maps.event.addListener(marker, 'click', function() {
        //        var contentString = "<div class='apartment_info'>" +
        //                            "<h3><a href='/apartments/" + apt.to_param + "'>" + apt.address.full_address + "</a></h3>" +
        //                            "<dl>" +
        //                            "<dt>Rent</dt>" +
        //                            "<dd>" + apt.rent + "</dd>" +
        //                            "<dt>Bedrooms</dt>" +
        //                            "<dd>" + apt.bedrooms + "</dd>" +
        //                            "<dt>Bathrooms</dt>" +
        //                            "<dd>" + apt.bathrooms + "</dd>" +
        //                            "<dt>Square footage</dt>" +
        //                            "<dd>" + apt.square_footage + "</dd>" +
        //                            "<dt>Start date</dt>" +
        //                            "<dd>" + apt.start_date + "</dd>" +
        //                            "</dl>" +
        //                            "</div>";
        //
        //        if (infowindow) infowindow.close();
        //
        //        infowindow = new google.maps.InfoWindow({
        //            content: contentString
        //        });
        //
        //        infowindow.open(map, marker);
        document.location = '/apartments/' + apt.to_param;
    });
}

function initializeMap() {
    map = new google.maps.Map(document.getElementById("map_canvas"), {
        zoom: 16,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    });

    map.setCenter(new google.maps.LatLng(40.7144843, -74.0072444));

    if (typeof(apartments) != 'undefined') {
        updateMap(self, apartments);
    }
}

function setPrimaryApartment(lat, lng, title) {
    var point = new google.maps.LatLng(lat, lng);
    map.setCenter(point);

    var marker = new google.maps.Marker({position: point, title: title, icon: '/images/icons/blue_marker.png'});
    marker.setMap(map);

    return marker;
}

function updateMap(self, others) {
    if (self.apartment != undefined && self.apartment.address != undefined) {
        var marker = setPrimaryApartment(self.apartment.address.lat, self.apartment.address.lng, self.apartment.address.full_address);
        attachClickToMarker(marker, self.apartment);
    } else {
        map.setCenter(new google.maps.LatLng(40.7144843, -74.0072444));
        var bounds = new google.maps.LatLngBounds();
    }

    for (var i = 0; i < others.length; i++) {
        var apartment = others[i].apartment;
        if (apartment.address != undefined) {
            point = new google.maps.LatLng(apartment.address.lat, apartment.address.lng);
            marker = new google.maps.Marker({position: point, param: apartment.to_param});

            attachClickToMarker(marker, apartment);

            marker.setMap(map);

            if (bounds) {
                bounds.extend(point);
                map.fitBounds(bounds);
            }
        }
    }
}

(function($) {
    $(function() {
        if ($('div#map_canvas').length > 0) {
            initializeMap();
        }
    });
})(jQuery);
