/*
 * Custom script for code.kx.com
 * Author: stephen@kx.com
 * Version: 2020.11.02
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
    var ops = ["add","amend","apply","index","trap","cast","coalesce","compose","cond","cut","deal","roll",
    	"permute","delete","display","dict","divide","display","dynamic load","drop","enkey","unkey",
    	"enumerate","enumeration","enum extend","equal","exec","file binary","file text","fill","find",
    	"flip","splayed","greater","greater than","identity","null","join","less than","lesser","match",
    	"matrix multiply","multiply","not equal","pad","select","set attribute","simple exec","signal",
    	"subtract","take","tok","update","vector conditional"];
	var kwds = ["abs","acos","aj","aj0","ajf","ajf0","all","and","any","asc","asin","asof","atan","attr",
		"avg","avgs","bin","binr","ceiling","cols","cor","cos","count","cov","cross","csv",
		"cut","delete","deltas","desc","dev","differ","distinct","div","do","dsave","each","ej",
		"ema","enlist","eval","except","exec","exit","exp","fby","fills","first","fkeys","flip",
		"floor","get","getenv","group","gtime","hclose","hcount","hdel","hopen","hsym","iasc",
		"idesc","if","ij","ijf","in","insert","inter","inv","key","keys","last","like","lj",
		"ljf","load","log","lower","lsq","ltime","ltrim","mavg","max","maxs","mcount","md5",
		"mdev","med","meta","min","mins","mmax","mmin","mmu","mod","msum","neg","next","not",
		"null","or","over","parse","peach","pj","prd","prds","prev","prior","rand","rank",
		"ratios","raze","read0","read1","reciprocal","reval","reverse","rload","rotate","rsave",
		"rtrim","save","scan","scov","sdev","select","set","setenv","show","signum","sin","sqrt",
		"ss","ssr","string","sublist","sum","sums","sv","svar","system","tables","tan","til","trim"
		,"type","uj","ujf","ungroup","union","update","upper","upsert","value","var","view",
		"views","vs","wavg","where","while","within","wj","wj1","wsum","xasc","xbar","xcol",
		"xcols","xdesc","xexp","xgroup","xkey","xlog","xprev","xrank"];
	var site = window.location.origin + "/";
	var test = site[4]!=="s"; // production site uses HTTPS
	// var kxSearch = site + 'q/search2?query='; // >>> reverse-proxy on Nginx at code.kx.com
	var gsSearch = 'https://www.google.com/search?q=site%3Acode.kx.com+';
	var srchHandler = function( evt ) {
		if( evt.which===13 ) {
			var qry = $("[data-md-component=search-query]").val().trim();
			if( qry !== "" ) {
				var tryThis = function( str, keys, vals, pfx, sfx ){
					var i = jQuery.inArray(str,keys);
					return i == -1 ? "" : pfx + vals[i].replace(/ /g,"-") + sfx;
				};
				// Reference
				// try overloaded operator glyphs
				var ovl = ["at","backslash","bang","dot","dollar","hash","query","quote","quote-colon","slash","underscore"];
				var pag = tryThis(qry, ["@","\\","!",".","$","#","?","'","':","/","_"], ovl, "overloads/#", "");
				// by name
				pag = pag?pag : tryThis(qry, ovl, ovl, "overloads/#", "");
				// operator glyphs, not overloaded
				pag = pag?pag : tryThis(qry,
					["+","-","*","%","~","|","&","^",",",],
					["add","subtract","multiply","divide","match","greater","lesser","fill","join"],
					"", "/");
				// map iterators
				pag = pag?pag : tryThis(qry,
					["/:","\\:"],
					["maps/#each-left-and-each-right","maps/#each-left-and-each-right"],
					"", "");
				// operator names: rely on server config to map e.g. /q/ref/roll/ to /q/ref/deal/
				pag = pag?pag : tryThis(qry.toLowerCase(), ops, ops, "", "/");
				// keywords: rely on server config to map e.g. /q/ref/ajf/ to /q/ref/aj/
				pag = pag?pag : tryThis(qry, kwds, kwds, "", "/");
				// namespaces
				if( !pag && qry.length>1 && qry[0]=="." ){
 					pag = ($.inArray(qry[1], ["h","j","m","q","Q","z"] )>-1 ? "dot"+qry[1].toLowerCase()+"/" : "");
				}
				pag = pag ? "ref/" + pag : "";  // all the above in /q/ref

				// system commands
				pag = pag?pag : ( qry.match(/^\\[a-zA-Z12_\\]{0,2}$/) ? "basics/syscmds/" : "" );
				// command-line options
				pag = pag?pag : ( qry.match(/^-[a-zA-Z]$/) ? "basics/cmdline/" : "" );
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
				pag = pag ? (test ? "" : "q/") + pag : "";  // all the above in /q

				pag = pag?pag : (qry.match(/q4m/gi)       ? "q4m3/" : "");
				pag = pag?pag : (qry.match(/mortal/gi)    ? "q4m3/" : "");
				pag = pag?pag : (qry.match(/phrase/gi)    ? "phrases/" : "");
				pag = pag?pag : (qry.match(/dict/gi)      ? "q/basics/dictsandtables/" : "");
				pag = pag?pag : (qry.match(/developer/gi) ? "developer/" : "");

				var url = pag ? site + pag : gsSearch + encodeURIComponent(qry);
				// var url = pag ? site + pag : kxSearch + encodeURIComponent(qry);
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
	// // White paper branding
	// var authorList = function( authors ) { // author list as string
	// 	var res = '', lst = authors.length - 1;
	// 	authors.forEach(function(author,i){
	// 		res += author+(i==lst?'':(i==lst-1?' &amp; ':', '));
	// 	});
	// 	return res;
	// };
	// if( $('link[rel=canonical]').attr('href').includes('/wp/') ) {
	// 	var auth = $('meta[name=author]').attr('content');
	// 	// console.log(authorPubs(pubs[auth]));
	// 	if( auth !== 'Kx Systems' ) { // default
	// 		var ttl = $('title').text();
	// 		ttl = ttl.slice(0,ttl.indexOf('|')).trim();
	// 		var authors = auth.charAt(0)==='[' ? JSON.parse(auth.replace(/'/g,'"')) : [auth];
	// 		// Other papers by the authors
	// 		// var pubs = {};
	// 		// authors.forEach(function(author){
	// 		// 	pubs[author] = '';
	// 		// });
	// 		// $.getJSON("/data/white-papers.json", function( papers ) { 
	// 		// 	papers.forEach(function(paper){
	// 		// 		if( paper.title !== ttl ){
	// 		// 			var uri = encodeURI('/wp/'+paper.slug+'/');
	// 		// 			var li = '<li><i class="far fa-map"></i> <a href="'+uri+'">'+paper.title+'</a></li>';
	// 		// 			authors.forEach(function(author){
	// 		// 				if( paper.authors.indexOf(author) != -1 ){
	// 		// 					pubs[author] += li;
	// 		// 				}
	// 		// 			});
	// 		// 		}
	// 		// 	});
	// 		// 	Object.keys(pubs).forEach(author => {
	// 		// 		if( pubs[author].length ){
	// 		// 			$('#author'+s).nextAll('p:contains("'+author+'")').first()
	// 		// 				.after('<p class="publications">Other papers by '+author+'</p><ul class="publications">'+pubs[author]+'</ul>');
	// 		// 		}
	// 		// 	});
	// 		// });
	// 		// $('h1').before('<p id="wp-brand">White paper</p>'); // WP heading
	// 		var s = authors.length > 1 ? 's' : ''; // plural?
	// 		$('h1').after('<p class="wp-author"><a href="#author'+s+'">by '+authorList(authors)+'</a></p>');
	// 	}
	// }
});
