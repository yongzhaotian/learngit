<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 <%@ page import="com.amarsoft.dict.als.cache.CodeCache"%>
<%
	/*
		Author:  yongxu 2015/05/25
		Tester:
		Content: 影像类型信息
		Input Param:
		Output param:
		History Log: 
	*/
	
	String PG_TITLE = "影像类型信息";
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","450");
	String iButtonsLineMax = "3";
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);
 	//获取页面参数
 	
 	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));//任务编号
 	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));//阶段编号
 	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));//任务编号
 	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));//任务编号
 	
 	String sOperateMode = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OperateMode"));//操作类型
 	String ssuretype = Sqlca.getString(new SqlObject("SELECT suretype FROM business_contract WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", sObjectNo));
 	
 	String sCheckStatus = Sqlca.getString( new SqlObject("Select checkstatus From CHECK_CONTRACT "+
		" Where ContractSerialNo = :SerialNo").setParameter( "SerialNo", sObjectNo ) );
	if( sCheckStatus == null ) sCheckStatus = " ";
 	
	String sCheckResult = Sqlca.getString(new SqlObject("SELECT CheckResult FROM check_contract WHERE CONTRACTSERIALNO=:SERIALNO").setParameter("SERIALNO", sObjectNo));
	if( sCheckResult == null ) sCheckResult = " ";
	
 	if(sObjectNo==null) sObjectNo = "";
 	if(sPhaseNo==null) sPhaseNo = "";
 	if(sObjectType==null) sObjectType = "";
 	
	String typeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
 	String sStartWithId = CurComp.getParameter("StartWithId");
 	if (sStartWithId == null) sStartWithId = "";

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CheckDocImageTypeList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.multiSelectionEnabled=false;//设置可多选
	
	doTemp.setVisible("OPINION1,OPINION2,QualityMark1,QualityMark2", false);
	doTemp.setVisible("CHECKOPINION1", true);
	doTemp.setVisible("CHECKOPINION2", true);
	doTemp.setVisible("QualityMarkLoan1", true);
	doTemp.setVisible("QualityMarkLoan2", true);
	
	if("4".equals(sCheckStatus)){//初审中
		doTemp.setReadOnly("CHECKOPINION2", true);//初审只能修改初审意见
		doTemp.setReadOnly("QualityMarkLoan2", true);
	}else if("7".equals(sCheckStatus)){//销售补充资料完成，复审中
		doTemp.setReadOnly("CHECKOPINION1", true);//复审不能签署复审意见
		doTemp.setReadOnly("QualityMarkLoan1", true);
	}else if("5".equals(sCheckStatus)) { // 初审有错误
		doTemp.setReadOnly("CHECKOPINION2,QualityMarkLoan2", true);
	}else if("1".equals(sCheckStatus) && "1".equals(sCheckResult)){
		doTemp.setReadOnly("CHECKOPINION2,QualityMarkLoan2", true);   //初审合同，管理员修改质量标注
	}else if("1".equals(sCheckStatus) && !"1".equals(sCheckResult)){
		doTemp.setReadOnly("CHECKOPINION1,QualityMarkLoan1", true);   //复审合格，管理员修改质量标注
	}
	
	doTemp.WhereClause += " and ECM_IMAGE_OPINION.TypeNo in (Select ECM_Image_Type.TypeNo from ECM_Image_Type where ECM_Image_Type.isinuse = '1') and ECM_IMAGE_OPINION.ObjectType = 'BusinessLoan' "; 
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+sObjectType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{("view".equals(sOperateMode))?"true":"false","","Button","保存","保存记录","saveRecord()",sResourcesPath},
		{"true","","Button","审核要点提示","审核要点提示","AuditPoints()",sResourcesPath},
		{"true","","Button","电子合同","电子合同","createPDF()",sResourcesPath},
		{"true","","Button","查看摩托车车驾号","查看摩托车车驾号","viewMotuoPhoto()",sResourcesPath},
		{("upload".equals(sOperateMode))?"true":"false","","Button","补充贷后资料","补充贷后资料","imageManage()",sResourcesPath}
	};
	
	String AppUrl4pdf = CodeCache.getItem("PrintAppUrl","0010").getItemAttribute();
	String FCUrl4pdf = CodeCache.getItem("PrintAppUrl","0015").getItemAttribute();
	String sToday = StringFunction.getTodayNow();

%>
<%@include file="/Resources/CodeParts/List0501.jsp"%>

