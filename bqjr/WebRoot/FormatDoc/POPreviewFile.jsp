<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xdhou  2005.02.25
		Tester:
		Content: �鿴���ɵĵ��鱨���ļ�
		Input Param:
			DocID:    formatdoc_catalog�е��ĵ���𣨵��鱨�棬�����鱨�棬...)
			ObjectNo��ҵ����ˮ��
		Output param:
		History Log: cdeng 2009-02-12 �޸Ļ�ȡ�ĵ��洢·����ʽ
	 */
	%>
<%/*~END~*/%>

<%
	//����������	
	String sEncryptSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("EncryptSerialNo"));
	String sFrameName = DataConvert.toRealString(iPostChange,(String)request.getParameter("FrameName"));
	//	���ҳ�����	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 		//ҵ����ˮ��
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")); 	//��������
	String sTimeOut = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TimeOut")); 	//��������
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sFrameName==null) sFrameName = "_self";
	if(sTimeOut==null) sTimeOut = "";	//����˲�����Ҫ���ģ̬�����д򿪳��ֳ�ʱ����

    //cdeng 2009-02-12 ��ȡ�ĵ��洢·����ʽ
	ASResultSet rs = null;
	String sSql1="",sFileName="";
	sSql1=" select SerialNo,SavePath from Formatdoc_Record where ObjectType='"+sObjectType+"' and  ObjectNo='"+sObjectNo+"' ";
	rs = Sqlca.getASResultSet(sSql1);
	if(rs.next()){
		sFileName = rs.getString("SavePath");
	}
	rs.getStatement().close();
	if(sFileName==null) sFileName="";
	
	java.io.File file = new java.io.File(sFileName);
	if(file.exists()){
%> 
		<html>
		<head>
			<title>���鱨��</title>		
			<script type="text/javascript">
				function mykd1()
				{
					//F3:F5:F11:FullScreen
					if(event.keyCode==114 || event.keyCode==116 || event.keyCode==122 || (event.keyCode==78 && event.ctrlKey) ) 	 
					{
						event.keyCode=0; 
						event.returnValue=false; 
						return false;
					}
				}
			</script>	
		</head>
		<body onkeydown=mykd1 >
<%
		if(!sFrameName.equals("_self")){
	    java.io.FileInputStream inStream=new java.io.FileInputStream(file);  
	    StringBuffer sTemp=new StringBuffer();  
	    byte[]  buffer =new  byte[144400];    
	    int length=0;
	    int bytesum=0;
	    int byteread=0;
      while ((byteread=inStream.read(buffer))!=-1)
				sTemp.append(new String(buffer,0,byteread,"GBK"));
			        //sTemp.append(new String(buffer,"GBK"));
		 		inStream.close();    
				String sReportData = sTemp.toString();
				sReportData = StringFunction.replace(sReportData,"<object ID='WebBrowser1' WIDTH=0 HEIGHT=0 border=1  style=\"display:none\" CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2' > </object> <input type=button value='��ӡ����' onclick=\"WebBrowser1.ExecWB(8,1)\"> <input type=button value='��ӡԤ��' onclick=\"WebBrowser1.ExecWB(7,1)\"> <input type=button value='��ӡ' onclick=\"WebBrowser1.ExecWB(6,1)\"> <input type=button value='���Ϊ' onclick=\"WebBrowser1.ExecWB(4,1)\"> <input type=button value='�ر�' onclick=\"WebBrowser1.ExecWB(45,1)\">","");
				sReportData = StringFunction.replace(sReportData,"try {	document.oncontextmenu=Function(\"return false;\"); } catch(e) {var a=1;}","");
				out.println("<textarea name='describe1' style='width:100%; height:100%' >"+sReportData+"</textarea>");
		}
%>	 
</body>
</html>
<script type="text/javascript">
	try {	document.body.onkeydown=mykd1; } catch(e) {var a=1;}
	try {	document.onkeydown=mykd1; } catch(e) {var a=1;}
</script>	
<% if(sFrameName.equals("_self")){	%>
		<form name=form1 method=post target="<%=sFrameName%>" action=<%=sWebRootPath%>/servlet/view/file >
			<div style="display:none">
				<input name=filename value="<%=sFileName%>">
				<input name=contenttype value="text/html">
				<input name=viewtype value="view">		
			</div>
		</form>
		<script type="text/javascript">
<%		if(sTimeOut.equals("1")){	%>
				//add by syang 2009/11/11
				//������ô�ҳ����ϲ㴰����һ��ģ̬���ڣ���ҳ�治����OpenPage����ʽ�򿪣�ֻ����PopPage����ʽ�򿪣���������session��ʧ����
				OpenPage("/servlet/view/file?filename=<%=sFileName%>&contenttype=text/html&viewtype=view","_self","width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,");
				self.close();
<%		}else{	%>
				//modify in 2008/04/10,2008/02/21
				form1.submit();
<%		}	%>
</script>
<%	}else{%>
<script type="text/javascript">
	var sss = document.all('describe1').value;	
	 document.all('describe1').value = sss.replace(/<input type=\'hidden\' name=\'(.+?)\' value=\'(.+?)\'>/g,"");
	/*
	document.all('describe1').value = document.all('describe1').value.replace(/<input type='hidden' name='PageClientID' value='(.*)'>/g,"");
	document.all('describe1').value = document.all('describe1').value.replace(/<input type='hidden' name='CompClientID' value='(.*)'>/g,"");
	document.all('describe1').value = document.all('describe1').value.replace(/<input type='hidden' name='Rand' value='(.*)'>/g,"");
	document.all('describe1').value = document.all('describe1').value.replace(/<input type='hidden' name='ObjectType' value='(.*)'>/g,"");
	document.all('describe1').value = document.all('describe1').value.replace(/<input type='hidden' name='ObjectNo' value='(.*)'>/g,"");
	document.all('describe1').value = document.all('describe1').value.replace(/<input type='hidden' name='SerialNo' value='(.*)'>/g,"");
	document.all('describe1').value = document.all('describe1').value.replace(/<input type='hidden' name='Method' value='(.*)'>/g,"");
	*/
	//alert(sss);
	var config = new Object();    
	config.toolbar = [];
	editor_generate('describe1',config);	

</script>
<%
		}		
	}else{
%>
<script type="text/javascript">
	self.close();
</script>
<%}%> 

<%@ include file="/IncludeEnd.jsp"%>