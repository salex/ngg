function selectHandler(sel,url){
	sobj = $('#'+sel).val()
	var URL = url + sobj;
	window.location = URL;
}

