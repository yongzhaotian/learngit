<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang  2005.1.2
		Tester:
		Content: 插入检查表
		Input Param:
			                sObjectNo:代号
			                sInspectType:报告类型
							                010	贷款用途报告
											020	贷款检查报告
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	String sSql;
	String sObjectNo="",sInspectType="",sSerialNo="",sObjectType="";	
	ASResultSet rs = null;
	SqlObject so = null;
	String sReturnValue="";
	String sActionType=DataConvert.toRealString(iPostChange,(String)request.getParameter("ActionType"));
	if(sActionType==null)
		sActionType="";
	//如果是删除操作
	if(sActionType.equals("Del"))
	{
		sSerialNo=DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));

		sSql="delete from inspect_info where SerialNo=:SerialNo";
		so = new SqlObject(sSql);
		so.setParameter("SerialNo",sSerialNo);
		Sqlca.executeSQL(so);
		//删除该贷款用途报告的提款纪录、用款纪录
		sSql="delete from inspect_detail where ObjectNo=:ObjectNo";
		so = new SqlObject(sSql);
		so.setParameter("ObjectNo",sSerialNo);
		Sqlca.executeSQL(so);
	}
	//新增操作
	else
	{
		sObjectNo   = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
		sObjectType   = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));
		sInspectType   = DataConvert.toRealString(iPostChange,(String)request.getParameter("InspectType"));
		sSerialNo = DBKeyHelp.getSerialNo("INSPECT_INFO","SerialNo",Sqlca);
		if(sInspectType.equals("020010") || sInspectType.equals("020020"))//贷后检查报告未完成、已完成
		{
			sSql = "insert into INSPECT_INFO(ObjectType,ObjectNo,SerialNo,InspectType,UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				"values('Customer',:ObjectNo,:SerialNo,:InspectType,:UpToDate,:InputOrgID,:InputUserID,:InputDate,:UpdateDate)";
			so = new SqlObject(sSql);
			so.setParameter("ObjectNo",sObjectNo).setParameter("SerialNo",sSerialNo)
			.setParameter("InspectType",sInspectType).setParameter("UpToDate",StringFunction.getToday())
			.setParameter("InputOrgID",CurOrg.getOrgID()).setParameter("InputUserID",CurUser.getUserID())
			.setParameter("InputDate",StringFunction.getToday()).setParameter("UpdateDate",StringFunction.getToday());
			Sqlca.executeSQL(so);

			sSql = "select ItemDescribe from CODE_LIBRARY where CodeNo ='InspectType' and ItemNo=:ItemNo";
			so = new SqlObject(sSql).setParameter("ItemNo",sInspectType);
			String sItemDescribe = Sqlca.getString(so);
			if(sItemDescribe == null) sItemDescribe = "";
			int i = 0;
			StringTokenizer st = new StringTokenizer(sItemDescribe,"@");
		    String [] sDocID = new String[st.countTokens()];

			while (st.hasMoreTokens())
		    {			
				sDocID[i] = st.nextToken();
		        i ++;
		    }

			for(int j = 0 ; j < sDocID.length ; j ++)
		    {	    	
				 sSql ="insert into INSPECT_DATA(SerialNo,DocID,ObjectNo,ObjectType,OrgID,UserID,InputDate,UpdateDate) "+
				 	"values(:SerialNo,:DocID,:ObjectNo,:ObjectType,:OrgID,:UserID,:InputDate,:UpdateDate)";
				 so = new SqlObject(sSql);
					so.setParameter("ObjectNo",sObjectNo).setParameter("SerialNo",sSerialNo)
					.setParameter("ObjectType",sObjectType).setParameter("DocID",sDocID[j])
					.setParameter("OrgID",CurOrg.getOrgID()).setParameter("UserID",CurUser.getUserID())
					.setParameter("InputDate",StringFunction.getToday()).setParameter("UpdateDate",StringFunction.getToday());
				Sqlca.executeSQL(so);	
		    }
		}
		else
		{
			sSql = "insert into INSPECT_INFO(ObjectType,ObjectNo,SerialNo,InspectType,UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				"values('BusinessContract',:ObjectNo,:SerialNo,:InspectType,:UpToDate,:InputOrgID,:InputUserID,:InputDate,:UpdateDate)";
			so = new SqlObject(sSql);
			so.setParameter("ObjectNo",sObjectNo).setParameter("SerialNo",sSerialNo)
			.setParameter("InspectType",sInspectType).setParameter("UpToDate",StringFunction.getToday())
			.setParameter("InputOrgID",CurOrg.getOrgID()).setParameter("InputUserID",CurUser.getUserID())
			.setParameter("InputDate",StringFunction.getToday()).setParameter("UpdateDate",StringFunction.getToday());
			Sqlca.executeSQL(so);
		}
	}
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sSerialNo);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>