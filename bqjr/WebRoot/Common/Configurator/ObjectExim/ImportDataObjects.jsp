<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.app.util.ObjectExim"%><%
	/*
		Content: �������ݶ���
	 */
	//�������
	String[] saObjects ;
	String sOldObjectType="";
	String sObjectType,sFileName;
	ObjectExim oe=null;
	
	//����������	
	String sObjectValue =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("column_selection"));
	String sRealPath =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FilePath"));
	if(sObjectValue==null) sObjectValue="";
	if(sRealPath==null) sRealPath="";
	sRealPath = sRealPath.trim();

	try{
		saObjects = StringFunction.toStringArray(sObjectValue,"\r\n");
		for(int i=0;i<saObjects.length-1;i++){
			sFileName=saObjects[i];
			sObjectType=StringFunction.getSeparate(sFileName,"_",1);
			if( sObjectType == "" || sFileName == "" )
				throw new Exception("��Ϣ���岻������ObjectType["+sObjectType+"]-FileName["+sFileName+"]");
			if( !sObjectType.equals(sOldObjectType) ){
				sOldObjectType = sObjectType;
				System.out.println("New ObjectExim:"+sObjectType);
				oe = new ObjectExim(Sqlca,sObjectType,sRealPath);
			}
			//oe.setSDefaultSchema("INFORMIX");
			System.out.println("Import DataObject--"+sObjectType+"-"+sFileName);
			oe.importFromXml(Sqlca,sFileName);
		}
		System.out.println("Import is ok.............");
		%>
		<script type="text/javascript">
		self.returnValue="succeeded";
		alert("���ݵ���ɹ���");
		self.close();
		</script>
		<%
	}catch(Exception ex){
		out.println("���ݵ���ʧ��!����:"+ex.toString());
		%>
		<script type="text/javascript">
		self.returnValue="failed";
		</script>
		<%
	}
%><%@ include file="/IncludeEnd.jsp"%>