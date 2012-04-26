/*
 * Function that marks errors on Forms.
 */
function mark_errors(form_id, errors_object) { 
	$.each(errors_object, function(key, value) { 
		var input_temp = $(form_id).find('input[name$="[' + key +']"]');

 		if (input_temp.size() == 0 ) 
			return true;
		input_temp.parent().append('<div class="errorMessage"></div>');
		input_temp.parent().css("color","red").children(".errorMessage").css('text-align','center').text(($.isArray(value) ? value[0] : value));

 	}); 
}

/*
 * Shows a toast error message
 * uses the jquery-toastmessage-plugin
 */
function showToastError(message) {
	$.mobile.fixedToolbars.show(true);
	loadToast('error', message);
	hideLoadingToast();
}

/*
 * Shows a toast success message
 * uses the jquery-toastmessage-plugin
 */
function showToastSuccess(message) {
	$.mobile.fixedToolbars.show(true);
	loadToast('success', message);
}

// Used to remove the sticky loading toast.
var loadingToast;

/*
 * Shows a sticky toast loading message
 * uses the jquery-toastmessage-plugin
 */
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

/*
 * Hides the sticky toast loading message
 * uses the jquery-toastmessage-plugin
 */
function hideLoadingToast() {
	$().toastmessage('removeToast', loadingToast, { close:function () { $.mobile.fixedToolbars.show(true); } });
	loadingToast = null;
	$.mobile.fixedToolbars.show(true);
}

/*
 * Loads a custom toast message
 * uses the jquery-toastmessage-plugin
 */
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

/*
 * Loads thumbnails based from the ID that is sent
 * to it. It only supports Movies at the moment.
 * Uses the jquery.lazyload plugin. To load this function
 * line 97 in the plugin as been added.
 */
function loadAllThumbs(id) {
	var result = id.split("_");
	if (result[0] == "movieid") {
		$.get("/app/Movie/get_thumb", {"movieid":result[1]});
	} 
}
