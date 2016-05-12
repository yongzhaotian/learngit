<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: ndeng 2005-03-16
		Tester:
		Describe: 出账发回通知列表;
		Input Param:

		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "出账发回通知列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";

	//获得页面参数

	//获得组件参数

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","出账流水号"},
							{"ArtificialNo","合同号"},
							{"CustomerName","客户名称"},
				            {"BusinessTypeName","业务品种"},
							{"CurrencyName","币种"},
				            {"BusinessSum","金额(元)"}				            
						  };

	sSql =  "select FO.ObjectType,FO.ObjectNo,FT.SerialNo as FSerialNo,BP.SerialNo,BP.ArtificialNo,BP.CustomerName,BP.BusinessType,getBusinessName(BP.BusinessType) as BusinessTypeName, "+
            " BP.BusinessCurrency,getItemName('Currency',BP.BusinessCurrency) as CurrencyName,BP.BusinessSum,FT.EndTime "+
            " from FLOW_TASK FT,FLOW_OBJECT FO,BUSINESS_PUTOUT BP "+
            " where FT.ObjectType=FO.ObjectType and FO.ObjectNo=BP.SerialNo and FT.ObjectNo=FO.ObjectNo "+
            " and FO.ObjectType='PutOutApply'and FO.ApplyType='PutOutApply' "+
            " and GetPhaseType(FT.FlowNo,FT.PhaseNo) ='1030' "+
            " and FT.PhaseNo = '3000' and  FT.UserID='"+CurUser.getUserID()+"' and FO.UserID != '"+CurUser.getUserID()+"'"+
            " and (FT.EndTime is null or FT.EndTime =' ')";

    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);

	//设置表头,更新表名,键值,可见不可见,是否可以更新
	doTemp.setHeader(sHeaders);
	
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("FSerialNo,ObjectType,ObjectNo,BusinessType,BusinessCurrency,EndTime",false);
	doTemp.setUpdateable("EntTime",true);

	//设置格式
	doTemp.setAlign("BusinessSum","3");
	doTemp.setCheckFormat("BusinessSum","2");
	doTemp.setHTMLStyle("BusinessSum"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:250px} ");

	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sCriteriaAreaHTML = ""; //查询区的页面代码
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
		{"true","","Button","详情","查看出账信息详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","已查阅","查阅完成","Finished()",sResourcesPath}
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
    //完成查阅出账信息
    function Finished(){
        var sFSerialNo = getItemValue(0,getRow(),"FSerialNo");
		if (typeof(sFSerialNo)=="undefined" || sFSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		} 
        if(confirm("您确定已经查阅完成吗？")){
            PopPageAjax("FinishPutOutAction","/DeskTop/FinishPutOutActionAjax.jsp","SerialNo="+sFSerialNo,"_blank","");
        }
    }
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">


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