<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
		Describe: 完成归档/取消归档操作的通用模块
		Input Param:
			ObjectType: 对象类型
			ObjectNo: 对象编号
			Pigeonholed:归档标志(Y/N)
	 */
	String sObjectType = CurPage.getParameter("ObjectType");
	String sObjectNo = CurPage.getParameter("ObjectNo");
    String sPigeonholed = CurPage.getParameter("Pigeonholed");//归档标志取Y/N
	if (sPigeonholed==null) sPigeonholed="";
    String sReturnValue="";
   	
   	 String sTable="";//归档/取消归档的表对象
     String sSql="";

	//根据sObjectType的不同，得到不同的关联表名
	sSql="select ObjectTable from OBJECTTYPE_CATALOG where ObjectType=:ObjectType";
	SqlObject so = new SqlObject(sSql);
	so.setParameter("ObjectType",sObjectType);
	ASResultSet rs = Sqlca.getASResultSet(so);
	if(rs.next()){ 
		sTable=DataConvert.toString(rs.getString("ObjectTable"));
	}
	rs.getStatement().close(); 
    
    if(sPigeonholed.equals("Y")){//已归档
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

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg("true");
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>