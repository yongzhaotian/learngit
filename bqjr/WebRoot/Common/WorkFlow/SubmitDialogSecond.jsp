<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.biz.workflow.*" %>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
<%
	/*
		Author: byhu 2004-12-06 
		Tester:
		Describe: �ύѡ���
		Input Param:
			SerialNo��������ˮ��
			PhaseOpinion1�����
		Output Param:
		HistoryLog: zywei 2005/08/01	
					cdeng 2009-02-17
	 */
%>
<%/*~END~*/%> 


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<% 
	//��ȡ������������ˮ�š����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sPhaseOpinion1 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseOpinion1"));
	
	//������������̱�š��׶α�š�������
	String sFlowNo = "",sPhaseNo = "",sObjectNo = "";
	//��������������������б��׶ε����͡�������ʾ���׶ε�����
	String sPhaseAction = "",sActionList[],sSelectStyle = "",sActionDescribe = "",sPhaseAttribute = ""; 
	String sSql="";
	ASResultSet rsTemp = null;
%>
<%/*~END~*/%>	


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=����ҵ���߼�����;]~*/%>
<%
	//���������̱�FLOW_TASK�в�ѯ�����̱�š��׶α��
	sSql = "select FlowNo,PhaseNo from FLOW_TASK where SerialNo = :SerialNo ";
	rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
	if (rsTemp.next()){
		sFlowNo  = DataConvert.toString(rsTemp.getString("FlowNo"));
		sPhaseNo  = DataConvert.toString(rsTemp.getString("PhaseNo"));
		
		//����ֵת���ɿ��ַ���
		if(sFlowNo == null) sFlowNo = "";
		if(sPhaseNo == null) sPhaseNo = "";				
	}
	rsTemp.getStatement().close();
	
	//������ģ�ͱ�FLOW_MODEL�в�ѯ���׶����ԡ��׶�����
	sSql = "select PhaseAttribute,ActionDescribe from FLOW_MODEL where FlowNo = :FlowNo and PhaseNo = :PhaseNo ";
	rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("FlowNo",sFlowNo).setParameter("PhaseNo",sPhaseNo));
	if (rsTemp.next()){
		sPhaseAttribute  = DataConvert.toString(rsTemp.getString("PhaseAttribute"));
		sActionDescribe = DataConvert.toString(rsTemp.getString("ActionDescribe"));
		//����ֵת���ɿ��ַ���
		if(sPhaseAttribute == null) sPhaseAttribute = "";
		if(sActionDescribe == null) sActionDescribe = "";
		sSelectStyle = StringFunction.getProfileString(sPhaseAttribute,"ActionStyle");
		//����ֵת���ɿ��ַ���
		if(sSelectStyle == null) sSelectStyle = "";
	}
	rsTemp.getStatement().close();
	    
	//��ʼ���������		 
	FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);
	//��ȡ����ѡ���б�
	sActionList = ftBusiness.getActionList(sPhaseOpinion1);
	if (sActionList == null){ 
		sActionList = new String[1];
		sActionList[0] = "";
	}	
	
	String sActionValue[];
	String sTempString1 = "";
	int iCount=sActionList.length;
	sActionValue = new String[iCount];

	for(int i=0;i<iCount;i++){
		sSql = "select LoginID||'  '||UserName from USER_INFO where UserID = :UserID ";
		rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("UserID",sActionList[i]));
		if(rsTemp.next()){
			sActionValue[i] = rsTemp.getString(1);
		}
		rsTemp.getStatement().close();
	}
	if(sActionValue[0] == null){
		sActionValue = sActionList;
	}
%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=����ѡ���ύ����������;]~*/%>
	<html>
	<head> 
		<link rel="stylesheet" href="<%=sResourcesPath%>/Style.css">
		<title>�ύ����ѡ���б�</title>
	</head>
	<body class="ShowModalPage" leftmargin="0" topmargin="0" onload="" >

	<form name="Phase" method="post" target="_top">
 		<table width="100%"> 
		  	<tr width="100%" > 
		  		<td width="100%"  valign="top" >
	 		       <table >
					<tr>
						<td>
						<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��  ��","�ύ","javascript:commitAction()",sResourcesPath)%>
						</td>
						<td>
						<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��  ��","����","javascript:doCancel()",sResourcesPath)%>
						</td>			
					</tr>
		           </table>
		           <tr height=1> 
			          <td colspan="5" valign="top" ><hr></td>
			       </tr>	 		       
	               <table align="center">						
							<tr>
								<td valign="top" width=1><img src="<%=sResourcesPath%>/TN_031.gif" width="123" height="80"></td>
					  		    <td colspan=4>
									<select size=8 <%=sSelectStyle%> <%=sSelectStyle%> name="PhaseAction"  class="select1">
			                  			<option value='' style='color:white'>------------------------</option>
			                  			<%=HTMLControls.generateDropDownSelect(sActionList,sActionValue,"")%> 
									</select>
								</td>
							</tr> 
	                	 	<tr>
	                	 	    <td colspan=4></td>
	                	 	</tr> 
					</table>
				</td>
			</tr>
		</table> 
	 <p>	       
	 <input name="SelectedCount" readonly type="text" style="font-size: 9pt;background-color:#DEDFCE;border-style=none" > 
	</form>	
	</body>
	</html>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

		var thisPhaseAction  = "";
		var thisPhaseOpinion1  = "<%=sPhaseOpinion1%>";
		//�ύ����
		function commitAction()
		{
			var sReturnValue = "";
			var thisPhaseAction = "";			
			iLength  = document.forms["Phase"].PhaseAction.length;
			for(i = 0;i <= iLength - 1;i++)
			{	
				if (document.forms["Phase"].PhaseAction.item(i).selected)
				{
					var tempPhaseAction=document.forms["Phase"].PhaseAction.item(i);// add by cdeng 2009-02-17
					var index=tempPhaseAction.value.indexOf(" ",0);	
					if(index>=0)//�½׶��н�ɫ��ֻȡ�û�ID
						thisPhaseAction += "," + tempPhaseAction.value.substring(0,index);
					else//�½׶��޽�ɫ
						thisPhaseAction += "," + tempPhaseAction.value;
				}

			}	
			thisPhaseAction = thisPhaseAction.substring(1);
			if(thisPhaseAction.length == 0) alert("���Ƚ����ύ����ѡ�� !");
			else if (thisPhaseAction == '<%=CurUser.getUserID()%>')
			{
				alert("�ύ������Ϊ��ǰ�û���");
			}
			else 
			{					
				var sPhaseInfo = PopPageAjax("/Common/WorkFlow/GetNextFlowPhaseActionAjax.jsp?SerialNo=<%=sSerialNo%>&PhaseAction="+thisPhaseAction+"&PhaseOpinion1="+thisPhaseOpinion1+"&rand="+randomNumber(),"_blank","");
				if (confirm(sPhaseInfo+"\r\n ȷ���ύ��"))
				{
					sReturnValue = PopPageAjax("/Common/WorkFlow/SubmitActionAjax.jsp?SerialNo=<%=sSerialNo%>&PhaseOpinion1="+thisPhaseOpinion1+"&PhaseAction="+thisPhaseAction+"&rand="+randomNumber(),"","");
					self.returnValue = sReturnValue;   				
					self.close();
				}
			}
		}
		
		//ȡ���ύ
		function doCancel()
		{
			if (confirm("��Ҫ�����ô��ύ��ȷ����")) 
			{
				self.returnValue = "_CANCEL_";
				self.close();
			}	
		}	
   
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>	