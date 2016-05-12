<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --还款登记
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
	String PG_TITLE = "还款登记 "; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得页面参数
	String sRelativeSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("relativeSerialNo"));	
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("customerID"));	
	if(sCustomerID==null) sCustomerID="";
	if(sRelativeSerialNo==null) sRelativeSerialNo="";
	String sSql="";
	ASResultSet rs = null;
	String sOpenBranch="",sRepaymentBank="",sRepaymentNo="";//收款
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sTempletNo = "DistributorRepaymentInfo1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	sSql="select getBankName(OpenBranch) as OpenBranch,getitemname('BankCode',bankName) as bankName,accountNo from account_information where accountType='02' and relativeSerialNo =:relativeSerialNo";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("relativeSerialNo",sCustomerID));
	if(rs.next()){
		sOpenBranch = DataConvert.toString(rs.getString("OpenBranch"));//  收款开户支行
		sRepaymentBank = DataConvert.toString(rs.getString("bankName"));// 收款开户行
		sRepaymentNo = DataConvert.toString(rs.getString("accountNo"));//  收款开户帐号
								
		//将空值转化成空字符串
		if(sOpenBranch == null) sOpenBranch = "";
		if(sRepaymentBank == null) sRepaymentBank = "";	
		if(sRepaymentNo == null) sRepaymentNo = "";	
	}
	rs.getStatement().close();
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	//生成HTMLDataWindow
	Vector vTemp =dwTemp.genHTMLDataWindow(sRelativeSerialNo);
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
			{"true","","Button","确定","确定","determine()",sResourcesPath},
			{"true","","Button","取消","取消","doCance()",sResourcesPath}
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

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function determine()
	{
		var sSerialNo=getItemValue(0,getRow(),"serialNo");
		RunMethod("ModifyNumber","GetModifyNumber","car_info,carStatus='030',relativeSerialNo='"+sSerialNo+"' and carStatus='020'"); //修改车辆信息状态
		var sCount=RunMethod("Unique","uniques","car_info,count(1),carStatus='020' and relativeSerialNo='"+sSerialNo+"'");  //判断是否车辆状态是否修改成功
		if(sCount=="0.0"){
			alert("收款成功！！！");
			AsControl.OpenView("/DistributorInfo/DistributorRepaymentList1.jsp","","_self");
		}
	}
   
    function doCance(){
		AsControl.OpenView("/DistributorInfo/DistributorRepaymentList1.jsp","","_self");		
    }
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	function initRow(){
		//合同编号下所有请求还款状态的车辆出厂价之和 ；还款金额
		var sLoadMoney=RunMethod("GetElement","GetElementValue","sum(carPrice),car_info,relativeSerialNo='<%=sRelativeSerialNo %>' and carStatus='020'");
		var sBondSum=getItemValue(0,getRow(),"bondSum"); 
		sLoadMoney=parseFloat(sLoadMoney);//合同启用金额
		var sBalance=parseFloat(sBondSum)-sLoadMoney;   //合同余额
		setItemValue(0,0,"loadMoney",sLoadMoney );
		setItemValue(0,0,"nextPayDate", "<%=StringFunction.getToday()%>");
		setItemValue(0,0,"balance", sBalance);
		setItemValue(0, 0, "OpenBranch", "<%=sOpenBranch %>");
		setItemValue(0, 0, "RepaymentBank", "<%=sRepaymentBank %>");
		setItemValue(0, 0, "RepaymentNo", "<%=sRepaymentNo %>");
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
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
