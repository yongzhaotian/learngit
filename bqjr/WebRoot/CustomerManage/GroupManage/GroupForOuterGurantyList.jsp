<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
    <%
    /*
        Author:   
        Tester: 
        Content: 为集团外客户担保信息
        Input Param:   
        Output Param:  
    */
    %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
    <%
    String PG_TITLE = "为集团外客户担保信息"   ; // 浏览器窗口标题 <title> PG_TITLE </title>  
    %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
    //定义变量
	String sTempletNo = "";//模板
     
    //获得组件参数    ：客户类型    
    String sGroupID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupID"));
	if(sGroupID == null) sGroupID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%    
    //取得模板号
    sTempletNo = "GroupForOuterGuarantyList";
	String sTempletFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	//增加过滤器 
    doTemp.generateFilters(Sqlca);
    doTemp.parseFilterData(request,iPostChange);
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
    //产生DataWindow
    ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
    dwTemp.setPageSize(25); //设置在datawindows中显示的行数
    dwTemp.Style="1"; //设置DW风格 1:Grid 2:Freeform
    dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    
    //生成HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow(sGroupID);
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
        //6.资源图片路径{"true","","Button","管户权转移","管户权转移","ManageUserIdChange()",sResourcesPath}
    String sButtons[][] = {
            {"true","","Button","详情","详情","viewClue()","","","","btn_icon_detail"},
     };
    %> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
    <%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

   
<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script language=javascript>
    var bHighlightFirst = true;//自动选中第一条记录
	function viewClue(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--担保信息编号
		
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			var sGuarantyType= getItemValue(0,getRow(),"GuarantyType");//担保类型
			var sContractType = getItemValue(0,getRow(),"ContractType");//担保合同类型	010：一般担保；020：最高额担保
			if(sContractType="020"){//如果是最高额担保
				//PopPage("/CreditManage/CreditAssure/ApplyAssureInfo2.jsp?SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType+"&BackToClose=true","","dialogWidth=800px;dialogHeight=800px;");
				//AsControl.PopComp("/CreditManage/CreditAssure/CreditHAssureContract/HAContractInfo.jsp","SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType+"&RightType=ReadOnly","dialogWidth=800px;dialogHeight=800px;resizable=yes;maximize:yes;help:no;status:no;scrollbar:no;");
				AsControl.PopComp("/CreditManage/CreditAssure/ApplyAssureInfo2.jsp","SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType+"&BackToClose=true","dialogWidth=800px;dialogHeight=650px;");			
			}else{
				//PopPage("/CreditManage/CreditAssure/ApplyAssureInfo1.jsp?SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType+"&BackToClose=true","","dialogWidth=800px;dialogHeight=800px;");
				//AsControl.PopComp("/CreditManage/CreditAssure/CreditHAssureContract/GAContractInfo.jsp","SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType+"&RightType=ReadOnly","dialogWidth=800px;dialogHeight=800px;resizable=yes;maximize:yes;help:no;status:no;scrollbar:no;");
				AsControl.PopComp("/CreditManage/CreditAssure/ApplyAssureInfo1.jsp","SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType+"&BackToClose=true","dialogWidth=800px;dialogHeight=650px;");			
			}
		}
	}
    </script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
    AsOne.AsInit();
    init(); 
    var bHighlightFirst = true;//自动选中第一条记录
    my_load(2,0,'myiframe0');
</script>   
<%/*~END~*/%>

   
<%@ include file="/IncludeEnd.jsp"%>