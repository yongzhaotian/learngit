<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
 
 <%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "未回盘数据查询";
	ASDataObject doTemp = new ASDataObject("ImportNoRecList",Sqlca);
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
			//{"true","","Button","未回盘数据查询","未回盘数据查询","affirmWithhold()",sResourcesPath},
		    };
%>

<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">


<%/*~[Describe=再次代扣申请确认;InputParam=无;OutPutParam=无;]~*/%>
function affirmWithhold(){
	var sSerialNo = getItemValue(0,getRow(),"outid");
	
	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
	{
		alert(getHtmlMessage(1));  //请选择一条记录！
		return;
	}
	
	
	var returlVale = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.WithholdSimpleQuery","sendPayMentSimple","serialNo="+sSerialNo);
	if(returlVale == 'true'){
		alert("查询成功!");
	}else{
		alert('调用接口失败!');
	}
	reloadSelf();
}
	


	$(document).ready(function(){
		AsOne.AsInit();
		//showFilterArea();//查询条件展开设置
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>