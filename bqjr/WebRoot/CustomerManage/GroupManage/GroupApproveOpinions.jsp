<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
    <%
    /*
        Author:   
        Tester: 
        Content: 集团家谱复核意见
        Input Param:   
        Output Param:  
    */
    %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
    <%
    String PG_TITLE = "集团家谱复核意见"   ; // 浏览器窗口标题 <title> PG_TITLE </title>  
    %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
    //定义变量
	String sTempletNo = "";//模板
     
    //获得组件参数    ：客户类型    
    String sGroupID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupID"));
	if(sGroupID == null) sGroupID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%    
    //取得模板号
    sTempletNo = "GroupApproveOpinionList";
	String sTempletFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
    
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
        //6.资源图片路径{"true","","Button","管户权转移","管户权转移","ManageUserIdChange()",sResourcesPath}
        String sButtons[][] = {
    		//只有集团家谱变更才显示该按钮
    		{"true","","Button","意见详情","意见详情","viewOpinions()","","","",""},
    		{"true","","Button","关联家谱草稿信息","关联家谱草稿信息","viewGroupStemma()","","","",""}
    		
    	};
    %> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
    <%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

   
<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script language=javascript>
	function viewOpinions()
	{
		//获得集团客户ID
		sGroupID = getItemValue(0,getRow(),"GroupID");
		sFamilySEQ = getItemValue(0,getRow(),"FamilySEQ");    			  //更新后家谱版本号（新）
		sOldFamilySEQ = getItemValue(0,getRow(),"OldFamilySEQ");    			  //更新前家谱版本号（旧）
		
		if (typeof(sGroupID)=="undefined" || sGroupID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		sCompURL = "/CustomerManage/GroupManage/FamilyVersionApprove/FamilyVersionOpinionView.jsp";
		PopComp("FamilyVersionOpinionView",sCompURL,"GroupID="+sGroupID+"&FamilySeq="+sFamilySEQ+"&OldFamilySEQ="+sOldFamilySEQ+"&EditRight=Readonly","");
		reloadSelf();
	}
	/*~[Describe=查看集团家谱草稿信息;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewGroupStemma()
	{
		//获取业务信息
		sGroupID="<%=sGroupID%>";     //集团客户编号
		sFamilySEQ = getItemValue(0,getRow(),"FamilySEQ");    			  //更新后家谱版本号（新）
		sOldFamilySEQ = getItemValue(0,getRow(),"OldFamilySEQ");    			  //更新后家谱版本号（新）
		
		if(typeof(sFamilySEQ)=="undefined" || sFamilySEQ.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}

		var sArgs="GroupID="+ sGroupID+"&FamilySEQ="+sFamilySEQ+"&OldFamilySEQ="+sOldFamilySEQ;
		//集团家谱草稿信息
		PopComp("FamilyVersionInternalList","/CustomerManage/GroupManage/FamilyVersionApprove/FamilyVersionInternalList.jsp",sArgs,"");
        //刷新List页面
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