<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
    <%
    /*
        Author:   ttshao 2012-12-21
        Tester: 
        Content: 集团客户信息列表
        Input Param:   
        Output Param:  
    */
    %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
    <%
    String PG_TITLE = "集团家谱维护"   ; // 浏览器窗口标题 <title> PG_TITLE </title>  
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
	String sRight="All";
	String sRoleID="";

	//获得组件参数    ：客户类型
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	if(sCustomerType == null) sCustomerType = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%    
	String hasRole016 ="false";  //added by yzheng 2013/05/29
	String hasRole216 ="false";
    //016 总行集团家谱维护岗,216 分行集团家谱维护岗
    if(CurUser.hasRole("016") || CurUser.hasRole("216")|| CurUser.hasRole("000")){
    	sTempletNo = "GroupCustomerList";
    	hasRole016 = "true";
    	hasRole216 = "true";
    }
    else{
    	out.println("没有家谱维护权限");
    	return;
    }

    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
    
    //增加过滤器 
   // doTemp.setColumnAttribute("CustomerName,CustomerID,CertID","IsFilter","1");模板没有相应字段nyzhang
    doTemp.generateFilters(Sqlca);
    doTemp.parseFilterData(request,iPostChange);
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
    //产生DataWindow
    ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
    dwTemp.setPageSize(20); //设置在datawindows中显示的行数
    dwTemp.Style="1"; //设置DW风格 1:Grid 2:Freeform
    dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    
    //生成HTMLDataWindow
    Vector vTemp = null;
    if(CurUser.hasRole("016") || CurUser.hasRole("216")|| CurUser.hasRole("000"))
        vTemp = dwTemp.genHTMLDataWindow(sUserID+","+sOrgID);
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
    		 {"true","","Button","新增集团","新增一条记录","newRecord()",sResourcesPath}, 
             {"true","","Button","集团详情","集团详情","viewGroupInfo()",sResourcesPath},
             {"true","","Button","删除集团","删除集团","deletePhyRecord()","btn_icon_delete"},//(sRightType.equals("ReadOnly")?"false":"true")
             {CurUser.hasRole("016")?"false":"true","","Button","加入总行管理名单","加入总行管理名单","changeGroupType2()",sResourcesPath},
            //{"true","","Button","加入总行管理名单","加入总行管理名单","changeGroupType2()",sResourcesPath},
             {"true","","Button","集团家谱复核意见","查看集团家谱复核意见","viewOpinions()",sResourcesPath},
             {"true","","Button","集团家谱概况","查看集团家谱概况","viewGroupFamily()","btn_icon_detail"},
             {"true","","Button","集团家谱历次已认定版本","查看集团家谱历次已认定版本","viewGroupFamilyList()","btn_icon_detail"},
             };
    %> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
    <%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

   
