<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --��ͬ����
			δ�õ��������ֶ���ʱ���أ������Ҫ��չʾ������
		Input Param:
        	TypeNo��    --���ͱ��
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	
	//���ҳ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("serialNo"));	
	String sType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));	
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("customerID"));	
	String ssSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ssSerialNo"));	
	String ssCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ssCustomerID"));
	if(ssSerialNo==null) ssSerialNo="";
	if(sCustomerID==null) sCustomerID="";
	if(sType==null) sType="";
	if(sSerialNo==null) sSerialNo="";
	if(ssCustomerID==null) ssCustomerID="";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
    String sTempletNo="";
    if(sType.equals("Access")){
    	sTempletNo="AccessTypeInfo";
    }else{
    	sTempletNo="ReturnTypeInfo";
    }
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if(sType.equals("Access")){
	    doTemp.setHTMLStyle("EventTime", "onChange=\"javascript:parent.getDoChange1()\" ");
	}else{
	    doTemp.setHTMLStyle("EventTime", "onChange=\"javascript:parent.getDoChange2()\" ");
	}
    doTemp.setHTMLStyle("ReturnTime", "onChange=\"javascript:parent.getDoChange()\" ");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>

<%/*~END~*/%>


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
			{"true","","Button","����","����","saveRecord()",sResourcesPath},
			{"true","","Button","����","����","saveRecordAndBack()",sResourcesPath}
		    };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurTypeNo=""; //��¼��ǰ��ѡ���еĴ����
    var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		var sRemarks=getItemValue(0,getRow(),"Remarks");
		var sReturnTime=getItemValue(0,getRow(),"ReturnTime");
		var sEventTime=getItemValue(0,getRow(),"EventTime");
		var sNewOrg=getItemValue(0,getRow(),"NewOrg");
		var sOldValue=getItemValue(0,getRow(),"OldValue");
    	if("<%=sType%>"=="Access"){
    		ssSerialNo="<%=ssSerialNo%>";
    		ssCustomerID="<%=ssCustomerID%>";
    		ssSerialNo=ssSerialNo.split(",");
    		ssCustomerID=ssCustomerID.split(",");
    		var sReturn=getDoChange();
    		if(typeof(sReturn)=="undefined" || sReturn.length==0) return;
    		var sReturn1=getDoChange1();
    		if(typeof(sReturn1)=="undefined" || sReturn1.length==0) return;
            for(var i=0;i<ssSerialNo.length;i++){
            	cSerialNo=getSerialNo("EVENT_INFO", "SerialNo", "");
            	RunMethod("GeInsert","GetInsertValue","'"+ssSerialNo[i]+"','"+ssCustomerID[i]+"','030','<%=CurOrg.orgID%>','<%=CurUser.getUserID()%>','"+sRemarks+"','"+sReturnTime+"','"+sEventTime+"','"+cSerialNo+"','"+sNewOrg+"','"+sOldValue+"'");
            	updateNumber(ssSerialNo[i]);
          	   
            }
    	  self.returnValue ="Success";
    	  self.close();
    	}else{
    		sSerialNo="<%=sSerialNo%>";
    		var sReturn1=getDoChange2();
    		if(typeof(sReturn1)=="undefined" || sReturn1.length==0) return;
    		bIsInsert = false;
    	    as_save("myiframe0");
    	    updateNumber(sSerialNo);
    	    self.returnValue ="Success";
    	}
		
	}
    function getDoChange(){
    	var sEventTime=getItemValue(0,getRow(),"EventTime");
    	var sReturnTime=getItemValue(0,getRow(),"ReturnTime");
    	if(sEventTime>sReturnTime){
    		alert("Ԥ�ڹ黹ʱ�䲻��С�ڵ���ʱ�䣡");
    		return;
    	}
    	return "succes";
    }
   
    function getDoChange1(){
    	var maxDate="1100/01/01";
    	ssSerialNo="<%=ssSerialNo%>";
    	ssSerialNo=ssSerialNo.split(",");
    	var sEventTime=getItemValue(0,getRow(),"EventTime");
 //   	var sContractNo=getItemValue(0,getRow(),"ContractNo");
        for(var i=0;i<ssSerialNo.length;i++){
        	var nowReturnTime=RunMethod("GetElement","GetElementValue","NOWRETURNDATE,business_contract,serialno='"+ssSerialNo[i]+"'");
        	if(maxDate<nowReturnTime){
        		maxDate=nowReturnTime;
        	}
        }
    	if(sEventTime<maxDate){
    		alert("����ʱ�䲻��С���ϴι黹ʱ�䣡");
    		return;
    	}
    	return "succes";
    }
    
    function getDoChange2(){
    	var sEventTime=getItemValue(0,getRow(),"EventTime");
    	var sContractNo=getItemValue(0,getRow(),"ContractNo");
    	var sAccessDate=RunMethod("GetElement","GetElementValue","ACCESSDATE,business_contract,serialno='"+sContractNo+"'");
    	if(sEventTime<sAccessDate){
    		alert("�黹ʱ�䲻��С�ڵ���ʱ�䣡");
    		return;
    	}
    	return "succes";
    }
    
    
    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndBack()
	{ 
    	top.close();
	}
    
	/*~[Describe=�����������Ψһ��;InputParam=;OutPutParam=�Ƿ��м�¼;]~*/
    function beforeSave()
    {
    	var sProductCategoryID  = getItemValue(0,getRow(),"ProductCategoryID");
		var sPara = "TypeNo=" + sProductCategoryID;
		var hasRecord =  RunJavaMethodSqlca("com.amarsoft.app.als.product.BusinessTypeUniqueCheck","insertUniqueCheck",sPara);
		if (hasRecord == "true"){
			return false;
		}
    }
    
    function updateNumber(sSerialNo){
    	var sAccessUserName = getItemValue(0,getRow(),"OldValue");//������/�黹��
    	var sAccessDate = getItemValue(0,getRow(),"EventTime");//����ʱ��/�黹ʱ��
    	var sRenturnDate = getItemValue(0,getRow(),"ReturnTime");//Ԥ�ڹ黹ʱ��
    	if(typeof(sAccessUserName)=="undefined" || sAccessUserName.length==0) sAccessUserName="";
    	if(typeof(sAccessDate)=="undefined" || sAccessDate.length==0) sAccessDate="";
    	if(typeof(sRenturnDate)=="undefined" || sRenturnDate.length==0) sRenturnDate="";
    	if("<%=sType%>"=="Access"){
    		RunMethod("ModifyNumber","GetModifyNumber","business_contract,AccessUserName='"+sAccessUserName+"',SerialNo='"+sSerialNo+"'");
    		RunMethod("ModifyNumber","GetModifyNumber","business_contract,AccessDate='"+sAccessDate+"',SerialNo='"+sSerialNo+"'");
    		RunMethod("ModifyNumber","GetModifyNumber","business_contract,RenturnDate='"+sRenturnDate+"',SerialNo='"+sSerialNo+"'");
    	}else{
    		RunMethod("ModifyNumber","GetModifyNumber","business_contract,ReturnUserName='"+sAccessUserName+"',SerialNo='"+sSerialNo+"'");
    		RunMethod("ModifyNumber","GetModifyNumber","business_contract,NowReturnDate='"+sAccessDate+"',SerialNo='"+sSerialNo+"'");
    	}
    }

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">	
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			if("<%=sType%>"=="Access"){
				setItemValue(0,0,"Type", "030");
			}else{
				setItemValue(0,0,"Type", "040");
			}
			
			setItemValue(0,0,"ContractNo", "<%=sSerialNo%>");
			setItemValue(0,0,"SerialNo", getSerialNo("EVENT_INFO", "SerialNo", ""));
			setItemValue(0,0,"InputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"InputOrg", "<%=CurOrg.orgID%>");
			setItemValue(0,0,"CustomerID", "<%=sCustomerID%>");
			setItemValue(0,0,"InputUser", "<%=CurUser.getUserID()%>");
//			setItemValue(0,0,"InputUserName", "<%=CurUser.getUserName()%>");
//			setItemValue(0,0,"EventTime", "<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
