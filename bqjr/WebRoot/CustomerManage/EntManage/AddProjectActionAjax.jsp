<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=注释区;]~*/%>
<%
/* 
  Tester:
  Content:  新增项目动作
  Input Param:
			ObjectType  ：对象类型
			ObjectNo:   : 对象编号
			ProjectType : 项目类型
			ProjectName : 项目名称
  Output param:
 			sProjectNo  :项目编号
 
  History Log:     
      DATE	  CHANGER		CONTENT
      2005-7-25 fbkang     增加注释
       2005/09/13 zywei 增加事务处理         
 */
 %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>

<%     	
    //定义变量
   	String sSql = "",sReturnValue="";
    //获得页面参数
	String sObjectType     = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo       =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sProjectType    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProjectType"));
	String sProjectName    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProjectName"));
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sProjectType == null) sProjectType = "";
	if(sProjectName == null) sProjectName = "";
   //获得组件参数

	//初始化项目编号
    String sProjectNo  = DBKeyHelp.getSerialNo("PROJECT_INFO","ProjectNo",Sqlca);
 %>
<%/*~END~*/%>	

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=执行sql命令*/%>    
<%
	try {
	   	//插入项目资料库
	    sSql = " insert into PROJECT_INFO(ProjectNo,InputUserID,InputOrgID,InputDate,UpdateDate,ProjectType,ProjectName) " +
 	   " values(:ProjectNo,:InputUserID,:InputOrgID,:InputDate,:UpdateDate,:ProjectType,:ProjectName)" ;
	    SqlObject so = new SqlObject(sSql);
	    so.setParameter("ProjectNo",sProjectNo);
	    so.setParameter("InputUserID",CurUser.getUserID());
	    so.setParameter("InputOrgID",CurOrg.getOrgID());
	    so.setParameter("InputDate",StringFunction.getToday());
	    so.setParameter("UpdateDate",StringFunction.getToday());
	    so.setParameter("ProjectType",sProjectType);
	    so.setParameter("ProjectName",sProjectName);
	    Sqlca.executeSQL(so);    
   
	   	//插入项目关联对象库
	    sSql = " insert into PROJECT_RELATIVE(ProjectNo,ObjectType,ObjectNo) " +
 	  		   " values(:ProjectNo,:ObjectType,:ObjectNo)";
	    so = new SqlObject(sSql);
	    so.setParameter("ProjectNo",sProjectNo);
	    so.setParameter("ObjectType",sObjectType);
	    so.setParameter("ObjectNo",sObjectNo);
	    Sqlca.executeSQL(so);
	}catch(Exception e)
	{
		throw new Exception("事务处理失败！"+e.getMessage());
	}
%>
<%/*~END~*/%>	

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main04;Describe=返回参数*/%>  

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sProjectNo);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>