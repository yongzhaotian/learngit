<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%><%@
 page import="com.amarsoft.awe.res.AppBizObject"%><%@
 page import="com.amarsoft.awe.res.ErrMsgManager"%>
<%
	//获取页面参数：对象类型、对象编号、视图编号
	String sObjectType  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sViewID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ViewID"));
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sViewID == null) sViewID = "";
    AppBizObject bom = new AppBizObject(Sqlca,sObjectType,sObjectNo);

    String sRightType = bom.getRightType(Sqlca,CurUser.getUserID(),sViewID);
    if(sRightType == null) sRightType="None";
    
    String sViewToOpen = "";
    if (sViewID.equals("") || sViewID.equalsIgnoreCase("null"))
        sViewToOpen = bom.getType().getDefaultView();
    else
        sViewToOpen = sViewID;      

    String sViews = bom.getType().getViewType();
    
    String sOjbectTypeURL = (String)bom.getType().getPagePath();
    
    // add by tbzeng 2014/06/27 合同状态非录入状态，不能修改
    String sCustomerName="";
    if ("Customer".equals(sObjectType) || "BusinessContract".equals(sObjectType)||"AssistInvestigate".equals(sObjectType)) {
    	 // 获取当前合同编号
        String sBQContractNo = CurARC.getAttribute("BQContractNo");
        if (sBQContractNo == null) sBQContractNo = "";
        // 获取合同状态
        String sContractStatus = Sqlca.getString(new SqlObject("SELECT CONTRACTSTATUS from BUSINESS_CONTRACT where SERIALNO=:ObjectNo").setParameter("ObjectNo", sBQContractNo));
        //获得当前客户名称
        sCustomerName=Sqlca.getString(new SqlObject("SELECT customername from BUSINESS_CONTRACT where SERIALNO=:ObjectNo").setParameter("ObjectNo", sBQContractNo));
        
        //add CCS-574 PRM-256 原地复活计划安硕系统需求(是否复活合同(1:是)) by rqiao 20150415
        String sIsReconsider = Sqlca.getString(new SqlObject("SELECT ISRECONSIDER FROM BUSINESS_CONTRACT WHERE SERIALNO = :OBJECTNO").setParameter("OBJECTNO",sBQContractNo));
        if(null == sIsReconsider) sIsReconsider = "";
        if (!"060".equals(sContractStatus) || ("1".equals(sIsReconsider) && !"AssistInvestigate".equals(sObjectType))) sRightType= "ReadOnly"; //update CCS-574 PRM-256 原地复活计划安硕系统需求 by rqiao 20150415
    }
    String sObjectTitle="";
    if("AssistInvestigate".equals(sObjectType)){
    	sObjectTitle = bom.getType().getObjectName()+"-"+sCustomerName+"-详情"+(sRightType.equalsIgnoreCase("ReadOnly")?"-只读":(sRightType.equalsIgnoreCase("all")?"-可修改":"-无权限"));
    }else{
       	sObjectTitle = bom.getType().getObjectName()+"-"+bom.getName()+"-详情"+(sRightType.equalsIgnoreCase("ReadOnly")?"-只读":(sRightType.equalsIgnoreCase("all")?"-可修改":"-无权限"));
    }
   
	//向Component中存储参数
	CurComp.setAttribute("CompObjectType",sObjectType);
	CurComp.setAttribute("CompObjectNo",sObjectNo);
	CurComp.setAttribute("RightType",sRightType);

%>

<html>
<head>

<title><%=sObjectTitle%></title>
<script type="text/javascript">
	setDialogTitle("&nbsp;&nbsp;<b><%=sObjectTitle%></b>");
</script>
</head> 

<body leftmargin="0" topmargin="0" class="pagebackground" style="overflow: auto;overflow-x:visible;overflow-y:visible">
   <table align='center' cellspacing=0 cellpadding=0 border=0 width=100% height="100%">
      <tr>
           <td>
                <%if (sRightType!=null && sRightType.equalsIgnoreCase("None")){%>
                	对不起，您没有查看[<%if(bom.getName()!=null){%><%=bom.getName()%><%} %>]视图["+sViewToOpen+"]的权限.
                <%}else{%>
					<iframe name="DeskTopInfo" src="<%=com.amarsoft.awe.util.Escape.getBlankJsp(sWebRootPath,"正在打开页面,请稍候...")%>" width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0></iframe>
			    <%}%>
			</td>
      </tr>                         
   </table>
</body>
</html>


<script type="text/javascript">

	<%if (sRightType!=null && sRightType.equalsIgnoreCase("None")){%>
		alert("对不起，您没有查看对象["+bom.getName()+"]视图["+sViewToOpen+"]的权限.");
	<%}else{%>
		OpenComp("<%=sViews%>","<%=sOjbectTypeURL%>","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ViewID=<%=sViewToOpen%>&ToInheritObj=y","DeskTopInfo","");
	<%}%>
	
</script>
<%

%>
<%@ include file="/IncludeEnd.jsp"%>
