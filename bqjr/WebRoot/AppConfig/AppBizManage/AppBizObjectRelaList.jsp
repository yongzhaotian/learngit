<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	//获得参数	
	String sObjectType =  CurPage.getParameter("ObjectType");
	if(sObjectType==null) sObjectType="";
	
	ASObjectModel doTemp = new ASObjectModel("AppBizObjectRelaList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);
	
	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sObjectType);

	String sButtons[][] = {
		{"true","All","Button","新增","新增一条记录","newRecord()","","","","btn_icon_add"},
		{"true","All","Button","删除","删除所选中的记录","deleteRecord()","","","","btn_icon_delete"},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	/*~[Describe=新增记录;]~*/
	function newRecord(){
        OpenPage("/AppConfig/AppBizManage/AppBizObjectRelaInfo.jsp?ObjectType=<%=sObjectType%>","frameright","");  
	}

    /*~[Describe=查看及修改详情;]~*/
	function mySelectRow(){
		var sRelationShip = getItemValue(0,getRow(),"RelationShip");
		if(typeof(sRelationShip)=="undefined" || sRelationShip.length==0){
			OpenPage("/AppMain/Blank.jsp","frameright");
		}else{
	      	OpenPage("/AppConfig/AppBizManage/AppBizObjectRelaInfo.jsp?ObjectType=<%=sObjectType%>&RelationShip="+sRelationShip,"frameright"); 
		}
	}
    
	/*~[Describe=删除记录;]~*/
	function deleteRecord(){
		var sRelationShip = getItemValue(0,getRow(),"RelationShip");
		if(typeof(sRelationShip)=="undefined" || sRelationShip.length==0){
			alert(getMessageText('AWEW1001'));//请选择一条信息！
	      return ;
		}
		if(confirm("您确定删除该记录吗？")){
			as_delete("myiframe0","");
		}
		
	}
	mySelectRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>