shinyjs.cookie = function(params) {
  var cookie = Cookies.get("id");
  if (typeof cookie !== "undefined") {
    Shiny.onInputChange("jscookie", cookie);
  } else {
    Cookies.set("id", escape(params), { expires: 1825 });
    Shiny.onInputChange("jscookie", params);
  }
};

shinyjs.get_lang_cookie = function(params) {
  var lang_cookie = Cookies.get("lang");
  if (typeof lang_cookie !== "undefined") {
    Shiny.onInputChange("jslang_cookie", lang_cookie);
  } else {
    Cookies.set("lang", escape(params), { expires: 1825 });
    Shiny.onInputChange("jslang_cookie", params);
  }
};

shinyjs.set_lang_cookie = function(params) {
  Cookies.set("lang", escape(params), { expires: 1825 });
  Shiny.onInputChange("jslang_cookie", params);
};

shinyjs.reset_hearts = function(params) {
  $('.rating-symbol-foreground').css('width', params);
};
