/**
 * @author Tatamae
 * @copyright Copyright © 2009, Tatemae.
 */
(function() {
	tinymce.create('tinymce.plugins.muckFlickr', {
		init : function(ed, url) {
			// Register commands
			ed.addCommand('muckFlickr', function() {
				var e = ed.selection.getNode();
				// Internal file object like a flash placeholder
				if (ed.dom.getAttrib(e, 'class').indexOf('mceItem') != -1)
					return;
				ed.windowManager.open({
					file : jQuery('#tiny_mce_flickr_path').val(),
					width : parseInt(jQuery('#tiny_mce_flickr_width').val()) + parseInt(ed.getLang('muckflickr.delta_width', 0)),
					height : parseInt(jQuery('#tiny_mce_flickr_height').val()) + parseInt(ed.getLang('muckflickr.delta_height', 0)),
					inline : 1
				}, {
					search_string : ed.selection.getContent({format : 'text'}),
					plugin_url : url
				});
			});
			// Register button
			ed.addButton('flickr', {
				title : 'Flickr',
				cmd : 'muckFlickr',
				image : '/images/tinymce/flickr.gif'
			});
		},
		getInfo : function() {
			return {
				longname : 'Flickr in muck',
				author : 'Tatemae',
				authorurl : 'http://Tatemae.com',
				version : tinymce.majorVersion + "." + tinymce.minorVersion
			};
		}
	});
	// Register plugin
	tinymce.PluginManager.add('muckflickr', tinymce.plugins.muckFlickr);
})();