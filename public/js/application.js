function mark_errors(form_id, errors_object) { 
	$.each(errors_object, function(key, value) { 
		var input_temp = $(form_id).find('input[name$="[' + key +']"]');

 		if (input_temp.size() == 0 ) 
			return true;
		input_temp.parent().append('<div class="errorMessage"></div>');
		input_temp.parent().css("color","red").children(".errorMessage").css('text-align','center').text(($.isArray(value) ? value[0] : value));

 	}); 
}

function showToastError(message) {
	$.mobile.fixedToolbars.show(true);
	loadToast('error', message);
	hideLoadingToast();
}

function showToastSuccess(message) {
	$.mobile.fixedToolbars.show(true);
	loadToast('success', message);
}

var loadingToast;

function showToastLoading(message) {
	$.mobile.fixedToolbars.show(true);
	loadingToast = $().toastmessage('showToast', {
		text:message, 
		sticky:true,
		type:'notice', 
		//stayTime:2000, 
		position:'top-center',
		close:function () { $.mobile.fixedToolbars.show(true); }
	});
}

function hideLoadingToast() {
	$().toastmessage('removeToast', loadingToast, { close:function () { $.mobile.fixedToolbars.show(true); } });
	loadingToast = null;
	$.mobile.fixedToolbars.show(true);
}

function loadToast(type, message) {
	$().toastmessage('showToast', {
		text:message, 
		sticky:false,
		type:type, 
		stayTime:2000, 
		position:'top-center',
		close:function () { $.mobile.fixedToolbars.show(true); }
	});
}

function loadAllThumbs(id) {
	var result = id.split("_");
	if (result[0] == "movieid") {
		$.get("/app/Movie/get_thumb", {"movieid":result[1]});
	} 
}
