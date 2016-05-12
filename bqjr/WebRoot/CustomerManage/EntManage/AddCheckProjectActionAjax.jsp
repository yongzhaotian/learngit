<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=注释区;]~*/%>
<%
/* 
  author:  --fbkang 2005-7-25 
  Tester:
  Content:  校验是否可以删除此项目
  Input Param:
			--ObjectType  ：对象类型
			--ObjectNo    : 对象编号
            --ProjectNo   ：项目编号
  Output param:
 
  History Log:     

               
 */
 %>
<%/*~END~*/%>

<%     
	
    //定义变量
    ASResultSet rs = null;
    int iCount = 0;
    String sSql = "";
    String sreturnvalue = "";
    //获得页面参数,项目编号、对象编号。
	String sProjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProjectNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
   	if(sProjectNo == null) sProjectNo = "";
   	if(sObjectNo == null) sObjectNo = "";
   	//获得组件参数
    String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
    if(sObjectType == null) sObjectType = "";
    sSql= " select count(ProjectNo) from PROJECT_RELATIVE "+
	      " where ProjectNo=:ProjectNo and " +
    	  " (ObjectType ='CreditApply' "+
    	  " or ObjectType ='AfterLoan') ";
    
	rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("ProjectNo",sProjectNo));
	if(rs.next())
		iCount = rs.getInt(1);
	    
	rs.getStatement().close();
	//如果是客户信息进入
	if (sObjectType.equals("Customer"))
	{
		//假如有业务关联不能删除
		if (iCount>0)
		  sreturnvalue="NO";
		//如果没有业务关联可以完全删除
		else
		  sreturnvalue="YES";
	}else //如果是业务进入，只是删除和项目的关联内容  
	    sreturnvalue="YES";   
	      
 %>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sreturnvalue);
	sreturnvalue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sreturnvalue);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>