<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.app.util.ObjectExim"%><%
	/*
		Content: �������ݶ���
	 */
	//�������
	String[] saObjects ;
	String sOldObjectType="";
	String sObjectType,sObjectNo;
	ObjectExim oe=null;
	
	//����������	
	String sObjectValue =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("column_selection"));
	String sRealPath =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FilePath"));
	if(sObjectValue==null) sObjectValue="";
	if(sRealPath==null) sRealPath="";
	sRealPath = sRealPath.trim();
	
	//��������ԡ�\���������Զ�����
	if(sRealPath.length()>1 && !sRealPath.substring(sRealPath.length()-1).equals(Configure.sCurSlash)){
		sRealPath = sRealPath + Configure.sCurSlash;
	}
	
	try{
		saObjects = StringFunction.toStringArray(sObjectValue,"\r\n");
		Vector errors = new Vector();
		for(int i=0;i<saObjects.length-1;i++){
			try{
				sObjectType=StringFunction.getSeparate(saObjects[i],".",1);
				sObjectNo=StringFunction.getSeparate(saObjects[i],".",2);
				if(sObjectType.indexOf("\\")>=0) throw new Exception("�Ƿ��Ķ����������ƣ�"+sObjectType);
				if(sObjectType.indexOf("/")>=0) throw new Exception("�Ƿ��Ķ����������ƣ�"+sObjectType);
				if(sObjectNo.indexOf("\\")>=0) throw new Exception("�Ƿ��Ķ������ƣ�"+sObjectNo+"["+sObjectType+"]");
				if(sObjectNo.indexOf("/")>=0) throw new Exception("�Ƿ��Ķ������ƣ�"+sObjectNo+"["+sObjectType+"]");
				if( sObjectType == "" || sObjectNo == "" )
					throw new Exception("��Ϣ���岻������ObjectType["+sObjectType+"].ObjectNo["+sObjectNo+"]");
				if( !sObjectType.equals(sOldObjectType) )
				{
					sOldObjectType = sObjectType;
					System.out.println("New ObjectExim:"+sObjectType);
					oe = new ObjectExim(Sqlca,sObjectType,sRealPath);
				}
				//oe.setSDefaultSchema("INFORMIX");
				System.out.println("Export DataObject--"+sObjectType+":"+sObjectNo);
				oe.exportToXml(Sqlca,sObjectNo);
			}catch(Exception ex){
				errors.add(ex.getMessage());
			}
		}
		System.out.println("�������.............");
		if(errors.size()<=0){
			%>
			<script type="text/javascript">
			self.returnValue="succeeded";
			alert("���ݵ����ɹ����뵽��ָ����Ŀ¼�¼���ļ���");
			self.close();
			</script>
			<%
		}else{
			out.println("���ݵ�������ɣ����д���"+errors.size()+"����");
			for(int i=0;i<errors.size();i++) out.println(SpecialTools.amarsoft2Real((String)errors.get(i))+"<br>");
			%>
			<script type="text/javascript">
			self.returnValue="failed";
			</script>
			<%		
		}
	}catch(Exception ex){
		out.println("����ʧ��!����:"+ex.toString());
		%>
		<script type="text/javascript">
		self.returnValue="failed";
		</script>
		<%
	}
%><%@ include file="/IncludeEnd.jsp"%>