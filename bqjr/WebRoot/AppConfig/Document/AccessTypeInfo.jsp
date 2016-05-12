<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --合同调阅
			未用到的属性字段暂时隐藏，如果需要请展示出来。
		Input Param:
        	TypeNo：    --类型编号
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	
	//获得页面参数
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


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "合同调阅"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
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
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>

<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
			{"true","","Button","保存","保存","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回","saveRecordAndBack()",sResourcesPath}
		    };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
    var sCurTypeNo=""; //记录当前所选择行的代码号
    var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
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
    		alert("预期归还时间不能小于调阅时间！");
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
    		alert("调阅时间不能小于上次归还时间！");
    		return;
    	}
    	return "succes";
    }
    
    function getDoChange2(){
    	var sEventTime=getItemValue(0,getRow(),"EventTime");
    	var sContractNo=getItemValue(0,getRow(),"ContractNo");
    	var sAccessDate=RunMethod("GetElement","GetElementValue","ACCESSDATE,business_contract,serialno='"+sContractNo+"'");
    	if(sEventTime<sAccessDate){
    		alert("归还时间不能小于调阅时间！");
    		return;
    	}
    	return "succes";
    }
    
    
    /*~[Describe=返回;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndBack()
	{ 
    	top.close();
	}
    
	/*~[Describe=检验插入数据唯一性;InputParam=;OutPutParam=是否有记录;]~*/
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
    	var sAccessUserName = getItemValue(0,getRow(),"OldValue");//调阅人/归还人
    	var sAccessDate = getItemValue(0,getRow(),"EventTime");//调阅时间/归还时间
    	var sRenturnDate = getItemValue(0,getRow(),"ReturnTime");//预期归还时间
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


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">	
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
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


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
