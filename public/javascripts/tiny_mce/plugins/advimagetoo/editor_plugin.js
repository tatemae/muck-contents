/**
 * $Id: editor_plugin_src.js 520 2008-01-07 16:30:32Z spocke $
 * @author Moxiecode
 * @copyright Copyright © 2004-2008, Moxiecode Systems AB, All rights reserved.
 */
(function() {
	tinymce.create('tinymce.plugins.AdvancedImageTooPlugin', {
		init : function(ed, url) {
			// Register commands
			ed.addCommand('mceAdvImageToo', function() {
				var e = ed.selection.getNode();
				// Internal image object like a flash placeholder
				if (ed.dom.getAttrib(e, 'class').indexOf('mceItem') != -1)
					return;
				ed.windowManager.open({
					file : url + '/tiny_mce_images?upload_path=' + jQuery('#upload-path').val(),
					width : 675 + parseInt(ed.getLang('advimagetoo.delta_width', 0)),
					height : 560 + parseInt(ed.getLang('advimagetoo.delta_height', 0)),
					inline : 1
				}, {
					plugin_url : url
				});
			});
			// Register buttons
			ed.addButton('image', {
				title : 'Upload Images',
				cmd : 'mceAdvImageToo'
			});
		},
		getInfo : function() {
			return {
				longname : 'Advanced image',
				author : 'Moxiecode Systems AB',
				authorurl : 'http://tinymce.moxiecode.com',
				infourl : 'http://wiki.moxiecode.com/index.php/TinyMCE:Plugins/advimage',
				version : tinymce.majorVersion + "." + tinymce.minorVersion
			};
		}
	});
	// Register plugin
	tinymce.PluginManager.add('advimagetoo', tinymce.plugins.AdvancedImageTooPlugin);
})();