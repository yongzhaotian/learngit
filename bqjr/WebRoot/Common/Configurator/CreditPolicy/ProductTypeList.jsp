<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   --fbkang
		Tester:
		Content: --产品管理列表
		Input Param:
                  
		Output param:
		       DoNo:--模板号码
		       EditRight: --编辑权限
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "产品定义列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql="";//--存放sql语句
	String sSortNo=""; //--排序编号
	//获得页面参数业务品种编号
	String sParentTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ParentTypeNo"));
	if(sParentTypeNo == null) sParentTypeNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
    ASDataObject doTemp = new ASDataObject("ProductTypeList",Sqlca);
    if("ENT".equals(sParentTypeNo)){//公司业务
    	doTemp.WhereClause+=" and (TypeNo like '1%' or TypeNo like '2%') and  TypeNo not like '111%'";
	}else {
		doTemp.WhereClause+=" and TypeNo like '"+sParentTypeNo+"%' ";
	}
    
    //过滤查询
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	//设置页面显示的列数
	dwTemp.setPageSize(20);

	//生成HTMLDataWindow
	Vector	vTemp = dwTemp.genHTMLDataWindow("");
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
			{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
			{"true","","Button","申请模板详情","查看/编辑申请显示模板详情","DataObjectview1()",sResourcesPath},
			{"true","","Button","批复模板详情","查看/编辑最终审批意见显示模板详情","DataObjectview2()",sResourcesPath},
			{"true","","Button","合同模板详情","查看/编辑合同显示模板详情","DataObjectview3()",sResourcesPath},
			{"true","","Button","出帐模板详情","查看/编辑出帐模板详情","DataObjectview4()",sResourcesPath},
			{"false","","Button","审批流程详情","查看/编辑审批流程详情","DataObjectview5()",sResourcesPath},
			{"true","","Button","核算业务组件定义","核算业务组件定义","TermEdit()",sResourcesPath,"btn_icon_detail"}
		   };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
    
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=查看/编辑产品相关节点详情;InputParam=无;OutPutParam=无;]~*/
	function PRDNodeInfoConfig()
	{
		var sTypeNo = getItemValue(0,getRow(),"TypeNo");//--永久产品类型编号
		var sTypeName = getItemValue(0,getRow(),"TypeName");//--永久产品类型名称
		if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	        return ;
		}

		var sPara = "ProductID=" + sTypeNo;
		var sNodeIDArr =  RunJavaMethodSqlca("com.amarsoft.app.als.product.CVNodeDBManipulateController", "checkPRDNode", sPara);
		
		AsControl.OpenView("/SystemManage/SynthesisManage/HTMLGridDrawing.jsp","ProductID=" + sTypeNo + "&NodeIDArr=" + sNodeIDArr + "&TypeName=" + sTypeName, "right");
	}
	
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
        sReturn=popComp("ProductTypeInfo","/Common/Configurator/CreditPolicy/ProductTypeInfo.jsp","","");
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            //新增数据后刷新列表
            if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
            {
                sReturnValues = sReturn.split("@");
                if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
                {
                    OpenPage("/Common/Configurator/CreditPolicy/ProductTypeList.jsp","_self","");    
                }
            }
        }
        
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
	    sTypeNo = getItemValue(0,getRow(),"TypeNo");//--永久类型编号
	    if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	        return ;
		}
	    sReturn=popComp("ProductTypeInfo","/Common/Configurator/CreditPolicy/ProductTypeInfo.jsp","TypeNo="+sTypeNo,"");
	    if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
	    {
			//新增数据后刷新列表
			if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
			{
				sReturnValues = sReturn.split("@");
				if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
				{
				    OpenPage("/Common/Configurator/CreditPolicy/ProductTypeList.jsp","_self","");    
				}
			}
	    }
	}
	
	/*~[Describe=核算业务组件定义;InputParam=无;OutPutParam=无;]~*/
	function TermEdit()
	{
		sTypeNo = getItemValue(0,getRow(),"TypeNo");
		AsControl.OpenView("/Accounting/Product/ProductVersionList.jsp","TypeNo="+sTypeNo,"_blank",OpenStyle);
	}

	/*~[Describe=查看申请显示模板详情;InputParam=无;OutPutParam=无;]~*/
	function DataObjectview1()
	{
		sTypeNo = getItemValue(0,getRow(),"TypeNo");//--永久类型编号
	    if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	        return ;
		}
		sDisplayTemplet = getItemValue(0,getRow(),"ApplyDetailNo");//--模板号编号
		sEditRight="01";//编辑权限
		if(typeof(sDisplayTemplet)=="undefined" || sDisplayTemplet.length==0) 
		{
			alert("您选择的产品没有设置申请显示模版，请重新选择！");
		    return ;
		}
		//根据模板号打开模板详情
		popComp("DataObjectList","/Common/Configurator/DataObject/DOLibraryList.jsp","DoNo="+sDisplayTemplet+"&EditRight="+sEditRight,"");
	}
	
	/*~[Describe=查看最终审批意见显示模板详情;InputParam=无;OutPutParam=无;]~*/
	function DataObjectview2()
	{
		sTypeNo = getItemValue(0,getRow(),"TypeNo");//--永久类型编号
	    if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	        return ;
		}
		sDisplayTemplet = getItemValue(0,getRow(),"ApproveDetailNo");//--模板号编号
		sEditRight="01";//
		if(typeof(sDisplayTemplet)=="undefined" || sDisplayTemplet.length==0) 
		{
			alert("您选择的产品没有设置最终审批意见显示模版，请重新选择！");
		    return ;
		}
		//根据模板号打开模板详情
		popComp("DataObjectList","/Common/Configurator/DataObject/DOLibraryList.jsp","DoNo="+sDisplayTemplet+"&EditRight="+sEditRight,"");
	}
	
	/*~[Describe=查看合同显示模板详情;InputParam=无;OutPutParam=无;]~*/
	function DataObjectview3()
	{
		sTypeNo = getItemValue(0,getRow(),"TypeNo");//--永久类型编号
	    if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	        return ;
		}
		sDisplayTemplet = getItemValue(0,getRow(),"ContractDetailNo");//--模板号编号
		sEditRight="01";//编辑权限
		if(typeof(sDisplayTemplet)=="undefined" || sDisplayTemplet.length==0) 
		{
			alert("您选择的产品没有设置合同显示模版，请重新选择！");
		    return ;
		}
		//根据模板号打开模板详情
		popComp("DataObjectList","/Common/Configurator/DataObject/DOLibraryList.jsp","DoNo="+sDisplayTemplet+"&EditRight="+sEditRight,"");
	}
   
	/*~[Describe=查看出帐显示模板详情;InputParam=无;OutPutParam=无;]~*/
	function DataObjectview4()
	{
		sTypeNo = getItemValue(0,getRow(),"TypeNo");//--永久类型编号
	    if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	        return ;
		}
		sDisplayTemplet = getItemValue(0,getRow(),"DisplayTemplet");//--模板号编号
		sEditRight="01";//编辑权限
		if(typeof(sDisplayTemplet)=="undefined" || sDisplayTemplet.length==0) 
		{
			alert("您选择的产品没有设置出帐显示模版，请重新选择！");
		    return ;
		}
		//根据模板号打开模板详情
		popComp("DataObjectList","/Common/Configurator/DataObject/DOLibraryList.jsp","DoNo="+sDisplayTemplet+"&EditRight="+sEditRight,"");
	}
	
   /*~[Describe=查看审批流程详情;InputParam=无;OutPutParam=无;]~add by wlu 2009-02-19*/
	function DataObjectview5()
	{
        sFlowNo = getItemValue(0,getRow(),"Attribute9");
        if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0)
        {
			alert("您选择的产品没有设置审批流程，请重新选择！");//您选择的产品没有设置审批流程，请重新选择！
            return ;
		}
        popComp("FlowCatalogView","/Common/Configurator/FlowManage/FlowCatalogView.jsp","ObjectNo="+sFlowNo,"");
    }
    
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sTypeNo = getItemValue(0,getRow(),"TypeNo");//--永久类型编号
        if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))) 
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
