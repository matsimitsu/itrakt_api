/*
  Lightweight lightbox for jQuery. v0.2
  Moves the element you want to show (not the element itself!) to a lightbox.
*/

(function($){
  var overlay, lightbox, body, el;

  var settings =  {
                    relative_to: 'viewport',
                    overlay_color: '#000',
                    close_button: true
                  };

  var methods = {
    init: function(options) {
      if (options) {
        $.extend(settings, options);
      }

      // Bind "escape"-key to hide lightbox when needed.
      $(document.documentElement).keyup(function(e) {
        if (e.keyCode == 27) {
          methods['hide'].apply();
        }
      });

      // Set some vars.
      var viewport_w = $(window).width();
      var viewport_h = $(window).height();
      body = $('body');
      el = this;

      // Append dark overlay and lightbox.
      body.append('<div id="overlay" style="width: 100%; height: 100%; top: 0; left: 0; position: absolute; background: ' + settings.overlay_color + '; z-index: 10; filter: alpha(opacity=60); opacity: .6"></div><div id="lightbox" style="position: absolute; z-index: 100"></div>');

      overlay = $('#overlay');
      lightbox = $('#lightbox');

      if (settings.close_button === true) {
        lightbox.append('<a href="#" onclick="$.fn.beansbox(\'hide\'); return false" class="close">close</a>');
      }

      // Move content to lightbox.
      lightbox.append(this.show());

      // Store lightbox size.
      var lightbox_w = lightbox.width();
      var lightbox_h = lightbox.height();

      // Hide horizontal scrollbar in IE.
      if ($.browser.msie) {
        $('html').css('overflow-x', 'hidden');
      }

      // Set overlay width & height.
      overlay.height($(document).height()+'px').width($(document).width() + 'px');

      // Resize overlay if scrollTop + lightbox height > overlay height.
      if (($(window).scrollTop() + lightbox_h) > $(document).height()) {
        overlay.height(($(window).scrollTop() + lightbox_h) + 'px');
      }

      // Make lightbox disappear when clicking on overlay.
      overlay.click(function(){
        methods['hide'].apply();
      });

      if (settings.relative_to == 'viewport') {
        // Calculate top/left offset for lightbox based on lightbox size.
        var pos_top = (viewport_h < lightbox_h) ? 0 : ((viewport_h - lightbox_h) / 2);
        var pos_left = (viewport_w < lightbox_w) ? 0 : ((viewport_w - lightbox_w) / 2);

        // Position lightbox.
        lightbox.css({
          top: (pos_top + $(window).scrollTop()) + 'px',
          left: pos_left + 'px'
        });
      } else {
        var relative_to_obj = $(settings.relative_to);

        if (relative_to_obj.length) {
          // Get position of element we want to position it faux relative to.
          rel_offset = relative_to_obj.offset();
          lightbox.css({
            top: rel_offset.top + 'px',
            left: rel_offset.left + 'px'
          });
        }
      }
    },

    hide: function() {
      // Move and hide element again.
      body.append(el.hide());

      // Remove elements.
      overlay.remove();
      lightbox.remove();
    }
  };

  $.fn.beansbox = function(method) {
    if (methods[method]) {
      return methods[ method ].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === 'object' || ! method) {
      return methods.init.apply(this, arguments);
    } else {
      $.error('Method ' +  method + ' does not exist on jQuery.beansbox');
    }
  };

})( jQuery );