function updateContent(content) {
    var $contentKeyElements = $(content).filter('[data-content-key]');
    $contentKeyElements.each(function() {
        var node = $(this);
        var key = node.attr("data-content-key");

        $("[data-content-key=" + key + "]").replaceWith(node);
    });

    $(document).trigger('content-updated');
}

function showAndFadeFlash() {
    var container = $('div#flash');
    if (container.children('span').html() !== '') {
        clearTimeout(this.timer);

        container.show();

        this.timer = setTimeout(function() {
            container.fadeOut();
        }, 4000);
    }
}

function showLoading() {
    var container = $('div#loading:hidden');
    if (container) {
        container.fadeIn(150);
    }
}

function hideLoading() {
    $('div#loading:visible').fadeOut();
}

function toggleRoleFields() {
    if ($("input#role_ids_0:checked").length > 0) {
        $("fieldset.finder").show();
    } else {
        $("fieldset.finder").hide();
    }

    if ($("input#role_ids_1:checked").length > 0) {
        $("fieldset.lister").show();
    } else {
        $("fieldset.lister").hide();
    }
}

function liveNeighborhoodAutocomplete() {
    $("input#neighborhood_autocomplete").autocomplete({
        source: neighborhoods,
        minLength: 1,
        select: function(event, ui) {
            var form = $(event.target).closest("form");
            if (form.hasClass('search')) {
                $("input#q_neighborhood_ids").val(ui.item.id);
            } else {
                if ($("input[name='user[profile_attributes][neighborhood_ids][]'][value='" + ui.item.id + "']").length == 0) {
                    var remove = "<a href='#' data-remove = 'li'>X</a>&nbsp;"
                    var input = "<input type='hidden' name='user[profile_attributes][neighborhood_ids][]' value='" + ui.item.id + "' />";
                    $("ul#selected_neighborhoods").append("<li>" + remove + ui.item.label + input + "</li>");
                }
                $("input#neighborhood_autocomplete").val('');
                return false;
            }
        }
    });
}

(function($) {
    $(function() {
        $("input[data-date=true]").datepicker();

        $("input[name=apartment[sublet]]").live("change", function(event) {
            if ($("input#apartment_sublet_true").attr('checked')) {
                $("li#apartment_end_date_input").show();
            } else {
                $("li#apartment_end_date_input").hide();
            }
        });

        $("form.user li.boolean input[type=checkbox]").live("change", function() {
            toggleRoleFields();
        });
        toggleRoleFields();

        $("div#search select").spicyselect();

        $("input#apartment_full_address").autocomplete({
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

        liveNeighborhoodAutocomplete();

        $("[data-default-value]").live("click", function(event) {
            var element = $(event.currentTarget);
            if (element.val() == element.attr('data-default-value')) {
                element.val('');
            }
        });

        $("[data-default-value]").live("blur", function(event) {
            var element = $(event.currentTarget);
            if (element.val() == '') {
                element.val(element.attr('data-default-value'));
            }
        });

        $("[data-large-image-path]").live("click", function(event) {
            var element = $(event.currentTarget);
            $("img.active").attr('src', element.attr('data-large-image-path'));
            element.closest("li").addClass("active");
        });

        $("[data-remove]").live("click", function(event) {
            var element = $(event.currentTarget);
            element.closest(element.attr('data-remove')).remove();
            return false;
        });

        $("ul.buttons li.save a").live("click", function() {
            $("form.apartment").submit();
            return false;
        });

        $("div.conversations ul.conversation").live("click", function(event) {
            $(event.currentTarget).parent("div").next("div").slideToggle(150);
            return false;
        });

        $("div.messages a.close").live("click", function(event) {
            $(event.currentTarget).parents("div.messages").slideUp(150);
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

                        $('#upload_status').text('Uploading image...');
                    } else {
                        $('#upload_status').text('Error: only images are allowed');
                        return false;
                    }

                },
                onComplete : function(file, extension) {
                    $("div#upload_status").text('');
                    $("ul#images").append(extension);
                }
            });
        }

        $('ul#images').sortable({
            axis: 'x',
            dropOnEmpty:false,
            cursor: 'crosshair',
            items: 'li',
            opacity: 0.4,
            scroll: true,
            update: function() {
                $.ajax({
                    type: 'put',
                    data: $('ul#images').sortable('serialize'),
                    dataType: 'script',
                    url: "/apartments/" + self.apartment.id + "/order_images"});
            }
        });

        $('.feedback').tabSlideOut({
            tabHandle: '.handle',                     //class of the element that will become your tab
            pathToTabImage: '/images/contact_tab.gif', //path to the image for the tab //Optionally can be set using css
            imageHeight: '122px',                     //height of tab image           //Optionally can be set using css
            imageWidth: '40px',                       //width of tab image            //Optionally can be set using css
            tabLocation: 'left',                      //side of screen where tab lives, top, right, bottom, or left
            speed: 300,                               //speed of animation
            action: 'click',                          //options: 'click' or 'hover', action to trigger animation
            topPos: '175px',                          //position from the top/ use if tabLocation is left or right
            leftPos: '20px',                          //position from left/ use if tabLocation is bottom or top
            fixedPosition: true                      //options: true makes it stick(fixed position) on scroll
        });

        $("div.feedback :submit").bind("click", function() {
            $('div.feedback a.handle').click();
        });

        //        $("form.apartment :input").live("blur", function(event) {
        //            $.ajax({
        //                type      : "put",
        //                url       : $("form.apartment").attr('action'),
        //                data      : $("form.apartment").serialize(),
        //                dataType  : 'json',
        //                success   : function success(response) {
        //                    $(document).trigger('content-received', response);
        //                }
        //            });
        //        });

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

        $("div.apartment ul li.status form input").live("change", function(event) {
            var element = $(event.target);
            var form = element.closest('form');

            $.ajax({
                type     : 'put',
                data     : { event : element.val() },
                dataType : 'json',
                url      : form.attr('action'),
                success  : function success(response) {
                    $(document).trigger('content-received', response);
                }
            });
            return false;
        });

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
                    form.find(":input").not(":submit").val("");
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
                            if (container.is('div') || container.is('li')) {
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
                if (type == 'delete') {
                    link.closest('.removeable').remove();
                }

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

        if ($("div#flash span").text() !== '') {
            showAndFadeFlash();
        }

        $(document).bind("content-received", function(event, data) {
            if (data && data.flash) {
                var flash = data.flash;
                if (flash && flash != "") {
                    $("div#flash span").html(flash);
                    showAndFadeFlash();
                }
            }
        });

        $(document).bind('content-received', function(e, content) {
            if (content.map_others) {
                apartments = JSON.parse(content.map_others);
            }

            $.each(content, function(key, value) {
                if (key != "map_others") {
                    updateContent(value);
                }
            });
        });

        $(document).bind('content-updated', function(event, data) {
            $("[data-animate]").each(function() {
                $(this).animate({
                    opacity: 0,
                    height: 0
                });
            });

            toggleRoleFields();
            liveNeighborhoodAutocomplete();
            if ($("div#map_canvas").length > 0) {
                initializeMap();
            }
        });

        $(document).bind('ajaxStart', function() {
            showLoading();
        });

        $(document).bind('ajaxStop', function() {
            hideLoading();
        });
    });
})(jQuery);
