<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>

<%
	//文档编号
	String sObjectNO = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	String sRightType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	List<String> imageList = new ArrayList<String>();
	if (sObjectNO == null) sObjectNO = "";
	if (sTypeNo == null) sTypeNo = "";
	
    System.out.println(sObjectNO+"--------sDocNo文档编号-------"+sTypeNo);
    System.out.println(sObjectNO+"--------sRightType是否可修改-------"+sRightType);
    String path = request.getContextPath(); 
	String requestpath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	
	//定义数据库操作变量
	SqlObject so = null;
	String sSql = "";
	ASResultSet rs=null;
	String sDocumentID="";
	String documentid=""; //文件路径（删除使用）
	
	ArrayList<String> list = new ArrayList<String>();
	
	sSql=" select DocumentID from ECM_PAGE where TypeNo=:TypeNo and objecttype='Business' and objectno=:ObjectNo ";
	so = new SqlObject(sSql).setParameter("TypeNo", sTypeNo).setParameter("ObjectNo",sObjectNO);
    rs=Sqlca.getASResultSet(so);
    /* while(rs.next()){
   	   sDocumentID = DataConvert.toString(rs.getString("DocumentID"));//
		//将空值转化成空字符串
		if(sDocumentID == null) sDocumentID = "";
		list.add(sDocumentID);
    }
    rs.getStatement().close(); */
    
	/* for(int i=0;i<list.size();i++){
		 String str = list.get(i);
		 System.out.println("--------list-------"+str);
		 
		
	} */
	

%>
<html>
<head> 
<title>请输入附件信息</title>
<script type="text/javascript" src="Frame/resources/js/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="Frame/resources/js/js/artZoom.js"></script>
<script type="text/javascript">jQuery('a.artZoom').artZoom();</script>
<style type="text/css">
.divcss5{ border:1px solid #F00; width:420px; height:310px}
img { border:0 none; width: 420px; height: 310px;}
#idContainer{border:1px solid 0000;width:420px; height:310px; background:#FFF center no-repeat;}

</style>
<script type="text/javascript">
	function checkItems(){
		var o = document.forms["SelectAttachment"];
		var sFileName = o.AttachmentFileName.value;
		o.FileName.value=sFileName;
		
		if (typeof(sFileName) == "undefined" || sFileName==""){
			alert("请选择一个文件名!");
			return false;
		}

		return true;
	}	   

</script>
<!-- 添加图片放大缩小功能 -->
<script type="text/javascript">
	
		var zoom = 1.2; // 缩放率
		function big(img){
			var img =  document.getElementById(img);
			var width = img.scrollWidth;
			var height = img.scrollHeight;
			img.style.width=parseInt(width)*zoom+"px";
			img.style.height=parseInt(height)*zoom+"px";
		}
		function small(img){
			var img =  document.getElementById(img);
			var width = img.scrollWidth;
			var height = img.scrollHeight;
			img.style.width=parseInt(width)/zoom+"px";
			img.style.height=parseInt(height)/zoom+"px";
		}
		var num = 0; 
		function change(img){ 
			num = (num + 1) % 4; 
			document.getElementById(img).style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(rotation='+num+')'; 
		}

	/**
	 * 页面初始化事件
	 */
	window.onload = function() {
		
		if('<%=sRightType%>' == "ReadOnly"){
			jQuery('#delButt').hide();//隐藏按钮
		}
	}

	/**
	 * 鼠标滚动
	 */
	function MW(picObj) {
		if (event.wheelDelta >= 120)
			resize(picObj.id, 1);
		else if (event.wheelDelta <= -120)
			resize(picObj.id, -1);
	}
	
	/**
	 * 删除按钮
	 */
	function deleteButt(documentid) {
		if (confirm("你确认删除此文件吗？")){
			RunMethod("公用方法", "DelByWhereClause", "ECM_PAGE,objectno='"
					+ <%=sObjectNO%> + "' and documentid='"+ documentid + "'");
			alert("删除成功");
			location.replace(location.href);
		}
		
	}
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>
<body bgcolor="#D3D3D3" onload="myfunction()">

<div style="overflow-x:hidden;overflow-y:scroll;width:100%;height:350px;"> 
<table align="center">
<%
int i = 1;
while(rs.next()){
	sDocumentID = DataConvert.toString(rs.getString("DocumentID"));//
	documentid = sDocumentID;
	//将空值转化成空字符串
	if(sDocumentID == null) {
	sDocumentID = "&nbsp;";
	}else{
		requestpath = sWebRootPath+"/servlet/ImageServlet?ImageId=";
		sDocumentID = requestpath + sDocumentID;
		System.out.println("--------------------sDocumentID:" + sDocumentID);
	}
%>
	<tr>
    	<td>
    		<input type="button" value='放大' onclick="javascript:big('page<%=i%>')"/>
			<input type="button" value='缩小' onclick="javascript:small('page<%=i%>')"/>
			<input type="button" value='旋转' onclick="javascript:change('page<%=i%>')"/>
			<input id="delButt" type="button" value="删除" onclick="deleteButt('<%=documentid%>');" /> 
			<br>
		</td>     
	</tr>
    <tr>
    	<td>
			<a class="miniImg artZoom"  rel="<%=sDocumentID%>"><img id="page<%=i%>" src="<%=sDocumentID%>" alt="<%=i%>" style="width:420px;height:310px;"/></a>
			<br>
       </td>
    </tr>
<%
i++;
}
rs.getStatement().close();
%>
</table>
</div>

</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>