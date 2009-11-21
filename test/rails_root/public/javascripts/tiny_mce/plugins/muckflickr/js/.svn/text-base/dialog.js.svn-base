tinyMCEPopup.requireLangPack();

var FlickrDialog = {
	init : function() {
		var selected_text = tinyMCEPopup.editor.selection.getContent({format : 'text'});
        if(selected_text.length > 3 && selected_text.length < 30 ){
            $("#q_id").val(selected_text)
            updateResults();
        }
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

tinyMCEPopup.onInit.add(FlickrDialog.init, FlickrDialog);
