<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 格式化报告参数列表
	 */
	String PG_TITLE = "格式化报告参数列表"; // 浏览器窗口标题 <title> PG_TITLE </title>

	String[][] sHeaders={
		    {"OrgName","使用机构"},
			{"DocID","报告编号"},
			{"DefaultValue","缺省节点"},
			{"DocName","报告名称"}
		};

	String sSql =  " select OrgID,getOrgName(OrgID) as OrgName,DocID,DefaultValue,DocName "+
			" from FormatDoc_Para where 1=1";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FormatDoc_Para";
	doTemp.setKey("DocID,OrgID",true);
	doTemp.setHeader(sHeaders);
	
	doTemp.setVisible("OrgID",false);
	doTemp.setHTMLStyle("OrgName,DocID"," style={width:70px} ");
	doTemp.setHTMLStyle("DefaultValue,DocName"," style={width:240px} ");

	//查询
 	doTemp.setColumnAttribute("OrgName,DocID,DocName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		sReturn=popComp("FormatdocParaInfo","/Common/Configurator/FormatDocManage/FormatdocParaInfo.jsp","","");
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
            //新增数据后刷新列表
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				sReturnValues = sReturn.split("@");
				if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
					OpenPage("/Common/Configurator/FormatDocManage/FormatdocParaList.jsp","_self","");    
                }
            }
        }
	}
	
	function viewAndEdit(){
		var sDocID = getItemValue(0,getRow(),"DocID");
		var sOrgID = getItemValue(0,getRow(),"OrgID");
       if(typeof(sDocID)=="undefined" || sDocID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
       //openObject("FlowCatalogView",sFlowNo,"001");
       popComp("FormatdocParaInfo","/Common/Configurator/FormatDocManage/FormatdocParaInfo.jsp","DocID="+sDocID+"~"+"OrgID="+sOrgID,"");
	}

	function deleteRecord(){
		var sDocID = getItemValue(0,getRow(),"DocID");
		if(typeof(sDocID)=="undefined" || sDocID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		if(confirm(getHtmlMessage('69'))){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>