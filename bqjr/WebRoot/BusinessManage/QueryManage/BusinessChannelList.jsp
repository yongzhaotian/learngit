<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
    <%
    /*
        Author: lwang 20140221
        Tester:
        Describe: 还款渠道信息列表
        Input Param:
        Output Param:       
        HistoryLog:
     */
    %>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
    <%
    String PG_TITLE = "还款渠道信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
    %>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

    //定义变量

    //获得页面参数

    //获得组件参数
    String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
    String sContractSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
    String sChannelSerialNo = "";
    if(sContractSerialNo == null ) sContractSerialNo = "";
    if(sObjectType == null ) sObjectType = "";
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
    //通过DW模型产生ASDataObject对象doTemp
  	String sTempletNo = "RepaymentChannelDetailList";//模型编号
  	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
  	String sSql = "select serialno from BaseDataSet_Info where TYPECODE='RepaymentChannel' and bigvalue "+
  					"=(select city from store_info si  where si.identtype='01' and "+
    				"si.sno=(select STORES from Business_Contract where SerialNo = :SerialNo))";
    //获城市渠道
    sChannelSerialNo = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo", sContractSerialNo));
    if(null == sChannelSerialNo) sChannelSerialNo ="";
    //生成datawindow
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
    dwTemp.Style="1";      //设置为Grid风格
    dwTemp.ReadOnly = "1"; //设置为只读
    
    Vector vTemp = dwTemp.genHTMLDataWindow(sChannelSerialNo);
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
        {"true","","Button","详情","查看详情","viewDetail()",sResourcesPath},
        };
    %>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
    <%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
    <script type="text/javascript">
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
    function viewDetail()
    {
    	var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenPage("/CustomService/BusinessConsult/RepaymentChannelInfo.jsp","ChannelSerialNo=<%=sChannelSerialNo%>&detailSerialNo="+sSerialNo+"&OperateType=view&fromContractView=true","_self");
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

<%@ include file="/IncludeEnd.jsp"%>