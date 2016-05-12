<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --地址变更
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
	String PG_TITLE = "地址变更"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sCabinetID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("cabinetID"));
	if(sCabinetID==null) sCabinetID="";	
	
	ASDataObject doTemp = new ASDataObject("UpdateAddressInfo",Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCabinetID);
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
			{"true","","Button","修改","修改","saveRecord()",sResourcesPath},
			{"false","","Button","返回","返回","saveRecordAndBack()",sResourcesPath}
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
		var sCabinetID1=getItemValue(0,getRow(),"cabinetID1");
		var sCabinetID2=getItemValue(0,getRow(),"cabinetID2");
	    if (typeof(sCabinetID1)=="undefined" || sCabinetID1.length==0){
            alert("请选择一个原箱子！");
            return;
        }
	    if (typeof(sCabinetID2)=="undefined" || sCabinetID2.length==0){
            alert("请选择一个新箱子！");
            return;
        }
		var sSerialNo = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.ContractFile", "updateAdderss","CabinetID1="+sCabinetID1+",CabinetID2="+sCabinetID2);
		alert(sSerialNo);
		reloadSelf();

	}

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndBack()
	{
		OpenPage("/AppConfig/Document/RecordRoomList.jsp","_self","");
	}
	   
    function getDoChange(){
    	var sRecordRoom=getItemValue(0,getRow(),"RecordRoom");
    	var sCabinetID=getItemValue(0,getRow(),"CabinetID");
    	var sCount= RunMethod("Unique","uniques","archives_Warehouse,count(1), SNO='"+sCabinetID+"' and CreditAttribute='0002' and CodeAttribute='LineNumberCode'");
    	if(sRecordRoom<sCount){
    		alert("已存行超出你修改的容量，不能修改！");
    		sTemp=true;
    		return;
    	}
    	sTemp=false;
    }
    
    function selectOldBox(){
    	var sRetVal = setObjectValue("SelectOldBox", "", "@cabinetName1@1", 0, 0, "");
    	if (typeof(sRetVal)=="undefined" || sRetVal.length==0){
			alert("请选择一个箱子");
			return;
		}
    	setItemValue(0,0,"cabinetID1", sRetVal.split("@")[0]);
    }
    function selectNewBox(){
    	var sRetVal = setObjectValue("SelectNewBox", "", "@cabinetName2@1", 0, 0, "");
    	if (typeof(sRetVal)=="undefined" || sRetVal.length==0){
			alert("请选择一个箱子");
			return;
    	}
    	setItemValue(0,0,"cabinetID2", sRetVal.split("@")[0]);
    }
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"CabinetID",getSerialNo("archives_Warehouse", "CabinetID", ""));
			setItemValue(0,0,"CreditAttribute", "0002");
			setItemValue(0,0,"CodeAttribute", "RecordRoomCode");
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
