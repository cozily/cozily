function updateContent(content) {
    var $contentKeyElements = $(content).filter('[data-content-key]');

    $contentKeyElements.each(function() {
        var node = $(this);
        var key = node.attr("data-content-key");

        $("[data-content-key=" + key + "]").html(node.html());
    });

    $(document).trigger('content-updated');
}

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

        $('a[data-remote=true]').live('click', function(event) {
            var link = $(event.currentTarget);
            var type = link.attr('data-method') ? link.attr('data-method') : 'post';
            $.ajax({
                type      : type,
                url       : link.attr('href'),
                dataType  : 'json',
                success   : function success(response) {
                    $(document).trigger('content-received', response);
                }
            });
            return false;
        });

        $(document).bind('content-received', function(e, content) {
            $.each(content, function(key, value) {
                updateContent(value);
            });
        });
    });
})(jQuery);