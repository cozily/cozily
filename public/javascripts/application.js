(function($) {
    $(function() {
        if (document.getElementById('map_canvas') != null) {
            var bounds = new google.maps.LatLngBounds();
            var map = new google.maps.Map(document.getElementById("map_canvas"), {
                mapTypeId: google.maps.MapTypeId.HYBRID
            });

            var point1 = new google.maps.LatLng(address.address.lat, address.address.lng);
            bounds.extend(point1);

            var marker = new google.maps.Marker({position: point1, title: address.address.full_address});

            marker.setMap(map);
            map.fitBounds(bounds);
        }
    });
})(jQuery);