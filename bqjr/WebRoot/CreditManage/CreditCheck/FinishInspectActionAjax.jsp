<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat" %>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   ndeng  2005.1.24
		Tester:
		Content: 检查表完成操作
		Input Param:
			                sSerialNo: 流水号
		Output param:
		History Log: 
			
	 */
	%>
<%/*~END~*/%>

<%
	String sSql;
	boolean bFinishFlag=false;
	String sFinishType="";
	ASResultSet rs = null;
	SqlObject so = null;
	String sReturnValue="";
	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));

	//如果是贷款用途报告
	if(sObjectType.equals("BusinessContract"))
	{
		//检查该报告有无提款记录
		sSql= "select count(*) as c from INSPECT_DETAIL where itemtype='01' and SerialNo=:SerialNo and ObjectNo=:ObjectNo and ObjectType=:ObjectType";
		so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo).setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);
		rs = Sqlca.getResultSet(so);
		int count1=0,count2=0;
		if(rs.next())
		{
			count1=rs.getInt("c");
		}
		rs.getStatement().close();
		
		//检查该报告有无用款纪录
		sSql= "select count(*) as c from INSPECT_DETAIL where itemtype='02' and SerialNo=:SerialNo and ObjectNo=:ObjectNo and ObjectType=:ObjectType";
		so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo).setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);
		rs = Sqlca.getResultSet(so);
		if(rs.next())
		{
			count2=rs.getInt("c");
		}
		rs.getStatement().close();
		
		//如果以上两种都有记录，则可完成该报告
		if(count1>0 && count2>0)
			bFinishFlag=true;
		else
			bFinishFlag=false;

		if(bFinishFlag)
		{
			sSql = "update INSPECT_INFO set finishdate=:finishdate,UpdateDate=:UpdateDate"+
			" where SerialNo=:SerialNo and ObjectNo=:ObjectNo and ObjectType=:ObjectType";
			so = new SqlObject(sSql).setParameter("finishdate",StringFunction.getToday())
			.setParameter("UpdateDate",StringFunction.getToday()).setParameter("SerialNo",sSerialNo)
			.setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);
			Sqlca.executeSQL(so);
		}
		sFinishType="Purpose";
	}
	//贷后检查报告，
	else if(sObjectType.equals("Customer"))
	{
		String sBeforDay="";
		String sToday="";
		sToday=StringFunction.getToday();
		sBeforDay=StringFunction.getRelativeDate(sToday,-10);//获得10天前的日期
		
		//在10天内做过风险分析的才能完成检查报告
		sSql="select count(*) as ClassifyCount from CLASSIFY_RECORD where FinishDate > :FinishDate and FinishDate <= :FinishDate and UserId=:UserId and ObjectNo in(select serialno from business_contract where customerid=:customerid)";
		//out.println(sSql);
		so = new SqlObject(sSql).setParameter("FinishDate",sBeforDay).setParameter("FinishDate",sToday)
		.setParameter("UserId",CurUser.getUserID()).setParameter("customerid",sObjectNo);
		rs = Sqlca.getResultSet(so);
		if(rs.next())
		{
			int count=rs.getInt("ClassifyCount");
			//out.println(count);
			if(count>0)
				bFinishFlag=true;
			else
				bFinishFlag=false;
		}
		rs.getStatement().close();
		
		//屏蔽完成检查条件，在测试过后可以去掉
		bFinishFlag=true;
		//----------------end---------------

		if(bFinishFlag)
		{
			if(sObjectType.equals("BusinessContract")){
				sSql = "update INSPECT_INFO set finishdate=:finishdate,UpdateDate=:UpdateDate,InspectType = '010020'"+
			   			" where SerialNo=:SerialNo and ObjectNo=:ObjectNo and ObjectType=:ObjectType";
				so = new SqlObject(sSql).setParameter("finishdate",StringFunction.getToday()).setParameter("UpdateDate",StringFunction.getToday())
		   		.setParameter("SerialNo",sSerialNo).setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);	
			}else if(sObjectType.equals("Customer")){
				sSql = "update INSPECT_INFO set finishdate=:finishdate,UpdateDate=:UpdateDate,InspectType = '020020'"+
	   			" where SerialNo=:SerialNo and ObjectNo=:ObjectNo and ObjectType=:ObjectType";
				so = new SqlObject(sSql).setParameter("finishdate",StringFunction.getToday())
				.setParameter("UpdateDate",StringFunction.getToday()).setParameter("SerialNo",sSerialNo)
		   		.setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);	
			}
			Sqlca.executeSQL(so);
		}
		sFinishType="Inspect";
	}
	
	if(bFinishFlag){
		sReturnValue="finished";
	}else{
		if("Purpose".equals(sFinishType))
			sReturnValue="Purposeunfinish";
		if("Inspect".equals(sFinishType))
			sReturnValue="Inspectunfinish";
	}
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>