/*
 * Custom script for code.kx.com/v2
 * Author: stephen@kx.com
 * Version: 2019.05.07
 * https://gist.github.com/wpscholar/4637176#file-jquery-external-links-new-window-js-L4
 */
$(function() {
	// Open all external links in a new window
    $('a').not('[href*="mailto:"]').each(function () {
		var isInternalLink = new RegExp('/' + window.location.host + '/');
		if ( ! isInternalLink.test(this.href) ) {
			$(this).attr('target', '_blank');
		}
	});
    // Search engine call from Search box
	var serviceRoot = 'https://code.kx.com/v2/search'; // >>> reverse-proxy on Nginx at code.kx.com
	var srchHandler =function( evt ) {
		// console.log(evt.which);
		if( evt.which===13 ) {
			var url = serviceRoot + "?query=" + encodeURIComponent($("[data-md-component=query]").val());
			console.log(url);
			window.location = url;
			return false;
		};
	};
	$(window).off('keydown');
	$("[data-md-component=query]").off('focus keyup change');
	$(".md-search__form").on('keydown', srchHandler); 
	// replace Close button with link to Search tips
	var btn = $("button.md-icon.md-search__icon");
	$(btn).text("?");
	$(btn).attr("title","Search help");
	$(btn).css({
		color:"white",
		fontFamily:'Roboto,"Helvetica Neue",Helvetica,Arial,sans-serif',
		opacity:"1",
		transform:"none","-webkit-transform":"none"
	});
	$(btn).click(function() {
		var host = window.location.host;
		var dest = "/v2/about/search";
		window.location = dest;
	});
});
