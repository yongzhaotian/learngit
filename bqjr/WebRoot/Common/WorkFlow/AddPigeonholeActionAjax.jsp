<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
		Describe: ��ɹ鵵/ȡ���鵵������ͨ��ģ��
		Input Param:
			ObjectType: ��������
			ObjectNo: ������
			Pigeonholed:�鵵��־(Y/N)
	 */
	String sObjectType = CurPage.getParameter("ObjectType");
	String sObjectNo = CurPage.getParameter("ObjectNo");
    String sPigeonholed = CurPage.getParameter("Pigeonholed");//�鵵��־ȡY/N
	if (sPigeonholed==null) sPigeonholed="";
    String sReturnValue="";
   	
   	 String sTable="";//�鵵/ȡ���鵵�ı����
     String sSql="";

	//����sObjectType�Ĳ�ͬ���õ���ͬ�Ĺ�������
	sSql="select ObjectTable from OBJECTTYPE_CATALOG where ObjectType=:ObjectType";
	SqlObject so = new SqlObject(sSql);
	so.setParameter("ObjectType",sObjectType);
	ASResultSet rs = Sqlca.getASResultSet(so);
	if(rs.next()){ 
		sTable=DataConvert.toString(rs.getString("ObjectTable"));
	}
	rs.getStatement().close(); 
    
    if(sPigeonholed.equals("Y")){//�ѹ鵵
        sSql="UPDATE " + sTable + " SET PigeonholeDate=null";
        sSql=sSql + " where SerialNo=:SerialNo";
        so = new SqlObject(sSql);
        so.setParameter("SerialNo",sObjectNo);
        Sqlca.executeSQL(so);
    }else{
    	sSql="UPDATE " + sTable + " SET PigeonholeDate=:PigeonholeDate";
    	sSql=sSql + " where SerialNo=:SerialNo";
        so = new SqlObject(sSql);
        so.setParameter("PigeonholeDate",StringFunction.getToday()).setParameter("SerialNo",sObjectNo);
        Sqlca.executeSQL(so);
    }
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg("true");
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>