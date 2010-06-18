var infowindow, map;

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
        var apt = apartments[index].apartment;
        var contentString = "<div class='apartment_info'>" +
                            "<h3><a href='" + apt.to_param + "'>" + apt.address.full_address + "</a></h3>" +
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

        if ($("a[data-upload-path]").length > 0) {
            new AjaxUpload('upload', {
                action: $("a[data-upload-path]").attr('data-upload-path'),
                onSubmit : function(file, ext) {
                    if (ext && /^(jpg|png|jpeg|gif)$/.test(ext)) {
                        this.setData({
                            'authenticity_token': window._token
                        });

                        $('#upload_status').text('Uploading ' + file);
                    } else {
                        $('#upload_status').text('Error: only images are allowed');
                        return false;
                    }

                },
                onComplete : function(file, extension) {
                    $("div#upload_status").text('');
                    $("div#images").append(extension);
                }
            });
        }

        if (document.getElementById('map_canvas') != null) {
            var point = new google.maps.LatLng(address.address.lat, address.address.lng);
            map = new google.maps.Map(document.getElementById("map_canvas"), {
                zoom: 16,
                center: point,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            });

            var marker = new google.maps.Marker({position: point, title: address.address.full_address});
            marker.setMap(map);

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

            if (type == "delete") {
                var container = link.closest("div.removeable");
                container.hide('explode');
            }

            return false;
        });

        $(document).bind('content-received', function(e, content) {
            $.each(content, function(key, value) {
                updateContent(value);
            });
        });
    });
})(jQuery);