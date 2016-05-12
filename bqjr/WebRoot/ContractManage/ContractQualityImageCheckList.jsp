<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 <%@ page import="com.amarsoft.dict.als.cache.CodeCache"%>
<%
	/*
		Author: daihuafeng 2015-9-30
		Tester:
		Describe: 合同质量管理-影像合同调阅
	*/
	
	String PG_TITLE = "影像类型信息";
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","450");
	String iButtonsLineMax = "4";
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);
 	//获取页面参数
 	
 	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));//任务编号
 	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));//任务编号
 	
 	String ssuretype = Sqlca.getString(new SqlObject("SELECT suretype FROM business_contract WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", sObjectNo));
	String sCheckDocStatus = Sqlca.getString(new SqlObject("SELECT CheckDocStatus FROM check_contract WHERE CONTRACTSERIALNO=:SERIALNO").setParameter("SERIALNO", sObjectNo));
 	
 	String sBusinessType = Sqlca.getString( new SqlObject("Select BusinessType From BUSINESS_CONTRACT "+
		" Where SerialNo = :SerialNo").setParameter( "SerialNo", sObjectNo ) );
	if( sBusinessType == null ) sBusinessType = " ";
 	
 	if(sObjectNo==null) sObjectNo = "";
 	if(sObjectType==null) sObjectType = "";
 	
	String typeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
 	String sStartWithId = CurComp.getParameter("StartWithId");
 	if (sStartWithId == null) sStartWithId = "";

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CheckDocImageTypeList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.multiSelectionEnabled=false;//设置可多选
	
	doTemp.WhereClause += " and ECM_IMAGE_OPINION.TypeNo in (Select ECM_Image_Type.TypeNo from ECM_Image_Type where ECM_Image_Type.isinuse = '1') "; 
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
	
	var typeNo = "";
	function mySelectRow(obj){
		var sCheckDocStatus="<%=sCheckDocStatus%>";
		var sTypeNo = getItemValue(0,getRow(),"TYPENO");//获取选中的记录ID	
		var sOpinion1 = getItemValue(0,getRow(),"OPINION1");//获取选中的初审意见
		if(sOpinion1 !="2" && sCheckDocStatus == "7"){//初审为合格
			setItemValue(0,getRow(),"OPINION2","");//复审意见置空
			setItemValue(0,getRow(),"QualityMark2","");//复审质量置空
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