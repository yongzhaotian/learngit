<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
<%
    /*
        Author:zwang 2008.11.11
        Tester:
        Content: 组合计提信息页面
        Input Param:
            会计月份：AccountMonth
            借据编号：DuebillNo
        Output param:
        History Log: 
            modify by jgao 20090424 留底
    */
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
<%
    // 浏览器窗口标题 <title> PG_TITLE </title>
    String PG_TITLE = "组合计提信息"; 
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
    //定义变量
    String sAccountMonth,sDuebillNo,sCustomerType;
    //获得组件参数
    
    //获得页面参数            
    sAccountMonth =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
    sDuebillNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DuebillNo"));
    if(sAccountMonth == null) sAccountMonth = "";
    if(sDuebillNo == null) sDuebillNo = "";
    sCustomerType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
    if(sCustomerType == null) sCustomerType = ""; 
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%
    //通过显示模版产生ASDataObject对象doTemp
    String sTempletNo = "ReserveCompInfo";
    String sTempletFilter = "1=1";
    ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);    
    if(sCustomerType.equals("03"))
        doTemp.setVisible("IsMsIndustry,IndustryGrade,IsMarket,IndustryType,BelongArea",false);
   
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
    //设置DW风格 1:Grid 2:Freeform
    dwTemp.Style="2";      
    //设置是否只读 1:只读 0:可写
    dwTemp.ReadOnly = "0"; 
    
    //生成HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow(sAccountMonth+","+sDuebillNo);
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
    
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
            //{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
            //{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
    };
%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
    <%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
<script type="text/javascript">
    
    //---------------------定义按钮事件------------------------------------
    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
    function saveRecord(sPostEvents)
    {
        //更新前进行自动置位
        beforeUpdate();
        as_save("myiframe0",sPostEvents);
    }
    
    /*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
    function goBack()
    {
        OpenPage("/Reserve/ReserveComp/ReserveCompList.jsp","_self","");
    }
</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
<script type="text/javascript">
        
    /*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
    function beforeUpdate()
    {
        //更新日期自动置位
        setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
    }
        
    /*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
    function initRow()
    {
        //如果没有找到对应记录，则新增一条，并设置字段默认值
        if (getRowCount(0)==0) 
        {
            //新增记录
            as_add("myiframe0");
            bIsInsert = true;
        }
    }
</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
    AsOne.AsInit();
    init();
    var bFreeFormMultiCol = true;
    my_load(2,0,'myiframe0');
    //页面装载时，对DW当前记录进行初始化
    initRow();
    var bCheckBeforeUnload = false;
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
