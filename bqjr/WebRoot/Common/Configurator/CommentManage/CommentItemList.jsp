<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-28
		Tester:
		Content: 注释项列表
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "注释项列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
   	String sHeaders[][] = {
				{"CommentItemID","注释项编号"},
				{"CommentItemName","注释导读"},
				{"SortNo","排序号"},
				{"ChapterNo","章节号"},
				{"CommentItemType","注释项类型"},
				{"CommentText","注释文字内容"},
				{"DocNo","注释文档编号"},
				{"DoGenDesignSpec","是否生成设计文档"},
				{"DoGenHelp","是否生成帮助文件"},
				{"REMARK","备注"},
				{"INPUTUSERNAME","输入人"},
				{"INPUTUSER","输入人"},
				{"INPUTORGNAME","输入机构"},
				{"INPUTORG","输入机构"},
				{"INPUTTIME","输入时间"},
				{"UPDATEUSERNAME","更新人"},
				{"UPDATEUSER","更新人"},
				{"UPDATETIME","更新时间"}
			       };  

	sSql = " Select  "+
				"CommentItemID,"+
				"CommentItemName,"+
				"SortNo,"+
				"ChapterNo,"+
				"getItemName('CommentItemType',CommentItemType) as CommentItemType,"+
				"CommentText,"+
				"DocNo,"+
				"DoGenDesignSpec,"+
				"DoGenHelp,"+
				"REMARK,"+
				"getUserName(INPUTUSER) as INPUTUSERNAME,"+
				"INPUTUSER,"+
				"getOrgName(INPUTORG) as INPUTORGNAME,"+
				"INPUTORG,"+
				"INPUTTIME,"+
				"getUserName(UPDATEUSER) as UPDATEUSERNAME,"+
				"UPDATEUSER,"+
				"UPDATETIME "+
				"From REG_COMMENT_ITEM where 1=1";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REG_COMMENT_ITEM";
	doTemp.setKey("CommentItemID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("CommentItemID"," style={width:160px} ");
	doTemp.setHTMLStyle("CommentItemName"," style={width:160px} ");
	doTemp.setHTMLStyle("SortNo"," style={width:160px} ");
	doTemp.setHTMLStyle("ChapterNo"," style={width:160px} ");
	doTemp.setHTMLStyle("DocNo"," style={width:160px} ");
	doTemp.setHTMLStyle("DoGenDesignSpec"," style={width:160px} ");
	doTemp.setHTMLStyle("INPUTUSER,UPDATEUSER"," style={width:160px} ");
	doTemp.setHTMLStyle("INPUTORG"," style={width:160px} ");
	doTemp.setHTMLStyle("INPUTTIME,UPDATETIME"," style={width:130px} ");
	doTemp.setHTMLStyle("REMARK"," style={width:400px} ");
	doTemp.setReadOnly("INPUTUSER,UPDATEUSER,INPUTORG,INPUTTIME,UPDATETIME",true);
 
	doTemp.setVisible("CommentText,REMARK,INPUTUSER,INPUTORG,UPDATEUSER,NPUTUSERNAME,INPUTORGNAME,UPDATEUSERNAME",false);    	
	doTemp.setUpdateable("INPUTUSERNAME,INPUTORGNAME,UPDATEUSERNAME",false);

	//查询
 	doTemp.setColumnAttribute("CommentItemID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" Where 1=2";

	//filter过滤条件
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);

	//定义后续事件
	dwTemp.setEvent("BeforeDelete","!Configurator.DelCommentRela(#CommentItemID)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","注释关联列表","查看/修改注释关联列表","viewAndEdit2()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
    var sCurCodeNo=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
        sReturn=popComp("CommentItemInfo","/Common/Configurator/CommentManage/CommentItemInfo.jsp","","");
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            //新增数据后刷新列表
            if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
            {
                sReturnValues = sReturn.split("@");
                if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
                {
                    OpenPage("/Common/Configurator/CommentManage/CommentItemList.jsp","_self","");    
                }
            }
        }
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
        sCommentItemID = getItemValue(0,getRow(),"CommentItemID");
        if(typeof(sCommentItemID)=="undefined" || sCommentItemID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        //openObject("CommentItemView",sCommentItemID,"001");
        popComp("CommentItemView","/Common/Configurator/CommentManage/CommentItemView.jsp","ObjectNo="+sCommentItemID);
	}
    
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit2()
	{
        sCommentItemID = getItemValue(0,getRow(),"CommentItemID");
        if(typeof(sCommentItemID)=="undefined" || sCommentItemID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        popComp("CommentRelaList","/Common/Configurator/CommentManage/CommentRelaList.jsp","CommentItemID="+sCommentItemID,"");
	}

    
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sCommentItemID = getItemValue(0,getRow(),"CommentItemID");
        if(typeof(sCommentItemID)=="undefined" || sCommentItemID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		if(confirm(getHtmlMessage('45'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	function mySelectRow()
	{
        
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

<%@ include file="/IncludeEnd.jsp"%>
