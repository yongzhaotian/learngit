<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="java.util.Date"%>

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


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性、页面变量;]~*/%>
<%
	String isInert = "0"; //是否新增[0:否,1:是]
	String PG_TITLE = "无预约现金贷外部客户配置详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得页面参数
	String serialno = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("serialno"));	
	if(serialno==null || "".equals(serialno)){
		/** --update Object_Maxsn取号优化 tangyb 20150817 start-- 
		serialno = DBKeyHelp.getSerialNo("NOORDERDCASH_PARA", "SERIALNO");*/
						
		serialno = DBKeyUtils.getSerialNo("NP");
		/** --end --*/
		
		isInert = "1";
		PG_TITLE = "无预约现金贷外部客户配置新增"; // 浏览器窗口标题 <title> PG_TITLE </title>
	}
%>
<%/*~END~*/%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sTempletNo = "NoBespeakCashLoanParaInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//非新增
	if("0".equals(isInert)){
		doTemp.setUnit("areacodename", ""); //隐藏城市选择按钮
		doTemp.setUnit("productname", ""); //隐藏产品选择按钮
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(serialno);
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
			{"true","","Button","取消","取消","goBack()",sResourcesPath}
		    };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
    var sCurTypeNo=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(){
		var startdate = getItemValue(0, 0, "startdate"); //起始日期
		var enddate = getItemValue(0, 0, "enddate"); //结束日期
		var flag = checkDateTime(startdate, enddate);
		if (flag == -1) {
			alert("开始日期不能晚于结束日期");
			setItemValue(0, 0, "enddate", "");
			return;
		}
		
		//新增操作
		if ('<%=isInert %>'== '1') {
			var areacode = getItemValue(0, 0, "areacode"); //城市代码
			var businesstype = getItemValue(0, 0, "businesstype"); //产品代码
			
			var areacodename = getItemValue(0, 0, "areacodename"); //城市名称
			var productname = getItemValue(0, 0, "productname"); //产品名称
			
			var count =  RunMethod("Unique","uniques","noorderdcash_para,count(1),areacode='"+areacode+"' and businesstype = '"+businesstype+"'");
			if (parseInt(count)> 0){
				alert("城市为["+areacodename+"]、产品为["+productname+"]的参数已配置，不能重复配置");
				return;
			} 
		}
		
	    as_save("myiframe0","self.close();");
	}

    /*~[Describe=取消;InputParam=后续事件;OutPutParam=无;]~*/
	function goBack(){
		self.returnValue = "_CANCEL_";
		self.close();
	}
   
	/*~[Describe=弹出行政规划选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getRegionCode() {
		
		var retVal = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		
		if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("请选择所要选择的城市！");
			return;
		}
		
		setItemValue(0, 0, "areacode", retVal.split("@")[0]);
		setItemValue(0, 0, "areacodename", retVal.split("@")[1]);
	}
	
	/*
	 *弹出产品选择窗口，并置将返回的值设置到指定的域
	 */
	function selectProductID() {
		var sParaString = "pID,020";
		setObjectValue("QueryBusinessInfoList",sParaString,"@productname@1@businesstype@2",0,0,"");
	}
	
	
	/*
	 * 校验起始日期与结束日期
	 * [-1:开始日期>结束日期;0:开始日期==结束日期;1:开始日期<结束日期]
	 */
	function checkDateTime(startValue, endValue) {
		var flag = 0;
		if (startValue != null && startValue != "" && endValue != null
				&& endValue != "") {
			var dateS = startValue.split('/');//日期是用'-'分隔,如果你日期用'/'分隔的话,你将这行和下行的'-'换成'/'即可
			var dateE = endValue.split('/');
			var startDate = new Date(dateS[0], dateS[1], dateS[2])
					.getTime();//如果日期格式不是年月日,需要把new Date的参数调整
			var endDate = new Date(dateE[0], dateE[1], dateE[2]).getTime();
			if (startDate > endDate) {
				flag = -1; //开始日期>结束日期
			} else if (startDate == endDate) {
				flag = 0; //开始日期==结束日期
			} else {
				flag = 1; //开始日期<结束日期
			}
		}
		return flag;
	}
	
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">	
	/**
	 * 初始化数据
	 **/
	function initRow(){
		//如果没有找到对应记录，则新增一条，并设置字段默认值
		if ('<%=isInert %>'== '1') {
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"serialno", "<%=serialno %>"); //登记机构
			setItemValue(0,0,"inputorg", "<%=CurOrg.orgID %>"); //登记机构
			setItemValue(0,0,"inputuser", "<%=CurUser.getUserID() %>"); //登记人
			setItemValue(0,0,"inputtime", "<%=StringFunction.getToday() %>"); //登记时间
		}else{
			setItemValue(0,0,"updateuser", "<%=CurUser.getUserID()%>"); //更新人
			setItemValue(0,0,"updatetime", "<%=StringFunction.getToday()%>"); //更新时间
		}
	}

	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();//初始化
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
