<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>

<%
	//文档编号
	String sObjectNO = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	
	if (sObjectNO == null) sObjectNO = "";
	if (sTypeNo == null) sTypeNo = "";
	
    System.out.println(sObjectNO+"--------sDocNo文档编号-------"+sTypeNo);
    String path = request.getContextPath(); 
	String requestpath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	
	//定义数据库操作变量
	SqlObject so = null;
	String sSql = "";
	ASResultSet rs=null;
	String sDocumentID="";
	
	ArrayList<String> list = new ArrayList<String>();
	
	sSql=" select DocumentID from ECM_PAGE where TypeNo=:TypeNo and objecttype='FlowModel' and objectno=:ObjectNo ";
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

	 
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>
<body bgcolor="#D3D3D3">

<div style="overflow-x:hidden;overflow-y:scroll;width:100%;height:350px;"> 
<table align="center">
<%

while(rs.next()){
   	   sDocumentID = DataConvert.toString(rs.getString("DocumentID"));//
		//将空值转化成空字符串
		if(sDocumentID == null) {
			sDocumentID = "&nbsp;";
		}else{
			requestpath = sWebRootPath+"/servlet/ImageServlet?ImageId=";
			sDocumentID = requestpath + sDocumentID;
		}
%>
	<tr>
    	<td>
    		<input type="button" value='放大' onclick="javascript:big('page<%=sDocumentID%>')"/>
			<input type="button" value='缩小' onclick="javascript:small('page<%=sDocumentID%>')"/>
			<input type="button" value='旋转' onclick="javascript:change('page<%=sDocumentID%>')"/>
    	<br></td>     
	</tr>
    <tr>
    	<td>
			<img  id="page<%=sDocumentID%>"  src="<%=sDocumentID%>"  alt="2" style="width:420px;height:310px;"/><br>
       </td>
    </tr>
<%}
rs.getStatement().close();
%>
</table>
</div>

</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>