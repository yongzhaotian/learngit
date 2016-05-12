<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   slliu 2004.11.22
		Tester:
		Content: 查封资产台帐信息
		Input Param:
			    SerialNo：查封资产编号
				ObjectNo：对象编号或案件编号
				ObjectType：对象类型
				sBookType：台帐类型			       
		Output param:
		               
		History Log: zywei 2005/09/06 重检代码
		                 
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "查封资产台帐信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	String sRecoveryUserID = "";
	String sRecoveryUserName = "";
	String sAmbientName = "";
	String sPropertyOrg = "";
	ASResultSet rs = null;
	
	//获得页面参数
	//记录流水号、案件编号、对象类型、台帐类型
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PageSerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sBookType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BookType"));
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sBookType == null) sBookType = "";
		
	//获得不良资产的管户人，自动默认为查封资产的不良管户人
	sSql = " select BC.RecoveryUserID as RecoveryUserID,getUserName(BC.RecoveryUserID) as RecoveryUserName "+
		   " from BUSINESS_CONTRACT BC,LAWCASE_INFO LI,LAWCASE_RELATIVE LR "+
		   " where BC.Serialno=LR.ObjectNo "+
		   " and LR.ObjectType='BusinessContract' "+
		   " and LR.Serialno = :Serialno ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("Serialno",sObjectNo));	
	if(rs.next()){
		sRecoveryUserID = DataConvert.toString(rs.getString("RecoveryUserID"));
		sRecoveryUserName = DataConvert.toString(rs.getString("RecoveryUserName"));
	}
	//将空值转化为空字符串
	if(sRecoveryUserID == null) sRecoveryUserID = "";
	if(sRecoveryUserName == null) sRecoveryUserName = "";
	
	rs.getStatement().close();
	
	//获得案件对应的最新查封资产的法律文书号、查封资产所有人等，以作为下笔查封资产的默认值
	sSql = 	" select AmbientName,PropertyOrg "+
			" from ASSET_INFO "+
			" where ObjectNo = :ObjectNo1 "+
			" and ObjectType=:ObjectType1 "+
			" and Serialno = (select  max(Serialno) from ASSET_INFO where ObjectNo = :ObjectNo2 and  ObjectType=:ObjectType2)";
	SqlObject so = new SqlObject(sSql).setParameter("ObjectNo1",sObjectNo).setParameter("ObjectType1",sObjectType)
	.setParameter("ObjectNo2",sObjectNo).setParameter("ObjectType2",sObjectType);				
	rs = Sqlca.getASResultSet(so);
	if(rs.next()){
		sAmbientName = DataConvert.toString(rs.getString("AmbientName"));
		sPropertyOrg = DataConvert.toString(rs.getString("PropertyOrg"));	 
	}
	//将空值转化为空字符串
	if(sAmbientName == null) sAmbientName = "";
	if(sPropertyOrg == null) sPropertyOrg = "";
	
	rs.getStatement().close();
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "LawsuitInfo";
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//选择现机构及人员
	doTemp.setUnit("OperateUserName"," <input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectUser(\""+CurOrg.getOrgID()+"\",\"OperateUserID\",\"OperateUserName\",\"OperateOrgID\",\"OperateOrgName\")>");
	//字符串输整数		
	 doTemp.appendHTMLStyle("LandownerNo"," onkeyup=\"value=value.replace(/[^0-9]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;,clipboardData.getData(&quot;text&quot;).replace(/[^0-9]/g,&quot;&quot;))\" ");

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
	
	if(!(sBookType.equals("112")))  //从不良资产信息列表进入查看查封资产信息
	{
		
		sButtons[0][0]="false";
		
	}
		
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
		if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;			
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawsuitAssetsList.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">
	
	/*~[Describe=弹出用户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectUser(sParam,sUserID,sUserName,sOrgID,sOrgName)
	{		
		sParaString = "BelongOrg"+","+sParam;
		setObjectValue("SelectUserBelongOrg",sParaString,"@"+sUserID+"@0@"+sUserName+"@1@"+sOrgID+"@2@"+sOrgName+"@3",0,0,"");
	}	
	
	/*~[Describe=执行新增操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
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

	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			
			//资产属性为查封资产、状态为未退出查封
			setItemValue(0,0,"AssetAttribute","02");
			setItemValue(0,0,"AssetStatus","01");  
			
			//对象编号、对象类型
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			
			//法律文书号、查封资产所有人
			setItemValue(0,0,"AmbientName","<%=sAmbientName%>");
			setItemValue(0,0,"PropertyOrg","<%=sPropertyOrg%>");
			
			//查封资产管户机构、管户人
			setItemValue(0,0,"OperateUserID","<%=sRecoveryUserID%>");
			setItemValue(0,0,"OperateUserName","<%=sRecoveryUserName%>");
		
			//登记人、登记人名称、登记机构、登记机构名称
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			
			//登记日期						
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		}	
		var sColName = "LawCaseName"+"~";
		var sTableName = "LAWCASE_INFO"+"~";
		var sWhereClause = "String@SerialNo@"+<%=sObjectNo%>+"~";
		
		sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{			
			sReturn = sReturn.split('~');
			var my_array = new Array();
			for(i = 0;i < sReturn.length;i++)
			{
				my_array[i] = sReturn[i];
			}
			
			for(j = 0;j < my_array.length;j++)
			{
				sReturnInfo = my_array[j].split('@');				
				if(typeof(sReturnInfo) != "undefined" && sReturnInfo != "")
				{					
					if(sReturnInfo[0] == "lawcasename" && sReturnInfo[1]!="null")//@jlwu当没有输入案件名称时避免出现null
					{
						setItemValue(0,getRow(),"LawCaseName",sReturnInfo[1]);
						break;
					}else if(sReturnInfo[0] == "lawcasename" && sReturnInfo[1]=="null")
					{
						setItemValue(0,getRow(),"LawCaseName","");
						break;
					}					
				}
				
					
			}			
		}			
    }	

	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{		
		var sTableName = "ASSET_INFO";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
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

