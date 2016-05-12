<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   wlu 2009-2-17
		Tester:
		Content: 核心科目管理
		Input Param:
                  
		Output param:
		

	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "核心科目管理"; // 浏览器窗口标题
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获取组件参数
	
	//获取页面参数
    
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	//由SQL语句生成窗体对象。
	  String sTempletNo = "SubjectList"; //模版编号
	 ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);	

	//filter过滤条件
    //过滤查询
 	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	//设置页面显示的列数
	dwTemp.setPageSize(20);
	
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
	String sButtons[][] = 
	{
		{"true","","Button","新增","新增","newRecord()",sResourcesPath,"btn_icon_add"},
		{"true","","Button","详情","查看详情/修改","viewAndEdit()",sResourcesPath,"btn_icon_detail"},
		{"true","","Button","删除","删除","deleteRecord()",sResourcesPath},
		
	};
        
	
	%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

		/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
		function newRecord(){
			sReturn = popComp("SubjectInfo","/Common/Configurator/SubjectPolicy/SubjectInfo.jsp","","");
			if (typeof(sReturn)!='undefined' && sReturn.length!=0) {
				reloadSelf();
			}
		}

		/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
		function viewAndEdit(){
			sSubjectNo = getItemValue(0,getRow(),"SubjectNo");
			if (typeof(sSubjectNo)=="undefined" || sSubjectNo.length==0){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}

			sReturn = popComp("SubjectInfo","/Common/Configurator/SubjectPolicy/SubjectInfo.jsp","SubjectNo="+sSubjectNo,"");
			//修改数据后刷新列表
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				reloadSelf();
			}
		}
    
		/*~[Describe=从当前列表中删除该记录;InputParam=无;OutPutParam=无;]~*/
		function deleteRecord(){   
			sSubjectNo = getItemValue(0,getRow(),"SubjectNo");
			if (typeof(sSubjectNo)=="undefined" || sSubjectNo.length==0){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}
			if(confirm(getHtmlMessage("2")))//您真的想删除该信息吗？
			{
				as_del("myiframe0");
				as_save("myiframe0");  //如果单个删除，则要调用此语句
			}
		}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	function mySelectRow(){     
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
