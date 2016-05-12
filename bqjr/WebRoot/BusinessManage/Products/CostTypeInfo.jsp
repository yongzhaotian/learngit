<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --产品管理详情
			未用到的属性字段暂时隐藏，如果需要请展示出来。
		Input Param:
        	TypeNo：    --类型编号
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	
	//获得页面参数
	String sProductCategoryID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("productCategoryID"));	
	if(sProductCategoryID==null) sProductCategoryID="";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "新增费用类型"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//ASDataObject doTemp = new ASDataObject("CostTypeInfo3",Sqlca);
	ASDataObject doTemp = new ASDataObject("FeeTypePreserve",Sqlca);
    
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
			//{"true","","Button","保存","保存","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回","saveRecordAndBack()",sResourcesPath},
			{"true","","Button","保存","保存","saveRecord1()",sResourcesPath},
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
		bIsInsert = false;
	    as_save("myiframe0");
	    saveAndOpenPage();
	}
    
	//保存
	function saveRecord1(){
		
	    var termID = getItemValue(0,getRow(),"TermID");
	    var TermName = getItemValue(0,getRow(),"TermName");
	    var FeeType = getItemValue(0,getRow(),"FeeType");
	    
	    	if(typeof(termID)=="undefined" || termID.length==0)return;
		    setItemValue(0,0,"ObjectNo",termID);
			var existsFlag = RunMethod("PublicMethod","GetColValue","1,PRODUCT_TERM_LIBRARY,String@ObjectType@Term~String@TermID@"+termID);
			if(existsFlag =="1"){
				alert("费用代码重复，请确认！");
				return;
			}
			//if(confirm('确定保存吗？')){//进行数据库保存时请求修改者确认
				var targetTermID = "";
				if(FeeType=="A9"){//A9：提前还款费率
					targetTermID = "TQHKSXF";
				}else if(FeeType=="A11"){//A11：印花税
					targetTermID = "C300";
				}else if(FeeType=="A12"){//保险费
					targetTermID = "BXF";
				}else if(FeeType=="A10"){//滞纳金
					targetTermID = "ZNJ";
			} else if (FeeType == "A18") {	// 随心还服务费
				targetTermID = "SXH001";
			}
			sReturn = RunMethod("ProductManage","CopyTerm","copyTerm,"+termID+","+TermName+","+targetTermID);
			var SortNo = getSerialNo("product_term_library","SortNo","");
			var ActiveDate = getItemValue(0,getRow(),"ActiveDate");//生效日
			var CloseDate = getItemValue(0,getRow(),"CloseDate");//失效日
			var InputDate = getItemValue(0,getRow(),"InputDate");//创建时间
			var UpdateDate = getItemValue(0,getRow(),"UpdateDate");//修改时间
				//if(FeeType=="A9"||FeeType=="A11"){//A9：提前还款费率,A11：印花税
					RunMethod("PublicMethod","UpdateColValue","String@SortNo@"+SortNo+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID);
					RunMethod("PublicMethod","UpdateColValue","String@SubTermType@"+FeeType+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID);
					RunMethod("PublicMethod","UpdateColValue","String@ActiveDate@"+ActiveDate+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID);
					RunMethod("PublicMethod","UpdateColValue","String@CloseDate@"+CloseDate+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID);
					RunMethod("PublicMethod","UpdateColValue","String@InputDate@"+InputDate+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID);
					RunMethod("PublicMethod","UpdateColValue","String@UpdateDate@"+UpdateDate+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID);
					/* if(FeeType=="A11"){
						//印花税关联交易范围为 一般贷款发放:0020
						RunMethod("PublicMethod","UpdateColValue","String@valueslist@'',PRODUCT_TERM_LIBRARY,String@PARAID@FeeTransactionCode@String@ObjectType@Term@String@TermID@"+termID);
					} */
				//}else if(FeeType=="A12"){//保险费
					/* RunMethod("PublicMethod","UpdateColValue","String@SortNo@"+SortNo+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID);
					RunMethod("PublicMethod","UpdateColValue","String@SubTermType@"+FeeType+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID);
					RunMethod("PublicMethod","UpdateColValue","String@ActiveDate@"+ActiveDate+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID);
					RunMethod("PublicMethod","UpdateColValue","String@CloseDate@"+CloseDate+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID);
					RunMethod("PublicMethod","UpdateColValue","String@InputDate@"+InputDate+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID);
					RunMethod("PublicMethod","UpdateColValue","String@UpdateDate@"+UpdateDate+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID); */
					
				//}
			/* //更新费用组件的名称 20121126 dxu1
				var TermName = getItemValue(0,getRow(),"TermName");
				if(typeof(TermName) !="undefined" && TermName.length !=0){
					RunMethod("ProductManage","UpdateTermName",termID+","+TermName);
			    }
				as_save("myiframe0"); */
			//}
			
			//reloadSelf();	    
	    
		AsControl.OpenView("/BusinessManage/Products/FeeLibraryInfo.jsp","ObjectNo="+termID+"&ObjectType=Term&TermID="+termID+"&FeeType="+FeeType,"_blank",OpenStyle);
		window.close();
	}
   
    function saveAndOpenPage(){
		var sFeeType  = getItemValue(0,getRow(),"feeType");
		var sSerialNo  = getItemValue(0,getRow(),"serialNo");
		if(sFeeType == "3" || sFeeType == "1"){
			AsControl.OpenView("/BusinessManage/Products/CostTypeInfo1.jsp","serialNo="+sSerialNo,"_blank");
			window.close();
		}else if(sFeeType == "4"){
			AsControl.OpenView("/BusinessManage/Products/CostTypeInfo2.jsp","serialNo="+sSerialNo,"_blank");
			window.close();
		}else if(sFeeType == "040"){
			AsControl.OpenView("","","_blank");
		}else{
			window.close();
	        reloadSelf();
		}

    }

    /*~[Describe=返回;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndBack()
	{ 
       	window.close();
	}
    
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">	
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"SortNo", getSerialNo("PRODUCT_TERM_LIBRARY", "SortNo", " "));
			setItemValue(0,0,"InputOrgID", "<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputUserID", "<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgName", "<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputUserName", "<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateDate", "<%=StringFunction.getToday()%>");
			setItemValue(0,0,"InputDate", "<%=StringFunction.getToday()%>");
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
