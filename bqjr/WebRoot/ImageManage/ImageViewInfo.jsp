<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>

<%
	//�ĵ����
	String sObjectNO = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	if(sTypeNo==null){
		sTypeNo = request.getParameter("TypeNo");
	}
	//��ȡ�жϴ�ǰ���Ǵ�������ݲ���
	String uploadPeriod = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("uploadPeriod"));
	if(uploadPeriod==null){
		uploadPeriod = request.getParameter("uploadPeriod");
	}
	List<String> imageList = new ArrayList<String>();
	if (sObjectNO == null) sObjectNO = "";
	if (sTypeNo == null) sTypeNo = "";
	if (uploadPeriod == null) uploadPeriod = "";
	
    System.out.println(sObjectNO+"--------sDocNo�ĵ����-------"+sTypeNo);
    String path = request.getContextPath(); 
	String requestpath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	
	//�������ݿ��������
	SqlObject so = null;
	String sSql = "";
	ASResultSet rs=null;
	String sDocumentID="";
	
	ArrayList<String> list = new ArrayList<String>();
	
	//���ݴ�ǰ����״̬�����ò�ѯ����
	//	sSql=" select DocumentID from ECM_PAGE where TypeNo=:TypeNo and objecttype='Business' and objectno=:ObjectNo ";
	if("1".equals(uploadPeriod)){
		//��������
		sSql=" select DocumentID from ECM_PAGE where TypeNo=:TypeNo and objecttype='BusinessLoan' and objectno=:ObjectNo order by modifyTime desc ";
		so = new SqlObject(sSql).setParameter("TypeNo", sTypeNo).setParameter("ObjectNo",sObjectNO);
	}else if("2".equals(uploadPeriod)){
		sSql=" select DocumentID from ECM_PAGE where TypeNo=:TypeNo and objectno=:ObjectNo  order by modifyTime desc ";
		so = new SqlObject(sSql).setParameter("TypeNo", sTypeNo).setParameter("ObjectNo",sObjectNO);
	}else{
		//��ǰ����
		sSql=" select DocumentID from ECM_PAGE where TypeNo=:TypeNo and objecttype='Business' and objectno=:ObjectNo  order by modifyTime desc ";
		so = new SqlObject(sSql).setParameter("TypeNo", sTypeNo).setParameter("ObjectNo",sObjectNO);
	}
    rs=Sqlca.getASResultSet(so);
    /* while(rs.next()){
   	   sDocumentID = DataConvert.toString(rs.getString("DocumentID"));//
		//����ֵת���ɿ��ַ���
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
<title>�����븽����Ϣ</title>
<script type="text/javascript" src="../Frame/resources/js/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="../Frame/resources/js/js/artZoom.js"></script>
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
			alert("��ѡ��һ���ļ���!");
			return false;
		}

		return true;
	}	   

</script>
<!-- ���ͼƬ�Ŵ���С���� -->
<script type="text/javascript">

	var zoom = 1.2; // ������
    function big(i){
		var img =  document.getElementById("img"+i);
		var width = img.scrollWidth;
		var height = img.scrollHeight;
		img.style.width=parseInt(width)*zoom+"px";
		img.style.height=parseInt(height)*zoom+"px";
    }
    function small(i){
		var img =  document.getElementById("img"+i);
		var width = img.scrollWidth;
		var height = img.scrollHeight;
		img.style.width=parseInt(width)/zoom+"px";
		img.style.height=parseInt(height)/zoom+"px";
    }
	var num = 0; 
	function change(i){ 
		num = (num + 1) % 4; 
		document.getElementById('img'+i).style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(rotation='+num+')'; 
	}
	// ɾ��ͼƬ CCS-1103��PRM-637pc������ʱ�ϴ�Ӱ�����ϴ�����ɾ�����ܣ�
	function delImg(docId) {
		if (confirm("��ȷ��ɾ�����ļ���")){
			var rs = RunJavaMethodSqlca("com.amarsoft.app.billions.ImageViewInfoDEL", "imageViewInfoDel", "objectno=<%=sObjectNO%>,docId=" + docId);
			if (rs == 'Success') {
				alert("ɾ���ɹ�");
				location.href=location.href;
			}else{
				alert("ɾ��ʧ��");
			}
			
			// RunMethod("���÷���", "DelByWhereClause", "ECM_PAGE,objectno='<%=sObjectNO%>' and documentid='"+ docId + "'");
			// alert("ɾ���ɹ�");
			// location.href=location.href;
		}
	}
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>
<body bgcolor="#D3D3D3">

<div style="overflow-x:hidden;overflow-y:scroll;width:100%;height:400px;"> 
<table align="center">
<%
	int i=0;
	while(rs.next()){
   	   sDocumentID = DataConvert.toString(rs.getString("DocumentID"));//
		//����ֵת���ɿ��ַ���
		if(sDocumentID == null) {
			sDocumentID = "&nbsp;";
		}else{
			requestpath = sWebRootPath+"/servlet/ImageServlet?ImageId=";
			sDocumentID = requestpath + sDocumentID;
			i++;
			
		}
%>
	<tr>
    	<td>
    		<input type="button" value='�Ŵ�' onclick="javascript:big(<%=i%>)"/>
			<input type="button" value='��С' onclick="javascript:small(<%=i%>)"/>
			<input type="button" value='��ת' onclick="javascript:change(<%=i%>)"/>
			
			<!-- ɾ��ͼƬ CCS-1103��PRM-637pc������ʱ�ϴ�Ӱ�����ϴ�����ɾ�����ܣ� -->
			<input type="button" value='ɾ��' onclick="javascript:delImg('<%=DataConvert.toString(rs.getString("DocumentID"))%>')"/>
		<br></td>     
	</tr>
    <tr>
    	<td>
			<a class="miniImg artZoom" href="<%=sDocumentID%>" rel="<%=sDocumentID%>"><img  id="img<%=i%>"  src="<%=sDocumentID%>"  alt="2" style="width:420px;height:310px;"/></a>
			
			
			<br>
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