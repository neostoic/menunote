$(function() {
	$(".accordions").accordion({
		collapsible: true,
		active: false
	});
	$("#food_category").on('click', function() {
		if ($("#restaurant_info_contents").is(":visible")===true) {
			$("#restaurant_info_header").trigger("click");
		}
		$("#food_category_header").trigger("click");
	});
	$(".restaurant_name").on('click', function() {
		if ($("#food_category_contents").is(":visible")===true) {
			$("#food_category_header").trigger("click");
		}
		$("#restaurant_info_header").trigger("click");
	});
});
