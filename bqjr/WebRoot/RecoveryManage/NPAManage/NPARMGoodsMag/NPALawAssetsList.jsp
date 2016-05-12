<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "查封资产列表";
	String sSql = "";
	String sItemID = "";  
	String sWhereCondition = "";
	
	
	//获得组件参数
	String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType")); 
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo")); 
	String sCurItemID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CurItemID")); 
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sCurItemID == null) sCurItemID = "";
	if(sFinishType == null) sFinishType = "";
	
	if(sCurItemID.equals("075010")) //未退出查封的资产
		sItemID="020";
	else if(sCurItemID.equals("075020")) //已退出查封的资产
		sItemID="030";
	String sTempletNo="";
	if(sItemID.equals("020"))
	{
		sTempletNo = "020_NPALawAssetsList";//未退出查封的资产
	}
	
	if(sItemID.equals("030"))
	{
		sTempletNo = "030_NPALawAssetsList";//已退出查封的资产
	}
	
	//通过DW模型产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo+","+sCurItemID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {			
			{"true","","Button","详情","查看详情","viewAndEdit()",sResourcesPath},
			{sFinishType.equals("")?"true":"false","","Button","退出查封","退出查封资产信息","quitRecord()",sResourcesPath}
			};
			
		if(sItemID.equals("030"))
		{
			sButtons[1][0] = "false";
		}
	
		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得记录流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		var sItemID = "<%=sItemID%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		if(sItemID=="030")
		{
			popComp("NPALawAssetsView","/RecoveryManage/NPAManage/NPARMGoodsMag/NPALawAssetsView.jsp","ObjectNo="+sSerialNo,"");
		}
		else
		{
			popComp("NPALawAssetsView","/RecoveryManage/NPAManage/NPARMGoodsMag/NPALawAssetsView.jsp","ObjectNo="+sSerialNo,"");
		}
	
	}
	
	/*~[Describe=退出查封;InputParam=无;OutPutParam=SerialNo;]~*/
	function quitRecord()
	{
		//获得记录流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		if(confirm(getBusinessMessage("774"))) //该查封资产真的要退出查封吗？
		{
			var sReturn = RunMethod("PublicMethod","UpdateColValue","String@AssetStatus@02,ASSET_INFO,String@SerialNo@"+sSerialNo);
			if(sReturn == "TRUE") //刷新页面
			{
				alert(getBusinessMessage("775"));//该查封资产已成功退出查封！
				reloadSelf();
			}else
			{
				alert(getBusinessMessage("776")); //该查封资产退出查封失败！
				return;
			}
		}
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