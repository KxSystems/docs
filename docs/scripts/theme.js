    /** 
 * https://gist.github.com/wpscholar/4637176#file-jquery-external-links-new-window-js-L4
 * Open all external links in a new window
 */
// window.addEventListener('load', function(e) {
$(function() {
    $('a').not('[href*="mailto:"]').each(function () {
		var isInternalLink = new RegExp('/' + window.location.host + '/');
		if ( ! isInternalLink.test(this.href) ) {
			$(this).attr('target', '_blank');
		}
	});
	// Supplement local search: send query to Web search engine on Return
/*	$("[data-md-component=query]").change(function() {
		var qry = "http://www.google.com/search?q="; // www.bing.com is an alternative
		qry += "site%3Acode.kx.com/q/+"; // non-portable, excludes wiki
		window.location = qry + $(this).val();
		return false; // prevents submitting form to server
	});
*/	// replace Close button with link to Search tips
	var btn = $("button.md-icon.md-search__icon");
	$(btn).text("?");
	$(btn).attr("title","Search help");
	$(btn).css({
		color:"white",
		fontFamily:'Roboto,"Helvetica Neue",Helvetica,Arial,sans-serif',
		fontSize:"1.6rem",
		opacity:"1",
		paddingTop:".5rem",
		transform:"none","-webkit-transform":"none"
	});
	$(btn).click(function() {
		var host = window.location.host;
		var dest = "/about/thissite/#search-tips";
		dest = (host==="code.kx.com" ? "/q" : "") + dest
		window.location = dest;
	});
	// $("button.md-icon.md-search__icon").replaceWith('<a href="/about/thissite/#search-tips" title="Search tips">?</a>');

	// // cse.google.com Google Custom Search Engine
	// // replace MkDocs Search form with GCSE container
	// $('form[name="search"]').parent().parent().replaceWith('<gcse:search id="gcse_search"></gcse:search>');
	// // compose master GCSE script to call other scripts
	// var cx = '004878902718534787160:xazraufkjx4';
	// var gcse = document.createElement('script');
	// gcse.type = 'text/javascript';
	// gcse.async = true;
	// gcse.src = 'https://cse.google.com/cse.js?cx=' + cx;
	// // insert the master GCSE script
	// var s = document.getElementsByTagName('script')[0];
	// // console.log('Insert new script');
	// s.parentNode.insertBefore(gcse, s);
	// // override GCSE style rules to 
	// var style = '.cse .gsc-control-cse, .gsc-control-cse {background-color: transparent !important; border-color: transparent !important;}';
	// // style += '.gsc-search-button {display: none;}';
	// style += 'input.gsc-search-button.gsc-search-button-v2 {height: inherit !important; width: inherit !important;}';
	// style += ' #gcse_search {width: 300px !important}';
	// $('html > head').append($('<style>'+style+'</style>'));

	// $(document).arrive("input.gsc-search-button.gsc-search-button-v2", function(newElem) {
	// 	// https://github.com/uzairfarooq/arrive
	// 	// console.log('button found');
	// 	$(document).unbindArrive(); // unbind all arrive events
	// 	$(newElem).replaceWith('<a href="/about/thissite/#search-tips" title="Search tips">?</a>');
	// 	// $(newElem).click(function(){window.location.href="/about/thissite";});
	// });

});
