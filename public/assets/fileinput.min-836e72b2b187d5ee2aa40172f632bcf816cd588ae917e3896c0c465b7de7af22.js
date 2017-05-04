/*!
 * @copyright Copyright &copy; Kartik Visweswaran, Krajee.com, 2013
 * bootstrap-fileinput
 * For more JQuery Plugins visit http://plugins.krajee.com
 */
!function(e){var i='{preview}\n<div class="input-group {class}">\n   {caption}\n   <div class="input-group-btn">\n       {remove}\n       {upload}\n       {browse}\n   </div>\n</div>',t="{preview}\n{remove}\n{upload}\n{browse}\n",a='<div class="file-preview {class}">\n   <div class="file-preview-status text-center text-success"></div>\n   <div class="close fileinput-remove text-right">&times;</div>\n   <div class="file-preview-thumbnails"></div>\n   <div class="clearfix"></div></div>',n='<div class="form-control file-caption {class}">\n   <span class="glyphicon glyphicon-file"></span> <span class="file-caption-name"></span>\n</div>',l='<div id="{id}" class="modal fade">\n  <div class="modal-dialog modal-lg">\n    <div class="modal-content">\n      <div class="modal-header">\n        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>\n        <h3 class="modal-title">Detailed Preview <small>{title}</small></h3>\n      </div>\n      <div class="modal-body">\n        <textarea class="form-control" style="font-family:Monaco,Consolas,monospace; height: {height}px;" readonly>{body}</textarea>\n      </div>\n    </div>\n  </div>\n</div>\n',s=function(i,t){return null===i||void 0===i||i==[]||""===i||t&&""===e.trim(i)},r=function(e,i,t){return s(e)||s(e[i])?t:e[i]},o=function(e,i){return"undefined"!=typeof e?e.match("image.*"):i.match(/\.(gif|png|jpe?g)$/i)},p=function(e,i){return"undefined"!=typeof e?e.match("text.*"):i.match(/\.(txt|md|csv|htm|html|php|ini)$/i)},d=function(){return Math.round((new Date).getTime()+100*Math.random())},c=function(a,n){this.$element=e(a),this.showCaption=n.showCaption,this.showPreview=n.showPreview,this.showRemove=n.showRemove,this.showUpload=n.showUpload,this.captionClass=n.captionClass,this.previewClass=n.previewClass,this.mainClass=n.mainClass,s(n.mainTemplate)?this.mainTemplate=this.showCaption?i:t:this.mainTemplate=n.mainTemplate,this.previewTemplate=this.showPreview?n.previewTemplate:"",this.captionTemplate=n.captionTemplate,this.browseLabel=n.browseLabel,this.browseIcon=n.browseIcon,this.browseClass=n.browseClass,this.removeLabel=n.removeLabel,this.removeIcon=n.removeIcon,this.removeClass=n.removeClass,this.uploadLabel=n.uploadLabel,this.uploadIcon=n.uploadIcon,this.uploadClass=n.uploadClass,this.uploadUrl=n.uploadUrl,this.msgLoading=n.msgLoading,this.msgProgress=n.msgProgress,this.msgSelected=n.msgSelected,this.previewFileType=n.previewFileType,this.wrapTextLength=n.wrapTextLength,this.wrapIndicator=n.wrapIndicator,this.isDisabled=this.$element.attr("disabled")||this.$element.attr("readonly"),s(this.$element.attr("id"))&&this.$element.attr("id",d()),this.$container=this.createContainer(),this.$captionContainer=r(n,"elCaptionContainer",this.$container.find(".file-caption")),this.$caption=r(n,"elCaptionText",this.$container.find(".file-caption-name")),this.$previewContainer=r(n,"elPreviewContainer",this.$container.find(".file-preview")),this.$preview=r(n,"elPreviewImage",this.$container.find(".file-preview-thumbnails")),this.$previewStatus=r(n,"elPreviewStatus",this.$container.find(".file-preview-status")),this.$name=this.$element.attr("name")||n.name,this.$hidden=this.$container.find('input[type=hidden][name="'+this.$name+'"]'),0===this.$hidden.length&&(this.$hidden=e('<input type="hidden" />'),this.$container.prepend(this.$hidden)),this.original={preview:this.$preview.html(),hiddenVal:this.$hidden.val()},this.listen()};c.prototype={constructor:c,listen:function(){var i=this;i.$element.on("change",e.proxy(i.change,i)),e(i.$element[0].form).on("reset",e.proxy(i.reset,i)),i.$container.find(".fileinput-remove").on("click",e.proxy(i.clear,i))},trigger:function(e){var i=this;i.$element.trigger("click"),e.preventDefault()},clear:function(e){var i=this;e&&e.preventDefault(),i.$hidden.val(""),i.$hidden.attr("name",i.name),i.$element.attr("name",""),i.$element.val(""),e!==!1&&(i.$element.trigger("change"),i.$element.trigger("fileclear")),i.$preview.html(""),i.$caption.html(""),i.$container.removeClass("file-input-new").addClass("file-input-new")},reset:function(){var e=this;e.clear(!1),e.$hidden.val(e.original.hiddenVal),e.$preview.html(e.original.preview),e.$container.find(".fileinput-filename").text(""),e.$element.trigger("filereset")},change:function(e){var i,t=this,a=t.$element,n=a.get(0).files,s=n?n.length:1,r=a.val().replace(/\\/g,"/").replace(/.*\//,""),c=t.$preview,h=t.$previewContainer,m=t.$previewStatus,v=t.msgLoading,u=t.msgProgress,f=t.msgSelected,w=t.previewFileType,g=parseInt(t.wrapTextLength),b=t.wrapIndicator;if(i=void 0===e.target.files?e.target&&e.target.value?[{name:e.target.value.replace(/^.+\\/,"")}]:[]:e.target.files,0!==i.length){c.html("");for(var $=i.length,t=t,C=0;$>C;C++)!function(e){var i=e.name,t=o(e.type,e.name),a=p(e.type,e.name);if(c.length>0&&("any"==w?t||a:"text"==w?a:t)&&"undefined"!=typeof FileReader){var n=new FileReader;m.html(v),h.addClass("loading"),n.onload=function(e){var t="",n="";if(a){var s=e.target.result;if(s.length>g){var r=d(),o=.75*window.innerHeight,n=l.replace("{id}",r).replace("{title}",i).replace("{body}",s).replace("{height}",o);b=b.replace("{title}",i).replace("{dialog}","$('#"+r+"').modal('show')"),s=s.substring(0,g-1)+b}t='<div class="file-preview-frame"><div class="file-preview-text" title="'+i+'">'+s+"</div></div>"+n}else t='<div class="file-preview-frame"><img src="'+e.target.result+'" class="file-preview-image" title="'+i+'" alt="'+i+'"></div>';c.append("\n"+t),C>=$-1&&(h.removeClass("loading"),m.html(""))},n.onprogress=function(i){if(i.lengthComputable){var t=parseInt(i.loaded/i.total*100,10),a=u.replace("{percent}",t).replace("{file}",e.name);m.html(a)}},a?n.readAsText(e):n.readAsDataURL(e)}else c.append('\n<div class="file-preview-frame"><div class="file-preview-other"><h2><i class="glyphicon glyphicon-file"></i></h2>'+i+"</div></div>")}(i[C]);var y=s>1?f.replace("{n}",s):r;t.$caption.html(y),t.$container.removeClass("file-input-new"),a.trigger("fileselect",[s,r])}},createContainer:function(){var i=this,t=e(document.createElement("div")).attr({"class":"file-input file-input-new"}).html(i.renderMain());return i.$element.before(t),t.find(".btn-file").append(i.$element),t},renderMain:function(){var e=this,i=e.previewTemplate.replace("{class}",e.previewClass),t=e.isDisabled?e.captionClass+" file-caption-disabled":e.captionClass,a=e.captionTemplate.replace("{class}",t);return e.mainTemplate.replace("{class}",e.mainClass).replace("{preview}",i).replace("{caption}",a).replace("{upload}",e.renderUpload()).replace("{remove}",e.renderRemove()).replace("{browse}",e.renderBrowse())},renderBrowse:function(){var e=this,i=e.browseClass+" btn-file",t="";return e.isDisabled&&(t=" disabled "),'<div class="'+i+'"'+t+"> "+e.browseIcon+e.browseLabel+" </div>"},renderRemove:function(){var e=this,i=e.removeClass+" fileinput-remove fileinput-remove-button",t="";return e.showRemove?(e.isDisabled&&(t=" disabled "),'<button type="button" class="'+i+'"'+t+">"+e.removeIcon+e.removeLabel+"</button>"):""},renderUpload:function(){var e=this,i="",t="";return e.showUpload?(e.isDisabled&&(t=" disabled "),i=s(e.uploadUrl)?'<button type="submit" class="'+e.uploadClass+'"'+t+">"+e.uploadIcon+e.uploadLabel+"</button>":'<a href="'+e.uploadUrl+'" class="'+e.uploadClass+'"'+t+">"+e.uploadIcon+e.uploadLabel+"</a>"):""}},e.fn.fileinput=function(i){return this.each(function(){var t=e(this),a=t.data("fileinput");a||t.data("fileinput",a=new c(this,i)),"string"==typeof i&&a[i]()})},e.fn.fileinput=function(i){var t=Array.apply(null,arguments);return t.shift(),this.each(function(){var a=e(this),n=a.data("fileinput"),l="object"==typeof i&&i;n||a.data("fileinput",n=new c(this,e.extend({},e.fn.fileinput.defaults,l,e(this).data()))),"string"==typeof i&&n[i].apply(n,t)})},e.fn.fileinput.defaults={showCaption:!0,showPreview:!0,showRemove:!0,showUpload:!0,captionClass:"",previewClass:"",mainClass:"",mainTemplate:null,previewTemplate:a,captionTemplate:n,browseLabel:"Browse &hellip;",browseIcon:'<i class="glyphicon glyphicon-folder-open"></i> &nbsp;',browseClass:"btn btn-primary",removeLabel:"Remove",removeIcon:'<i class="glyphicon glyphicon-ban-circle"></i> ',removeClass:"btn btn-default",uploadLabel:"Upload",uploadIcon:'<i class="glyphicon glyphicon-upload"></i> ',uploadClass:"btn btn-default",uploadUrl:null,msgLoading:"Loading &hellip;",msgProgress:"Loaded {percent}% of {file}",msgSelected:"{n} files selected",previewFileType:"image",wrapTextLength:250,wrapIndicator:' <span class="wrap-indicator" title="{title}" onclick="{dialog}">[&hellip;]</span>',elCaptionContainer:null,elCaptionText:null,elPreviewContainer:null,elPreviewImage:null,elPreviewStatus:null},e(function(){var i=e("input.file[type=file]");i.length>0&&i.fileinput()})}(window.jQuery);