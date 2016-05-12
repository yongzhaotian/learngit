<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   fxie  2005.03.21
		Tester:
		Content: ���ʽ�����־�б�
		Input Param:
			                SerialNo: ������ˮ��
			         
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>
<%
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sCondition="";
	
	if (sSerialNo==null) sSerialNo="";
	if (!sSerialNo.equals("")) sCondition = " and SerialNo='"+sSerialNo+"'";
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������־������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {	{"SerialNo","������ˮ��"},
							{"Date","����ʱ��"},
							{"TradeCode","���״���"},
							{"OperateFlag","����״̬"},
							{"OperateOrgName","��������"},
							{"OperateUserName","������"},
							{"SendMsg","������Ϣ"},
							{"BackMsg","������Ϣ"}
						  };

	String sSql =	" select SerialNo,Date,TradeCode,OperateFlag,OperateOrgID,OperateUserID,"+
	                " getOrgName(OperateOrgID) as OperateOrgName,getUserName(OperateUserID) as OperateUserName,"+
	                " ltrim(rtrim(SendMsg)) as SendMsg,ltrim(rtrim(BackMsg)) as BackMsg" +	                
					" from Trade_Log " +
					//" where TradeCode<>'O6001' " + sCondition+
					" where 1=1 " + sCondition+
					" Order by Date Desc ";

	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "Trade_Log";

	doTemp.setKey("SerialNo,Date",true);
	doTemp.setVisible("OperateOrgID,OperateUserID,BackMsg",false);
	
		
	doTemp.setHTMLStyle("TradeCode,OperateFlag"," style={width:60px} ");
	doTemp.setHTMLStyle("OperateOrgName,OperateUserName"," style={width:100px} ");
	doTemp.setHTMLStyle("Date"," style={width:120px} ");
	
	//���ö�ѡ��   
	doTemp.multiSelectionEnabled = true;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��


	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
		
		String sButtons[][] = {
								{"true","","Button","ȫѡ","ȫѡ","SelectedAll()",sResourcesPath},
								{"true","","Button","��ѡ","��ѡ","SelectedBack()",sResourcesPath},
								{"true","","Button","ȡ��ȫѡ","ȡ��ȫѡ","SelectedCancel()",sResourcesPath},
								{"true","","Button","����","�鿴��־����","viewDetail()",sResourcesPath},
								{"false","","Button","ɾ��","ɾ����־","deleteSelected()",sResourcesPath}
							  };
	   
	   if(CurUser.hasRole("000")){
	       sButtons[4][0] = "true";
	   }
	%> 
<%/*~END~*/%>



<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
	
	/*~[Describe=ȫѡObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function SelectedAll(){
		
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a != "��"){
				setItemValue(0,iMSR,"MultiSelectionFlag","��");
			}
		}
	}
	
	
	/*~[Describe=��ѡObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function SelectedBack(){
		
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a != "��"){
				setItemValue(0,iMSR,"MultiSelectionFlag","��");
			}else{
				setItemValue(0,iMSR,"MultiSelectionFlag","");
			}
		}
	}
	
	/*~[Describe=ȡ��ȫѡObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function SelectedCancel(){
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a != ""){
				setItemValue(0,iMSR,"MultiSelectionFlag","");
			}
		}
	}
	
	/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function viewDetail()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));
			return;
		}else{
		
		}
		sSendMsg = getItemValue(0,getRow(),"SendMsg");
		sBackMsg = getItemValue(0,getRow(),"BackMsg");
		alert("������Ϣ:\r\n"+ sSendMsg + "\r\n ������Ϣ:\r\n"+sBackMsg);
	}
	
	/*~[Describe=;InputParam=��;OutPutParam=��;]~*/

	function deleteSelected()
	{
		var sSerialNoList = getItemValueArray(0,"SerialNo");
		if (sSerialNoList.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
		
		sReturn = PopPageAjax("/Common/Exchange/ExchangeLogDeleteActionAjax.jsp?SerialNoArray="+sSerialNoList,"","resizable=yes;dialogWidth=60;dialogHeight=30;center:yes;status:no;statusbar:no");
        if (typeof(sReturn)!="undefined"){
        	if (sReturn == "SUC"){
        		alert("ɾ���ɹ���");
        	}else{
        		alert("ɾ��ʧ�ܣ�");
        	}
        }else{
        	alert("ɾ��ʧ�ܣ�");
        }
		
		reloadSelf();
	}
		
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>

<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,"myiframe0");
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>