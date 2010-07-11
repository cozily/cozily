var infowindow, map;

function attachClickToMarker(marker, apt) {
    google.maps.event.addListener(marker, 'click', function() {
        var contentString = "<div class='apartment_info'>" +
                            "<h3><a href='/apartments/" + apt.to_param + "'>" + apt.address.full_address + "</a></h3>" +
                            "<dl>" +
                            "<dt>Rent</dt>" +
                            "<dd>" + apt.rent + "</dd>" +
                            "<dt>Bedrooms</dt>" +
                            "<dd>" + apt.bedrooms + "</dd>" +
                            "<dt>Bathrooms</dt>" +
                            "<dd>" + apt.bathrooms + "</dd>" +
                            "<dt>Square footage</dt>" +
                            "<dd>" + apt.square_footage + "</dd>" +
                            "<dt>Start date</dt>" +
                            "<dd>" + apt.start_date + "</dd>" +
                            "</dl>" +
                            "</div>";

        if (infowindow) infowindow.close();

        infowindow = new google.maps.InfoWindow({
            content: contentString
        });

        infowindow.open(map, marker);
    });
}

(function($) {
    $(function() {
        if (document.getElementById('map_canvas') != null) {
            map = new google.maps.Map(document.getElementById("map_canvas"), {
                zoom: 16,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            });

            if (self.apartment != undefined) {
                var point = new google.maps.LatLng(self.apartment.address.lat, self.apartment.address.lng);
                map.setCenter(point);

                var marker = new google.maps.Marker({position: point, title: self.apartment.address.full_address, icon: '../images/icons/blue_marker.png'});
                marker.setMap(map);

                attachClickToMarker(marker, self.apartment);
            } else {
                var bounds = new google.maps.LatLngBounds();
            }

            for (var i = 0; i < apartments.length; i++) {
                var apartment = apartments[i].apartment;

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
    });
})(jQuery);
