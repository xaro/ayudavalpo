# Map legend
$(".map-legend .title").bind "click", (e) =>
  if $(".map-legend").hasClass("expanded")
    $(".map-legend").removeClass("expanded")
    $(".map-legend .title .right").html("+")
    $(".map-legend .legend").addClass("hide")
  else
    $(".map-legend").addClass("expanded")
    $(".map-legend .title .right").html("-")
    $(".map-legend .legend").removeClass("hide")