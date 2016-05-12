<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 用款记录列表
		
		Input Param:
		SerialNo:流水号
		ObjectType:对象类型
		ObjectNo：对象编号
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "车辆登记证归档"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sTemp  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("temp"));	
    if(sTemp==null) sTemp="";	
	
     String sTempletNo="";
	 ASDataObject doTemp = null;
	 if(sTemp.equals("2")){
		 sTempletNo = "BoxList1";
	 }else{
		 sTempletNo = "BoxList";
	 }
	 
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//新增模型：2013-5-9
	
	 doTemp.setColumnAttribute("boxID,boxName,carNumber","IsFilter","1");
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//新增参数传递：2013-5-9
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径

	String sButtons[][] = {
		{"true","","Button","新箱子登记","新箱子登记","newRecord()",sResourcesPath},
		{"true","","Button","车辆登记证登记","车辆登记证登记","carRegistration()",sResourcesPath},
		{"true","","Button","归档完成","归档完成","fileEnd()",sResourcesPath},
		};
	   if(sTemp.equals("2")){
		   sButtons[0][0]="false";
		   sButtons[1][0]="false";
		   sButtons[2][0]="false";
	   }
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		AsControl.OpenView("/AppConfig/Document/BoxInfo.jsp","","_self");		

	}
	
	function carRegistration(){
		var sBoxID=getItemValue(0,getRow(),"boxID");
		if(typeof(sBoxID)=="undefined" || sBoxID.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else{
			AsControl.OpenView("/AppConfig/Document/BoxFrame.jsp","boxID="+sBoxID,"_self");
		}
	}
	
	function fileEnd(){
		var sBoxID=getItemValue(0,getRow(),"boxID");
		var sCabinetID=getItemValue(0,getRow(),"cabinetID");
		var sCount =RunMethod("GetElement","GetElementValue","count(*),business_contract,boxID='"+sBoxID+"' and CreditAttribute='0001' and carRegistration='01'");//判断该箱子下是否已存在登记过的车辆合同 
		if(typeof(sBoxID)=="undefined" || sBoxID.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		if(sCabinetID!=""){
			if(sCount>="1.0"){
				if(confirm("您真的确定归档吗？")){
					RunMethod("ModifyNumber","GetModifyNumber","box,trueFalseFile='01',cabinetID='"+sCabinetID+"' and boxID='"+sBoxID+"'");
					RunMethod("ModifyNumber","GetModifyNumber","Box ,fileDate='<%=StringFunction.getToday()%>',cabinetID='"+sCabinetID+"' and boxID='"+sBoxID+"'");  //更新归档时间
					alert("归档成功！");
					reloadSelf();
				}
			}else{
				alert("请先车辆登记证登记！谢谢！");
			}
			
		}else{
			alert("信息部完整，没有指定存放柜子");
		}
		
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>

