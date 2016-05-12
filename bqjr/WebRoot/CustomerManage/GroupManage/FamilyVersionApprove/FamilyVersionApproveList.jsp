<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
    <%
    /*
        Author:   
        Tester: 
        Content: 集团家谱复核信息列表
        Input Param:   
        Output Param:  
    */
    %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
    <%
    String PG_TITLE = "集团家谱复核"   ; // 浏览器窗口标题 <title> PG_TITLE </title>  
    %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
    //定义变量
    String sCurBranchOrg=""; //当前用户所在分行
	String sCurOrgLevel=CurOrg.getOrgLevel(); //当前用户所在机构的级别
	String sUserID = CurUser.getUserID();
	String sCurOrgID = CurOrg.getOrgID(); //当前用户所属机构
	String sTempletNo = "";//显示模板编号
	String isCollectMangage = "";//是否总行集中管理
	
    //生成显示模板使用，总行集团家谱维护岗登录后对分行提交的“是总行管理名单”的记录可见
    if(CurUser.hasRole("026")||CurUser.hasRole("000")){
		isCollectMangage = "1";//是总行集中管理 
	}else if (CurUser.hasRole("226")){
		isCollectMangage = "2";//非总行集中管理 
	}
	
    //获得组件参数    ：是否已处理
    String sFinishFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishFlag"));
    if(sFinishFlag == null) sFinishFlag = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%

	if(sFinishFlag.equals("N")){//未处理
		if(sCurOrgLevel.equals("0")){//0：总行  3:分行  6：支行 
			sTempletNo = "FamilyVersionList01";
		}else{
			sTempletNo = "FamilyVersionList";
		} 
	}else{						//已处理
		sTempletNo = "FamilyVersionList02"; 
	}

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
    Vector vTemp = null;
    
    //生成HTMLDataWindow
    if(sFinishFlag.equals("N")){//未处理
    	 vTemp = dwTemp.genHTMLDataWindow(isCollectMangage+","+sCurOrgID);
	}else{						//已处理
		 vTemp = dwTemp.genHTMLDataWindow(isCollectMangage+","+sUserID);
	}
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
            {"true","","Button","集团详情","集团详情","viewTab()","","","","btn_icon_detail"},
            {(sFinishFlag.equals("N")?"true":"false"),"","Button","复核","复核","signCheckOpinion()","","","",""},
            {(sFinishFlag.equals("N")?"false":"true"),"","Button","查看复核意见","查看复核意见","viewCheckOpinion()","","","",""}
        };
    %> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
    <%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

   
<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script language=javascript>
	/*~[Describe=复核 ;InputParam=无;OutPutParam=无;]~*/
	function signCheckOpinion() 
	{
		//获得集团客户ID
		sGroupID = getItemValue(0,getRow(),"GroupID");
		sVersionSeq = getItemValue(0,getRow(),"VersionSeq");
		sOldFamilySeq = getItemValue(0,getRow(),"RefVersionSeq");
		if (typeof(sGroupID)=="undefined" || sGroupID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
	
		sCompURL = "/CustomerManage/GroupManage/FamilyVersionApprove/FamilyVersionOpinionView.jsp";
		PopComp("FamilyVersionOpinionView",sCompURL,"GroupID="+sGroupID+"&FamilySeq="+sVersionSeq+"&OldFamilySeq="+sOldFamilySeq,"");
		reloadSelf();
	}	
	
	/*~[Describe=集团详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		var sGroupID = getItemValue(0,getRow(),"GroupID");
		var sRightType="ReadOnly";
		
     	if (typeof(sGroupID)=="undefined" || sGroupID.length==0){
     		 alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		PopComp("CustomerDetailTab","/CustomerManage/CustomerDetailTab.jsp", "GroupID="+sGroupID+"&RightType="+sRightType, "");
	    reloadSelf();
	}
	
	/*~[Describe=查看签署意见;InputParam=无;OutPutParam=无;]~*/
	function viewCheckOpinion() 
	{
		//获得申请类型、申请流水号、流程编号、阶段编号、审批流程流水号
		sGroupID = getItemValue(0,getRow(),"GroupID");
		sFamilySEQ = getItemValue(0,getRow(),"VersionSeq");
		sOldFamilySEQ = getItemValue(0,getRow(),"RefVersionSeq");
		
		if (typeof(sGroupID)=="undefined" || sGroupID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompURL = "/CustomerManage/GroupManage/FamilyVersionApprove/FamilyVersionOpinionView.jsp";
		PopComp("FamilyVersionOpinionView",sCompURL,"GroupID="+sGroupID+"&FamilySeq="+sFamilySEQ+"&OldFamilySEQ="+sOldFamilySEQ+"&EditRight=Readonly","");
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