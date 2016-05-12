<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-3
		Tester:
		Describe:
			检查关联关系情况，主要是检查关联关系的主键重复问题，在新插入关联关系的时候被调用
			对于集团成员关系，主要成员只能有一个（主体成员关系代码0401）

		Input Param:
			CustomerID: 客户编号
			RelationShip: 关联关系
			CertType: 证件类型
			CertID:证件号码
		Output Param:
			Message: 返回关联客户编号RelativeID 如果为空则表示检查不通过,并提示消息
		HistoryLog:
	*/
	%>
<%/*~END~*/%>

<%
	//获取页面参数
	String sCustomerID   = DataConvert.toRealString(iPostChange,CurPage.getParameter("CustomerID"));
	String sRelationShip = DataConvert.toRealString(iPostChange,CurPage.getParameter("RelationShip"));
	String sCertType     = DataConvert.toRealString(iPostChange,CurPage.getParameter("CertType"));
	String sCertID       = DataConvert.toRealString(iPostChange,CurPage.getParameter("CertID"));
	
	//定义变量
	String sRelativeID = "";
	String sSql = "";
	String sMessage = "";
	ASResultSet rs = null;
	
	//根据证件类型和证件编号获取客户编号
	sSql = 	" select CustomerID from CUSTOMER_INFO "+
			" where CertType = '"+sCertType+"' "+
			" and CertID = '"+sCertID+"' ";
	rs = Sqlca.getResultSet(sSql);
	if (rs.next()) {
		sRelativeID = rs.getString(1);
		if(sRelativeID.equals(sCustomerID)){
			sMessage="false@客户不可与自己本身建立成员关系,请选择其他客户后保存!";
		}
		else{
			//根据客户编号、关联客户编号和关联关系获得关联客户名称
			sSql = 	" select CustomerName from CUSTOMER_RELATIVE "+
					" where CustomerID = :CustomerID "+
					" and RelativeID = :RelativeID ";//+
					//" and RelationShip = :RelationShip ";	
			SqlObject so=new SqlObject(sSql);
			so.setParameter("CustomerID",sCustomerID);
			so.setParameter("RelativeID",sRelativeID);
			//so.setParameter("RelationShip",sRelationShip);
			ASResultSet rs1 = Sqlca.getResultSet(so);		
			if (rs1.next())
			{
				sMessage="false@客户["+rs1.getString("CustomerName")+"]与本客户的关系已经建立,请选择其他客户后保存!";
				if (sRelationShip.equals("0401"))
					sMessage="false@客户["+rs1.getString("CustomerName")+"]已经是该集团的主体成员,一个关联集团只能有一个主体成员,不予保存!";
			}
			rs1.getStatement().close();
			
			if (!sMessage.equals("")) sRelativeID = "";
		}
	}
	else 
	{
		sRelativeID = DBKeyHelp.getSerialNo("CUSTOMER_INFO","CustomerID",Sqlca);
	}
	rs.getStatement().close();	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sRelativeID);
	sRelativeID = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	if (sMessage != "") {
		out.println(sMessage);
	}
	else{ 
		out.println("true@" + sRelativeID);
	}
%>
<%/*~END~*/%>

<%@	include file="/IncludeEndAJAX.jsp"%>