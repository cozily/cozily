var staleMap;
var sortableOptions = {
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
};

function updateContent(content) {
    var $contentKeyElements = $(content).filter('[data-content-key]');
    $contentKeyElements.each(function() {
        var node = $(this);
        var key = node.attr("data-content-key");
        $("[data-content-key=" + key + "]").replaceWith(node);
        if (node.is("ul#images")) {
            node.sortable(sortableOptions);
        }
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
        minLength: 2,
        select: function(event, ui) {
            var form = $(event.target).closest("form");
            if (form.hasClass('search')) {
                $("input#q_neighborhood_ids").val(ui.item.id);
            } else {
                if ($("input[name='user[profile_attributes][neighborhood_ids][]'][value='" + ui.item.id + "']").length == 0) {
                    var link = "<a href='#' data-remove = 'span'>" + ui.item.label + "</a>"
                    var input = "<input type='hidden' name='user[profile_attributes][neighborhood_ids][]' value='" + ui.item.id + "' />";
                    $("div#selected_neighborhoods").append("<span>" + link + input + "</span>");
                    $("div#selected_neighborhoods").trigger("selected_neighborhood::change");
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
        $("table.datatable").dataTable({
            "bJQueryUI": true,
            "sPaginationType": "full_numbers",
            "iDisplayLength": 50
        });

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

                setPrimaryApartment(ui.item.lat, ui.item.lng, ui.item.label);
            }
        });

        $("form.search input[type=text]").live("click", function(event) {
            var element = $(event.currentTarget);
            element.val('');

            if (element.attr('id') == "neighborhood_autocomplete") {
                $("input#q_neighborhood_ids").val('');
            }
        });

        $("input#q_min_bedrooms").live("blur", function(event) {
            var element = $(event.currentTarget);
            var count = (element.val().replace(/[^\d]/g, ""));

            if (count) {
                element.val(count + "+ Bedrooms");
            } else {
                element.val("All # Bedrooms");
            }
        });

        $("input#q_max_rent").live("blur", function(event) {
            var element = $(event.currentTarget);
            var count = (element.val().replace(/[^\d]/g, ""));

            if (count) {
                element.val("Under $" + count);
            } else {
                element.val("All Prices");
            }
        });

        $("input#q_min_bedrooms, input#q_max_rent").blur();

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

            $("div#selected_neighborhoods").trigger("selected_neighborhood::change");

            return false;
        });

        $("ul.buttons li.save a").live("click", function() {
            $("form.apartment").submit();
            return false;
        });

        $("div.conversations ul.conversation").live("click", function(event) {
            var element = $(event.currentTarget);
            element.parent("div").next("div").slideToggle(150);
            element.find("li.status").removeClass("new");
            $.ajax({
                type: 'put',
                dataType: 'json',
                url: "/conversations/" + element.attr('data-conversation-id') + "/read",
                success  : function success(response) {
                    $(document).trigger('content-received', response);
                }

            });
            return false;
        });

        $("div.conversations ul.conversation li.delete").live("click", function(event) {
            var element = $(event.currentTarget);
            element.parent("ul.conversation").parent("div.conversation").hide('explode');
            $.ajax({
                type: 'delete',
                dataType: 'json',
                url: "/conversations/" + element.parent("ul").attr('data-conversation-id'),
                success  : function success(response) {
                    $(document).trigger('content-received', response);
                }

            });
            return false;
        });

        $("div.messages a.close").live("click", function(event) {
            $(event.currentTarget).parents("div.messages").slideUp(150);
            return false;
        });

        if (typeof message_id != 'undefined') {
            $.scrollTo("div#message_" + message_id, 800);
        }

        $("div.apartment li.message a").live("click", function(event) {
            var element = $(event.currentTarget);
            var div = $("div#message_dialog_" + element.attr('data-apartment-id') + ":last");
            var dialog = div.dialog({
                modal: true,
                resizable: false,
                width: 400,
                height: 325,
                buttons: {
                    'Cancel': function() {
                        $(this).dialog('close');
                    },

                    'Send': function() {
                        if (div.find('textarea').val() != '') {
                            div.find("form").submit();
                        }
                        $(this).dialog('close');
                    }
                }
            });

            div.css("height", "175px");
        });

        if ($("a[data-upload-path]").length > 0) {
            new AjaxUpload('upload', {
                action: $("a[data-upload-path]").attr('data-upload-path'),
                onSubmit : function(file, ext) {
                    if (ext && /^(jpg|png|jpeg|gif)$/i.test(ext)) {
                        this.setData({
                            'authenticity_token': window._token
                        });

                        $('#upload_status').text('Uploading image...');
                    } else {
                        $('#upload_status').text('Error: only images are allowed');
                        return false;
                    }
                },
                onComplete : function(file, response) {
                    $("div#upload_status").text('');
                    $("ul#images").replaceWith(response);
                    $("ul#images").sortable(sortableOptions);
                }
            });
        }

        $('ul#images').sortable(sortableOptions);

        $(document).bind("selected_neighborhood::change", function(event) {
            var div = $(event.target);
            var spans = div.find("span");

            div.html('');
            if (spans.length > 0) {
                div.append("<div>Selected Neighborhoods</div>");
            }

            for (var i = 0; i < spans.length; i++) {
                div.append(spans.eq(i));
                if (i != spans.length - 1) {
                    div.append(", ");
                }
            }

            if (div.is(':hidden')) {
                div.fadeIn();
            }
        });

        $("div#selected_neighborhoods").trigger("selected_neighborhood::change");

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
                    form.find(":input").not(":submit").not(":hidden").val("");
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
                staleMap = true;
            } else {
                staleMap = false;
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
            if ($("div#map_canvas").length > 0 && staleMap) {
                initializeMap();
            }

            $("div#selected_neighborhoods").trigger("selected_neighborhood::change");
        });

        $(document).bind('ajaxStart', function() {
            showLoading();
        });

        $(document).bind('ajaxStop', function() {
            hideLoading();
        });
    });
})(jQuery);
