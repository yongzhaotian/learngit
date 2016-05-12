<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String PG_TITLE = "利率管理";

	String sRateType = DataConvert.toRealString(iPostChange,(String)request.getParameter("RateType"));  
	if(sRateType == null) sRateType = "";	
	
	//通过sql产生数据窗体对象		
	ASDataObject doTemp = new ASDataObject("RateList","",Sqlca);
	//设置表头
	if(sRateType != null && !"".equals(sRateType))
	{
		doTemp.WhereClause += " and RateType = '"+sRateType+"' ";
	}
	
	//增加过滤器
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	//生成ASDataWindow对象，参数一用于本页面内区别其他的ASDataWindow，参数二是ASDataObject对象	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		

	String sButtons[][] = {
			{"true","","Button","新增","新增","newRecord()",sResourcesPath},
			{"true","","Button","查看/修改","查看/修改","viewAndEdit()",sResourcesPath},
			{"true","","Button","刷新利率定义","刷新利率定义","reloadCache()",sResourcesPath},
		};
	%> 


	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script type="text/javascript">
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		AsControl.PopView("/SystemManage/SynthesisManage/RateInfo.jsp","",
				"dialogWidth="+(screen.availWidth*0.3)+"px;dialogHeight="+(screen.availHeight*0.4)+"px;resizable=yes;maximize:yes;help:no;status:no;"); 
		self.reloadSelf();
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit(){
	    var sRateType = getItemValue(0,getRow(),"RateType");
	    var sTermUnit = getItemValue(0,getRow(),"TermUnit");
	    var sTerm = getItemValue(0,getRow(),"Term");
	    var sRateUnit = getItemValue(0,getRow(),"RateUnit");
	    var sEffectDate = getItemValue(0,getRow(),"EffectDate");
		if (typeof(sRateType)=="undefined" || sRateType.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}

		AsControl.PopView("/SystemManage/SynthesisManage/RateInfo.jsp",
				"RateType="+sRateType+"&TermUnit="+sTermUnit+"&Term="+sTerm+"&RateUnit="+sRateUnit+"&EffectDate="+sEffectDate,
				"dialogWidth="+(screen.availWidth*0.5)+"px;dialogHeight="+(screen.availHeight*0.6)+"px;resizable=yes;maximize:yes;help:no;status:no;");
		self.reloadSelf();
	}

	function reloadCache(){
		AsDebug.reloadCache('RateSet');
		reloadSelf();
	}
	</script>


<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	


<%@ include file="/IncludeEnd.jsp"%>
