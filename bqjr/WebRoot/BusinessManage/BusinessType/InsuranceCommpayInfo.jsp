<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --产品管理详情
			未用到的属性字段暂时隐藏，如果需要请展示出来。
		Input Param:
        	TypeNo：    --类型编号
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "新增保险公司产品配置"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得页面参数,产品编号
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sFlag =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("sFlag"));

	if(sSerialNo == null) sSerialNo = "";
	if(sFlag == null) sFlag = "";


	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	ASDataObject doTemp = new ASDataObject("InsuranceCommpayInfo",Sqlca);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写


	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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
			{"true","","Button","保存","保存Detail","saveDetailRecord()",sResourcesPath},
			{"true","","Button","保存","保存Add","saveAddRecord()",sResourcesPath},

		    };
	if("Add".equals(sFlag)){
		sButtons[0][0]="false";		
	}else if("Detail".equals(sFlag)){
		sButtons[1][0]="false";		
	}
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
	function saveDetailRecord()
	{
    	var SerialNo = getItemValue(0,0,"SerialNo"); //保险公司编号
    	if(checkServiceProvidersType(SerialNo)){
    		alert("您输入的保险公司和保险产品已存在");
    		return;
    	}
	    as_save("myiframe0");
	}

    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveAddRecord(){	
		if(checkServiceProvidersType("")){
    		alert("您输入的保险公司和保险产品已存在");
    		return;
    	}
	    var sReturn = as_save("myiframe0");
        if(sReturn == undefined){
    	     return;
        } else{
    	    self.close();
        }	
	}
    
		/**
		 * 校验保险公司和保险产品是否已存在 [true:已存在，false：非存在]
		 */
		function checkServiceProvidersType(SerialNo) {
			var type = getItemValue(0, 0, "ServiceProvidersType"); //保险公司名称
			var name = getItemValue(0, 0, "ServiceProvidersName"); //保险产品名称


		var count = "1";
			if (SerialNo == "") {
				count = RunMethod("公用方法", "GetColValue", "bq_insurance_info,count(1),INS_NAME='" + type + "' and INS_SERVICEPROVIDERSNAME='" + name + "'");
			} else {
				count = RunMethod("公用方法", "GetColValue", "bq_insurance_info,count(1),INS_NAME='" + type + "' and INS_SERVICEPROVIDERSNAME='" + name + "' and INS_SERIALNO <> '" + SerialNo + "'");
			}
			
			
			if (count == "0.0") {
				return false;
			}
			return true;
		}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"CreditAttribute", "0002");
			setItemValue(0,0,"CustomerType1", "09");
			setItemValue(0,0,"SerialNo", "<%=sSerialNo%>");
			setItemValue(0,0,"insId", "<%=sSerialNo%>");
			setItemValue(0,0,"InputUserID", "<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputDate", "<%=StringFunction.getToday()%>");
			setItemValue(0,0,"InputOrgID", "<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputUserIDName", "<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgIDName", "<%=CurOrg.getOrgName()%>");
			bIsInsert = true;
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	var bCheckBeforeUnload = false;
	my_load(2,0,'myiframe0');
	initRow();
	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
