<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	 /*
		Author:
		Tester:
		Describe: �ͻ�ҵ��ϲ�
		Input Param:
		Output Param:
		HistoryLog: zywei on 2005/08/14 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ�ҵ��ϲ�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//���������sql���
	String sSql = "";			 
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
		//�����б���ʾ����			
	String sHeaders[][] = {							
							{"CustomerID","�ͻ����"},								
							{"CustomerName","�ͻ�����"},
							{"CustomerType","�ͻ�����"},
							{"OrgName","�ܻ�����"},
							{"UserName","�ܻ��ͻ�����"}								
				          };
   
   sSql = " select CI.CustomerID,CI.CustomerName,CB.OrgID, "+
   		  " getItemName('CustomerType',CI.CustomerType) as CustomerType, "+
   		  " getOrgName(CB.OrgID) as OrgName,CB.UserID,getUserName(CB.UserID) as UserName "+
          " from CUSTOMER_BELONG CB, CUSTOMER_INFO CI where CB.CustomerID = CI.CustomerID "+
          " and exists (select OI.OrgID from ORG_INFO OI where OI.OrgID = CB.OrgID "+
          " and OI.SortNo like '"+CurOrg.getSortNo()+"%') and CB.BelongAttribute1 = '1' ";
    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ÿɸ���Ŀ���
	doTemp.UpdateTable = "CUSTOMER_INFO";
	//��������
	doTemp.setKey("CustomerID",true);
	//�����ֶ��Ƿ�ɼ�
	doTemp.setVisible("OrgID,UserID",false);
	
	//����html���	
    doTemp.setHTMLStyle("CustomerName"," style={width:200px}");
		
	//���ɲ�ѯ����
	doTemp.setColumnAttribute("CustomerID,CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
			{"true","","Button","ҵ��ϲ�","�ϲ�ҵ����Ϣ","UniteBusiness()",sResourcesPath}		
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
		
	/*~[Describe=�ϲ�ҵ��;InputParam=��;OutPutParam=��;]~*/
	function UniteBusiness()
    {    	
    	var sFromCustomerID = "";
		var sFromCustomerName = "";			
		var sToCustomerID = "";
		var sToCustomerName = "";
		sFromCustomerID = getItemValue(0,getRow(),"CustomerID");
		sFromCustomerName = getItemValue(0,getRow(),"CustomerName");
		if(typeof(sFromCustomerID) == "undefined" || sFromCustomerID == "")
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}

    	if (confirm(getBusinessMessage("931")))//ȷ�Ϻϲ��ÿͻ���ҵ����
    	{				
			//��ȡ�ϲ���Ŀͻ�	
			var sParaStr = "CertType, ";
			sCustomerInfo = setObjectValue("SelectOwner",sParaStr,"",0,0);				
		    if (sCustomerInfo == "" || sCustomerInfo == "_CANCEL_" || sCustomerInfo == "_NONE_" || sCustomerInfo == "_CLEAR_" || typeof(sCustomerInfo) == "undefined") 
		    {
			    alert(getBusinessMessage("932"));//��ѡ��ϲ���Ŀͻ���
			    return;
		    }else
		    {
			    sCustomerInfo = sCustomerInfo.split('@');
			    sToCustomerID = sCustomerInfo[0];
			    sToCustomerName = sCustomerInfo[1];	
			    sToCertType = sCustomerInfo[2];
			    sToCertID = sCustomerInfo[3];
			    sToLoanCardNo = sCustomerInfo[4];
			    
				if(sFromCustomerID == sToCustomerID)
				{
					alert(getBusinessMessage("933"));//��������ͬһ�ͻ������ҵ��ϲ�������������ѡ��ϲ���Ŀͻ���
					return;						
				}																						
				//����ҳ�����
				sReturn = PopPageAjax("/SystemManage/SynthesisManage/CoalitionBusinessActionAjax.jsp?FromCustomerID="+sFromCustomerID+"&FromCustomerName="+sFromCustomerName+"&ToCustomerID="+sToCustomerID+"&ToCustomerName="+sToCustomerName+"&ToCertType="+sToCertType+"&ToCertID="+sToCertID+"&ToLoanCardNo="+sToLoanCardNo,"","dialogWidth=21;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 
				if(sReturn == "TRUE")
					alert("�ͻ����("+sFromCustomerID+"),"+getBusinessMessage("934"));//ҵ��ϲ��ɹ���
				else if(sReturn == "FALSE")
					alert("�ͻ����("+sFromCustomerID+"),"+getBusinessMessage("935"));//ҵ��ϲ�ʧ�ܣ�
				reloadSelf();	
			}
		}
	}	

</script>

<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
