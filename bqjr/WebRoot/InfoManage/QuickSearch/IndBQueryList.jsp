<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
    <%
    /*
        Author: zhuang 2010-03-17
        Tester:
        Content: 个体客户快速查询
        Input Param:
        Output param:
        History Log: 
     */
    %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
    <%
    String PG_TITLE = "个体经营户快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
    String PG_CONTENT_TITLE = "&nbsp;&nbsp;个体经营户快速查询&nbsp;&nbsp;";
    %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
    //定义变量
    String sSql = "";//--存放sql语句
    //获得组件参数    
    
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%  
    //定义表头文件
	String sSortNo=CurOrg.getSortNo();

	String sTempletNo="IndBQueryList";
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
    
    //生成查询框
    doTemp.generateFilters(Sqlca);
    doTemp.parseFilterData(request,iPostChange);
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca)); 
    
    if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";

    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
    dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
    dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(16);  //服务器分页

    //生成HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow(sSortNo);
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
        {"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath}
    };
    %> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
    <%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
    <script type="text/javascript">
    //---------------------定义按钮事件------------------------------//

    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
    function viewAndEdit()
    {
        //获得个人客户代码
        sCustomerID=getItemValue(0,getRow(),"CustomerID");  
        
    
        if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
        {
            alert(getHtmlMessage(1));  //请选择一条记录！
            return;
        }else
        {
            openObject("Customer",sCustomerID,"002");//打开个人客户详细信息
        }
    }   
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
