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
	// var kxSearch = 'https://code.kx.com/v2/search?query='; // >>> reverse-proxy on Nginx at code.kx.com
	var kxSearch = 'https://code.kx.com/v2/search2?query='; // >>> reverse-proxy on Nginx at code.kx.com
	var gsSearch = "https://www.google.com/search?q=site%3Acode.kx.com+";
	var sendToG = function( str ) {
		// send to GS queries with spaces, in PascalCase, hyphenated-phrases or words_joined_with_underscores
		// UNLESS query begins with a .
		if( str[0] === '.' ) {
			return false;
		} else {
			var pc = /([A-Z][a-z0-9]+){2,}/g; 				// PascalCaseLikeThis
			var hy = /^([A-Za-z0-9]+-)+[A-Za-z0-9]+$/; 		// hyphenated-phrases-like-this
			var us = /^([A-Za-z0-9]+_)+[A-Za-z0-9]+$/; 		// underscored_words_like_this
			return str.indexOf(' ') >= 0 || str.match(pc) || str.match(hy) || str.match(us);
		}
	}
	var gsQuery = function( str ) {
		// expand PascalCase, eg 'CompactingHdbSym' to 'Compacting Hdb Sym'
		var separate = function( x ){return x +' ';};
		var r = str.replace(/([A-Z][a-z0-9]+){2,}/g,function( x ){return x.replace(/[A-Z][a-z0-9]+/g,separate);})
		// hyphens and underscores to spaces, eg 'Command-line' and 'command_line' to 'command line'
		var r = r.replace(/[-|_]/g," ");
		return encodeURIComponent(r);
	};
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
