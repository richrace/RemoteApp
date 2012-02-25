function mark_errors(form_id, errors_object) { 
	$.each(errors_object, function(key, value) { 
		var input_temp = $(form_id).find('input[name$="[' + key +']"]');

 		if (input_temp.size() == 0 ) 
			return true;

 		//if (input_temp.parent().children(".errorMessage").size() == 0) 
		input_temp.parent().append('<div class="errorMessage"></div>');
		input_temp.parent().css("color","red").children(".errorMessage").css('text-align','center').text(($.isArray(value) ? value[0] : value));

 	}); 
}

function showToastError(message) {
	$().toastmessage('showToast', {
		text:message, 
		sticky:false,
		type:'error', 
		stayTime:2000, 
		position:'top-center',
		close:function () { $.mobile.fixedToolbars.show(true); }
	});
}

function showLoading(message) {
	$.mobile.loadingMessage = message;
    $.mobile.showPageLoadingMsg();
}

function hideLoading() {
	$.mobile.hidePageLoadingMsg();
    $.mobile.loadingMessage = false;
}
