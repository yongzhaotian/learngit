<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "处置中的资产信息列表";
	//获得页面参数
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sInOut = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InOut"));
	String sFlag="";
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sInOut == null) sInOut = "";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "AppDisposingList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if (sInOut.equals("In"))   //获取表内资产
		sFlag = "010";
	else								//获取表外资产
		sFlag = "020";

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sFlag+","+CurUser.getUserID());
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	String sButtons[][] = {
			{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath},
			{"true","","Button","处置终结","处置终结","PDADisposed()",sResourcesPath},	
			{"true","","Button","转表内","转表内","my_Intable()",sResourcesPath},
			{"true","","Button","转表外","转表外","my_Outtable()",sResourcesPath},
		};

	if (sInOut.equals("In"))  //表内资产只能转表外
		sButtons[2][0]="false";
	else							  //表外资产只能转表内
		sButtons[3][0]="false";
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	//---------------------定义按钮事件------------------------------------
	
	/*~[Describe=转表内信息;InputParam=无;OutPutParam=SerialNo;]~*/
	function my_Intable()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{			
			myFlag = getItemValue(0,getRow(),"Flag");
			if (myFlag == "020")
			{
				//弹出信息窗口,提示用户输入新的入账价值与待处理抵债资产科目余额
				var myReturn=popComp("PDAInOutSwitchDialog","/RecoveryManage/PDAManage/PDADailyManage/PDAInOutSwitchDialog.jsp","SerialNo="+sSerialNo+"&InOut=In","dialogWidth:600px;dialogheight:440px","");
				if (myReturn == "true") reloadSelf();
			}else
			{
				alert("该资产已经转入表内!");
			}
			reloadSelf();
		}
	}
	
	/*~[Describe=转表外信息;InputParam=无;OutPutParam=SerialNo;]~*/
	function my_Outtable()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			myFlag = getItemValue(0,getRow(),"Flag");
			if (myFlag == "010")
			{
				//弹出信息窗口,提示用户输入新的抵债时贷款余额与当前贷款余额
				var myReturn=popComp("PDAInOutSwitchDialog","/RecoveryManage/PDAManage/PDADailyManage/PDAInOutSwitchDialog.jsp","SerialNo="+sSerialNo+"&InOut=Out","dialogWidth:600px;dialogheight:440px","");
				if (myReturn == "true")	 reloadSelf();
			}else
			{
				alert("该资产已经转入表外!");
			}
			reloadSelf();
		}
	}
	
	
	//处置终结：自动设置AssetStatus状态和终结日期。
	function PDADisposed()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		//type=1 意味着从AppDisposingList中执行处置终结并且汇总。
		//type=2 意味着从PDADisposalEndList中察看汇总。
		//type=3 意味着从PDADisposalBookList中察看汇总。
        sReturn = popComp("PDADisposalEndInfo","/RecoveryManage/PDAManage/PDADailyManage/PDADisposalEndInfo.jsp","SerialNo="+sSerialNo+"&Type=1","dialogWidth:720px;dialogheight:580px","");
		reloadSelf();
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得抵债资产流水号、抵债资产类型
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");			
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		popComp("PDABasicView","/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp","ObjectNo="+sSerialNo,"");
		reloadSelf();
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>