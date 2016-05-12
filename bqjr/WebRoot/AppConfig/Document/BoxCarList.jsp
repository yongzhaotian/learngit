<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 
 <%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得页面参数
	String sTemp  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("temp"));
	String sBoxID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("boxID"));
	if(sBoxID == null) sBoxID = "";
    if(sTemp==null) sTemp="";
%>
<%/*~END~*/%>
 
 <%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "车辆登记证加入 ";
	 String sTempletNo="";
	//通过DW模型产生ASDataObject对象doTemp
	if(sTemp.equals("1")){
		 sTempletNo = "CarRegistration";
	}else{
	    sTempletNo = "EndCarRegistration";
	}
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.setColumnAttribute("CarFrame,ArtificialNo,customerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sBoxID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","信息补登","信息补登","informationBoard()",sResourcesPath},
			{"true","","Button","加入车辆登记证登记","加入车辆登记证登记","carRegistration()",sResourcesPath}
	};
	
	if(sTemp.equals("2")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	<%/*记录被选中时触发事件*/%>
	function informationBoard(){
		var sSerialNo=getItemValue(0,getRow(),"serialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		var sCarNumber =RunMethod("GetElement","GetElementValue","carNumber,business_contract,serialNo='"+sSerialNo+"'");
		var sGreenDate =RunMethod("GetElement","GetElementValue","greenDate,business_contract,serialNo='"+sSerialNo+"'");
		var sScanBarCode=RunMethod("GetElement","GetElementValue","scanBarCode,business_contract,serialNo='"+sSerialNo+"'");
		if(sCarNumber=="" || sGreenDate=="" || sScanBarCode==""){
			sCompID = "BoxCarInfo";
			sCompURL = "/AppConfig/Document/BoxCarInfo.jsp";
		    popComp(sCompID,sCompURL,"serialNo="+sSerialNo,"dialogWidth=300px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		    reloadSelf();
		}else{
			alert("信息已补登！！");
		}	
	}
   
	function carRegistration(){
		var sSerialNo=getItemValue(0,getRow(),"serialNo");	
		var sCarNumber =RunMethod("GetElement","GetElementValue","carNumber,business_contract,serialNo='"+sSerialNo+"'");
		var sGreenDate =RunMethod("GetElement","GetElementValue","greenDate,business_contract,serialNo='"+sSerialNo+"'");
		var sScanBarCode=RunMethod("GetElement","GetElementValue","scanBarCode,business_contract,serialNo='"+sSerialNo+"'");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		if(sCarNumber=="" || sGreenDate=="" || sScanBarCode==""){
			alert("请先信息补登！");
			return;
		}
		if(confirm("您真的确定加入车辆登记证登记吗？")){
			RunMethod("ModifyNumber","GetModifyNumber","business_contract,carStatus='02',serialNo="+sSerialNo);// 修改车辆补登状态 
			RunMethod("ModifyNumber","GetModifyNumber","business_contract,boxID=<%=sBoxID%>,serialNo="+sSerialNo);  //修改车辆存放哪个箱子的位置 
			as_save("myiframe0");  
			
			
		}
		 parent.reloadSelf();
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>