<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script language=javascript>
    /*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
    function newRecord(){
		var sCustomerType ="<%=sCustomerType%>";
		AsControl.PopView("/CustomerManage/GroupManage/GroupCustomerInfo.jsp","CustomerType="+sCustomerType,"resizable=yes;dialogWidth=50;dialogHeight=30;center:yes;status:no;statusbar:no");
		reloadSelf();
    } 
    
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
      	
		//查看集团是否有在途申请，如有则返回 
		var sReturn =RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkOnLineApply","GroupID="+sGroupID);  
		
		var hasRole016 = "<%= hasRole016%>";  //added by yzheng 2013/05/29
		var hasRole216 = "<%= hasRole216%>";
		
		if ( (sReturn == "ReadOnly" && hasRole016 == "true") || (sReturn == "ReadOnly" && hasRole216 == "true") ){
			sRightType=sReturn;
		}
		else{
			sRightType="<%=sRight %>";
		}
		
		//打开集团详情页面
		AsControl.PopView("/CustomerManage/CustomerDetailTab.jsp","GroupID="+sGroupID+"&GroupName="+sGroupName+"&GroupType2="+sGroupType2+"&MgtOrgID="+sMgtOrgID+"&MgtUserID="+sMgtUserID+"&KeyMemberCustomerID="+sKeyMemberCustomerID+"&RightType="+sRightType,"");
		reloadSelf();	
	}  
    
    /*~[Describe=集团家谱;InputParam=无;OutPutParam=无;]~*/
	function viewGroupFamily(){
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
      	
        //查看集团是否有在途申请，如有则返回 
		var sReturn =RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkOnLineApply","GroupID="+sGroupID);  
        
		var hasRole016 = "<%= hasRole016%>";  //added by yzheng 2013/05/29
		var hasRole216 = "<%= hasRole216%>";
		
		if ( (sReturn == "ReadOnly" && hasRole016 == "true") || (sReturn == "ReadOnly" && hasRole216 == "true") ){
			sRightType=sReturn;
		}
		else  sRightType="<%=sRight %>";
		
		AsControl.PopView("/CustomerManage/GroupFamilyDetailTab.jsp","GroupID="+sGroupID+"&GroupName="+sGroupName+"&GroupType2="+sGroupType2+"&MgtOrgID="+sMgtOrgID+"&MgtUserID="+sMgtUserID+"&KeyMemberCustomerID="+sKeyMemberCustomerID+"&RightType="+sRightType,"");
		reloadSelf();	
	}  
  
    /*~[Describe=集团家谱历次已认定版本;InputParam=无;OutPutParam=无;]~*/
	function viewGroupFamilyList(){
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
      	
        //查看集团是否有在途申请，如有则返回 
		var sReturn =RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkOnLineApply","GroupID="+sGroupID);  
        
		var hasRole016 = "<%= hasRole016%>";  //added by yzheng 2013/05/29
		var hasRole216 = "<%= hasRole216%>";
		
		if ( (sReturn == "ReadOnly" && hasRole016 == "true") || (sReturn == "ReadOnly" && hasRole216 == "true") ){
			sRightType=sReturn;
		}
		else  sRightType="<%=sRight %>";
		
		AsControl.PopView("/CustomerManage/GroupFamilyListDetailTab.jsp","GroupID="+sGroupID+"&GroupName="+sGroupName+"&GroupType2="+sGroupType2+"&MgtOrgID="+sMgtOrgID+"&MgtUserID="+sMgtUserID+"&KeyMemberCustomerID="+sKeyMemberCustomerID+"&RightType="+sRightType,"");
		reloadSelf();		
	} 
    
    /*~[Describe=删除集团客户;InputParam=无;OutPutParam=无;]~*/
    function deletePhyRecord(){
		var sGroupID = getItemValue(0,getRow(),"GroupID");
		var sGroupName = getItemValue(0,getRow(),"GroupName");
		var sFamilyMapStatus = getItemValue(0,getRow(),"FamilyMapStatus");    //家谱复核状态 
		var sFamilyMapStatusName = getItemValue(0,getRow(),"FamilyMapStatusName");
		var sUserID = "<%=sUserID%>";
		var sOrgID = "<%=sOrgID%>";
		
        if (typeof(sGroupID)=="undefined" || sGroupID.length==0) {
        	alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(sFamilyMapStatus != "0"){
			alert("该集团客户处于【"+sFamilyMapStatusName+"】状态,不能删除！");
			return;
		}else{
			//校验集团客户是否存在已生效版本
		    var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkGroupApproveOpinion","GroupID="+sGroupID);
			if(sReturn != "NOTEXIST" && sReturn != "ERROR"){
				alert("该集团客户存在已生效版本,不能删除！");
				return;
			}
		}
		
		//校验集团客户是否存在有效的授信额度
        var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkBeforeDeleteGroup","GroupID="+sGroupID);
		if(sReturn != "IsNotExist" && sReturn != "ERROR"){
			alert(sReturn);
			return;
		}
		
        if(confirm("是否确认删除该集团客户？")){
			// 删除集团客户
			var sReturnValue = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","deleteGroupCustomer","GroupID="+sGroupID+",UserID="+sUserID+",OrgID"+sOrgID+",GroupName="+sGroupName);
			if(sReturnValue == "true"){
				alert("删除成功！");
				reloadSelf();
			}else{
				alert("删除失败！");
			}
        }
    }
    
    /*~[Describe=加入总行管理名单;InputParam=无;OutPutParam=无;]~*/
    function changeGroupType2(){
		//1. 获取业务参数
		var sGroupID = getItemValue(0,getRow(),"GroupID"); //集团客户ID
		var sGroupType2 = getItemValue(0,getRow(),"GROUPTYPE2");
		var sInputUserID=getItemValue(0,getRow(),"InputUserID");
		var sInputOrgID=getItemValue(0,getRow(),"InputOrgID");
		var sFamilyMapStatus=getItemValue(0,getRow(),"FamilyMapStatus");
		var sFamilyMapStatusName = getItemValue(0,getRow(),"FamilyMapStatusName");

		if(sGroupType2 == "1"){
			alert("已经在总行管理名单中!");
			return;
		}
		if(sFamilyMapStatus == "1"){
			alert("该集团客户处于【"+sFamilyMapStatusName+"】状态,不能进行更改!");//家谱处于“审核中”，不允许修改。
			return;
		}
		if (typeof(sGroupID)=="undefined" || sGroupID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm("确定要加入总行管理名单吗？")){
			var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","updateGroupType2","GroupID="+sGroupID+",UserID="+sInputUserID+",OrgID="+sInputOrgID);
			if(sReturn == "Success"){
				alert("加入成功!");
			}else{
				alert("加入失败");
				return;
			}
		}
		reloadSelf();
    }
    
    /*~[Describe=查看集团家谱复核意见;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions(){
		var sGroupID = getItemValue(0,getRow(),"GroupID");
      	if (typeof(sGroupID)=="undefined" || sGroupID.length==0){
      		alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
      	AsControl.PopView("/CustomerManage/GroupManage/GroupApproveOpinions.jsp", "GroupID="+sGroupID+"&RightType=All", "");
      	reloadSelf();	
	}  

    
    /**
     * 
     * 代码选择框，传入一个代码编号，选择相应代码
     * 如果其它地方使用到选择代码比较频繁的情况，可考虑将此函数移至common.js
     * @author syang 2009/10/14
     * @param codeNo 代码编号
     * @param Caption 弹出对话框名称
     * @param defaultValue 选择框默认值
     * @param filterExpr 对ItemNo按照这个表达式进行匹配
     * @return 选择的ItemNo
     */
    function selectCode(codeNo,Caption,defaultValue,filterExpr){
        if(typeof(filterExpr) == "undefined"){
            filterExpr = "";
        }
        var codePage = "/CustomerManage/SelectCode.jsp";
        var sPara = "CodeNo="+codeNo+"&Caption="+Caption+"&DefaultValue="+defaultValue
                   +"&ItemNoExpr="+encodeURIComponent(filterExpr)  //这里需要作编码转换，否则形如&,%,+这类字符传输会有问题
                   ;
        style = "resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no";
        sReturnValue = PopPage(codePage+"?"+sPara,"",style);
        return sReturnValue;
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