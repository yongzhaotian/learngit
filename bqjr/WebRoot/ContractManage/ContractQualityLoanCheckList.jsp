<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 <%@ page import="com.amarsoft.dict.als.cache.CodeCache"%>
<%
	/*
		Author: daihuafeng 2015-9-30
		Tester:
		Describe: 合同质量管理-贷后文件调阅
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
 	
 	String ssuretype = Sqlca.getString(new SqlObject("SELECT suretype FROM business_contract WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", sObjectNo));
 	
 	String sCheckStatus = Sqlca.getString( new SqlObject("Select checkstatus From CHECK_CONTRACT "+
		" Where ContractSerialNo = :SerialNo").setParameter( "SerialNo", sObjectNo ) );
	if( sCheckStatus == null ) sCheckStatus = " ";
 	
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
	
	doTemp.WhereClause += " and ECM_IMAGE_OPINION.TypeNo in (Select ECM_Image_Type.TypeNo from ECM_Image_Type where ECM_Image_Type.isinuse = '1') and ECM_IMAGE_OPINION.ObjectType = 'BusinessLoan' "; 
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+sObjectType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
	};
	
%>
<%@include file="/Resources/CodeParts/List0501.jsp"%>

<script type="text/javascript">
	
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
	var typeNo = "";
	function mySelectRow(obj){
		var sCheckStatus="<%=sCheckStatus%>";
		var sTypeNo = getItemValue(0,getRow(),"TYPENO");//获取选中的记录ID	
		var sCheckopinion1 = getItemValue(0,getRow(),"CHECKOPINION1");//获取选中的初审意见
		if(sCheckopinion1 !="2" && sCheckopinion1 !="3" && sCheckStatus == "7"){//初审为合格
			setItemValue(0,getRow(),"CHECKOPINION2","");//复审意见置空
			setItemValue(0,getRow(),"QualityMarkLoan2","");//复审质量置空
			scanLoan();
		}else{
			if(typeNo!=sTypeNo){
				scanLoan();
				typeNo = sTypeNo;
			}
		}
    }
 	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	

<%@ include file="/IncludeEnd.jsp"%>