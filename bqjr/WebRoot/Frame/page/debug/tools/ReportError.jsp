<%@page import="java.io.FileOutputStream"%>
<%@ page contentType="text/html; charset=GBK" import="com.amarsoft.awe.common.attachment.*,com.amarsoft.are.jbo.*"%><%@
include file="/Frame/resources/include/include_begin.jspf"
%><%
	String sAttachmentNo="";
    String sSerialNo=  "";
    String sFileName = "",sFileExt = ".jpg";
		
    String sImageData = request.getParameter("imgdata");
    if(sImageData==null) sImageData = "";
	String sErrorDesc = request.getParameter("taError");
	String errorTitle = "�޷���ý�ͼ���ݣ��ύʧ�ܣ�";
	String sDono = request.getParameter("dono");
	if(sDono==null)sDono="";
	String sUrl = request.getParameter("url");
	if(sUrl==null)sUrl="";
	String sDomain = request.getParameter("domain");
	if(sDomain ==null)sDomain = "";
	//System.out.println("sErrorDesc=" + sErrorDesc);
	if(sImageData.length()>0){
		try 
		{
			String sBasePath = CurConfig.getConfigure("SnapShot");
			//������Ŀ¼�򴴽�
			java.io.File fileSS = new java.io.File(sBasePath);
			if(fileSS.exists()==false)fileSS.mkdirs();
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
			
			String sRand1 = String.valueOf(Math.random());
			sRand1  = sRand1.substring(sRand1.lastIndexOf(".")+1);
			String sRand2 = String.valueOf(Math.random());
			sRand2  = sRand1.substring(sRand2.lastIndexOf(".")+1);
			String sRand = sRand1 + "-" + sRand2;
			sFileName = sBasePath + "/"+sSerialNo+sRand+sFileExt;
			//�����ļ�
			
			byte[] bImageData = new byte[sImageData.length()/2];
			for(int i=0;i<sImageData.length();i+=2){
				bImageData[i/2] = Integer.valueOf(sImageData.substring(i,i+2),16).byteValue();
			}
			
			//byte[] bImageData = ObjectConverts.getBytes(sImageData);
			FileOutputStream fos = new FileOutputStream(sFileName);
			fos.write(bImageData);
			fos.close();
		} 
		catch(Exception e) 
		{
			e.printStackTrace();
			ARE.getLog().error("An error occurs : " + e.toString());
			//System.out.println("An error occurs : " + e.toString());				
	%>			
			<script type="text/javascript">
				alert("<%=errorTitle%>");
				//parent.bFileUploaded = false;
			</script>
	<%
			return;
		}	
	}
	
	//���浽���ݿ�
	try{
		BizObjectManager manager = JBOFactory.getFactory().getManager("jbo.awe.AWE_ERROR_REPORT");
		BizObject bo = manager.newObject();
		bo.setAttributeValue("REPORTDESC",sErrorDesc);
		bo.setAttributeValue("REPORTPIC",sFileName);
		bo.setAttributeValue("INPUTTIME",StringFunction.getTodayNow());
		bo.setAttributeValue("INPUTUSER",CurUser.getUserID());
		bo.setAttributeValue("REPORTDOMAIN",sDomain);
		bo.setAttributeValue("DONO",sDono);
		bo.setAttributeValue("URL",sUrl);
		bo.setAttributeValue("status",0);
		manager.saveObject(bo);
%>
		<script>
			alert('�ύ�ɹ���');
			parent.AsDebug.closeErrorWindow();
		</script>
<%
	}
	catch(Exception ex){
		ex.printStackTrace();
		ARE.getLog().error("�ύ���󱨸����"+ ex.toString());
		%>
		<script>
			alert('ϵͳ�����ύʧ�ܣ�����ϵ����Ա��');
		</script>
		<%
	}
%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>