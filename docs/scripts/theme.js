/*
 * Custom script for code.kx.com/v2
 * Author: stephen@kx.com
 * Version: 2019.06.15
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
	var kxSearch = 'https://code.kx.com/v2/search?query='; // >>> reverse-proxy on Nginx at code.kx.com
	var gsSearch = "https://www.google.com/search?q=site%3Acode.kx.com/v2/+";
	var srchHandler =function( evt ) {
		if( evt.which===13 ) {
			var qry = $("[data-md-component=query]").val().trim();
			if( qry !== "" ) {
				// var url = ( qry.indexOf(' ') >= 0 ? gsSearch : kxSearch ) + encodeURIComponent(qry);
				var url = sendToG(qry) ? gsSearch + gsQuery(qry) : kxSearch + encodeURIComponent(qry);
				console.log(url);
				window.location = url;
			};
			return false;
		};
	};
	$(window).off('keydown');
	// disable MkDocs keypress listener/s on Search form
	$('.md-search__form').replaceWith($('.md-search__form').clone());
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
		var dest = "/v2/about/search/";
		window.location = dest;
	});
});
