<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	//页面Title
	String PG_TITLE = "利率详情";

	//获得页面参数	
	String sRateType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RateType"));
	String sTermUnit = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TermUnit"));
	String sTerm = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Term"));
	String sRateUnit = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RateUnit"));
	String sEffectDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("EffectDate"));
	if (sRateType == null) sRateType = "N";	
	if (sTermUnit == null) sTermUnit = "N";	
	if (sTerm == null) sTerm = "0";	
	if (sRateUnit == null) sRateUnit = "N";	
	if (sEffectDate == null) sEffectDate = "N";

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "RateInfo";
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "2";//设置DW风格
	dwTemp.ReadOnly = "0";//设置是否只读
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sRateType+","+sTermUnit+","+sTerm+","+sRateUnit+","+sEffectDate);
	for (int i = 0; i < vTemp.size(); i++)
	out.print((String) vTemp.get(i));

	String sButtons[][] = { 
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath },
	};
	%> 


	<%@include file="/Resources/CodeParts/Info05.jsp"%>


<script language=javascript>
	//页面装载时，对DW进行初始化
	
	var isInsert = false;
	/*~[Describe=保存;InputParam=无;OutPutParam=无;]~*/
	function saveRecord()
	{
	
		if(!vI_all("myiframe0"))
		{
			return;
		}
		if(!isInsert)
		{
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateTime","<%=SystemConfig.getBusinessTime()%>");
		}
			
		as_save("myiframe0","");
	}
	/*~[Describe=初始化用户、机构;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0){ //如果没有找到对应记录，则新增一条，并设置字段默认值
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=SystemConfig.getBusinessTime()%>");
			isInsert = true;
		}
    }
</script>


<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>

<%@ include file="/IncludeEnd.jsp"%>
