// GOOGLE ANALYTICS CODE FOR CODE.KX.COM 
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
	(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
	m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

// ga('create', 'UA-3462586-4', 'auto');
ga('create', 'UA-3462586-1', 'auto');
// ga('send', 'pageview');
// report bookmarks in pageview 
ga('send', 'pageview', {
 'page': location.pathname + location.search  + location.hash
});
// report local bookmark change
// http://stackoverflow.com/questions/4811172/is-it-possible-to-track-hash-links-like-pages-with-google-analytics
// WITHOUT overriding other event listeners
// https://developer.mozilla.org/en/docs/Web/API/WindowEventHandlers/onhashchange
// https://developers.google.com/analytics/devguides/collection/analyticsjs/command-queue-reference
window.addEventListener("hashchange", function(){
	ga('send', 'pageview', {
	 'page': location.pathname + location.search  + location.hash
	});
}, false);