<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: cwliu 2004-12-15
 * Tester:
 *
 * Content: �г��ͻ�������Ŀ���ṩѡ��
 * Input Param:
 *      ObjectType����������(Customer,CreditApply,CreditApprove,CreditContract)
 *      ObjectNo�� ������
 * Output param:
 *      ObjectType����������(Customer,CreditApply,CreditApprove,CreditContract)
 *      ObjectNo�� ������
 *      ProjectNo����Ŀ���
 * History Log:
 */
%>
<html>
<head> 
<title>��������Ŀ��Ϣ</title>
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
    
    //��ѯ�ÿͻ�����Ŀ��Ϣ
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
		alert(getBusinessMessage('432'));//alert("��ǰ�ͻ�û�������Ŀ��Ϣ��");		
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
		  <td nowrap1>��Ŀ����</td>					
		  <td nowrap2>��Ŀ����</td>
		  <td nowrap3>��Ŀ����</td>	
		  <td nowrap4>��Ŀ���ڵ�</td>			
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
		<td onclick="javascript:assignProject()"><input type=button readonly value="ȷ��">
		</td>       		
		<td onclick="javascript: self.close()"><input type=button readonly value="ȡ��">
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
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��		
			return;
		}
		
		if(confirm("ָ����ǰ��ĿΪ�ñ�ҵ��������Ŀ��\r\nȷ����")){
			self.returnValue=sProjectInfo;
			self.close();
		}
	}
	
</script>		
				
<%@ include file="/IncludeEnd.jsp"%>