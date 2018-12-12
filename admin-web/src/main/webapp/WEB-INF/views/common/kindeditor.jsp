<link rel="stylesheet" type="text/css" href="theme/kindeditor/themes/default/default.css" />
<link rel="stylesheet" type="text/css" href="theme/kindeditor/plugins/code/prettify.css" />
<script type="text/javascript" charset="utf-8" src="theme/kindeditor/kindeditor.js"></script>
<script type="text/javascript" charset="utf-8" src="theme/kindeditor/lang/zh_CN.js"></script>
<script type="text/javascript" charset="utf-8" src="theme/kindeditor/plugins/code/prettify.js"></script>
<script type="text/javascript">


	function createKindEditor(name){
		KindEditor.ready(function(K) {
			var editor = K.create(name, {
				cssPath : 'theme/kindeditor/plugins/code/prettify.css',
				uploadJson : 'file/fileUpload', //上传
				afterCreate : function() {
					this.sync();
				},
				afterBlur: function() {
					this.sync();
				}
			});
			prettyPrint();
		});
	}
</script>
