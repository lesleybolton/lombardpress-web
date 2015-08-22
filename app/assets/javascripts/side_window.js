/////////event bindings related to side window /////////

$(document).on('ready page:load', function () {
  // Actions to do

	$(document).ready(function(){

		$("a.js-show-outline").click(function(){
			$paragraph = getCurrentViewingParagraph();
			showSideWindow($paragraph);
			var itemid = $(this).attr("data-itemid");
			showOutline(itemid);
		});
		$("a.js-close-side-window").click(function(){
			$paragraph = getCurrentViewingParagraph();
			hideSideWindow($paragraph);
		});
		$("a.js-minimize-side-window").click(function(){
			$paragraph = getCurrentViewingParagraph();
			minimizeSideWindow($paragraph);
		});
		$("a.js-maximize-side-window").click(function(){
			$paragraph = getCurrentViewingParagraph();
			maximizeSideWindow($paragraph);
		});
		$("a.js-show-paragraph-variants").click(function(){
			event.preventDefault();
			var itemid = $(this).attr("data-itemid");
			var pid = $(this).attr("data-pid");
			$paragraph = $("p#" + pid);
			showSideWindow($paragraph);
			showParagraphVariants(itemid, pid);
		});
		$("a.js-show-paragraph-notes").click(function(){
			event.preventDefault();
			var itemid = $(this).attr("data-itemid");
			var pid = $(this).attr("data-pid");
			$paragraph = $("p#" + pid);
			showSideWindow($paragraph);
			showParagraphNotes(itemid, pid);
		});
		$("a.js-show-paragraph-info").click(function(){
			event.preventDefault();
			var itemid = $(this).attr("data-itemid");
			var pid = $(this).attr("data-pid");
			$paragraph = $("p#" + pid);
			showSideWindow($paragraph)
			showParagraphInfo(itemid, pid)
		});

	});
});

///////document event bindings //////////////
$(document).on("mouseover", ".lbp-side-window-variant", function(event){
			var lem_ref = $(this).attr("data-lem-ref");
			$(this).css({backgroundColor: "yellow"});
			$("span#" + lem_ref).css({backgroundColor: "yellow"});
		});
$(document).on("mouseout", ".lbp-side-window-variant", function(event){
			var lem_ref = $(this).attr("data-lem-ref");
			$(this).css({backgroundColor: "transparent"});
			$("span#" + lem_ref).css({backgroundColor: "transparent"});
		});
$(document).on("mouseover", ".lbp-side-window-note", function(event){
			var note = $(this).attr("data-note");
			$(this).css({backgroundColor: "yellow"});
			$("span#" + note).css({backgroundColor: "yellow"});
		});
$(document).on("mouseout", ".lbp-side-window-note", function(event){
			var note = $(this).attr("data-note");
			$(this).css({backgroundColor: "transparent"});
			$("span#" + note).css({backgroundColor: "transparent"});
		});

$(document).on("click", ".js-side-bar-scroll-to-paragraph", function(event){
			var pid = $(this).attr("data-pid");
			$paragraph = $("p#" + pid);
			scrollToParagraph($paragraph);
		});
$(document).on("click", ".js-show-reference-paragraph", function(event){
			showSpinner("#lbp-bottom-window-container");
			showBottomWindow();
			halfSizeBottomWindow();
			var url = $(this).attr("data-url");
			showParagraphReference(url);
		});


///////////FUNCTIONS////////////////////

var scrollToParagraph = function(element){
	if (element.length > 0) {
	    $('html, body')
            .stop()
            .animate({
                scrollTop: element.offset().top - 100
            }, 1000);
   }

}

var getCurrentViewingParagraph = function(){
	var $paragraphs = $('p.plaoulparagraph');
	var viewerMidPoint = $(window).height()/2;
	$paragraph = ($paragraphs.nearest({y: $(window).scrollTop() + viewerMidPoint, x: 0})); 
	return $paragraph;
}

var showSideWindow = function(element){
	
	$("div#lbp-text-body").animate({"width": "50%", "margin-left": "45%"}, function(){
		$("div#lbp-side-window").css("display", "block").promise().done(function(){
			$("div#lbp-side-window").animate({"width": "40%"}, scrollToParagraph(element));
		});
	});
	
};

var hideSideWindow = function(element){
	
	$("li#lbp-max-side-window").css("display", "none").promise().done(function(){
		$("li#lbp-min-side-window").css("display", "block").promise().done(function(){
			$("div#lbp-side-window").animate({"width": "0"}, function(){
				$("div#lbp-side-window").css("display", "none").promise().done(function(){
					$("div#lbp-text-body").css({"margin-left": "auto"}).promise().done(function(){
						$("div#lbp-text-body").css({"width": "60%"}).promise().done(scrollToParagraph(element));
					});
				});
			});
		});
	});
};

var minimizeSideWindow = function(element){
	
	$("li#lbp-max-side-window").css("display", "block").promise().done(function(){
		$("li#lbp-min-side-window").css("display", "none").promise().done(function(){
			$("div#lbp-side-window").animate({"width": "100px"}, function(){
				$("div#lbp-text-body").css({"margin-left": "auto"}).promise().done(function(){
					$("div#lbp-text-body").css({"width": "60%"}).promise().done(scrollToParagraph(element));	
				}); 
			}); 
		});
	});
};
var maximizeSideWindow = function(element){
	$("li#lbp-min-side-window").css("display", "block").promise().done(function(){
			$("li#lbp-max-side-window").css("display", "none").removeClass("js-maximize-side-window").promise().done(showSideWindow(element));	
		});
};

var showOutline = function(itemid){
	$("#lbp-side-window-container").load("/text/toc/" + itemid + " #lbp-toc-container", function( response, status, xhr) {
		console.log(status);
  	if ( status == "error" ) {
    	var msg = "<h3>Sorry but an outline for this text is not yet available.</h3>";
    	$("#lbp-side-window-container").html( msg);
    		console.log(xhr.status + " " + xhr.statusText);
    }	

	});
}

var showParagraphVariants = function(itemid, pid){
	$("#lbp-side-window-container").load("/paragraphs/variants/" + itemid + "/" + pid + "#lbp-" + pid + "-variant-list", function( response, status, xhr) {
		console.log(status);
  	if ( status == "error" ) {
    	var msg = "<h3>Sorry, but there are no variants for this paragraph.</h3>";
    	$("#lbp-side-window-container").html( msg);
    		console.log(xhr.status + " " + xhr.statusText);
    }	
	});
}
var showParagraphNotes = function(itemid, pid){
	$("#lbp-side-window-container").load("/paragraphs/notes/" + itemid + "/" + pid + "#lbp-" + pid + "-notes-list", function( response, status, xhr) {
		console.log(status);
  	if ( status == "error" ) {
    	var msg = "<h3>Sorry, but there are no variants for this paragraph.</h3>";
    	$("#lbp-side-window-container").html( msg);
    		console.log(xhr.status + " " + xhr.statusText);
    }	
	});
}

var showParagraphInfo = function(itemid, pid){
	$.get("/paragraphexemplar/json/" + itemid + "/" + pid, function(data){
		var content = HandlebarsTemplates['textinfo'](data);
		$("#lbp-side-window-container").html(content);

	});
}
var showParagraphReference = function(url){
	$("#lbp-bottom-window-container").load("/paragraphs/show2/?url=" + url, function(response, status, xhr){
		if ( status == "error" ) {
    	var msg = "Sorry but something went wrong";
    	$("#lbp-bottom-window-container").html( msg + "(" + xhr.status + " " + xhr.statusText + ")");
    }
  });
}	