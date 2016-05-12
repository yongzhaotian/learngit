<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 公告列表
	 */
	String PG_TITLE = "公告列表";
	
//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "BoardList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	//删除相应的物理文件;DelDocFile(表名,where语句)
	//dwTemp.setEvent("BeforeDelete","!DocumentManage.DelDocFile(BOARD_LIST,BoardNo='#BoardNo')");
	dwTemp.setEvent("BeforeDelete","!DocumentManage.DelDocFile(DOC_ATTACHMENT,DocNo='#DocNo')");
	dwTemp.setEvent("AfterDelete","!DocumentManage.DelDocRelative(#DocNo)");
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","All","Button","新增公告","新增公告","my_add()",sResourcesPath},
		{"true","All","Button","删除公告","删除公告","my_del()",sResourcesPath},
		{"true","","Button","公告详情","查看公告详情","my_detail()",sResourcesPath},
		{"true","","Button","公告附件","查看公告附件","DocDetail()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function initRow(){
		if (getRowCount(0)==0){
		 	as_add("myiframe0");
		}
	}
	
	function my_add(){
		AsControl.OpenView("/AppConfig/BoardManage/BoardInfo.jsp","","rightdown","");
	}
	
	function my_detail(){
		var sBoardNo = getItemValue(0,getRow(),"BoardNo");			
		if (typeof(sBoardNo)=="undefined" || sBoardNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		AsControl.OpenView("/AppConfig/BoardManage/BoardInfo.jsp","BoardNo="+sBoardNo,"rightdown","");
	}
	
	<%/*[Describe=查看公告附件;]*/%>
	function DocDetail(){
		var sDocNo = getItemValue(0,getRow(),"DocNo");
		if(typeof(sDocNo)=="undefined" || sDocNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//AsControl.OpenView("/AppConfig/Document/AttachmentList.jsp","DocNo="+sDocNo,"rightdown","");
		AsControl.PopView("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+sDocNo, "dialogWidth=650px;dialogHeight=350px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	function my_del(){
		var sBoardNo = getItemValue(0,getRow(),"BoardNo");	
		if (typeof(sBoardNo)=="undefined" || sBoardNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('2'))){ //您真的想删除该信息吗？
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
		parent.reloadSelf();
	}

	<%/*~[Describe=单击事件;]~*/%>
	function mySelectRow(){
		var sBoardNo = getItemValue(0,getRow(),"BoardNo");
		if (typeof(sBoardNo)=="undefined" || sBoardNo.length==0){
			AsControl.OpenView("/Blank.jsp","TextToShow=请先选择相应的信息!","rightdown","");
		}else{
			AsControl.OpenView("/AppConfig/BoardManage/BoardInfo.jsp","BoardNo="+sBoardNo,"rightdown","");
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%@	include file="/IncludeEnd.jsp"%>