<script type="text/javascript">
	
	function saveRecord()
	{	
		//文件质量检查审核保存时间
		var sObjectNo   = "<%=sObjectNo%>";
		var sCheckStatus="<%=sCheckStatus%>";
		var sToday="<%=sToday%>";
		if(sCheckStatus=="4"){ //更新文件质量检查初审保存时间
			RunMethod("公用方法","UpdateColValue","check_contract,savetime3,"+sToday+",contractserialno = '"+sObjectNo+"'");
		}else if(sCheckStatus=="7"){//更新文件质量检查复审保存时间
			RunMethod("公用方法","UpdateColValue","check_contract,savetime4,"+sToday+",contractserialno = '"+sObjectNo+"'");
		}
		as_save("myiframe0");
//		checkAfterSave();
//		parent.reloadSelf();
	}
 	
	function checkAfterSave(){
		var sObjectNo   = "<%=sObjectNo%>"; //合同流水号
		//贷后资料总条数
		var sReturn = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' ");
		//初审未填写意见条数
		var sReturn4 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion1 is null ");
		//初审合格条数
//		var sReturn1 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion1 ='1' ");
		//初审关键错误条数
		var sReturn23 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion1 ='3' ");
		//初审非关键错误条数
		var sReturn22 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion1 ='2'  ");
		//复审未填写意见条数
		var sReturn5 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion2 is null ");
		//复审关键错误条数
		var sReturn63 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion2 ='3' ");
		//复审非关键错误条数
		var sReturn62 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion2 ='2'  ");

		//检查状态
		var sReturn3 = RunMethod("公用方法","GetColValue","BUSINESS_CONTRACT,CHECKSTATUS,SerialNo='"+sObjectNo+"' ");
		if(sReturn3 == "4"){//第一次检查
			if(sReturn4==sReturn){
				alert("未填写意见！");
				return false;
			}
			if(sReturn23 > 0){//有关键错误
				RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,checkstatus,5,SerialNo='"+sObjectNo+"' ");//补充资料
				RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,checkresult,3,SerialNo='"+sObjectNo+"' ");//更新合同状态为关键错误
			}else if(sReturn22 > 0){//有非关键错误
				RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,checkstatus,5,SerialNo='"+sObjectNo+"' ");//补充资料
				RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,checkresult,2,SerialNo='"+sObjectNo+"' ");//更新合同状态为非关键错误
			}else{// 都合格
				RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,checkstatus,1,SerialNo='"+sObjectNo+"' ");//检查通过
				RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,checkresult,1,SerialNo='"+sObjectNo+"' ");//更新合同状态为合格
			}
		}else if(sReturn3 == "7"){//第二次检查
			if(sReturn5==sReturn){
				alert("未填写意见！");
				return false;
			}
			if(sReturn63 > 0){//有关键错误
				RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,checkstatus,1,SerialNo='"+sObjectNo+"' ");//复审也不通过，结束
				RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,checkresult,3,SerialNo='"+sObjectNo+"' ");//更新合同状态为关键错误
			}else if(sReturn62 > 0){//有非关键错误
				RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,checkstatus,1,SerialNo='"+sObjectNo+"' ");//复审也不通过，结束
				RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,checkresult,2,SerialNo='"+sObjectNo+"' ");//更新合同状态为非关键错误
			}else{// 都合格
				RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,checkstatus,1,SerialNo='"+sObjectNo+"' ");//检查通过
				RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,checkresult,1,SerialNo='"+sObjectNo+"' ");//更新合同状态为合格
			}
		}
	}
	//电子合同
	function createPDF(){
	    var ssuretype = "<%=ssuretype%>";
	    if (ssuretype == null || ssuretype.length == 0 || ssuretype == "null" || ssuretype == "PC") {
	        alert("该合同非电子合同!");
	        return;
	    }
	    //通过　serverlet 打开页面
	    var url= "";
	    var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";  
	    if(ssuretype == 'APP'){
	    	url="<%=AppUrl4pdf%>"+"<%=sObjectNo%>";
		    window.open(url,"_blank",CurOpenStyle);
	    }else if(ssuretype == 'FC'){
	    	url="<%=FCUrl4pdf%>"+"<%=sObjectNo%>";
	    	window.open(url,"_blank",CurOpenStyle);
	    }
	}
	
	//补充贷后影像资料
	function imageManage(){
		var sObjectNo   = "<%=sObjectNo%>";
		var param = "ObjectType=BusinessLoan&ObjectNo="+sObjectNo+"&uploadPeriod=1";
		AsControl.PopView( "/ImageManage/CheckImageAfterLoanView.jsp", param, "" );
    }
	
	//审核要点提示
	function AuditPoints(){
        var sObjectNo   = "<%=sObjectNo%>";        
	     var param = "ObjectType=BusinessLoan&ObjectNo="+sObjectNo;
	     AsControl.PopView( "/ImageManage/ImageTypeListAuditPointsView.jsp", param, "" );
    }
	
	//PAD项目 CRA-372 贷后资料中，增加查看摩托车车架号图片功能
	//查看贷后文件资料
	function viewMotuoPhoto(){
		var sTypeNo = "20029";
		var sObjectType = "Business";
    	var sRightType = "ReadOnly";
    	var sObjectNo   = "<%=sObjectNo%>";
    	var sReturn = RunMethod("公用方法","GetColValue","Ecm_Page,count(1),ObjectNo='"+sObjectNo+"' and TypeNo = '"+sTypeNo+"' ");
    	if(sReturn == 0){
    		alert("该合同没有上传摩托车车驾号!");
    		return;
    	}
		OpenPage("/ImageManage/ImageViewInfo.jsp?ObjectType="+sObjectType+"&ObjectNo=<%=sObjectNo%>&TypeNo="+sTypeNo+"&RightType="+sRightType,"DetailFrame","");  
    }
	//查看贷后文件资料
	function scanLoan(){
    	var sTypeNo = getItemValue(0,getRow(),"TYPENO");//获取选中的记录ID	
		if (typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert("请选择一条记录！");
			return;
		}
    	var sRightType = "ReadOnly";
		OpenPage("/ImageManage/ImageViewInfo.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&TypeNo="+sTypeNo+"&RightType="+sRightType+"&uploadPeriod=1","DetailFrame","");  
    }
	function mySelectRow(obj){
		scanLoan();
    }
 	
	function initRecord(){
		var sSeriaslNo = getItemValueArray1(0,"TYPENO");
		var sOpinion1 = getItemValueArray1(0,"OPINION1");
		for(var i = 0; i < sSeriaslNo.length; i ++){
			var tmpTypeNo = sSeriaslNo[i];
			if(tmpTypeNo=="20001" || tmpTypeNo=="20025" || tmpTypeNo=="20002" ){
				setItemValue(0,i,"CHECKOPINION1","1");
				setItemValue(0,i,"CHECKOPINION2","");
				setItemReadOnly1(0,i,"CHECKOPINION1",true);
				setItemReadOnly1(0,i,"CHECKOPINION2",true);
			}
		}
		if(!(sCheckStatus=="1" || sCheckStatus == "5")){
			for(var i = 0; i < sOpinion1.length; i ++){
				var tmpOpinion = sOpinion1[i];
				if(tmpOpinion=="1"){
					setItemValue(0,i,"CHECKOPINION2","");//复审意见置空
					setItemReadOnly1(0,i,"CHECKOPINION2",true);
				}
			}
		}
		
	}
	
	function setItemReadOnly1(iDW,iRow,sCol,bReadOnly){
		iCol = getColIndex(iDW,sCol);
	//	window.frames["myiframe"+iDW].document.forms[0].elements["R"+iRow+"F"+iCol].readOnly = bReadOnly;
		window.frames["myiframe"+iDW].document.forms[0].elements["R"+iRow+"F"+iCol].setAttribute("disabled","disabeld");
	}

	function getItemValueArray1(iDW,sColumnID){
		var b = getRowCount(iDW);
		var countSelected = 0;
		var sMemberIDTemp = "";
		var sSelected = new Array(1000);
		for(var iMSR = 0 ; iMSR < b ; iMSR++){
			var a = getItemValue(iDW,iMSR,"MultiSelectionFlag");
			if(a == "on"){
				sSelected[countSelected] = getItemValue(iDW,iMSR,sColumnID);
				countSelected++;
			}
		}
		var sReturn = new Array(countSelected);
		for(var iReturnMSR = 0;iReturnMSR < countSelected; iReturnMSR++){
			sReturn[iReturnMSR] = sSelected[iReturnMSR];
		}
		return sReturn;
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
		initRecord();
	});
</script>	

<%@ include file="/IncludeEnd.jsp"%>