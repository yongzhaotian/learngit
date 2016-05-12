
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
    <%
    /*
        Author:zywei 2005/08/29
        Tester:
        Content: 授信额度基本信息页面
        Input Param:
            LineID：授信额度编号            
        Output param:
        History Log: 
            2009-10-21 cbsu 将更新表由CL_INFO更改为BUSINESS_CONTRACT

     */
    %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
    <%
    String PG_TITLE = "授信额度信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
    CurPage.setAttribute("ShowDetailArea","true");
    CurPage.setAttribute("DetailAreaHeight","300");
    %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

    //定义变量 add by cbsu 2009-10-20
    ASResultSet rs = null;//-- 存放结果集
    String sSql = "";
    //获得组件参数

    //获得页面参数
    String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    //将空值转化为空字符串
    if(sSerialNo == null) sSerialNo = "";   

	sSql = " select LineID from CL_INFO where BCSerialNo=:BCSerialNo and (ParentLineID is null or ParentLineID='' or ParentLineID=' ') ";
	//获得授信额度总协议号
	String sParentLineID = Sqlca.getString(new SqlObject(sSql).setParameter("BCSerialNo",sSerialNo));
	if(sParentLineID==null) sParentLineID="";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
    <%
    String[][] sHeaders = {                                            
                           {"CustomerID","客户编号"},
                           {"CustomerName","客户名称"},
                           {"BusinessSum","额度金额"},
                           {"TotalBalance","额度余额"},
                           {"BusinessCurrency","币种"},    
                           {"BeginDate","生效日"},
                           {"PutOutDate","起始日"},
                           {"Maturity","到期日"},            
                           {"LimitationTerm","额度使用最迟日期"},                
                           {"UseTerm","额度项下业务最迟到期日期"},                
                           {"InputOrgName","登记机构"},
                           {"InputUserName","登记人"},
                           {"InputDate","登记日期"},
                           {"UpdateDate","更新日期"}
            };
    sSql = " Select SerialNo, CustomerID, CustomerName, BusinessCurrency, BusinessSum,TotalBalance, " + //客户编号，客户名称，额度金额，币种
           " BeginDate, PutOutDate, Maturity, LimitationTerm, UseTerm, " + //发生日期，起始日，到期日，额度使用最迟日期，额度项下业务最迟到期日期
           " InputOrgID, GetOrgName(InputOrgID) as InputOrgName," + //登记机构
           " InputUserID, GetUserName(InputUserID) as InputUserName," + //登记人
           " InputDate, UpdateDate" + //登记日期，更新日期
           " From BUSINESS_CONTRACT" +
           " Where SerialNo = '" + sSerialNo + "'";
    
    ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.UpdateTable = "BUSINESS_CONTRACT";
    doTemp.setKey("SerialNo",true);    
    doTemp.setHeader(sHeaders);
    doTemp.setDDDWCode("BusinessCurrency","Currency");
    doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
    doTemp.setHTMLStyle("BeginDate,PutOutDate,Maturity,LimitationTerm,UseTerm"," style={width:80px} ");
    //设置不可见属性
    doTemp.setVisible("InputUserID,InputOrgID,SerialNo",false);
    //设置不可更新属性
    doTemp.setUpdateable("InputUserName,InputOrgName",false);
    //设置格式
    doTemp.setType("BusinessSum,TotalBalance","Number");
	doTemp.setCheckFormat("BusinessSum,TotalBalance","2");
    
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
    dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
    dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    
    //设置setEvent
        
    //生成HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow("");
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
            {"true","","Button","授信额度项下业务","相关授信额度项下业务","lineSubList()",sResourcesPath},        
            {"true","","Button","查看额度占用情况","查看额度占用情况","viewLineUsed()",sResourcesPath}        
        };
    %> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
    <%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
    <script type="text/javascript">
    
    //---------------------定义按钮事件------------------------------------
    /*~[Describe=授信额度项下业务;InputParam=无;OutPutParam=无;]~*/
    function lineSubList()
    {        
        sSerialNo = "<%=sSerialNo%>";
        if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
        {
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
        popComp("lineSubList","/CreditManage/CreditLine/lineSubList.jsp","LineNo="+sSerialNo,"","");
    }
    </script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
    <script type="text/javascript">
    /*~[Describe=查看额度占用情况;InputParam=无;OutPutParam=无;]~*/
    function viewLineUsed()
    {        
    	sSerialNo = "<%=sSerialNo%>";
        if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
        {
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
        sReturn = PopPage("/CreditManage/CreditLine/GetLineBalance.jsp?LineNo="+sSerialNo,"","dialogWidth=26;dialogHeight=14;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
       }
    
    </script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">    
    AsOne.AsInit();
    init();
    var bFreeFormMultiCol = true;
    my_load(2,0,'myiframe0');    
    OpenPage("/CreditManage/CreditLine/SubCreditLineAccountList.jsp?ParentLineID=<%=sParentLineID%>","DetailFrame","");
</script>    
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
