<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
	Author:  	--ygwang	2013.03
	Tester:
	Content: ���������
	Input Param:
			
	Output param:
 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>��ѯ��������</title>
<%
	String schemeIndicator = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SchemeIndicator")));	
	BusinessObject loan = (BusinessObject)session.getAttribute("SimulationObject_Loan");

	String returnValue = "true";
	if(loan==null) returnValue="����δ���ţ����ܽ��д˲�����";
	else{
		String t1=(String)session.getAttribute("SimulationSchemeCount");
		int t=Integer.valueOf(t1);
		if(schemeIndicator.equals("clear")){
			session.setAttribute("SimulationSchemeCount","1");
			session.setAttribute("SimulationObject_Loan"+1,"");
			session.setAttribute("SimulationObject_Loan"+2,"");
			session.setAttribute("SimulationObject_Loan"+3,"");
			session.setAttribute("SimulationObject_Loan"+4,"");
			session.setAttribute("SimulationObject_Loan"+5,"");
			session.setAttribute("SimulationObject_Loan"+6,"");
			session.setAttribute("SimulationObject_Loan"+7,"");
			//session.removeAttribute("SimulationObject_Loan");
		}
		else if(schemeIndicator.equals("save")){
			session.setAttribute("SimulationObject_Loan"+t,loan.cloneObject());
			t++;
			session.setAttribute("SimulationSchemeCount",String.valueOf(t));
			//session.removeAttribute("SimulationObject_Loan");
		}
		else if(schemeIndicator.equals("reset")){
			/* session.setAttribute("SimulationSchemeCount","1");
			session.setAttribute("SimulationObject_Loan"+1,"");
			session.setAttribute("SimulationObject_Loan"+2,"");
			session.setAttribute("SimulationObject_Loan"+3,"");
			session.setAttribute("SimulationObject_Loan"+4,"");
			session.setAttribute("SimulationObject_Loan"+5,"");
			session.setAttribute("SimulationObject_Loan"+6,"");
			session.setAttribute("SimulationObject_Loan"+7,""); */
			session.removeAttribute("SimulationObject_Loan");
			BusinessObject bp = (BusinessObject)session.getAttribute("SimulationObject_BusinessPutOut");
			if(bp!=null){
				bp.setAttributeValue("PutoutStatus", "0");
			}
			//session.removeAttribute("SimulationObject_BusinessPutOut");
		}
		else {
			BusinessObject loan_t = (BusinessObject)session.getAttribute("SimulationObject_Loan"+schemeIndicator);
			session.setAttribute("SimulationObject_Loan",loan_t);
		}
	}
	com.amarsoft.app.accounting.config.loader.AccountCodeConfig.accountcode_type_all="N,C,B,S";
	
%>
<script language=javascript>
	//���ؼ��״ֵ̬�Ϳͻ���
	self.returnValue = "<%=returnValue%>";
	self.close();
</script>


<%@ include file="/IncludeEnd.jsp"%>