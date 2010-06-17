function updateContent(content) {
    var $contentKeyElements = $(content).filter('[data-content-key]');

    $contentKeyElements.each(function() {
        var node = $(this);
        var key = node.attr("data-content-key");

        $("[data-content-key=" + key + "]").html(node.html());
    });

    $(document).trigger('content-updated');
}

function attachClickToMarker(marker, index) {
    google.maps.event.addListener(marker, 'click', function() {
        window.location = apartments[index].apartment.to_param;
    });
}

(function($) {
    $(function() {
        $("#apartment_start_date").datepicker();

        $("input#apartment_address_attributes_full_address").autocomplete({
            source: "/addresses/geocode",
            minLength: 3,
            delay: 400,
            select: function(event, ui) {
                $.ajax({
                    type      : 'get',
                    url       : '/neighborhoods/search',
                    data      : { "lat" : ui.item.lat, "lng" : ui.item.lng },
                    dataType  : 'json',
                    success   : function success(response) {
                        $(document).trigger('content-received', response);
                    }
                });
            }
        });

        new AjaxUpload('#image_upload', {
            action: '/images',
            onSubmit : function(file, ext) {
                //if (ext && new RegExp('^(' + allowed.join('|') + ')$').test(ext)){
                if (ext && /^(jpg|png|jpeg|gif)$/.test(ext)) {
                    /* Setting data */
                    this.setData({
                        'authenticity_token': window._token
                    });

                    $('#upload_text').text('Uploading ' + file);
                } else {

                    // extension is not allowed
                    $('#upload_text').text('Error: only images are allowed');
                    // cancel upload
                    return false;
                }

            },
            onComplete : function(file, extension) {
                $('#upload_text').text('Uploaded ' + file);
                extension = extension.split(",");
                console.debug(extension);
                $("form.apartment").append("<input type='hidden' value='" + extension[0] + "' name='apartment[image_ids][]' />");
                $("form.apartment").prepend("<image src='" + extension[1] + "'/>");
            }
        });

        if (document.getElementById('map_canvas') != null) {
            var bounds = new google.maps.LatLngBounds();
            var map = new google.maps.Map(document.getElementById("map_canvas"), {
                mapTypeId: google.maps.MapTypeId.HYBRID
            });

            var point = new google.maps.LatLng(address.address.lat, address.address.lng);
            bounds.extend(point);

            var marker = new google.maps.Marker({position: point, title: address.address.full_address});

            marker.setMap(map);
            map.fitBounds(bounds);

            for (var i = 0; i < apartments.length; i++) {
                var apartment = apartments[i].apartment;

                point = new google.maps.LatLng(apartment.address.lat, apartment.address.lng);
                marker = new google.maps.Marker({position: point, param: apartment.to_param});

                attachClickToMarker(marker, i);

                marker.setMap(map);
            }
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