<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: cwliu 2004-12-15
 * Tester:
 *
 * Content: 列出客户所有项目，提供选择
 * Input Param:
 *      ObjectType：对象类型(Customer,CreditApply,CreditApprove,CreditContract)
 *      ObjectNo： 对象编号
 * Output param:
 *      ObjectType：对象类型(Customer,CreditApply,CreditApprove,CreditContract)
 *      ObjectNo： 对象编号
 *      ProjectNo：项目编号
 * History Log:
 */
%>
<html>
<head> 
<title>请输入项目信息</title>
</head>
<%    
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	
	ASResultSet rs = null;
	String sCustomerID = "",sTableName = "";	
	if(sObjectType.equals("CreditApply"))
	    sTableName = "BUSINESS_APPLY";
	else if(sObjectType.equals("CreditApprove"))
		sTableName = "BUSINESS_APPROVE";
	else if(sObjectType.equals("CreditContract"))
		sTableName = "BUSINESS_CONTRACT";
	
	String sSql = " select CustomerID from "+sTableName+" where SerialNo = '"+sObjectNo+"' ";
    sCustomerID = Sqlca.getString(sSql);
    
    //查询该客户的项目信息
	sSql = " select PI.ProjectNo,getItemName('ProjectStyle',PI.ProjectType) as ProjectTypeName, "+
		   " PI.ProjectName,PI.ProjectRegiion,PI.ProjectLevel, " +
	       " getItemName('ProjectType',PI.ProjectLevel) as ProjectLevelName, " +
		   " getItemName('AreaCode',PI.ProjectRegiion) as ProjectRegiionName " +
		   " from PROJECT_INFO PI,PROJECT_RELATIVE PR " +
		   " where PI.ProjectNo = PR.ProjectNo " +
		   " and PR.ObjectType = 'Customer' " +
		   " and PR.ObjectNo = :ObjectNo " +
		   " order by PI.ProjectNo";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo",sCustomerID)); 
	if(!rs.next()){
%>	
	<script type="text/javascript">
		alert(getBusinessMessage('432'));//alert("当前客户没有相关项目信息！");		
		self.close();	
	</script>
<%
	}
%>

<body bgcolor="#DCDCDC" leftmargin="0" topmargin="0" >
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr valign=top>    
	<td>	
      <table>	 
        <tr align="center" bgcolor="#CCCCCC" height=1> 			
          <td>
          </td>
		  <td nowrap1>项目类型</td>					
		  <td nowrap2>项目名称</td>
		  <td nowrap3>项目级别</td>	
		  <td nowrap4>项目所在地</td>			
	    </tr>
	<%
		rs.beforeFirst();
		while(rs.next()){
			String t1 = DataConvert.toString(rs.getString("ProjectNo"));		
	%>	<tr height=1>
			<td rowspan=2><input name=refApplyNo type="radio"  style="width:15px" value="" onClick="setProjectNo('<%=t1%>')"></td>
			<td nowrap1 ><%=DataConvert.toString(rs.getString("ProjectTypeName"))%> </td>
			<td nowrap2 ><%=DataConvert.toString(rs.getString("ProjectName"))%> </td>
			<td nowrap3 ><%=DataConvert.toString(rs.getString("ProjectLevelName"))%> </td>
			<td nowrap4 ><%=DataConvert.toString(rs.getString("ProjectRegiionName"))%> </td>			
		</tr>	 
	<%	     
		}
		rs.getStatement().close();	  
	%>
		</table>
	</td>
</tr>
<tr height=50 valign=center bgcolor='#DEDFCE'>
    <td>    	
	  <table>	    	
	   <tr>	 		
		<td onclick="javascript:assignProject()"><input type=button readonly value="确定">
		</td>       		
		<td onclick="javascript: self.close()"><input type=button readonly value="取消">
		</td>		 	
	   </tr>    	
      </table>    
     </td>
 </tr>
</table>
</form>
</body>
</html>

<script type="text/javascript">
	
	var sProjectInfo="";	
	
	function setProjectNo(sProjectNo){
		sProjectInfo = sProjectNo;			
	}
	
	function assignProject(){
		if(typeof(sProjectInfo)=="undefined" || sProjectInfo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！		
			return;
		}
		
		if(confirm("指定当前项目为该笔业务的相关项目，\r\n确定吗？")){
			self.returnValue=sProjectInfo;
			self.close();
		}
	}
	
</script>		
				
<%@ include file="/IncludeEnd.jsp"%>