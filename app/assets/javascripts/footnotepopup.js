//implementation of jquery.footnotepopup library. Seen vendors/assets/javascripts/jquery.footnotepopup.js for library
$(document).on('ready page:load', function () {
	$(document).ready(function(){
		$('p a.appnote' ).footnotepopup( );
		$('p a.footnote' ).footnotepopup( );
		
	 });
});