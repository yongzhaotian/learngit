<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "资产转让项目管理列表页面";
	//获得页面参数
	String sStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProjectPhoseType"));//项目状态0010：筹建中; 0020：动作中；0030：己终结;
	if(sStatus==null) sStatus="";
	//转让类型
	String sTransferType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransferType"));
	if(sTransferType==null) sTransferType="";
	
	//out.println("项目阶段："+sStatus+"转让类型："+sTransferType);
	
	
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "BuildProjectList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	
	//增加项目关联协议查询条件判断（区分关联首次转让协议的项目，和关联再次转让协议的项目查询条件）
	doTemp.WhereClause +=" and status='"+sStatus+"' and ProtocolNo in(select serialno from transfer_deal where transfertype='"+sTransferType+"')";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增转让","新增转让","newRecord()",sResourcesPath},
		{"true","","Button","取消转让","取消转让","",sResourcesPath},
		{"true","","Button","转让详情","转让详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除","deleteRecord()",sResourcesPath},
	};
	
	//非筹建阶段的项目不能做删除和取消转让操作
	if(!sStatus.equals("0010")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
		sButtons[3][0]="false";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/BusinessManage/CollectionManage/BuildProjectInfo.jsp","TransferType=<%=sTransferType%>&Status=<%=sStatus%>","_self","");
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//项目编号
		var sProtocolNo = getItemValue(0,getRow(),"ProtocolNo");//项目所属的协议编号
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		if (typeof(sProtocolNo)=="undefined" || sProtocolNo.length==0){
			alert("该项目信息不完整，关联的协议编号为空！");
			return;
		}
		//AsControl.OpenView("/BusinessManage/CollectionManage/BuildProjectDetail.jsp","SerialNo="+sSerialNo+"&RightType=ReadOnly","_blank");
		AsControl.OpenView("/BusinessManage/CollectionManage/BuildProjectDetail.jsp","SerialNo="+sSerialNo+"&ProtocolNo="+sProtocolNo,"_blank");
	}
	
	$(document).ready(function(){
		//showFilterArea();
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>