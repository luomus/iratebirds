 shinyjs.cookie = function(params) {
   var cookie = Cookies.get("id");
   if (typeof cookie !== "undefined") {
     Shiny.onInputChange("jscookie", cookie);
   } else {
     Cookies.set("id", escape(params));
     Shiny.onInputChange("jscookie", params);
   }
 };
