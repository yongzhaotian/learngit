<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 
 <%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: 
		Input Param:
		Output param:
		History Log: xswang 20150429 CCS-433 PRM-146 安硕系统公告信息权限设置
	 */
	%>
<%/*~END~*/%>
 
 <%
	/*
		页面说明: 公告详情
	 */
	String PG_TITLE = "公告详情";

	//获得页面参数
	String sBoardNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BoardNo"));
	if(sBoardNo==null) sBoardNo="";

	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "BoardInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sBoardNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","上传文件","上传文件","fileadd()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	function saveRecord(sPostEvents){
		if(bIsInsert){
			setItemValue(0,getRow(),"BoardNo", getSerialNo("BOARD_LIST","BoardNo",""));
			setItemValue(0,getRow(),"DocNo", getSerialNo("DOC_LIBRARY","DocNo",""));
			bIsInsert = false;
		}
		as_save("myiframe0",sPostEvents);
	}
	
	function fileadd(){
		var sDocNo = getItemValue(0,getRow(),"DocNo");
		if(typeof(sDocNo)=="undefined" || sDocNo.length==0) {
			alert("先保存信息再上传文件!");
			return ;
		}else{
			AsControl.PopView("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+sDocNo, "dialogWidth=650px;dialogHeight=350px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    }
	}
	
	//add by xswang 20150429 CCS-433 PRM-146 安硕系统公告信息权限设置
	//弹出发布对象选择窗口，并置将返回的值设置到指定的域
	function selectBoardObject(){
		var retVal = setObjectValue("SelectOrg1","","",0,0,"");
		if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("请选择机构！");
			return;
		}
		var orgName = retVal.split("~");
		var sOrgId = "";
		var sOrgName = "";
		for (var i in orgName) {
			sOrgId += orgName[i].split("@")[0]+",";
			sOrgName += orgName[i].split("@")[1]+",";
		}
		sOrgId = sOrgId.substring(0,sOrgId.length-1);
		setItemValue(0, 0, "BoardObject", sOrgName);
	}
	//end by xswang 20150429

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			bIsInsert = true;
		}
    }

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>