<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "门店准入审批";
	//获得页面参数
	String sType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("type"));
	if(sType==null) sType="";
	System.out.println("----------------------"+sType);
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "StoreApproveList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.WhereClause="where SI.PrimaryApproveStatus='4' and SI.PrimaryApproveTime is null";
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled=true;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、快捷键	7、	8、	9、图标，CSS层叠样式 10、风格
			
			{"true","","Button","初审","初审","PrimaryApprove()","","","","btn_icon_detail",""},
			
			
			
		};
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function PrimaryApprove(){
		var sSeriaslNo = getItemValueArray(0,"SERIALNO");
		var sRegCode =  getItemValueArray(0,"SREGCODE");
	
		var  sSerialNo=sSeriaslNo[0];
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		//-- add by 门店在审核时先判断商户初审申请是否通过 tangyb 20151223 --//
		var sRSerialNo = RunMethod("公用方法", "GetColValue", "store_info,rserialno,serialno='"+sSeriaslNo+"'"); //查询零售商编号
		var isApp = RunMethod("公用方法", "GetColValue", "retail_info,primaryapprovestatus,serialno='"+sRSerialNo+"'"); // 查询零售商初审状态
		
		if(isApp != "1"){
			alert("门店关联的零售商["+sRSerialNo+"]还未通过初审申请");
			return;
		}
		//-- end --//
	
		AsControl.OpenView("/BusinessManage/RetailManage/StoreInfoDetailPrimary.jsp","SerialNo="+sSeriaslNo+"&RegCode="+sRegCode,"_blank");
		
		reloadSelf();
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
