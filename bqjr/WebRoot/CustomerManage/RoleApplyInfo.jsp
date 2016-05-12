<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  --fbkang 2005.7.25
		Tester:
		Content: --权限申请页面
		Input Param:
            CustomerID：客户号
            UserID：用户代码
            OrgID：机构代码
            Check：检查标志
		Output param:
			               
		History Log: fwang on 2009/06/16 调用方法对客户经理关系的逻辑判断
		History Log: fwang on 2009/06/24 屏蔽保存按钮
		
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户权限申请情况"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得组件参数：客户编号、用户ID、机构ID、检查标志
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserID"));
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
    String sCheck = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Check"));
    //将空值转化为空字符串
    if(sCustomerID == null) sCustomerID = "";
    if(sUserID == null) sUserID = "";
    if(sOrgID == null) sOrgID = "";
    if(sCheck == null) sCheck = "";
    
%>
<%/*~END~*/%>


<%
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "RoleApplyInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	if(sCheck.equals("Y"))
	   {
	      doTemp.setReadOnly("ApplyReason",true); 
	      doTemp.setRequired("",false);
	   }
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID+","+sUserID+","+sOrgID);//传入参数,逗号分割
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
			{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","","Button","提交","提交申请","Apply()",sResourcesPath},
			{"true","","Button","批准","批准申请","Authorize()",sResourcesPath},
			{"true","","Button","否决","否决申请","Overrule()",sResourcesPath}
		};
	if(sCheck.equals("Y"))
	{
	   sButtons[0][0]="false";
	   sButtons[1][0]="false";
	}
	else
	{
	   sButtons[2][0]="false"; 
	   sButtons[3][0]="false";
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(!checkOtherRoles())
		    return;
		as_save("myiframe0",sPostEvents);
	}
    /*~[Describe=提交;InputParam=无;OutPutParam=无;]~*/
    function Apply()
    {
        if(!checkOtherRoles())
		    return;
        var sApplyReason =  getItemValue(0,getRow(),"ApplyReason");
        if(sApplyReason=="")
        {
            alert("信息不全，提交失败！(申请理由没填)");
            return;
        }
        var sApplyAttribute =  getItemValue(0,getRow(),"ApplyAttribute");//--获得是否申请客户主办权标志
        var sApplyAttribute1 = getItemValue(0,getRow(),"ApplyAttribute1");//--获得是否申请信息查看权标志
        var sApplyAttribute2 = getItemValue(0,getRow(),"ApplyAttribute2");//--获得是否申请信息维护权标志
        var sApplyAttribute3 = getItemValue(0,getRow(),"ApplyAttribute3");//--获得是否申请业务申办权标志
        if(sApplyAttribute1=="" || sApplyAttribute2=="" || sApplyAttribute3=="")
        {
            alert("信息不全，提交失败！(申请权限不能为空)");
            return;
        }
        sCustomerID=getItemValue(0,getRow(),"CustomerID");
        sUserID = getItemValue(0,getRow(),"UserID");
        sOrgID = getItemValue(0,getRow(),"OrgID");
        //调用判断客户经理关系的类方法,用于判断客户经理关系以及插入一个标志位
        sReturnValue = RunMethod("CustomerManage","CheckRoleApply",sCustomerID+","+sUserID+","+sOrgID);
        
        if(sApplyAttribute == "1" || sApplyAttribute1=="1" || sApplyAttribute2 == "1" || sApplyAttribute3 == "1")
        {    
            setItemValue(0,0,"ApplyStatus","1"); 
            sReturnString = PopPageAjax("/CustomerManage/GetMessageActionAjax.jsp?CustomerID="+sCustomerID,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
           	alert(sReturnString);
           	saveRecord(self.close());
        }
        else
        {
            alert("至少要提交一个权限的申请！");
        }
    }
    
    function Authorize()
    {
        if(!checkOtherRoles())
		    return;
        if(confirm("确定通过该申请吗？"))
        {
            var sApplyAttribute =  getItemValue(0,getRow(),"ApplyAttribute");//--获得是否申请客户主办权标志
            var sApplyAttribute1 = getItemValue(0,getRow(),"ApplyAttribute1");//--获得是否申请信息查看权标志
            var sApplyAttribute2 = getItemValue(0,getRow(),"ApplyAttribute2");//--获得是否申请信息维护权标志
            var sApplyAttribute3 = getItemValue(0,getRow(),"ApplyAttribute3");//--获得是否申请业务申办权标志
            var sApplyAttribute4 = getItemValue(0,getRow(),"ApplyAttribute4");//--获得待定的权限标志
            var sApplyReason =  getItemValue(0,getRow(),"ApplyReason");
            
            sReturn = PopPageAjax("/CustomerManage/AuthorizeRoleActionAjax.jsp?CustomerID=<%=sCustomerID%>&UserID=<%=sUserID%>&ApplyAttribute="+sApplyAttribute+"&ApplyAttribute1="+sApplyAttribute1+"&ApplyAttribute2="+sApplyAttribute2+"&ApplyAttribute3="+sApplyAttribute3+"&ApplyAttribute4="+sApplyAttribute4,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
            sReturn =  getSplitArray(sReturn);
            sHave = sReturn[0];
            sOrgName = sReturn[1];
            sUserName = sReturn[2];
            sBelongUserID = sReturn[3];
            if(sHave == "_TRUE_")
            {
                if(confirm(sOrgName+" "+sUserName+" "+"已经拥有该客户的主办权！是否继续批准？如果主办权转移，原有主办权人则自动丧失一切客户权利，如有需求则需重新申请！"))
                {
                    var sReturn=PopPageAjax("/CustomerManage/ChangeRoleActionAjax.jsp?CustomerID=<%=sCustomerID%>&UserID=<%=sUserID%>&BelongUserID="+sBelongUserID,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
					if(typeof(sReturn) != "undefined" && sReturn == "true"){
	                    alert("批准该客户权限成功！");
						self.close();
					}else{
						alert("批准该客户权限失败！");
					}
                }
            }else
            {
                alert("批准该客户权限成功！");
            }
            setItemValue(0,0,"ApplyStatus","2");
            setItemValue(0,0,"ApplyAttribute",sApplyAttribute);
            setItemValue(0,0,"ApplyAttribute1",sApplyAttribute1);
            setItemValue(0,0,"ApplyAttribute2",sApplyAttribute2);
            setItemValue(0,0,"ApplyAttribute3",sApplyAttribute3);
            setItemValue(0,0,"ApplyAttribute4",sApplyAttribute4);
            setItemValue(0,0,"ApplyReason",sApplyReason);
            saveRecord(self.close());                
        }
    }
    
    function Overrule()
    {
        if(confirm("确定否决该申请吗？"))
        {
            setItemValue(0,0,"ApplyStatus","2");
            setItemValue(0,0,"ApplyAttribute","");
            setItemValue(0,0,"ApplyAttribute1","");
            setItemValue(0,0,"ApplyAttribute2","");
            setItemValue(0,0,"ApplyAttribute3","");
            setItemValue(0,0,"ApplyAttribute4","");
            setItemValue(0,0,"ApplyReason","");
            alert("已否决该客户权限申请！");
            saveRecord(self.close());  
        }
    }
    
    function checkApplyAttribute()
    {
        var sApplyAttribute = getItemValue(0,getRow(),"ApplyAttribute");//--获得是否申请客户主办权标志
        if(sApplyAttribute == "1")
        {
            setItemValue(0,0,"ApplyAttribute1","1");
            setItemValue(0,0,"ApplyAttribute2","1");
            setItemValue(0,0,"ApplyAttribute3","1");
            setItemValue(0,0,"ApplyAttribute4","1");
        }
    }
    function checkOtherRoles()
    {
        var sApplyAttribute = getItemValue(0,getRow(),"ApplyAttribute");//--获得是否申请客户主办权标志
        var sApplyAttribute1 = getItemValue(0,getRow(),"ApplyAttribute1");//--获得是否申请信息查看权标志
        var sApplyAttribute2 = getItemValue(0,getRow(),"ApplyAttribute2");//--获得是否申请信息维护权标志
        var sApplyAttribute3 = getItemValue(0,getRow(),"ApplyAttribute3");//--获得是否申请业务申办权标志
        var sApplyAttribute4 = getItemValue(0,getRow(),"ApplyAttribute4");//--未定
        
        if(sApplyAttribute == "1")
        {
            if(sApplyAttribute == "2" || sApplyAttribute2 == "2" || sApplyAttribute3 == "2" || sApplyAttribute4 == "2")
            {
                alert("你已经选择了主办权，主办权包含了各项权利，其他项不能选否");
                return false;
            }
        }
        
        if(sApplyAttribute2 == "1" && sApplyAttribute1 == "2")
        {            
            alert("你已经选择了信息维护权，信息维护权包含了信息查看权，信息查看权不能选否");
            return false;    
        }
        
        return true;
    }
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

    function initRow()
    {
        var sBelongAttribute =  getItemValue(0,getRow(),"BelongAttribute");//--获得是否客户主办权标志
        var sBelongAttribute1 = getItemValue(0,getRow(),"BelongAttribute1");//--获得是否信用等级评定权标志
        var sBelongAttribute2 = getItemValue(0,getRow(),"BelongAttribute2");//--获得是否信息查看权标志
        var sBelongAttribute3 = getItemValue(0,getRow(),"BelongAttribute3");//--获得是否信息维护权标志
        var sBelongAttribute4 = getItemValue(0,getRow(),"BelongAttribute4");//--获得是否业务申办权标志
        
        var sApplyStatus = getItemValue(0,getRow(),"ApplyStatus");//--获得是否提交申请标志

		if(sApplyStatus != "1")
		{
	        if(sBelongAttribute == "1")
	        	setItemValue(0,0,"ApplyAttribute","1");
			else 
			 	setItemValue(0,0,"ApplyAttribute","2");
			
		    if(sBelongAttribute1 == "1")
	        	setItemValue(0,0,"ApplyAttribute1","1");
			else 
			 	setItemValue(0,0,"ApplyAttribute1","2");
			
			if(sBelongAttribute2 == "1")
	        	setItemValue(0,0,"ApplyAttribute2","1");
	    	else 
			 	setItemValue(0,0,"ApplyAttribute2","2");
		
	        if(sBelongAttribute3 == "1")
	        	setItemValue(0,0,"ApplyAttribute3","1");
	        else 
			 	setItemValue(0,0,"ApplyAttribute3","2");
		
	        if(sBelongAttribute4 == "1")
	        	setItemValue(0,0,"ApplyAttribute4","1");
	        else 
			 	setItemValue(0,0,"ApplyAttribute4","2"); 
		}	    
        
    }
    
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>

<script type="text/javascript">	
    //不提示页面已修改
	function isModified(objname)
	{
		return false;
	}
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
