<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   bwang
		Tester:
		Content: ���õȼ�����������Ϣ
		Input Param:
		
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���õȼ�����������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>	
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//����������	���������͡��������͡��׶����͡����̱�š��׶α�š������š��ͻ���š�ģ�ͱ��
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	String sObjectNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sCustomerID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sModelType   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelType"));
	
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	if(sCustomerID == null ) sCustomerID="";
	if(sObjectNo == null ) sObjectNo="";
	if (sModelType==null) 
		sModelType = "010"; //ȱʡģ������Ϊ"���õȼ�����"

	
	//���������SQL���
	String sSql = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "EvaluateApplyCreateInfo";
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
    
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
		{"true","","Button","��һ��","�������Ŷ���������һ��","nextStep()",sResourcesPath},
		{"true","","Button","ȡ��","ȡ���������Ŷ������","doCancel()",sResourcesPath}		
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">	
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer(){
		sCustomerType = getItemValue(0,0,"CustomerType");
		if(typeof(sCustomerType) == "undefined" || sCustomerType == ""){
			alert("����ѡ��ͻ�����!");
			return;
		}
		//����ҵ�����Ȩ�Ŀͻ���Ϣ
		sParaString = "UserID"+","+"<%=CurUser.getUserID()%>"+","+"CustomerType"+","+sCustomerType;
		// ��˾�����š����˵����õȼ�������Ҫ��ͬ�Ĺ��˲�����
		if(sCustomerType == "01") {
			setObjectValue("SelectApplyCustomer4",sParaString,"@CustomerID@0@CustomerName@1@SubCustomerType@2",0,0,"");
		}else if (sCustomerType == "02") {
			setObjectValue("SelectApplyCustomer2",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
		}else if (sCustomerType == "03") {
			setObjectValue("SelectApplyCustomer6",sParaString,"@CustomerID@0@CustomerName@1@SubCustomerType@2",0,0,"");
		}
	}
	
	/*~[Describe=��һ��;InputParam=��;OutPutParam=��;]~*/
	function nextStep(){
		var sCustomerID = getItemValue(0,0,"CustomerID");
		var sCustomerType = getItemValue(0,0,"CustomerType");
		var sSubCustomerType = getItemValue(0,0,"SubCustomerType");
		//ȷ���Ǹ��˻��ǹ�˾�ͻ������õȼ�����
		if(sCustomerType == "03" && sSubCustomerType == "0310"){   
			//���Ϊ���˿ͻ��������õȼ�����������Ϊ"�������õȼ�����"��ModelType = "015" add by cbsu 2009-11-04
		 	sModelType = "015";
		}else if (sCustomerType == "03" && sSubCustomerType == "0320"){
			//���Ϊ���徭Ӫ���������õȼ�����������Ϊ"���徭Ӫ�����õȼ�����"��ModelType = "017" add by cbsu 2009-11-04
			sModelType = "017";
		}else if (sCustomerType == "01" && sSubCustomerType == "0120"){
			//���Ϊ��С��ҵ�������õȼ�����������Ϊ"��С��ҵ���õȼ�����"��ModelType = "012" add by cbsu 2009-11-04
			sModelType = "012";
		}else {
			sModelType = "<%=sModelType%>";
		}
		
		var stmp = CheckRole();
		if(typeof(sCustomerType) == "undefined" || sCustomerType == ""){
			alert("����ѡ��ͻ�����!");
			return;
		}
		if(typeof(sCustomerID) == "undefined" || sCustomerID == ""){
			alert("����ѡ��ͻ�!");
			return;
		}
		//������ʽ
		if("true"==stmp){
	   		sReturn = PopPage("/Common/Evaluate/AddEvaluateMessage.jsp?Action=display&ObjectType=<%=sObjectType%>&ObjectNo="+sCustomerID+"&ModelType="+sModelType+"&EditRight=100","","dialogWidth:550px;dialogHeight:350px;resizable:yes;scrollbars:no");
	   		if(sReturn==null || sReturn=="" || sReturn=="undefined") return;
	   		sReturns = sReturn.split("@");
	   		sObjectType = sReturns[0];
	   		sObjectNo = sReturns[1];
	   		sModelType = sReturns[2];
	   		sModelNo = sReturns[3];
	   		sAccountMonth = sReturns[4];
	   		sReportScope = sReturns[5];  //ʵ�ֶ�ھ���Ҫ���ϱ���ھ����������
	   		sReturn=PopPage("/Common/Evaluate/ConsoleEvaluateAction.jsp?Action=add&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ModelType="+sModelType+"&ModelNo="+sModelNo+"&AccountMonth="+sAccountMonth+"&ReportScope="+sReportScope,"","dialogWidth=20;dialogHeight=20;resizable=yes;center:no;status:no;statusbar:no");
	   		if (typeof(sReturn) != "undefined" && sReturn.length>=0 && sReturn == "EXIST"){
	   			alert(getBusinessMessage('189'));//�������õȼ�������¼�Ѵ��ڣ���ѡ�������·ݣ�
	   			return;
	   		}
	   		if(typeof(sReturn) != "undefined" && sReturn.length>=0 && sReturn != "failed"){
	   			var sEditable="true";
				OpenComp("EvaluateDetail","/Common/Evaluate/EvaluateDetail.jsp","Action=display&CustomerID="+sCustomerID+"&ObjectType=<%=sObjectType%>&ObjectNo="+sObjectNo+"&SerialNo="+sReturn+"&Editable="+sEditable,"_blank",OpenStyle);
	   		}
	   	    top.close();
   	    }else{
	        alert(getBusinessMessage('190'));//�Բ�����û�����õȼ�������Ȩ�ޣ�
	    }
    }
    /*~[Describe=ȡ��;InputParam=��;OutPutParam=��;]~*/
    function doCancel(){		
		top.close();
	}
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){ //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//����һ���ռ�¼			
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");	
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");	
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");		
			setItemValue(0,0,"CustomerType","01");	
		}
    }
	
	function CheckRole(){
	    var sCustomerID = getItemValue(0,0,"CustomerID");
		var sReturn = RunMethod("CustomerManage","CheckRolesAction",sCustomerID+",<%=CurUser.getUserID()%>");
        if (typeof(sReturn)=="undefined" || sReturn.length==0){
        	return n;
        }
        var sReturnValue = sReturn.split("@");
        sReturnValue1 = sReturnValue[0];        //�ͻ�����Ȩ
        sReturnValue2 = sReturnValue[1];        //��Ϣ�鿴Ȩ
        sReturnValue3 = sReturnValue[2];        //��Ϣά��Ȩ
        sReturnValue4 = sReturnValue[3];        //ҵ�����Ȩ

        if(sReturnValue3 =="Y2")
            return "true";
        else
            return "n";
	}	
	/*~[Describe=�����Ϣ;InputParam=��;OutPutParam=������ˮ��;]~*/
	function clearData(){
		setItemValue(0,0,"CustomerID","");
		setItemValue(0,0,"CustomerName","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();	
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��	
	var bCheckBeforeUnload=false;	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>