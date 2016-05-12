<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --新箱子登记
			未用到的属性字段暂时隐藏，如果需要请展示出来。
		Input Param:
        	TypeNo：    --类型编号
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "新箱子登记"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	ASDataObject doTemp = new ASDataObject("ContractFileInfo",Sqlca);
	doTemp.setDDDWSql("cabinetID", "select cabinetID,cabinetID from archives_Warehouse");
	doTemp.appendHTMLStyle("cabinetID"," onBlur=\"javascript:parent.getDoChange()\" ");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			{"true","","Button","保存","保存","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回","saveRecordAndBack()",sResourcesPath}
		    };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
    var sCurTypeNo=""; //记录当前所选择行的代码号
    var bIsInsert = false; //标记DW是否处于“新增状态”
    var sTemp=false;

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		var sBoxID =getItemValue(0,getRow(),"boxID");
		var sCabinetID =getItemValue(0,getRow(),"cabinetID");
		var sBoxName =getItemValue(0,getRow(),"boxName");
		checkNumber();
		if(sTemp) {sTemp=false; return;}
		var sUnique = RunMethod("Unique","uniques","Box,count(1),boxID='"+sBoxID+"'");
		var sBoxNameCount = RunMethod("Unique","uniques","Box,count(1),boxName='"+sBoxName+"'");
		if(bIsInsert && sUnique>="1.0"){
			alert("该箱子编号已经被占用,请输入新的箱子编号 ");
			return;
		}
		if(sBoxNameCount>="1.0"){
			alert("该箱子名称已经被占用,请输入新的箱子名称 ");
			return;
		}
		bIsInsert = false;
		
		if(isNaN(sBoxID)==true){
			alert("箱子编号必须是数字!");
			return false;
		}
	    as_save("myiframe0");
	    var sSCount= RunMethod("Unique","uniques","box,count(1),cabinetID='"+sCabinetID+"'");
		RunMethod("ModifyNumber","GetModifyNumber","archives_Warehouse,boxNumber='"+sSCount+"',cabinetID='"+sCabinetID+"'");
	}

    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndBack()
	{
		//OpenPage("/AppConfig/Document/ContractFileList.jsp?curItemID=1","_self","");
		AsControl.OpenView("/AppConfig/Document/ContractFileList.jsp","curItemID=1","right");
	}
    
    function getDoChange(){
		var sCabinetID =getItemValue(0,getRow(),"cabinetID");
		checkNumber();
		var cabinetAddress=RunMethod("GetElement","GetElementValue","cabinetAddress,archives_Warehouse,cabinetID='"+sCabinetID+"'");
		if ((typeof(sCabinetID)!="undefined" || sCabinetID.length!=0)&&sCabinetID!=""){
			setItemValue(0,0,"cabinetAddress", cabinetAddress);
		}else{
			setItemValue(0,0,"cabinetAddress", " ");
		}
    }
   
    //检查柜子中的箱子数量是否符合实际存入的箱子数量 
    function checkNumber(){
    	var sCabinetID =getItemValue(0,getRow(),"cabinetID");
    	var sCabinetBoxCapacity= RunMethod("Unique","uniques","archives_Warehouse,cabinetBoxCapacity, cabinetID='"+sCabinetID+"'"); //查询出该柜子下箱子的容量
		var sSCount= RunMethod("Unique","uniques","box,count(1), cabinetID='"+sCabinetID+"'");      //查询该柜子下有车辆登记证或档案登记证的箱子共数
		sSCount=parseFloat(sSCount)+1.0;
		if(sCabinetBoxCapacity<sSCount){
			alert("超出箱子的容量！");
			sTemp=true;
			return;
		}
    }
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"boxFile", "02");
			setItemValue(0,0,"inputOrg", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "inputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"inputUser", "<%=CurUser.getUserName()%>");
			setItemValue(0,0,"inputTime", "<%=StringFunction.getToday()%>");
			setItemValue(0,0,"updateOrg", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "updateOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"updateUser", "<%=CurUser.getUserName()%>");
			setItemValue(0,0,"updateTime", "<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
