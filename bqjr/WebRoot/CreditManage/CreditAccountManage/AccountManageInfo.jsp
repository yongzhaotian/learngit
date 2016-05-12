<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   qfang 2011-06-02 
		Tester:
		Content:   账户管理详情	
		Input Param:	
 		Output param:                
		History Log:            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "账户管理详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
	//获得组件参数:账号
	String sAccount =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Account"));
	String readOnly =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReadOnly"));
	if(sAccount==null) sAccount = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "AccountManageInfo"; //模版编号
	String sTempletFilter = "1=1"; //列过滤器，注意不要和数据过滤器混
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
    if(!sAccount.equals(""))
    {
    	doTemp.setReadOnly("Account,IsOwnBank",true);	
    }
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sAccount);
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
			{"y".equalsIgnoreCase(readOnly)?"true":"false","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"false","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		    };
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>	
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=无;OutPutParam=无;]~*/
	function saveRecord()
	{
		if(bIsInsert){
			if (!ValidityCheck()){
				return;
			}else{
				as_save("myiframe0");
			}
		}else
		{
			alert("账户详情不可修改");
		}
	}

    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function goBack(){
        self.close();
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	function initRow(){
		
		
		
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录			
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>")
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"AccountSource","020");
			bIsInsert = true;
		}
	}

	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{
		//返回客户的相关信息、客户代码、客户名称		
		sReturn = setObjectValue("SelectOrgCustomer","","@CustomerID@0@CustomerName@1",0,0,"");
		if(sReturn == "_CLEAR_"){
			setItemDisabled(0,0,"CustomerID",false);
			setItemDisabled(0,0,"CustomerName",false);
		}else{
			//防止用户点开后，什么也不选择，直接取消，而锁住这几个区域
			sCustomerID = getItemValue(0,0,"CustomerID");
			if(typeof(sCertID) != "undefined" && sCertID != ""){
				setItemDisabled(0,0,"CustomerID",false);
				setItemDisabled(0,0,"CustomerName",false);
			}else{
				setItemDisabled(0,0,"CustomerID",false);
				setItemDisabled(0,0,"CustomerName",false);
			}
		}
	}

	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck(){
		sAccount = getItemValue(0,getRow(),"Account");//账号
		//检查账户的有效性
		if (sAccount.length > 0)
		{
			var Letters = "#";
			//检查字符串中是否存在"#"字符
			if (!(sAccount.indexOf(Letters) == -1))
			{			        
				alert("输入的账号有误，请重新输入账号");
				return false;
			}
		}		
		//检查账户的唯一性
		sReturn=RunMethod("BusinessManage","CheckAccountChangeCustomer",sAccount);

		if(typeof(sReturn) != "undefined" && sReturn == "false")
		{
			alert("账户已经登记");
			return false;
		}else
		return true;
		
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
