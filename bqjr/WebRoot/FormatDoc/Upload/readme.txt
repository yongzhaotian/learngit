1、请在FormatDoc目录下建立一个Upload目录

2、请将editor1.js与FileUpload.jsp放入 Resources\1\HtmlEdit 目录下

3、请将insert_image.html放入 Resources\1\HtmlEdi\popups 目录下

4、注意：Resources\CodeParts\Preview01.jsp 的第42行

	try {	//document.oncontextmenu=Function("return false;"); } catch(e) {var a=1;}

   是有问题的，要改为：

	try {	/*document.oncontextmenu=Function("return false;");*/ } catch(e) {var a=1;}
