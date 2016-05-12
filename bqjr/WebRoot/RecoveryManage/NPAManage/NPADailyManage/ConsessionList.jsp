<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "债权让步记录管理";
	//获得页面参数
	String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType"));   
    String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); //对象类型
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));     //合同编号
	if(sFinishType == null) sFinishType = "";

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ConsessionList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{sFinishType.equals("")?"true":"false","","Button","新增","新增客户持有债券信息","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看客户持有债券详细信息","viewAndEdit()",sResourcesPath},
			{sFinishType.equals("")?"true":"false","","Button","删除","删除客户持有债券信息","deleteRecord()",sResourcesPath},
			};
		%>
	<%/*~END~*/%>

	<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
		<%@include file="/Resources/CodeParts/List05.jsp"%>
	<%/*~END~*/%>

	<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

		//---------------------定义按钮事件------------------------------------
		/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
		function newRecord()
		{
			sObjectNo = "<%=sObjectNo%>";
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/ConsessionInfo.jsp?ObjectNo="+sObjectNo,"_self","");
		}

		/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
		function deleteRecord()
		{
			sSerialNo = getItemValue(0,getRow(),"SerialNo");
			if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
			{
				alert(getHtmlMessage('1'));//请选择一条信息！
			}
			else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
			{	
				as_del('myiframe0');
				as_save('myiframe0');  //如果单个删除，则要调用此语句
			}
		}

		/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
		function viewAndEdit()
		{
			sSerialNo = getItemValue(0,getRow(),"SerialNo");
			if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
			{
				alert(getHtmlMessage('1'));//请选择一条信息！
			}else
			{
				OpenPage("/RecoveryManage/NPAManage/NPADailyManage/ConsessionInfo.jsp?SerialNo="+sSerialNo,"_self","");
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

	<%@include file="/IncludeEnd.jsp"%>
