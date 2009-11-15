/**
 * Modified version of advfile
 * @author Tatamae
 * @copyright Copyright © 2009, Tatemae.
 */
(function() {
	tinymce.create('tinymce.plugins.AdvancedFileTooPlugin', {
		init : function(ed, url) {
			// Register commands
			ed.addCommand('mceAdvFileToo', function() {
				var e = ed.selection.getNode();
				// Internal file object like a flash placeholder
				if (ed.dom.getAttrib(e, 'class').indexOf('mceItem') != -1)
					return;
				ed.windowManager.open({
					file : '/tiny_mce_files?upload_path=' + jQuery('#upload-path').val(),
					width : 675 + parseInt(ed.getLang('advfiletoo.delta_width', 0)),
					height : 540 + parseInt(ed.getLang('advfiletoo.delta_height', 0)),
					inline : 1
				}, {
					plugin_url : url
				});
			});
			// Register button
			ed.addButton('file', {
				title : 'Upload Files',
				cmd : 'mceAdvFileToo',
				image : url + '/img/upload.gif'
			});
		},
		getInfo : function() {
			return {
				longname : 'Advanced file',
				author : 'Moxiecode Systems AB',
				authorurl : 'http://tinymce.moxiecode.com',
				infourl : 'http://wiki.moxiecode.com/index.php/TinyMCE:Plugins/advfile',
				version : tinymce.majorVersion + "." + tinymce.minorVersion
			};
		}
	});
	// Register plugin
	tinymce.PluginManager.add('advfiletoo', tinymce.plugins.AdvancedFileTooPlugin);
})();