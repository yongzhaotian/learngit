<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> 

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: 集团成员概况
		Input Param:
		Output Param:
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "已核准成员概况（原集团成员概况）"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
    String sTempletNo = "";//模板
	
	//获得组件参数
	String sGroupID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupID"));
	String sRightType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	
    if(sGroupID == null) sGroupID = "";
    if(sRightType == null) sRightType = "";
    
    String sRelativeID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));

    //得到集团客户的客户类型：实体集团或虚拟集团 
    String sSql = " Select CustomerType from CUSTOMER_INFO where CustomerID = :CustomerID";
    String sGroupType = Sqlca.getString(new SqlObject(sSql).setParameter("CustomerID",sRelativeID));
    if (sGroupType == null) sGroupType = "";
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	
    //取得模板号
	sTempletNo = "GroupMemberList1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
    //产生DataWindow
    ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
    dwTemp.setPageSize(20); //设置在datawindows中显示的行数
    dwTemp.Style="1"; //设置DW风格 1:Grid 2:Freeform
    dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    
    //生成HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow(sGroupID);
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
		{"true","","Button","客户详情","查看集团成员客户信息详情","viewCustomer()",sResourcesPath},
		{"true","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath},
	};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*查看合同详情代码文件*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewCustomer()
	{/*
	    var sCustomerID = getItemValue(0,getRow(),"MemberCustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			PopComp("CustomerView","/CustomerManage/CustomerView.jsp", "ObjectNo="+sCustomerID, "");
	    	reloadSelf();
		}
	*/

		var sCustomerID = getItemValue(0,getRow(),"MemberCustomerID");
		if (typeof(sCustomerID) == "undefined" || sCustomerID.length == 0){
		    alert(getHtmlMessage('1'));//请选择一条信息！
		    return;
		}

     	sReturn = RunMethod("CustomerManage","CheckRolesAction",sCustomerID+",<%=CurUser.getUserID()%>");
    	if (typeof(sReturn) == "undefined" || sReturn.length == 0){
        return;
    	}

	    var sReturnValue = sReturn.split("@");
	    sReturnValue1 = sReturnValue[0];
	    sReturnValue2 = sReturnValue[1];
	    sReturnValue3 = sReturnValue[2];
                        
		if(sReturnValue3 == "Y2"){   
			openObject("Customer",sCustomerID,"001");
			reloadSelf();
		}else{
			openObject("Customer",sCustomerID,"003");//不具有信息维护权 ，只读
			reloadSelf();
		}
	}
	
	/*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
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
