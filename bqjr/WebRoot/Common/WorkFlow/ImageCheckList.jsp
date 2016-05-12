<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 <%@ page import="com.amarsoft.dict.als.cache.CodeCache"%>
<%
	/*
		Author:  xswang 2015/05/25
		Tester:
		Content: 影像类型信息
		Input Param:
		Output param:
		History Log: 
	*/
	
	String PG_TITLE = "影像类型信息";
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","450");
	String iButtonsLineMax = "4";
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);
 	//获取页面参数
 	
 	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));//任务编号
 	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));//阶段编号
 	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));//任务编号
 	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));//任务编号
 	
 	String ssuretype = Sqlca.getString(new SqlObject("SELECT suretype FROM business_contract WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", sObjectNo));
	String sCheckDocStatus = Sqlca.getString(new SqlObject("SELECT CheckDocStatus FROM check_contract WHERE CONTRACTSERIALNO=:SERIALNO").setParameter("SERIALNO", sObjectNo));
 	
	String sCheckDocResult = Sqlca.getString(new SqlObject("SELECT CheckDocResult FROM check_contract WHERE CONTRACTSERIALNO=:SERIALNO").setParameter("SERIALNO", sObjectNo));
	
 	String sBusinessType = Sqlca.getString( new SqlObject("Select BusinessType From BUSINESS_CONTRACT "+
		" Where SerialNo = :SerialNo").setParameter( "SerialNo", sObjectNo ) );
	if( sBusinessType == null ) sBusinessType = " ";
 	
 	if(sObjectNo==null) sObjectNo = "";
 	if(sPhaseNo==null) sPhaseNo = "";
 	if(sObjectType==null) sObjectType = "";
 	
	String typeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
 	String sStartWithId = CurComp.getParameter("StartWithId");
 	if (sStartWithId == null) sStartWithId = "";

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CheckDocImageTypeList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.multiSelectionEnabled=true;//设置可多选

	if("7".equals(sCheckDocStatus)){//复审中
		doTemp.setReadOnly("OPINION1,DESCRIBE1,QualityMark1", true);//复审只能修改复审意见
	}
/* 	else if("4".equals(sCheckDocStatus)){//销售补充资料
		doTemp.setReadOnly("OPINION1,OPINION2,QualityMark1,QualityMark2,DESCRIBE1,remark", true);//销售端不能签署任何意见
	} */  
	//补充资料也可以修改质量等级和质量标注CRA-289 
	else if("4".equals(sCheckDocStatus)){
		doTemp.setReadOnly("OPINION2,QualityMark2", true);//初审不能签署复审意见
	}
	else if("2".equals(sCheckDocStatus)){//初审中
		doTemp.setReadOnly("OPINION2,QualityMark2", true);//初审不能签署复审意见
	}else if("3".equals(sCheckDocStatus) && "1".equals(sCheckDocResult)){
		doTemp.setReadOnly("OPINION2,QualityMark2", true);
	}else if("3".equals(sCheckDocStatus) && !"1".equals(sCheckDocResult)){
		doTemp.setReadOnly("OPINION1,QualityMark1", true);
	}else if("5".equals(sCheckDocStatus)){
		doTemp.setReadOnly("OPINION1,QualityMark1", true);
	}
	
	doTemp.WhereClause += " and ECM_IMAGE_OPINION.TypeNo in (Select ECM_Image_Type.TypeNo from ECM_Image_Type where ECM_Image_Type.isinuse = '1') "; 
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
	//	{sCheckDocStatus.equals("4")?"false":"true","","Button","保存","保存记录","saveRecord()",sResourcesPath},
		{"true","","Button","保存","保存记录","saveRecord()",sResourcesPath},  
		{"true","","Button","审核要点提示","审核要点提示","AuditPoints()",sResourcesPath},
		{"true","","Button","电子合同","电子合同","createPDF()",sResourcesPath},
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
		var sCheckDocStatus="<%=sCheckDocStatus%>";
		var sToday="<%=sToday%>";
		if(sCheckDocStatus == "2"){//更新文件质量检查初审保存时间
			RunMethod("公用方法","UpdateColValue","check_contract,savetime1,"+sToday+",contractserialno = '"+sObjectNo+"'");
		}else if(sCheckDocStatus == "7"){//更新文件质量检查复审保存时间
			RunMethod("公用方法","UpdateColValue","check_contract,savetime2,"+sToday+",contractserialno = '"+sObjectNo+"'");
		}
		as_save("myiframe0");
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
	
	//审核要点提示
	function AuditPoints(){
        var sObjectNo   = "<%=sObjectNo%>";        
	     var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo;
	     AsControl.PopView( "/ImageManage/ImageTypeListAuditPointsView.jsp", param, "" );
    }
	
	//查看文件资料
	function scanLoan(){
    	var sTypeNo = getItemValue(0,getRow(),"TYPENO");//获取选中的记录ID	
		if (typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert("请选择一条记录！");
			return;
		}
    	var sRightType = "ReadOnly";
		var param = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&TypeNo="+sTypeNo+"&RightType="+sRightType;
		OpenPage("/ImageManage/ImageViewInfo.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&TypeNo="+sTypeNo+"&RightType="+sRightType,"DetailFrame",""); 
    }
	
	function mySelectRow(obj){
		scanLoan();
    }
 	
	function initRecord(){
		var sSeriaslNo = getItemValueArray1(0,"TYPENO");
		var sOpinion1 = getItemValueArray1(0,"OPINION1");
		var sCheckDocStatus = "<%=sCheckDocStatus%>";    
		for(var i = 0; i < sSeriaslNo.length; i ++){
			var tmpTypeNo = sSeriaslNo[i];
			if(tmpTypeNo=="20001" || tmpTypeNo=="20025" || tmpTypeNo=="20002" ){
				setItemValue(0,i,"OPINION1","1");//复审意见置空
				setItemValue(0,i,"OPINION2","");//复审意见置空
				setItemReadOnly1(0,i,"OPINION1",true);
				setItemReadOnly1(0,i,"OPINION2",true);
			}
		}
		if(!(sCheckDocStatus=="3" || sCheckDocStatus=="4" || sCheckDocStatus=="5")){
			for(var i = 0; i < sOpinion1.length; i ++){
				var tmpOpinion = sOpinion1[i];
				if(tmpOpinion=="1"){
					setItemValue(0,i,"OPINION2","");//复审意见置空
					setItemReadOnly1(0,i,"OPINION2",true);
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