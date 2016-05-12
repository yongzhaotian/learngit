<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   slliu 2004.11.22
		Tester:
		Content: 不良重组列表
		Input Param:
			   ItemID：重组状态     
		Output param:
				 
		History Log: 
		                  
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "不良重组列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql="";
	String sSortNo; //排序编号
	String sItemID; //重组状态
	String sWhereClause=""; //Where条件
	String sViewID=null; //查看方式
	
	//获得组件参数	
	sSortNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SortNo"));
	if(sSortNo==null) sSortNo="";
	
	sItemID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemID"));
	if(sItemID==null) sItemID="";
	
	//定义表头文件
	String sHeaders[][] = {
				{"SerialNo","重组方案编号"},
				{"ApplyTypeName","重组类型"},
				{"OperateTypeName","重组形式"},
				{"Flag1","是否首次重组"},
				{"OccurDate","首次重组时间"},
				{"OperateUserName","经办人"},
				{"OperateOrgName","经办机构"}				
				}; 

 	if(sItemID.equals("010")){	//未批准重组方案:被屏蔽，当然在任何时候都可以放开，不是么？
		sSql = 	" select BA.SerialNo as SerialNo,BA.ApplyType as ApplyType,getItemName('ReformType',BA.ApplyType) as ApplyTypeName," + 	
				" getItemName('YesNo',BA.Flag1) as Flag1," + 
				" getItemName('ReformShape',BA.OperateType) as OperateTypeName," + 
				" BA.OccurDate as OccurDate," + 
				" getUserName(BA.OperateUserID) as OperateUserName, " + 
				" getOrgName(BA.OperateOrgID) as OperateOrgName " + 			 
				" from BUSINESS_APPLY BA,Flow_Object FO " +		
				" where  BA.OperateUserID = '"+CurUser.getUserID()+"' " +
				" and  BA.OperateOrgID = '"+CurOrg.getOrgID()+"' " +
				" and BA.SerialNo = FO.ObjectNo "+
				" and FO.ObjectType = 'NPAReformApply' "+
				" and (FO.PhaseNo <> '1000' and FO.PhaseNo <> '8000')"+
				" and BA.PigeonholeDate is null "+
				" and BA.BusinessType = '6010' order by SerialNo desc " ;
	}
 	
	if(sItemID.equals("020")){	//已批准未执行的重组方案
		sSql = 	" select BA.SerialNo as SerialNo,BA.ApplyType as ApplyType,getItemName('ReformType',BA.ApplyType) as ApplyTypeName," + 	
				" getItemName('YesOrNo',BA.Flag1) as Flag1," + 
				" getItemName('ReformShape',BA.OperateType) as OperateTypeName," + 
				" BA.OccurDate as OccurDate," + 
				" getUserName(BA.OperateUserID) as OperateUserName, " + 
				" getOrgName(BA.OperateOrgID) as OperateOrgName " + 			 
				" from BUSINESS_APPLY BA,Flow_Object FO " +		
				" where  BA.OperateUserID = '"+CurUser.getUserID()+"' " +
				" and  BA.OperateOrgID = '"+CurOrg.getOrgID()+"' " +
				" and BA.SerialNo = FO.ObjectNo "+
				" and FO.ObjectType = 'NPAReformApply' "+
				" and FO.PhaseNo = '1000' "+
				" and BA.PigeonholeDate is null "+
				" and BA.SerialNo not in (select ObjectNo from CONTRACT_RELATIVE where ObjectType='NPAReformApply') "+
				" and BA.BusinessType = '6010' order by SerialNo desc " ;	
	}
	if(sItemID.equals("030")){	//已否决的重组方案
		sSql = 	" select BA.SerialNo as SerialNo,BA.ApplyType as ApplyType,getItemName('ReformType',BA.ApplyType) as ApplyTypeName," + 	
				" getItemName('YesOrNo',BA.Flag1) as Flag1," + 
				" getItemName('ReformShape',BA.OperateType) as OperateTypeName," + 
				" BA.OccurDate as OccurDate," + 
				" getUserName(BA.OperateUserID) as OperateUserName, " + 
				" getOrgName(BA.OperateOrgID) as OperateOrgName " + 			 
				" from BUSINESS_APPLY BA,Flow_Object FO " +		
				" where  BA.OperateUserID = '"+CurUser.getUserID()+"' " +
				" and  BA.OperateOrgID = '"+CurOrg.getOrgID()+"' " +
				" and BA.SerialNo = FO.ObjectNo "+
				" and FO.ObjectType = 'NPAReformApply' "+
				" and FO.PhaseNo = '8000' "+
				" and BA.PigeonholeDate is null "+
				" and BA.BusinessType = '6010' "+
				" order by SerialNo desc " ;
	}
	
	if(sItemID.equals("060")){	//已执行的重组方案
		sSql = 	" select BA.SerialNo as SerialNo,BA.ApplyType as ApplyType,getItemName('ReformType',BA.ApplyType) as ApplyTypeName," + 	
				" getItemName('YesOrNo',BA.Flag1) as Flag1," + 
				" getItemName('ReformShape',BA.OperateType) as OperateTypeName," + 
				" BA.OccurDate as OccurDate," + 
				" getUserName(BA.OperateUserID) as OperateUserName, " + 
				" getOrgName(BA.OperateOrgID) as OperateOrgName " + 			 
				" from BUSINESS_APPLY BA,Flow_Object FO " +		
				" where  BA.OperateUserID = '"+CurUser.getUserID()+"' " +
				" and  BA.OperateOrgID = '"+CurOrg.getOrgID()+"' " +
				" and BA.SerialNo = FO.ObjectNo "+
				" and FO.ObjectType = 'NPAReformApply' "+
				" and FO.PhaseNo = '1000' "+
				" and BA.PigeonholeDate is null "+
				" and BA.SerialNo in (select ObjectNo from CONTRACT_RELATIVE "+
				" where ObjectType='NPAReformApply') "+
				" and BA.BusinessType = '6010' order by SerialNo desc " ;
	}
	
	if(sItemID.equals("080")){	//已归档的重组方案
		sSql = 	" select BA.SerialNo as SerialNo,BA.ApplyType as ApplyType,getItemName('ReformType',BA.ApplyType) as ApplyTypeName," + 	
				" getItemName('YesOrNo',BA.Flag1) as Flag1," + 
				" getItemName('ReformShape',BA.OperateType) as OperateTypeName," + 
				" BA.OccurDate as OccurDate," + 
				" getUserName(BA.OperateUserID) as OperateUserName, " + 
				" getOrgName(BA.OperateOrgID) as OperateOrgName " + 			 
				" from BUSINESS_APPLY BA,Flow_Object FO " +		
				" where  BA.OperateUserID = '"+CurUser.getUserID()+"' " +
				" and  BA.OperateOrgID = '"+CurOrg.getOrgID()+"' " +
				" and BA.SerialNo = FO.ObjectNo "+
				" and FO.ObjectType = 'NPAReformApply' "+
				" And (BA.Pigeonholedate is not null and BA.Pigeonholedate<>' ')"+
				" and BA.BusinessType = '6010' order by SerialNo desc " ;
	}
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//利用Sql生成窗体对象
	//out.println(sSql);
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "BUSINESS_CONTRACT";	
	doTemp.setKey("SerialNo",true);	 //设置关键字
	
	//设置共用格式
	doTemp.setVisible("ApplyType,SerialNo",false);	
	doTemp.setCheckFormat("BusinessSum","2");
	doTemp.setCheckFormat("Balance","2");
	
	//设置对齐方式	
	doTemp.setAlign("BusinessSum","3");
	doTemp.setAlign("Balance","3");	
	
	//设置选项双击及行宽
	doTemp.setHTMLStyle("ArtificialNo"," style={width:100px} ");
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("RecoveryUserName"," style={width:65px} ");
	doTemp.setHTMLStyle("OccurTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName"," style={width:40px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("ShiftBalance,Balance"," style={width:95px} ");
	doTemp.setHTMLStyle("ClassifyResult"," style={width:55px} ");
	doTemp.setHTMLStyle("ShiftTypeName"," style={width:56px} ");
	doTemp.setHTMLStyle("Maturity"," style={width:65px} ");
	doTemp.setHTMLStyle("ManageOrgName"," style={width:90px} ");
	doTemp.setHTMLStyle("ManageUserName"," style={width:60px} ");
	
	//生成查询框
	doTemp.setColumnAttribute("ArtificialNo,CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);  //服务器分页


	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSortNo);
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
	
		//如果为拟重组不良资产，则列表显示如下按钮
		
		String sButtons[][] = {
					{"false","","Button","新增重组方案","新增重组方案","NewRecord()",sResourcesPath},
					{"false","","Button","删除重组方案","删除已批准未执行的重组方案","DeleteRecord()",sResourcesPath},
					{"false","","Button","拟重组原贷款","查看拟重组原贷款","viewAndEdit()",sResourcesPath},
					{"false","","Button","重组前原贷款","查看拟重组原贷款","viewAndEdit()",sResourcesPath},
					{"false","","Button","重组方案详情","查看重组方案详情","viewReform()",sResourcesPath},
					{"false","","Button","重组后新贷款","查看重组贷款信息","ReformCredit()",sResourcesPath},
					{"false","","Button","重组方案执行台帐","重组方案执行台帐","ReformBook()",sResourcesPath},
					{"false","","Button","归档","归档","archive()",sResourcesPath},
					{"false","","Button","取消归档","取消归档","cancelarch()",sResourcesPath}
				};
				
		if(sItemID.equals("010")){
			sButtons[4][0]="true";
			sButtons[6][0]="true";
			sButtons[7][0]="true";
		}
		
		if(sItemID.equals("020")){
			sButtons[0][0]="true";
			sButtons[1][0]="true";
			sButtons[2][0]="true";
			sButtons[4][0]="true";
			sButtons[7][0]="true";
		}

		if(sItemID.equals("030")){
			sButtons[0][0]="true";
			sButtons[2][0]="true";
			sButtons[4][0]="true";
			sButtons[7][0]="true";
		}

		if(sItemID.equals("060")){
			sButtons[3][0]="true";
			sButtons[4][0]="true";
			sButtons[5][0]="true";
			sButtons[6][0]="true";
			sButtons[7][0]="true";
		}

		if(sItemID.equals("080")){
			sButtons[3][0]="true";
			sButtons[4][0]="true";
			sButtons[5][0]="true";
			sButtons[8][0]="true";
		}
%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	function NewRecord(){
		var sItemID="<%=sItemID%>";
		if (sItemID=="020"){
			sReturn = createObject("NPAReformApply","ApplyType=NPAReformApply~FlowNo=NPAReformFlow~PhaseNo=1000");//已经批准未执行。
		}

		if (sItemID=="030"){
			sReturn = createObject("NPAReformApply","ApplyType=NPAReformApply~FlowNo=NPAReformFlow~PhaseNo=8000");//否决的方案。
		}
		
		if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
		var sObjectNo = sReturn;  //申请编号
		openObject("NPAReformApply",sObjectNo,"001");
		reloadSelf();
	}

	function DeleteRecord(){
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
		}else if(confirm(getHtmlMessage(2))){ //您真的想删除该信息吗？
			sSerialNo=getItemValue(0,getRow(),"SerialNo");
			//删除business_apply之后，必须在相关联的表中删除其他纪录(违反完整性约束条件，无法删除。)			
			var sReturn=PopPageAjax("/RecoveryManage/NPAManage/NPAReform/NPAReformDeleteAjax.jsp?SerialNo="+sSerialNo+	"&ObjectType=NPAReformApply&FlowNo=NPAReformFlow","","resizable=yes;dialogWidth=16;dialogHeight=10;center:yes;status:no;statusbar:no");
			if(typeof(sReturn) != "undefined" && sReturn == "true"){
				alert("删除数据成功!");
				self.close();
			}else{
				alert("删除数据失败!");
			}
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
		
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit(){
		//申请流水号		
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");  
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		OpenComp("NPAReformContractList","/RecoveryManage/NPAManage/NPAReform/NPAReformContractList.jsp","ComponentName=拟重组不良资产详情列表?&ComponentType=MainWindow&SerialNo="+sSerialNo+"&ItemID=<%=sItemID%>","right",OpenStyle);
	}
	
	/*~[Describe=归档;InputParam=无;OutPutParam=无;]~*/
	function archive(){
		var sObjectType ="NPAReformApply";
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
			if(confirm("真的要归档吗？")){
				sReturn = PopPageAjax("/Common/WorkFlow/AddPigeonholeActionAjax.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"","");
				if(typeof(sReturn)!="undefined" && sReturn!="failed") 
				alert("归档成功！");
				self.location.reload();
			}
		}
	}
	
	/*~[Describe=取消归档;InputParam=无;OutPutParam=无;]~*/
	function cancelarch(){
		var sObjectType ="NPAReformApply";
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
			if(confirm("真的要取消归档吗？")){
				sReturn = PopPageAjax("/Common/WorkFlow/AddPigeonholeActionAjax.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&Pigeonholed=Y","","");
				if(typeof(sReturn)!="undefined" && sReturn!="failed") 
				alert("取消归档成功！");
				self.location.reload();
			}
		}
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	//重组方案申请信息
	function viewReform(){
		//获得申请流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		var sItemID = "<%=sItemID%>"; 
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));  //请选择一条信息！
		}else{
			sObjectType = "NPAReformApply";
			sObjectNo = sSerialNo;
			
			if(sItemID=="060" || sItemID=="080"){
				sViewID = "002";
			}else
				if (sItemID=="020"){
					sViewID="001";
				}else{	//特殊的标志位，用来决定是否显示重组台帐：除了060和080之外，均不显示重组台帐。
					sViewID = "003";  
				}

			if ((sItemID=="020")||(sItemID=="030") ){  //允许已否决的方案修改：权宜之计，日后禁用之。
				//不用openObject，是因为权限无法控制。
				//在这里ViewID失去作用，除非在对象类型中把rightofapply改为rightofviewid.
				//但是这样修改就会影响到申请部分的其他页面的权限。
				//该页面的原创者居然把系统预留的权限标志作为私有变量之用，给维护增添了极大的难度。需要提高哟。。。。
					OpenComp("NPAReformApplyView","/RecoveryManage/RMApply/NPAReformApplyView.jsp",
						"ObjectNo="+sObjectNo+"&ViewID="+sViewID,"_blank",OpenStyle);
					self.location.reload();
			}else
				openObject(sObjectType,sObjectNo,sViewID);
		}
	}
	
	//重组贷款信息
	function ReformCredit(){
		//获得重组方案流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo"); 
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		OpenComp("NPAReformContractList","/RecoveryManage/NPAManage/NPAReform/NPAReformContractList.jsp","ComponentName=资产详情列表?&ComponentType=MainWindow&SerialNo="+sSerialNo+"&Flag=ReformCredit&ItemID=<%=sItemID%>","right",OpenStyle);
	}
	
	//重组方案执行台帐
	function ReformBook(){
		//获得重组方案流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo"); 
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		OpenComp("NPAReformInfo","/RecoveryManage/NPAManage/NPAReform/NPAReformInfo.jsp","ComponentName=重组方案执行台帐&ComponentType=MainWindow&ObjectNo="+sSerialNo,"_blank",OpenStyle);
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