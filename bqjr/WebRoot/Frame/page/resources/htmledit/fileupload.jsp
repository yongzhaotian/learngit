<%@ page contentType="text/html; charset=GBK" import="com.amarsoft.awe.common.attachment.*"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sAttachmentNo="";
    String sSerialNo=  ""; //(String)request.getParameter("SerialNo");
    String sFileName = "",sFileExt = "";
		
    AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
	myAmarsoftUpload.initialize(pageContext);              
	myAmarsoftUpload.upload();                                      
	if (!myAmarsoftUpload.getFiles().getFile(0).isMissing()){
		try {
			String sBasePath = CurConfig.getConfigure("FileSavePath");
			//���ݵ�ǰ���ڴ����ļ���
			String sToday = StringFunction.getToday();
			java.io.File file = new java.io.File(sBasePath+ "/" + sToday.substring(0,4));
			if(!file.exists()){
				//ʹ��try���Ƿ�ֹ�������ظ������ļ���
				try{
					file.mkdir();
				}
				catch(Exception ex){}
			}
			file = new java.io.File(sBasePath+ "/" + sToday.substring(0,7));
			if(!file.exists()){
				//ʹ��try���Ƿ�ֹ�������ظ������ļ���
				try{
					file.mkdir();
				}
				catch(Exception ex){}
			}
			file = new java.io.File(sBasePath+ "/" + sToday);
			if(!file.exists()){
				//ʹ��try���Ƿ�ֹ�������ظ������ļ���
				try{
					file.mkdir();
				}
				catch(Exception ex){}
			}
			sBasePath += "/" + sToday;
			sFileName = myAmarsoftUpload.getFiles().getFile(0).getFilePathName();
			int iPos = sFileName.lastIndexOf(".");
			if(iPos == -1) 
				sFileExt = ".gif";
			else
				sFileExt = sFileName.substring(iPos);
			String sRand1 = String.valueOf(Math.random());
			sRand1  = sRand1.substring(sRand1.lastIndexOf(".")+1);
			String sRand2 = String.valueOf(Math.random());
			sRand2  = sRand1.substring(sRand2.lastIndexOf(".")+1);
			String sRand = sRand1 + "-" + sRand2;
			sFileName = sBasePath + "/"+sSerialNo+sRand+sFileExt;
			myAmarsoftUpload.getFiles().getFile(0).saveAs(sFileName);
			myAmarsoftUpload = null;			
		}catch(Exception e){
			System.out.println("An error occurs : " + e.toString());				
			myAmarsoftUpload = null;
%>			
			<script type="text/javascript">
				//alert("�ϴ�ʧ�ܣ�");
				parent.bFileUploaded = false;
			</script>
<%
		}			
	}
%>

<script type="text/javascript">
	//alert("�ϴ��ɹ���");
	parent.bFileUploaded = true;
	parent.sFileName = "<%=sFileName%>";
	eval(parent.btnOKClick_2());
</script>
<%@ include file="/IncludeEnd.jsp"%>