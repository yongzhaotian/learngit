<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "退保审批页面";
    //定义变量
    String sTempletNoType="";
    String sBusinessDate=SystemConfig.getBusinessTime();
    
	//获得页面参数
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	if(sApplyType==null) sApplyType="";
		sTempletNoType = "CancelInsuranceListRealTime";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = sTempletNoType;//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled=true;//设置可多选
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause = " where 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	 if(!doTemp.haveReceivedFilterCriteria()){
		 doTemp.WhereClause+="  and mi.status='3' "; 
	 }
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(15);
	
//	doTemp.WhereClause+=" and mi.status in ('3','4','5') ) ";
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
			{"false","","Button","退保审批","确认退保","httpPostSend()",sResourcesPath},
			{"false","","Button","取消退保","取消退保","canhttpPostSend()",sResourcesPath},
			{"true","","Button","导出","导出","exportAll()",sResourcesPath},
		};
    
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
  function httpPostSend(){
	  var sAlertIDString="";
		if(!confirm("退保后该合同将无法再次申请投保，确定要退保？")){
			return;
		}else{
			var policyno = getItemValueArray(0,"policyno");// 多选
			var policynos="";
			for(var i=0;i<policyno.length;i++){
				if(i==0){
					policynos=policyno[i];
				}else{
					policynos=policynos+"@"+policyno[i];
				}
			}
			
			if(	typeof(policynos)=="undefined" || policynos.length==0){//单选
		    	//保单号
		    	policynos =getItemValue(0,getRow(),"policyno");
					if (typeof(policynos)=="undefined" || policynos.length==0){
						alert(getHtmlMessage(1));  //请选择一条记录！
					
						return;
					}
				}
			
				if(policynos){
					var sUserID = "<%=CurUser.getUserID()%>";
					ShowMessage("退保一条记录大约3秒，请等待....",true,false);
				var str=	RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateMinanSerialNo", "httpPostPolicynoRealTime","policyno="+policynos+",updateBy="+sUserID);
				hideMessage();
				if(str=="S"){
						alert("退保数据与民安数据对接成功！");
					}else{
						alert(str);
					}
					
				}
			reloadSelf();// 刷新
		}
  }
  
  
  function canhttpPostSend(){
	  var sAlertIDString="";
		if(!confirm("是否要取消该笔退保申请？")){
			return;
		}else{

			
			var policyno = getItemValueArray(0,"policyno");
			var policynos="";
			for(var i=0;i<policyno.length;i++){
				if(i==0){
					policynos=policyno[i];
				}else{
					policynos=policynos+"@"+policyno[i];
				}
			}
			if(	typeof(policynos)=="undefined" || policynos.length==0){
	    	//保单号
	    	policynos =getItemValue(0,getRow(),"policyno");
				if (typeof(policynos)=="undefined" || policynos.length==0){
					alert(getHtmlMessage(1));  //请选择一条记录！
					return;
				}
			}
			
				if(policynos){
					var sUserID = "<%=CurUser.getUserID()%>";
				var str=	RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateMinanSerialNo", "updateMinanSerialN1RealTime","policyno="+policynos+",updateBy="+sUserID);
					if(str=="S"){
						alert("取消退保成功！");
					}
				}
			reloadSelf();// 刷新
		}
}
	  
	  
  
	function exportAll(){
		amarExport("myiframe0");
	}

	$(document).ready(function(){
		AsOne.AsInit();
		//showFilterArea();//查询条件展开设置
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>