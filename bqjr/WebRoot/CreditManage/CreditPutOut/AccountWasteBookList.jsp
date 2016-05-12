<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "流水台帐列表";
	//获得页面参数
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//AccountType 01 发放 02 回收
	String sAccountType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AccountType"));
	
	if(sObjectNo == null) sObjectNo = "";
	if(sAccountType == null) sAccountType = "";
	
	String sTempletNo="";
	if(sAccountType.equals("ALL")){
	//通过DW模型产生ASDataObject对象doTemp
	sTempletNo = "ALL_AccountWasteBookList";//模型编号
	}else if(sAccountType.equals("01")){
	sTempletNo = "01_AccountWasteBookList";	
	}else if(sAccountType.equals("02")){
	sTempletNo = "02_AccountWasteBookList";	
	}
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+sAccountType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"false","","Button","新增流水","新增流水","newRecord()",sResourcesPath},
			{"true","","Button","查看详情","查看详情","viewAndEdit()",sResourcesPath},
			{"false","","Button","删除流水","删除流水","deleteRecord()",sResourcesPath}
			};
		%>
	<%/*~END~*/%>


	<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
		<%@include file="/Resources/CodeParts/List05.jsp"%>
	<%/*~END~*/%>


	<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
		<script type="text/javascript">

		//---------------------定义按钮事件------------------------------------
		/*~[Describe=新增流水信息;InputParam=无;OutPutParam=无;]~*/
		function newRecord(){
			OpenPage("/CreditManage/CreditPutOut/AccountWasteBookInfo.jsp?AccountType=<%=sAccountType%>", "_self","");
		}
		
		/*~[Describe=删除流水信息;InputParam=无;OutPutParam=无;]~*/
		function deleteRecord(){
			var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
			if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
				alert(getHtmlMessage('1'));//请选择一条信息！
			}
			else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
			{
				as_del('myiframe0');
				as_save('myiframe0');  //如果单个删除，则要调用此语句
			}		
		}

		/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
		function viewAndEdit(){
			var sSerialNo = getItemValue(0,getRow(),"SerialNo");
			var sOccurDirection = getItemValue(0,getRow(),"OccurDirection");
			if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
				alert(getHtmlMessage('1'));//请选择一条信息！
			}else{
				OpenPage("/CreditManage/CreditPutOut/AccountWasteBookInfo.jsp?SerialNo="+sSerialNo, "_self","");
			}
		}
		</script>
	<%/*~END~*/%>


	<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
	<script type="text/javascript">
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	</script>
	<%/*~END~*/%>

	<%@	include file="/IncludeEnd.jsp"%>