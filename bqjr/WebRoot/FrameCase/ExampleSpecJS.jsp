<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例校验页面
	 */
	String PG_TITLE = "示例校验页面";

	//获得页面参数
	String sExampleID =  CurPage.getParameter("ExampleID");
	if(sExampleID==null) sExampleID="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ExampleInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sExampleID);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","All","Button","获得字段值","getItemValue","getAllItemValue()","","","",""},
			{"true","All","Button","隐藏字段BeginDate","hide BeginDate","hideItem(0,0,'BeginDate')","","","",""},
			{"true","All","Button","显示字段BeginDate","show BeginDate","showItem(0,0,'BeginDate')","","","",""},
			{"true","All","Button","锁定多字段","lockall","lockall()","","","",""},
			{"true","All","Button","解锁多字段","unlockall","unlockall()","","","",""},
			{"true","All","Button","设置ApplySum*","require","setItemRequired(0,0,'ApplySum',true)","","","",""},
			{"true","All","Button","取消ApplySum*","unrequire","setItemRequired(0,0,'ApplySum',false)","","","",""},
			{"true","All","Button","获得ApplySum标题","getTitle","alert(getItemHeader(0,0,'ApplySum'))","","","",""},
			{"true","All","Button","设置ApplySum标题","setTitle","setTitle()","","","",""},
			{"false","All","Button","获得ApplySum unit","getUnit","alert(getItemUnit(0,0,'ApplySum'))","","","",""},
			{"false","All","Button","设置ApplySum unit","setUnit","setItemUnit(0,0,'ApplySum',prompt('输入Unit','Unit'));","","","",""}
		};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	function getAllItemValue(){
		var fields = "ExampleName,BeginDate,ApplySum";
		var aFields = fields.split(",");
		var sResult = "";
		for(var i=0;i<aFields.length;i++){
			sResult += aFields[i] + ".value = " + getItemValue(0,0,aFields[i]) + "\n";
		}
		alert(sResult);
	}
	function unlockall(){
		var fields = "ExampleName,BeginDate";
		var aFields = fields.split(",");
		for(var i=0;i<aFields.length;i++){
			setItemDisabled(0,0,aFields[i],false);
		}
	}
	function lockall(){
		var fields = "ExampleName,BeginDate";
		var aFields = fields.split(",");
		for(var i=0;i<aFields.length;i++){
			setItemDisabled(0,0,aFields[i],true);
		}
	}
	
	function setTitle(){
		var sTitle = prompt("输入标题",'标题');
		setItemHeader(0,0,"ApplySum",sTitle);
	}

	var bIsInsert = false; //标记DW是否处于“新增状态”
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		var serialNo = getSerialNo("EXAMPLE_INFO","ExampleId");//获取流水号
		setItemValue(0,getRow(),"ExampleId",serialNo);
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>