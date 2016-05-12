<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
    <%
    /*
        Author:   lyin 2012-12-28
        Tester: 
        Content: 集团客户查询信息列表
        Input Param:   
        Output Param:  
    */
    %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
    <%
    String PG_TITLE = "集团客户查询"   ; // 浏览器窗口标题 <title> PG_TITLE </title>  
    %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sCurBranchOrg=""; //当前用户所在分行
	String sUserID =CurUser.getUserID();
	String sOrgID=CurUser.getOrgID();
	String sCurBranchSortNo = ""; //当前用户所在分行的SortNo
	String sTempletNo = "";//模板
	String sRight="ReadOnly";
	String sRoleID="";

	//获得组件参数    ：客户类型
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	if(sCustomerType == null) sCustomerType = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%    
    //000：系统管理员，036：总行集团家谱查询岗
    //080: 总行客户经理,280：分行客户经理，480：支行客户经理 
    //236: 分行集团家谱查询岗，436：支行集团家谱查询岗

   	if(CurUser.hasRole("000")|| CurUser.hasRole("036")) sTempletNo="GroupCustomerList1";
   	else if(CurUser.hasRole("080")|| CurUser.hasRole("280")|| CurUser.hasRole("480")) sTempletNo="GroupCustomerList2";
   	else if(CurUser.hasRole("236")|| CurUser.hasRole("436")) sTempletNo="GroupCustomerList3";
    	
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
    
    //增加过滤器 
    doTemp.generateFilters(Sqlca);
    doTemp.parseFilterData(request,iPostChange);
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
    //产生DataWindow
    ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
    dwTemp.setPageSize(20); //设置在datawindows中显示的行数
    dwTemp.Style="1"; //设置DW风格 1:Grid 2:Freeform
    dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    
    //生成HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow(sUserID+","+sOrgID);	
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
        //6.资源图片路径{"true","","Button","管户权转移","管户权转移","ManageUserIdChange()",sResourcesPath}
    String sButtons[][] = {
             {"true","","Button","集团详情","集团详情","viewGroupInfo()",sResourcesPath},
             };
    %> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
    <%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

   
<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script language=javascript>
   
    /*~[Describe=集团概况;InputParam=无;OutPutParam=无;]~*/
	function viewGroupInfo(){
      	var sGroupID = getItemValue(0,getRow(),"GroupID");
		var sMgtOrgID=getItemValue(0,getRow(),"MgtOrgID");
		var sMgtUserID=getItemValue(0,getRow(),"MgtUserID");
		var sKeyMemberCustomerID=getItemValue(0,getRow(),"KeyMemberCustomerID");
		var sGroupName=getItemValue(0,getRow(),"GroupName");
		var sGroupType2=getItemValue(0,getRow(),"GROUPTYPE2");
		
      	if (typeof(sGroupID)=="undefined" || sGroupID.length==0){
      	    alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
      	
	    var sRightType="<%=sRight %>";
		
		//打开集团详情页面
		AsControl.PopView("/CustomerManage/CustomerDetailTab.jsp","GroupID="+sGroupID+"&GroupName="+sGroupName+"&GroupType2="+sGroupType2+"&MgtOrgID="+sMgtOrgID+"&MgtUserID="+sMgtUserID+"&KeyMemberCustomerID="+sKeyMemberCustomerID+"&RightType="+sRightType,"");
	    reloadSelf();	
	}  
    </script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
    AsOne.AsInit();
    init(); 
    var bHighlightFirst = true;//自动选中第一条记录
    my_load(2,0,'myiframe0');
</script>   
<%/*~END~*/%>

   
<%@ include file="/IncludeEnd.jsp"%>