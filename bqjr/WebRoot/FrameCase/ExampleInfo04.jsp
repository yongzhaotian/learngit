<div>
	<pre>
	
 	DataWindow前置/后续事件,List和Info都可以有:
	第一个参数："BeforeInsert","AfterInsert","BeforeDelete","AfterDelete","BeforeUpdate","AfterUpdate"
	第二个参数: !方法集名.方法名(参数值1,参数值2,...);
				 类方法参数值若想取当前DataWindow字段的值，可以用 #字段名 传入，
				 如下所示取当前模板ExampleId值作为参数传入类方法
	应用场景:当DataWindow的增删改和其他操作需要同时成功或失败时,用setEvent方法.
	本例中：dwTemp.setEvent("AfterUpdate","!示例.UpdateCustomerType(0110,#ExampleId)");//在DW保存后,更新客户类型,两操作在一个事务里.
	</pre>
</div>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: DataWindow事件示例页面
	 */
	String PG_TITLE = "DataWindow事件示例页面";

	//获得页面参数
	String sExampleId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ExampleId"));
	if(sExampleId==null) sExampleId="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ExampleInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//DataWindow前置/后续事件,List和Info都可以有:
	//第一个参数："BeforeInsert","AfterInsert","BeforeDelete","AfterDelete","BeforeUpdate","AfterUpdate"
	//第二个参数: !方法集名.方法名(参数值1,参数值2,...);
	//			 类方法参数值若想取当前DataWindow字段的值，可以用 #字段名 传入，
	//			 如下所示取当前模板ExampleId值作为参数传入类方法
	//应用场景:当DataWindow的增删改和其他操作需要同时成功或失败时,用setEvent方法.
	dwTemp.setEvent("AfterUpdate","!示例.UpdateCustomerType(0110,#ExampleId)");//在DW保存后,更新客户类型,两操作在一个事务里.
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sExampleId);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
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
		var serialNo = getSerialNo("EXAMPLE_INFO","ExampleId");// 获取流水号
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
		if(getRowCount(0)==0){
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