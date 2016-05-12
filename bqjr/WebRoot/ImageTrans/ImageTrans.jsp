<%@page import="java.net.URLEncoder"%>
<%@page import="com.amarsoft.app.contentmanage.action.ContentManagerAction"%>
<%@page import="com.amarsoft.app.als.image.ImageAuthManage"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
//获得组件参数	,影像对象号（客户号或申请号）、影像类型号
String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));

//查找对应的docId, 放进list
	ASResultSet resultSet= Sqlca.getResultSet(
			new SqlObject("select  documentId  from  ECM_PAGE where objectType=:objectType and objectNo=:objectNo and typeNo=:typeNo and documentId is not null and length(documentId)>0 order by pageNum")
				.setParameter("objectType", sObjectType).setParameter("objectNo", sObjectNo).setParameter("typeNo", sTypeNo)
	);
	ArrayList<String> list = new ArrayList<String>();
	while(resultSet.next()){
		list.add(resultSet.getString("documentId"));
	}
	
	resultSet.getStatement().close();
	
	ARE.getLog().trace(list);
	//缩略图列表html
	String htmlStr = "";
	for(int i=0; i<list.size(); i++){
		htmlStr = htmlStr+"<div class='thumbnail_unit'>"+
				"<div class='title'>第"+(i+1)+"页</div>"+
		"<div class='info' style='display: none;'>"+ContentManagerAction.getContentManager().get(list.get(i)).getDesc()+"</div>"+
				"<div class='content'><img style='width:206px ' src='"+sWebRootPath +"/servlet/ContentServlet?Id="+URLEncoder.encode(list.get(i),"utf-8")+"' ></img></div>"+ 
				"</div>";
	}
	
	%>
	
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>图片变换效果</title>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/ImageTrans/img.css"/>
<script>
$(document).ready(function(){
	$('#idInitialSize').click(function(){
		var size = document.getElementById('img_size').innerHTML;
		var sizes = size.split('X');
		$('#idContainer img').css({'width':Number(sizes[0])*2,'height':Number(sizes[1])*2});
		
	});
	$('#thumbnail_img .content').click(function(){
		var unit =  $(this).parent();
		unit.siblings('.focus').removeClass('focus');
		unit.addClass('focus');
		src = $(this).find('img').attr('src');
		it.dispose();
		it = new ImageTrans( container, options );
		it.load(src);
		$('#idContainer_root .bar').html(unit.find('.title').html());
		$('#img_info').html(unit.find('.info').html());
		AddMouseMoveEvent();
	});
	AddMouseMoveEvent();
	function AddMouseMoveEvent(){
		var img =$('#idContainer img');
		var width = img[0].scrollWidth;
		var height = img[0].scrollHeight;
		document.getElementById('img_size').innerHTML = width+"X"+height;
		$('#idContainer img').bind('mousemove',function(e){
			var obj = $(this).offset();
			var x= e.clientX;
			var y= e.clientY;
			var left = obj.left;
			var top = obj.top;
			x= x - left;
			y= y - top  +(document.all?93:0);
			$('#size_x').html('X:'+x);
			$('#size_y').html('Y:'+y);
		});
	}
});
</script>
<script type="text/javascript" src="<%=sWebRootPath%>/ImageTrans/CJL.0.1.min.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/ImageTrans/ImageTrans.js"></script>
</head>
<body>
<table style="height:100%;width:100%;border:0;" cellpadding="0">
<tr>
	<td colspan="2"><div id="menu"><div id="menu_2">
		<a id="idLeft"><span></span>左转90°</a>
		<a id="idRight"><span></span>右转90°</a>
		<a id="idVertical"><span></span>垂直翻转</a>
		<a id="idHorizontal"><span></span>水平翻转</a>
		<a id="idReset"><span></span>重置</a>
<!--		<span id="idCanvas">使用Canvas</span>-->
		<a id="idAutoFitWidth"><span></span>最适宽度</a>
		<a id="idFullPage"><span></span>整页显示</a>
		<a id="idInitialSize"><span></span>原始大小</a>
		<!-- <a id="idUp"><span></span>上移</a>
		<a id="idDown"><span></span>下移</a>
		<a id="idSetFirstPage"><span></span>设置成第一页</a>
		<a id="idSetLastPage"><span></span>设置成最后一页</a> -->
	</div></div></td>
</tr>
<tr>
	<td style="height:100%;width:100%;"><div id="idContainer_root" style="position:relative;">
		<table style="height:100%;width:100%;border:0;float:left;border:1px solid #C2C4CB;border-radius:3px 3px 0" cellpadding="0">
			<tr><td><div class="bar">第1页</div></td></tr>
			<tr><td style="height:100%;"><div id="idContainer"></div></td></tr>
		</table>
	</div></td>
	<td style="width:230px;height:100%;"><div id="thumbnail">
		<table style="height:100%;width:100%;border:0;float:left;border:1px solid #C2C4CB;border-radius:3px 3px 0" cellpadding="0">
		<tr><td><div class="bar" style="color:#9EA1AE;font-weight:bold;padding-left:5px;">缩略图列表</div></td></tr>
		<tr><td style="height:100%;"><div style="height:100%;width:100%;min-height:450px;position:relative;">
			<div id="thumbnail_img"></div>
		</div></td></tr>
		</table>
	</div></td>
</tr>
<tr>
	<td colspan="2">
	<div>
	<span>图片信息：<label id="img_info"></label></span>
	</div>
	<div id="bottom">
		<span>图像大小：<label id="img_size"></label></span>
		<span><label id="size_x">X:0</label>,<label id="size_y">Y:0</label></span>
	</div>
	</td>
</tr>
</table>
	
<script>
	$("#thumbnail_img").append("<%=htmlStr%>");

var container = $$("idContainer"), 
	src = '<%=list.size()>0? sWebRootPath +"/servlet/ContentServlet?Id="+URLEncoder.encode(list.get(0), "utf-8"): sWebRootPath+"/ImageTrans/1.jpg" %>',
	options = {
		onPreLoad: function(){ container.style.backgroundImage = ""; },
		onLoad: function(){ container.style.backgroundImage = ""; },
		onError: function(err){ container.style.backgroundImage = ""; alert(err); }
	},
	it = new ImageTrans( container, options );
	it.load(src);
	//如果有图片，默认显示第1页的图片信息
	var firstImgInfo = $(".info:first");
	if(firstImgInfo.length>0){
		$("#img_info").html(firstImgInfo.html());
	}
	//垂直翻转
	$$("idVertical").onclick = function(){ it.vertical(); }
	//水平翻转
	$$("idHorizontal").onclick = function(){ it.horizontal(); }
	//左旋转
	$$("idLeft").onclick = function(){ it.left(); }
	//右旋转
	$$("idRight").onclick = function(){ it.right(); }
	//重置
	$$("idReset").onclick = function(){ it.reset(); }
	
</script>	
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>