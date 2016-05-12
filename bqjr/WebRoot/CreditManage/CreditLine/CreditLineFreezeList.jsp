<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:zywei 2006/04/01
		Tester:
		Content: 授信额度冻结或解冻列表页面
		Input Param:
			FreezeFlag：冻结或解冻标志（1：有效的；2：已被冻结的）
		Output param:
		
		History Log: 

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授信额度冻结与解冻"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	
	//获得组件参数	
	String sFreezeFlag =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FreezeFlag"));
	if(sFreezeFlag == null) sFreezeFlag = "";
	//获得页面参数	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//显示标题				
	String sTempletNo="CreditLineFreezeList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	//如果通过filter框查询，则不会有如下的限制条件
	//冻结标志FreezeFlag（1：正常；2：冻结；3：解冻；4：终止）
	if(sFreezeFlag.equals("1")) //有效的
		doTemp.WhereClause +=	" and FreezeFlag in ('1','3') ";  
	else //冻结的
		doTemp.WhereClause +=	" and FreezeFlag = '"+sFreezeFlag+"' ";
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause += " and BeginDate <= '"+DateX.format(new java.util.Date(), "yyyy/MM/dd")+"' "+
	                                                           " and PutOutDate <= '"+DateX.format(new java.util.Date(), "yyyy/MM/dd")+"' "+
	          												   " and Maturity >= '"+DateX.format(new java.util.Date(), "yyyy/MM/dd")+"' ";  		
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
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
		{(sFreezeFlag.equals("1")?"true":"false"),"","Button","冻结","冻结所选的额度记录","freezeRecord()",sResourcesPath},
		{(sFreezeFlag.equals("2")?"true":"false"),"","Button","解冻","解冻所选的额度记录","unfreezeRecord()",sResourcesPath},
		{"true","","Button","额度详情","查看/修改详情","openWithObjectViewer()",sResourcesPath},
		{"true","","Button","授信额度项下业务","相关授信额度项下业务","lineSubList()",sResourcesPath},
		{"true","","Button","额度使用查询","额度使用查询","QueryUseInfo()",sResourcesPath}
		};
		
	%> 
	
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=冻结授信额度;InputParam=无;OutPutParam=无;]~*/
	function freezeRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getBusinessMessage('400')))//确实要冻结该笔授信额度吗？
		{
			//冻结操作
			sReturn=RunMethod("BusinessManage","FreezeCreditLine",sSerialNo+","+"2");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {				
				alert(getBusinessMessage('401'));//冻结授信额度失败！
				return;			
			}else
			{
				reloadSelf();	
				alert(getBusinessMessage('402'));//冻结授信额度成功！
			}	
		}	
	}
	
	/*~[Describe=解冻授信额度;InputParam=无;OutPutParam=无;]~*/
	function unfreezeRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getBusinessMessage('403')))//确实要解冻该笔授信额度吗？
		{
			//解冻操作
			sReturn=RunMethod("BusinessManage","FreezeCreditLine",sSerialNo+","+"3");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {				
				alert(getBusinessMessage('404'));//解冻授信额度失败！
				return;			
			}else
			{
				reloadSelf();	
				alert(getBusinessMessage('405'));//解冻授信额度成功！
			}	
		}	
	}
	
	/*~[Describe=授信额度项下业务;InputParam=无;OutPutParam=无;]~*/
	function lineSubList()
	{		
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//modify by hwang 20070701,修改组件参数。将CreditAggreement改为LineNo
		popComp("lineSubList","/CreditManage/CreditLine/lineSubList.jsp","LineNo="+sSerialNo,"","");
	}
			
	/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/
	function openWithObjectViewer()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}		
		openObject("BusinessContract",sSerialNo,"002");
	}
    
	/*~[Describe=查看额度使用情况;InputParam=无;OutPutParam=无;]~*/
	function QueryUseInfo()
	{
		var serialNo=getItemValue(0,getRow(),"SerialNo");
		var sBusinessType=getItemValue(0,getRow(),"BusinessType");
		if (typeof(serialNo)=="undefined" || serialNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }  
		AsControl.PopView("/CreditManage/CreditLine/CreditLineUseList.jsp","SerialNo="+serialNo,"dialogWidth=800px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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

<%@ include file="/IncludeEnd.jsp"%>
