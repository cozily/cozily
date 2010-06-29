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

        $("[data-click-path]").live("click", function(event) {
            var element = $(event.currentTarget);
            document.location = element.attr('data-click-path');
            return false;
        });

        if (typeof message_id != 'undefined') {
            $.scrollTo("div#message_" + message_id, 800);
        }

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

        if ($("div.business_search").length > 0) {
            var lat = $("div.business_search").attr('data-lat');
            var lng = $("div.business_search").attr('data-lng');
            $.ajax({
                type      : 'get',
                url       : '/yelp/business_search',
                data      : { "lat" : lat, "lng" : lng },
                dataType  : 'json',
                success   : function success(response) {
                    $("div.business_search").html(response.businesses).show("blind");
                }
            });
        }

        if (document.getElementById('map_canvas') != null) {
            map = new google.maps.Map(document.getElementById("map_canvas"), {
                zoom: 16,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            });

            if (self.apartment != undefined) {
                var point = new google.maps.LatLng(self.apartment.address.lat, self.apartment.address.lng);
                map.setCenter(point);

                var marker = new google.maps.Marker({position: point, title: self.apartment.address.full_address});
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

        $("form[data-remote=true]").live("submit", function(event) {
            event.preventDefault();
            var element = $(event.target);
            var form = element.closest('form');
            var data = form.serialize();
            var button = form.find(":submit");

            $.ajax({
                type      : form.attr('method'),
                url       : form.attr('action'),
                data      : data,
                dataType  : 'json',
                success   : function success(response) {
                    $(document).trigger('content-received', response);
                }
            });
            return false;
        });

        $('a[data-remote=true]').live('click', function(event) {
            var link = $(event.currentTarget);
            var type = link.attr('data-method') ? link.attr('data-method') : 'post';

            if (link.attr('data-confirm')) {
                $("<div>Are you sure?</div>").dialog({
                    resizable: false,
                    height:140,
                    modal: true,
                    title: "Delete this item?",
                    buttons: {
                        'Yes': function() {
                            $.ajax({
                                type      : type,
                                url       : link.attr('href'),
                                dataType  : 'json',
                                success   : function success(response) {
                                    $(document).trigger('content-received', response);
                                }
                            });
                            var container = link.closest(".removeable");
                            if (container.is('div')) {
                                container.hide('explode');
                            } else {
                                container.fadeOut();
                            }
                            $(this).dialog('close');
                        },
                        Cancel: function() {
                            $(this).dialog('close');
                        }
                    }
                });
            } else {
                $.ajax({
                    type      : type,
                    url       : link.attr('href'),
                    dataType  : 'json',
                    success   : function success(response) {
                        $(document).trigger('content-received', response);
                    }
                });
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
