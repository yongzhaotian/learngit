<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cwliu 2004-11-29  ndeng 2004-11-30
		Tester:
		Describe: 相关票据信息
		Input Param:
			ObjectType: 对象类型
			ObjectNo:   对象编号
			SerialNo:	流水号
		Output Param:
			

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "相关票据信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获得组件参数

	String sObjectType  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sPerPutOutNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PerPutOutNo"));
	
	//获得页面参数	
	String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null ) sSerialNo = "";
	String sSql = "";
	String sInterSerialNo = "";
    String sAccountNo = "";
    String sGatheringName = "";
    String sAboutBankID = "";
    String sAboutBankName = "";
    boolean bIsHave = false;
    
	String sSqlNo = "select InterSerialNo,AccountNo,GatheringName,AboutBankID,AboutBankName from BILL_INFO where ObjectNo =:ObjectNo"+
                    " and ObjectType=:ObjectType and InputUserID=:InputUserID order by InterSerialNo DESC";
	SqlObject so = new SqlObject(sSqlNo);
	so.setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType).setParameter("InputUserID",CurUser.getUserID());
    ASResultSet rsNo = Sqlca.getResultSet(so);
    if (rsNo.next()) {
        bIsHave = true;
        sInterSerialNo = rsNo.getString("InterSerialNo");
        sAccountNo = rsNo.getString("AccountNo");
        sGatheringName = rsNo.getString("GatheringName");
        sAboutBankID = rsNo.getString("AboutBankID");
        sAboutBankName = rsNo.getString("AboutBankName");     
    }
    rsNo.getStatement().close();
    if(sAccountNo==null)sAccountNo="";
    if(sGatheringName==null)sGatheringName="";
    if(sAboutBankID==null)sAboutBankID="";
    if(sAboutBankName==null)sAboutBankName="";
   
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "AcceptBillInfo";
	//out.println(sTempletNo);
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo+","+sSerialNo);
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
		var sInterSerialNo = getItemValue(0,getRow(),"InterSerialNo");
		if (sInterSerialNo.length > 4) {
			alert("承兑汇票组内序号不能超过4位！");
			return;
		}

		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sBusinessSum = getItemValue(0,getRow(),"BillSum");
		if (sBusinessSum == null || sBusinessSum=="undefined" || sBusinessSum=="") {
			alert("票据金额未录入！");
			return;
		}
		<%
		if (sPerPutOutNo!=null) {
		%>
		sMessage = PopPage("/CreditManage/CreditApply/AcceptBillCheckSumAction.jsp?SerialNo="+sSerialNo+"&ObjectNo=<%=sPerPutOutNo%>&ObjectType=PutOutApply&BusinessSum="+sBusinessSum,"","");
		<%
		} else {
		%>
		sMessage = PopPage("/CreditManage/CreditApply/AcceptBillCheckSumAction.jsp?SerialNo="+sSerialNo+"&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&BusinessSum="+sBusinessSum,"","");		<%
		}
		%>

		if(typeof(sMessage)!="undefined" && sMessage!="") {
			alert(sMessage);
			return;
		}

		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditApply/AcceptBillList.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();
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
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
			setItemValue(0,0,"InterSerialNo","0001");
			<%
			if (sPerPutOutNo!=null) {
			%>
				setItemValue(0,0,"PerPutOutNo","<%=sPerPutOutNo%>");
			<%
			}
			%>
			<%
			if(bIsHave)
			{
			        //完成字符串到数字再到字符串的转换，保留数字位前的0
			        sInterSerialNo = "1" + sInterSerialNo;
			        int dInterSerialNo = Integer.parseInt(sInterSerialNo);
			        dInterSerialNo = dInterSerialNo + 1;
			        String sdInterSerialNo = String.valueOf(dInterSerialNo);
			        String ssdInterSerialNo = sdInterSerialNo.substring(1);
			%>
			    setItemValue(0,0,"InterSerialNo","<%=ssdInterSerialNo%>");
			    setItemValue(0,0,"AccountNo","<%=sAccountNo%>");
    			setItemValue(0,0,"GatheringName","<%=sGatheringName%>");
    			setItemValue(0,0,"AboutBankID","<%=sAboutBankID%>");
    			setItemValue(0,0,"AboutBankName","<%=sAboutBankName%>");
			<%
			}
			%>
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "BILL_INFO";//表名
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