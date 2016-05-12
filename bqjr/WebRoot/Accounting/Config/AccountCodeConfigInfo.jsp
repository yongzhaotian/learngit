<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String PG_TITLE = "示例详情页面"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//定义变量
	
	//获得组件参数
	
	//获得页面参数	
	String sBookType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BookType")); 
	String sItemNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ItemNo"));   
	if(sItemNo==null) sItemNo="";
	if(sBookType==null) sBookType="";
	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "AccountCodeConfigInfo";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sItemNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
			{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};

	%>

	<%@include file="/Resources/CodeParts/Info05.jsp"%>




	<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		AsControl.OpenView("/Accounting/Config/AccountCodeConfigList.jsp","BookType=<%=sBookType%>", "_self","");
	}


	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputOrg","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"InputTime","<%=SystemConfig.getBusinessTime()%>");
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=SystemConfig.getBusinessTime()%>");
		setItemValue(0,0,"UpdateDate","<%=SystemConfig.getBusinessDate()%>");
	}

	/*~[Describe=弹出机构选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectOrg(sOrgID,sOrgName)
	{
		setObjectValue("SelectAllOrg","","@"+sOrgID+"@0@"+sOrgName+"@1",0,0,"");		
	}
	
	
	function selectAllBookType(){
		//setMultiObjectTreeValue("SelectOIKOrgID","","@ItemAttribute@0@ItemAttributeName@1",0,0,"");
		setMultiObjectTreeValue("SelectAllBookType","","@BookType@0@BookTypeName@1",0,0,"");	
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			setItemValue(0,0,"CodeNo","AccountCodeConfig");
		}
    }

	function setMultiObjectTreeValue(sObjectType,sParaString,sValueString,iArgDW,iArgRow,sStyle)
	{
		if(typeof(sStyle)=="undefined" || sStyle=="") sStyle = "dialogWidth:700px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
		var iDW = iArgDW;
		if(iDW == null) iDW=0;
		var iRow = iArgRow;
		if(iRow == null) iRow=0;
	
		var sValues = sValueString.split("@");
	
		var i=sValues.length;
	 	i=i-1;
	 	if (i%2!=0)
	 	{
	 		alert("setObjectValue()返回参数设定有误!\r\n格式为:@ID列名@ID在返回串中的位置...");
		return;
	 	}else
		{	
			var treeValueList="";
			var j=i/2,m,sColumn,iID;	
			for(m=1;m<=j;m++)
			{
				sColumn = sValues[2*m-1];
				iID = parseInt(sValues[2*m],10);
				
				if(sColumn!="")
					treeValueList+=","+getItemValue(iDW,iRow,sColumn);
			}
			
			sObjectNoString =  selectMultipleTree(sObjectType,sParaString,sStyle,treeValueList);
			
			if(typeof(sObjectNoString)=="undefined" )
			{
				return;	
			}else if(sObjectNoString=="_CANCEL_"  )
			{
				return;
			}else if(sObjectNoString=="_CLEAR_")
			{
				for(m=1;m<=j;m++)
				{
					sColumn = sValues[2*m-1];
					if(sColumn!="")
						setItemValue(iDW,iRow,sColumn,"");
				}	
			}else if(sObjectNoString!="_NONE_" && sObjectNoString!="undefined")
			{
				sObjectNos = sObjectNoString.split("@");
				for(m=1;m<=j;m++)
				{
					sColumn = sValues[2*m-1];
					iID = parseInt(sValues[2*m],10);
					
					if(sColumn!="")
						setItemValue(iDW,iRow,sColumn,sObjectNos[iID]);
				}	
			}else
			{
				//alert("选取对象编号失败！对象类型："+sObjectType);
				return;
			}
			return sObjectNoString;
		}	
	}
	
	function selectMultipleTree(sObjectType,sParaString,sStyle,sValue)
	{
		if(typeof(sStyle)=="undefined" || sStyle=="") sStyle = "dialogWidth:680px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
		if(typeof(sValue)=="undefined" || sValue=="") sValue = "";
		sObjectNoString = AsControl.PopView("/Accounting/Config/MultiSelectTreeViewDialog.jsp","SelectedValue="+sValue+"&SelName="+sObjectType+"&ParaString="+sParaString,sStyle);
		return sObjectNoString;
	}
	
	</script>





<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	


<%@ include file="/IncludeEnd.jsp"%>
