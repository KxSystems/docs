/*
 * Custom script for code.kx.com
 * Author: stephen@kx.com
 * Version: 2020.01.16
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
	var site = window.location.origin + "/";
	var kxSearch = site + 'q/search2?query='; // >>> reverse-proxy on Nginx at code.kx.com
	var gsSearch = 'https://www.google.com/search?q=site%3Acode.kx.com+';
	var srchHandler = function( evt ) {
		if( evt.which===13 ) {
			var qry = $("[data-md-component=query]").val().trim();
			if( qry !== "" ) {
				var tryThis = function( str, keys, vals, pfx, sfx ){
					var i = jQuery.inArray(str,keys);
					return i == -1 ? "" : pfx + vals[i] + sfx;
				};
				// Reference
				// try overloaded operator glyphs
				var ovl = ["at","backslash","bang","dot","dollar","hash","query","quote","quote-colon","slash","underscore"];
				var pag = tryThis(qry, ["@","\\","!",".","$","#","?","'","':","/","_"], ovl, "overloads/#", "");
				// by name
				pag = pag?pag : tryThis(qry, ovl, ovl, "overloads/#", "");
				// operator glyphs, not overloaded
				pag = pag?pag : tryThis(qry,
					["+","-","*","%","~","|","&","^",","],
					["add","subtract","multiply","divide","match","greater","lesser","fill","join"],
					"", "/");
				// popular direct hits
				pag = pag?pag :
					($.inArray(qry, ["aj","fby","join","if","lj","hopen","upsert","each","xbar","raze","xbar","enlist","table","sv","vs","uj","ssr","csv"] )>-1
						? qry + "/" : "");
				// namespaces
				if( !pag && qry.length>1 && qry[0]=="." ){
 					pag = ($.inArray(qry[1], ["h","j","m","q","Q","z"] )>-1 ? "dot"+qry[1]+"/" : "");
				}
				pag = pag ? "ref/" + pag : "";  // all the above in /q/ref

				// internal functions
				pag = pag?pag : ( qry.match(/^-\d\d?\d?!x?$/) ? "basics/internal/" : "" );
				// comparison operators
				pag = pag?pag :
					($.inArray(qry,["=","<>","<","<=",">",">="])>-1 ?
						"basics/comparison/#six-comparison-operators" : "");
				// some popular queries
				pag = pag?pag :
					($.inArray(qry,["types","datatype","datatypes","data type","data types"])>-1 ?
						"basics/datatypes/" : "");
				pag = pag?pag : ($.inArray(qry,["man","man.q"])>-1 ? "about/man/" : "");
				pag = pag ? "q/" + pag : "";  // all the above in /q

				pag = pag?pag : (qry.match(/q4m/gi)       ? "q4m3/" : "");
				pag = pag?pag : (qry.match(/mortal/gi)    ? "q4m3/" : "");
				pag = pag?pag : (qry.match(/phrase/gi)    ? "phrases/" : "");
				pag = pag?pag : (qry.match(/dict/gi)      ? "q/basics/dictsandtables/" : "");
				pag = pag?pag : (qry.match(/developer/gi) ? "developer/" : "");

				// var url = pag ? site + pag : gsSearch + encodeURIComponent(qry);
				var url = pag ? site + pag : kxSearch + encodeURIComponent(qry);
				// console.log(url);
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
		var dest = "/q/about/search/";
		window.location = dest;
	});
});
