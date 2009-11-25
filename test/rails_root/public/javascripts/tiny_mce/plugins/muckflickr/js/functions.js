tinyMCEPopup.requireLangPack();

var MuckFlickrDialog = {
	init : function() {
		var selected_text = tinyMCEPopup.editor.selection.getContent({format : 'text'});
	},
	insert : function() {
        selected_text = tinyMCEPopup.editor.selection.getContent({format : 'text'})
        if(selected_text.length > 3){
            return_text =  selected_text + document.getElementById("result_html_id").value;
        }else{
            return_text =  document.getElementById("result_html_id").value;
        }
		tinyMCEPopup.editor.execCommand('mceInsertContent', false, return_text);
		tinyMCEPopup.close();
	}
};

tinyMCEPopup.onInit.add(MuckFlickrDialog.init, MuckFlickrDialog);