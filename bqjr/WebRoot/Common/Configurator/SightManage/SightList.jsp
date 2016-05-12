<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zxu 2005-03-10
		Tester:
		Content: 视野列表
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "视野列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	String sSortNo; //排序编号
	
    //获得页面参数	
	String sSightSetID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SightSetID"));
    	if (sSightSetID == null) 
        	sSightSetID = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	


	
    String sTempletNo = "SightList"; //模版编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);	

	//查询

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	if(sSightSetID !=null && !sSightSetID.equals(""))
	{
		doTemp.WhereClause+=" And SightSetID='"+sSightSetID+"'";
	}
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";

    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(200);
    
	//定义后续事件
	dwTemp.setEvent("BeforeDelete","!Configurator.DelSightRight(#SightSetID)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
    	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
    	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
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
		{"true","","Button","检查并启用","语法检查并注册该权限点","checkAndRegRight('Y')",sResourcesPath},
		{"true","","Button","停用","停止使用","checkAndRegRight('N')",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		// Del by wuxiong 2005-02-22 因返回在TreeView中会有错误 {"true","","Button","返回","返回","doReturn('N')",sResourcesPath}
		};

    %> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	var sCurSightSetID=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
            sReturn=popComp("SightInfo","/Common/Configurator/SightManage/SightInfo.jsp","SightSetID=<%=sSightSetID%>","");
            //修改数据后刷新列表
		reloadSelf();
/**
            if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
            {
                sReturnValues = sReturn.split("@");
                if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
                {
                    OpenPage("/Common/Configurator/SightManage/SightList.jsp?SightSetID="+sReturnValues[0],"_self","");           
                }
            }
***/        
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
        sSightSetID = getItemValue(0,getRow(),"SightSetID");
        sSightID = getItemValue(0,getRow(),"SightID");
        if(typeof(sSightID)=="undefined" || sSightID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        sReturn=popComp("SightInfo","/Common/Configurator/SightManage/SightInfo.jsp","SightSetID="+sSightSetID+"&SightID="+sSightID,"");
        //修改数据后刷新列表
	reloadSelf();
/**
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                OpenPage("/Common/Configurator/SightManage/SightList.jsp?SightSetID="+sReturnValues[0],"_self","");           
            }
        }
**/
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSightID = getItemValue(0,getRow(),"SightID");
        	if(typeof(sSightID)=="undefined" || sSightID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            		return ;
		}
		
		if(confirm(getHtmlMessage('2'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
    /*~[Describe=启用;InputParam=sOper("Y-检查并启用； N-停用");OutPutParam=无;]~*/
	function checkAndRegRight(sOper){
		sSightSetID = getItemValue(0,getRow(),"SightSetID");
		sSightID = getItemValue(0,getRow(),"SightID");
		sSightWhereClause = getItemValue(0,getRow(),"SightWhereClause");
        	if(typeof(sSightSetID)=="undefined" || sSightSetID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            		return ;
		}
        	if(typeof(sSightID)=="undefined" || sSightID.length==0 || typeof(sSightWhereClause)=="undefined" || sSightWhereClause.length==0) {
			alert("信息不完整，请检查视野编号和条件子句是否填充！");
            		return ;
		}
		sReturn = PopPage("/Common/Configurator/SightManage/ChkAndRegRight.jsp?SightSetID="+sSightSetID+"&SightID="+sSightID+"&Oper="+sOper,"","dialogLeft="+(sScreenWidth*0.3)+";dialogWidth="+(sScreenWidth*0.4)+"px;dialogHeight="+(sScreenHeight*0.3)+"px;resizable=yes;status:yes;maximize:yes;help:no;");
		if(sReturn=="succeeded"){
			reloadSelf();
		}
	}

    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"SightSetID");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
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
