<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --基本参数
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
	String PG_TITLE = "基本参数"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//获得页面参数
	String sTypeNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("typeNo"));	
    if(sTypeNo==null) sTypeNo="";
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	ASDataObject doTemp = new ASDataObject("JXSBusinessTypeInfo1",Sqlca);
    
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sTypeNo);
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
			{"true","","Button","保存","保存","saveRecord()",sResourcesPath}
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
	function saveRecord()
	{	
		insertTerm();
		bIsInsert = false;
	    as_save("myiframe0");
	}
    
	//插入组件参数
	function insertTerm(){
		var sObjectNo = "<%=sTypeNo%>"+"-V1.0";
		var RATTerm = getItemValue(0, 0, "rateType");//利率类型
		var fixedInterestRate = getItemValue(0, 0, "fixedInterestRate");//利率固定值
		var adjustmentMode = getItemValue(0, 0, "adjustmentMode");//利率调整方式
		var productType = getItemValue(0, 0, "productType");//产品类型
		
		if(RATTerm=="1"){//浮动
			RATTerm="RAT001";
			FINTerm="FIN003";
		}else if(RATTerm=="0"){//固定
			RATTerm="RAT002";
			FINTerm="FIN005";
		}
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,"+RATTerm);//利率类型
		if(RATTerm=="RAT001"){//浮动
			var sFloatType = getItemValue(0, 0, "floatingManner");//浮动方式
			var floatingRange = getItemValue(0, 0, "floatingRange");//浮动幅度
			var floatingRate = getItemValue(0, 0, "floatingRate");//浮动比例
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+sFloatType+",PRODUCT_TERM_PARA,String@paraid@RateFloatType@String@termid@RAT001@String@ObjectNo@"+sObjectNo);//浮动方式
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+floatingRange+",PRODUCT_TERM_PARA,String@paraid@RateFloat@String@termid@RAT001@String@ObjectNo@"+sObjectNo);//浮动幅度
		}else if(RATTerm=="RAT002"){//固定
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+fixedInterestRate+",PRODUCT_TERM_PARA,String@paraid@ExecuteRate@String@termid@RAT002@String@ObjectNo@"+sObjectNo);//执行利率
		}
		
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,"+FINTerm);//罚息
		if(FINTerm=="FIN003"){//浮动
			var FINFloatType = getItemValue(0, 0, "penaltyRate");//罚息浮动方式
			var floatingRate = getItemValue(0, 0, "floatingRate");//罚息浮动幅度
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+FINTerm+",PRODUCT_TERM_PARA,String@paraid@RateFloatType@String@termid@FIN003@String@ObjectNo@"+sObjectNo);//浮动方式
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+floatingRate+",PRODUCT_TERM_PARA,String@paraid@RateFloat@String@termid@FIN003@String@ObjectNo@"+sObjectNo);//浮动幅度		
		}else if(FINTerm=="FIN005"){//固定
/* 			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+fixedInterestRate+",PRODUCT_TERM_PARA,String@paraid@ExecuteRate@String@termid@RAT002@String@ObjectNo@"+sObjectNo);//执行利率
 */		}
		
		if(productType=="0"){//库存融资
			//创建关联还款方式
			/* 先用按月付息，到期还本测试 */
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,RPT01");//按月计息随意还本
		}else if(productType == "1"){//流动资金贷款
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,RPT01");//按月计息到期还本
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,RPT002");//按季计息到期还本
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,RPT05");//到期还本付息
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,RPT17");//等额本息
			//费用
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,QT100");//其他费
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,N300");//担保服务费
		}
		//关联费用
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,N400");//手续费
		/* RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@03,PRODUCT_TERM_PARA,String@paraid@FeePayDateFlag@String@termid@N400@String@ObjectNo@"+sObjectNo);//手动一次性收取
		RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@01,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@N400@String@ObjectNo@"+sObjectNo);//固定金额		 */
		//关联交易
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA001");//发放类交易
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA002");//还款日变更
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA004");//提前还款
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA005");//还款类交易
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,PS001");//其他未归类参数定义
	}
    
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
		}
		setItemValue(0, 0, "inputOrgName", "<%=CurOrg.orgName %>");
		setItemValue(0,0,"inputOrg", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"inputUser", "<%=CurUser.getUserName()%>");
		setItemValue(0,0,"inputTime", "<%=StringFunction.getToday()%>");
		setItemValue(0,0,"updateOrg", "<%=CurOrg.orgID %>");
		setItemValue(0, 0, "updateOrgName", "<%=CurOrg.orgName %>");
		setItemValue(0,0,"updateUser", "<%=CurUser.getUserName()%>");
		setItemValue(0,0,"updateTime", "<%=StringFunction.getToday()%>");
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
