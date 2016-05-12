<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "影像列表";
	//获得页面参数
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ImageList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow( "" );
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","查看","查看记录","imageManage()",sResourcesPath},
		{"true","","Button","修改备注","修改备注","remark()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	
    /*~[Describe=影像操作;InputParam=无;OutPutParam=无;]~*/
    function imageManage(){
    	var sObjectType   = getItemValue(0,getRow(),"OBJECTTYPE");
    	var sObjectNo   = getItemValue(0,getRow(),"OBJECTNO");
    	var typeNo = getItemValue(0,getRow(),"TYPENO");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
     var param = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TypeNo="+typeNo;
     //alert(param);return;
     AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" );
     reloadSelf();
    }
    /*修改备注*/
    function remark() {
    	var sObjectType   = getItemValue(0,getRow(),"OBJECTTYPE");
    	var sObjectNo   = getItemValue(0,getRow(),"OBJECTNO");
    	var typeNo = getItemValue(0,getRow(),"TYPENO");
    	var pageNum = getItemValue(0,getRow(),"PAGENUM");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
        var param = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TypeNo="+typeNo+"&PageNum="+pageNum;
        AsControl.PopView( "/ImageManage/ImageInfo.jsp", param, "dialogwidth=500px;dialogheight=600px;" );
        reloadSelf();
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
