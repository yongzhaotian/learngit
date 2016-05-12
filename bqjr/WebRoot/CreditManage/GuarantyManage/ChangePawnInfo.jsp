<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zywei 2005-12-15
		Tester:
		Describe: 抵押物信息变更;
		Input Param:
			SerialNo: 变更流水号
			GuarantyID:抵押物流水号
			ChangeType: 变更类型
				010 价值变更
				020 其他变更
				030 他项权证变更
		Output Param:
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵押物信息变更"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数
	String sGuarantyID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GuarantyID"));
	if (sGuarantyID == null) sGuarantyID = "";
	String sChangeType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ChangeType"));
	if (sChangeType == null) sChangeType = "";
	
	//获得页面参数
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if (sSerialNo == null) sSerialNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//根据ChangeType的不同，得到不同的过滤条件
    String sTempletFilter = " (ColAttribute like '%"+sChangeType+"%' ) ";

	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject("PawnChangeInfo",sTempletFilter,Sqlca);
	
	   //设置一些必输项
    if(sChangeType.equals("010"))
    {
    	doTemp.setRequired("NewEvalOrgName,NewEvalNetValue,NewConfirmValue",true);
    }
    else if(sChangeType.equals("020"))
    {
    	doTemp.setRequired("NewCertType,NewCertID,NewOwnerName",true);
    } 

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//设置setEvent
	dwTemp.setEvent("AfterInsert","!BusinessManage.UpdateGuarantyChangeInfo(#GuarantyID,#SerialNo,"+sChangeType+")+!CustomerManage.AddCustomerInfo(#NewOwnerID,#NewOwnerName,#NewCertType,#NewCertID,#NewLoanCardNo,#InputUserID)");
	dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateGuarantyChangeInfo(#GuarantyID,#SerialNo,"+sChangeType+")+!CustomerManage.AddCustomerInfo(#NewOwnerID,#NewOwnerName,#NewCertType,#NewCertID,#NewLoanCardNo,#InputUserID)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
			{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		//录入数据有效性检查
		if (!ValidityCheck()) return;
		if(bIsInsert){		
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	function selectNewEvalOrgName()
	{
		
		setObjectValue("selectNewEvalOrgName","","@NewEvalOrgName@0",0,0,"");
	}
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/GuarantyManage/ChangePawnList.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{
		//返回客户的相关信息、客户代码、客户名称、证件类型、客户证件号码、贷款卡编号
		var sReturn = "";
		if(typeof(sCertType)!="undefined"&&sCertType!=""){
			sParaString = "CertType,"+sCertType;
			sReturn = setObjectValue("SelectOwner",sParaString,"@NewOwnerID@0@NewOwnerName@1@NewCertType@2@NewCertID@3@NewLoanCardNo@4",0,0,"");
		}else{
			sParaString = "CertType, ";
			sReturn = setObjectValue("SelectOwner",sParaString,"@NewOwnerID@0@NewOwnerName@1@NewCertType@2@NewCertID@3@NewLoanCardNo@4",0,0,"");
		}	
		var sCertID = getItemValue(0,0,"NewCertID");
		if( String(sReturn)==String("_CLEAR_") ){
            setItemDisabled(0,0,"NewCertType",false);
            setItemDisabled(0,0,"NewCertID",false);
            setItemDisabled(0,0,"NewOwnerName",false);
            setItemDisabled(0,0,"NewLoanCardNo",false);
		}else if( String(sReturn)!=String("_CLEAR_") && typeof(sCertID) != "undefined" && sCertID != "" ){
            setItemDisabled(0,0,"NewCertType",true);
            setItemDisabled(0,0,"NewCertID",true);
            setItemDisabled(0,0,"NewOwnerName",true);
            var certType = getItemValue(0,0,"NewCertType");
            var temp = certType.substring(0,3);
            if(temp=='Ent'){
            	setItemRequired(0,0,"NewLoanCardNo",true);
            	 setItemDisabled(0,0,"NewLoanCardNo",true);
            }
            else{
            	setItemRequired(0,0,"NewLoanCardNo",false);
            	 setItemDisabled(0,0,"NewLoanCardNo",false);
            }
            sCertType="";
        }
		}
	var sCertType="";
	/*~[Describe=根据证件类型和证件编号获得客户编号、客户名称和贷款卡编号;InputParam=无;OutPutParam=无;]~*/
	function getCustomerName()
	{
		sCertType   = getItemValue(0,getRow(),"NewCertType");
		var sCertID   = getItemValue(0,getRow(),"NewCertID");
		
		if(typeof(sCertType) != "undefined" && sCertType != "" && 
		typeof(sCertID) != "undefined" && sCertID != "")
		{
			//获得客户编号、客户名称和贷款卡编号
	        var sColName = "CustomerID@CustomerName@LoanCardNo";
			var sTableName = "CUSTOMER_INFO";
			var sWhereClause = "String@CertID@"+sCertID+"@String@CertType@"+sCertType;
			
			sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{			
				sReturn = sReturn.split('~');
				var my_array1 = new Array();
				for(i = 0;i < sReturn.length;i++)
				{
					my_array1[i] = sReturn[i];
				}
				
				for(j = 0;j < my_array1.length;j++)
				{
					sReturnInfo = my_array1[j].split('@');	
					var my_array2 = new Array();
					for(m = 0;m < sReturnInfo.length;m++)
					{
						my_array2[m] = sReturnInfo[m];
					}
					
					for(n = 0;n < my_array2.length;n++)
					{									
						//设置客户ID
						if(my_array2[n] == "customerid")
							setItemValue(0,getRow(),"NewOwnerID",sReturnInfo[n+1]);
						//设置客户名称
						if(my_array2[n] == "customername")
							setItemValue(0,getRow(),"NewOwnerName",sReturnInfo[n+1]);
						//设置贷款卡编号
						if(my_array2[n] == "loancardno") 
						{
							if(sReturnInfo[n+1] != 'null')
								setItemValue(0,getRow(),"NewLoanCardNo",sReturnInfo[n+1]);
							else
								setItemValue(0,getRow(),"NewLoanCardNo","");
						}
					}
				}			
			}else
			{
				setItemValue(0,getRow(),"NewOwnerID","");
				setItemValue(0,getRow(),"NewOwnerName","");	
				setItemValue(0,getRow(),"NewLoanCardNo","");			
			} 
		}		
	}
	
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{			
		//检查证件编号是否符合编码规则
		sNewCertType = getItemValue(0,0,"NewCertType");//--证件类型		
		sNewCertID = getItemValue(0,0,"NewCertID");//证件代码
		
		if(typeof(sNewCertType) != "undefined" && sNewCertType != "" )
		{
			//判断组织机构代码合法性
			if(sNewCertType =='Ent01')
			{
				if(typeof(sNewCertID) != "undefined" && sNewCertID != "" )
				{
					if(!CheckORG(sNewCertID))
					{
						alert(getBusinessMessage('102'));//组织机构代码有误！						
						return false;
					}
				}
			}
				
		
		}
		
		//校验新权利人贷款卡编号
		sNewLoanCardNo = getItemValue(0,getRow(),"NewLoanCardNo");//新权利人贷款卡编号	
		if(typeof(sNewLoanCardNo) != "undefined" && sNewLoanCardNo != "" )
		{
			if(!CheckLoanCardID(sNewLoanCardNo))
			{
				alert(getBusinessMessage('237'));//新权利人贷款卡编号有误！							
				return false;
			}
			
			//检验新权利人贷款卡编号唯一性
			sNewOwnerName = getItemValue(0,getRow(),"NewOwnerName");//新权利人名称	
			sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sNewOwnerName+","+sNewLoanCardNo);
			if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
			{
				alert(getBusinessMessage('238'));//该新权利人贷款卡编号已被其他客户占用！							
				return false;
			}						
		}
			
		//检查输入的新权利人是否建立信贷关系，如果未建立，需要新获取新权利人的客户编号
		if(typeof(sNewCertType) != "undefined" && sNewCertType != "" 
		&& typeof(sNewCertID) != "undefined" && sNewCertID != "")
		{
			var sNewOwnerID = PopPageAjax("/PublicInfo/CheckCustomerActionAjax.jsp?CertType="+sNewCertType+"&CertID="+sNewCertID,"","");
			if (typeof(sNewOwnerID)=="undefined" || sNewOwnerID.length==0) {
				return false;
			}
			setItemValue(0,0,"NewOwnerID",sNewOwnerID);
		}			
		
		return true;
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0) == 0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"GuarantyID","<%=sGuarantyID%>");
			setItemValue(0,0,"ChangeType","<%=sChangeType%>");
			setItemValue(0,0,"ChangeDate","<%=StringFunction.getToday()%>");
<%
		ASResultSet rs=Sqlca.getASResultSet(new SqlObject("select * from GUARANTY_INFO where GuarantyID=:GuarantyID").setParameter("GuarantyID",sGuarantyID));
		if(rs.next())
		{ 
			String sEvalOrgID = DataConvert.toString(rs.getString("EvalOrgID"));
			String sEvalOrgName = DataConvert.toString(rs.getString("EvalOrgName"));
			String sEvalNetValue = DataConvert.toMoney(DataConvert.toString(rs.getString("EvalNetValue")));
			String sConfirmValue = DataConvert.toMoney(DataConvert.toString(rs.getString("ConfirmValue")));
			String sOwnerID = DataConvert.toString(rs.getString("OwnerID"));
			String sOwnerName = DataConvert.toString(rs.getString("OwnerName"));
			String sCertType = DataConvert.toString(rs.getString("CertType"));
			String sCertID = DataConvert.toString(rs.getString("CertID"));
			String sLoanCardNo = DataConvert.toString(rs.getString("LoanCardNo"));
			//将空值转化为空字符串
			if(sEvalOrgID == null) sEvalOrgID = "";
			if(sEvalOrgName == null) sEvalOrgName = "";
			if(sEvalNetValue == null) sEvalNetValue = "";
			if(sConfirmValue == null) sConfirmValue = "";
			if(sOwnerID == null) sOwnerID = "";
			if(sOwnerName == null) sOwnerName = "";
			if(sCertType == null) sCertType = "";
			if(sCertID == null) sCertID = "";
			if(sLoanCardNo == null) sLoanCardNo = "";
%>
			setItemValue(0,0,"OldEvalOrgID","<%=sEvalOrgID%>");
			setItemValue(0,0,"OldEvalOrgName","<%=sEvalOrgName%>");
			setItemValue(0,0,"OldEvalNetValue","<%=sEvalNetValue%>");
			setItemValue(0,0,"OldConfirmValue","<%=sConfirmValue%>");
			setItemValue(0,0,"OldOwnerID","<%=sOwnerID%>");
			setItemValue(0,0,"OldOwnerName","<%=sOwnerName%>");
			setItemValue(0,0,"OldCertType","<%=sCertType%>");
			setItemValue(0,0,"OldCertID","<%=sCertID%>");
			setItemValue(0,0,"OldLoanCardNo","<%=sLoanCardNo%>");
<%
		}
		rs.getStatement().close(); 
%>
			bIsInsert = true;
		}
		
    }

	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "GUARANTY_CHANGE";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),"SerialNo",sSerialNo);
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化

</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

