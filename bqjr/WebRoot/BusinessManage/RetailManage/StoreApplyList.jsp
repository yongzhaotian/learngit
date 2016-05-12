<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "示例列表页面";
	//获得页面参数
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "StoreApplyList";//模型编号
	String sType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("type"));
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	String sUserCity = Sqlca.getString(new SqlObject("select city from user_info where userid=:userid").setParameter("userid", CurUser.getUserID()));
	if(CurUser.hasRole("1004")){
	if(sType.equals("01")){
		   doTemp.WhereClause="where  PrimaryApproveTime is null and AgreementApproveTime is null and AgreementApproveTime is null and PrimaryApproveStatus='3' and  AgreementApproveStatus='3' and SafDepApproveStatus='3' and city='"+sUserCity+"'"; 
				      			

		}else if (sType.equals("02")){
			
			doTemp.WhereClause="where ((PrimaryApproveStatus in ('1','4') and  AgreementApproveStatus in ('1','4') and SafDepApproveStatus='4')or(PrimaryApproveStatus in ('1','4') and  AgreementApproveStatus ='4' and SafDepApproveStatus in ('1','4')))and city='"+sUserCity+"'";
		}else if(sType.equals("03")){
			doTemp.WhereClause="where PrimaryApproveStatus ='1' and  AgreementApproveStatus='1' and SafDepApproveStatus='1' and sno is not null and city='"+sUserCity+"'";
		}else {
			
			doTemp.WhereClause="where (PrimaryApproveStatus ='2' or  AgreementApproveStatus='2' or SafDepApproveStatus='2' )and city='"+sUserCity+"'";
		}
	}else {
		if(sType.equals("01")){
			   doTemp.WhereClause="where  PrimaryApproveTime is null and AgreementApproveTime is null and AgreementApproveTime is null and PrimaryApproveStatus='3' and  AgreementApproveStatus='3' and SafDepApproveStatus='3' and inputuser='"+CurUser.getUserID()+"'"; 
					      			

			}else if (sType.equals("02")){
				
				doTemp.WhereClause="where ((PrimaryApproveStatus in ('1','4') and  AgreementApproveStatus in ('1','4') and SafDepApproveStatus='4')or(PrimaryApproveStatus in ('1','4') and  AgreementApproveStatus ='4' and SafDepApproveStatus in ('1','4')))and inputuser='"+CurUser.getUserID()+"'";
			}else if(sType.equals("03")){
				doTemp.WhereClause="where PrimaryApproveStatus ='1' and  AgreementApproveStatus='1' and SafDepApproveStatus='1' and sno is not null and inputuser='"+CurUser.getUserID()+"'";
			}else {
				
				doTemp.WhereClause="where (PrimaryApproveStatus ='2' or  AgreementApproveStatus='2' or SafDepApproveStatus='2' )and inputuser='"+CurUser.getUserID()+"'";
			}
	}
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、快捷键	7、	8、	9、图标，CSS层叠样式 10、风格
			{(sType.equals("01")&&CurUser.hasRole("1005"))?"true":"false","All","Button","新增","新增一条记录","newRecord()","","","","btn_icon_add",""},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()","","","","btn_icon_detail",""},
			{(sType.equals("01")&&CurUser.hasRole("1005"))?"true":"false","All","Button","删除","删除所选中的记录","deleteRecord()","","","","btn_icon_delete",""},
			{((sType.equals("01")||sType.equals("04"))&&CurUser.hasRole("1005"))?"true":"false","All","Button","提交","提交所选中的记录","doSubmit()","","","","btn_icon_submit",""},
			{(sType.equals("02")&&CurUser.hasRole("1005"))?"true":"false","","Button","撤销","撤销","UndoRetailInfo()","","","","btn_icon_detail",""}, //add by tangyb CCS-992
		};
	
	
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		
     	AsControl.PopView("/BusinessManage/RetailManage/StoreInfoDetail.jsp", "", "");
		reloadSelf();
	
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
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
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sRegCode=getItemValue(0,getRow(),"REGCODE");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
	
		AsControl.OpenView("/BusinessManage/RetailManage/StoreInfoDetail.jsp","SerialNo="+sSerialNo+"&RegCode="+sRegCode+"&PhaseType=<%=sType%>","_blank");
		reloadSelf();
	}
	
	//-- add by 添加撤销功能 tangyb 20151223 --//
	function UndoRetailInfo(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		var sPrimaryApproveStatus = RunMethod("公用方法", "GetColValue", "store_info,PRIMARYAPPROVESTATUS,serialno='"+sSerialNo+"'");
		var sAgreementApproveStatus = RunMethod("公用方法", "GetColValue", "store_info,AGREEMENTAPPROVESTATUS,serialno='"+sSerialNo+"'");
	    var sSafDepApproveStatus = RunMethod("公用方法", "GetColValue", "store_info,SAFDEPAPPROVESTATUS,serialno='"+sSerialNo+"'");
	    if((sPrimaryApproveStatus !="4") || (sAgreementApproveStatus !="4" )|| (sSafDepApproveStatus !="4" ) ){
	    	alert("初审或合作协议或安全部已审批，不能撤销！");
	    }else if(sPrimaryApproveStatus=="4"&&sAgreementApproveStatus=="4" &&sSafDepApproveStatus=="4"){
	    	RunMethod("PublicMethod","UpdateColValue","String@PrimaryApproveStatus@3@String@PrimaryApproveTime@None@String@AgreementApproveStatus@3@String@SafDepApproveStatus@3,store_info,String@SerialNo@"+sSerialNo);
	    	RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateRetailRno", "selectSnoIsBuild", "SerialNo="+sSerialNo);
	    	alert("撤销成功");
	    }
	    reloadSelf();
	}
	//-- end --//
	
	function doSubmit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sRegCode = getItemValue(0,getRow(),"REGCODE");
	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var sCount = RunMethod("公用方法", "GetColValue", "DOC_ATTACHMENT,count(1),OBJECTNO='"+sRegCode+"'");
		if(sCount=="0.0"){
			alert("请先上传附件信息！");
			return;
		}
		//设置是否有门店确认函
		var sCount = RunMethod("公用方法", "GetColValue", "DOC_ATTACHMENT,count(1), Type='A0002' and OBJECTNO='"+sRegCode+"'");
		if(sCount=="0.0"){
			RunMethod("公用方法", "UpdateColValue", "store_info,ISSTORECONFIRLETTER,2,serialno='"+sSerialNo+"'");
		}else{
			RunMethod("公用方法", "UpdateColValue", "store_info,ISSTORECONFIRLETTER,1,serialno='"+sSerialNo+"'");
		}
		
		var sType = "<%=sType%>";
		if(sType=="04"){
			RunMethod("BusinessManage", "UpdateStorelTime",sSerialNo);
		}

		//提交
		RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateRetailRno", "firstSubmitStore", "SerialNo="+sSerialNo);
		
		reloadSelf();
	}
	<%/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/%>
	function openWithObjectViewer(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		AsControl.OpenObject("Example",sExampleId,"001");//使用ObjectViewer以视图001打开Example，
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
