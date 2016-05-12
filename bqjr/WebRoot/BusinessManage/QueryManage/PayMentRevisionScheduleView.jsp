<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Describe: 还款计划修正页面
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "还款计划修正预览"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得组件参数
	String revisionSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("revisionSerialNo"));
    String sContractSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
    if(sContractSerialNo == null ) sContractSerialNo = "";
    if(revisionSerialNo == null ) revisionSerialNo = "";

	String loanSerialNo = Sqlca.getString(new SqlObject("select serialno from acct_loan where putoutno =:ObjectNo").setParameter("ObjectNo", sContractSerialNo));
 	
	String BusinessDate=SystemConfig.getBusinessDate();
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
		<%
		/*
			Describe: 还款计划修正页面
			本页面进行了特殊处理，修改的时候请不要随便改动sHeaders的顺序，
			确保PayprincipalAmt在第6列，PayprincipalRrevisionAmt在第7列
			CustomerServeFee在第9列，CustomerServeRevisionFee在第10列
			AccountManageFee在第11列，AccountManageRevisionFee在第12列。
			后几列为以下内容。
			{"Payserialno","本金ID"},
			{"A2serialno","客户服务费 id"},
			{"A7serialno","财务管理费id"},
			{"revisionSerialno","调整申请id"}
		 */
		%>
	<%
		String sHeaders[][] = { 
								{"SeqID","期次"},
								{"PayDate","应还日期"},
								{"segfromdate","滞纳金创建日期"},
								{"TotalAmt","应还期款总金额(元)"},
								{"ActualTotalAmt","实还总金额"},
								{"PayprincipalAmt","原本金金额(元)"},
								{"PayprincipalRrevisionAmt","修改后本金金额(元)"},
								{"InteAmt","利息金额(元)"},
								{"CustomerServeFee","原客户服务费(元)"},
								{"CustomerServeRevisionFee","修改后客户服务费(元)"},
								{"AccountManageFee","原财务管理费(元)"},
								{"AccountManageRevisionFee","修改后财务管理费(元)"},
								{"StampTax","印花税(元)"},
								{"PayInsuranceFee","增值服务费(元)"},
								{"OverDueAmt","滞纳金(元)"},
								{"AdvanceFee","提前还款手续费(元)"},
								{"Payserialno","本金ID"},
								{"A2serialno","客户服务费 id"},
								{"A7serialno","财务管理费id"},
								{"revisionSerialno","调整申请id"}
							}; 

		 String sSql ="SELECT aps.seqid as SeqID,aps.paydate as PayDate, af.segfromdate as segfromdate, "
				 +"sum(case when r.payprincipal_revision_amt is null then nvl(aps.payprincipalamt,0) else r.payprincipal_revision_amt end +nvl(aps.payinteamt,0)) as TotalAmt, " //--应还总金额 
				 +"sum(nvl(aps.actualpayprincipalamt,0)+nvl(aps.actualpayinteamt,0)) as ActualTotalAmt, " //--实还总金额
				 +"sum(case when aps.paytype='1' then nvl(r.payprincipal_amt,0) else 0 end) as PayprincipalAmt, "//--原本金金额(元)
				 +"sum(case when r.paytype='1' then nvl(r.payprincipal_revision_amt,0) else 0 end) as PayprincipalRrevisionAmt, "//--本金 金额(元)
				 +"sum(case when aps.paytype='1' then nvl(aps.payinteamt,0) else 0 end) as InteAmt, "//--利息金额(元)
				 +"sum(case when aps.paytype='A2' then nvl(r.payprincipal_amt,0) else 0 end) as CustomerServeFee, "//--原应还客户服务费
				 +"SUM(case when r.paytype='A2' then nvl(r.payprincipal_revision_amt,0) else 0 end) as CustomerServeRevisionFee, "// --调整后的客户服务费 
				 +"sum(case when aps.paytype='A7' then nvl(r.payprincipal_amt,0) else 0 end) as AccountManageFee, "// --原应还财务管理费
				 +"SUM(case when r.paytype='A7' then nvl(r.payprincipal_revision_amt,0) else 0 end) as AccountManageRevisionFee, "// --调整后的财务管理费
				 +"sum(case when aps.paytype='A11' then nvl(aps.payprincipalamt,0) else 0 end) as StampTax, "// --印花税
				 +"sum(case when aps.paytype='A10' then nvl(aps.payprincipalamt,0) else 0 end) as OverDueAmt, "// --滞纳金
				 +"sum(case when aps.paytype='A9' then nvl(aps.payprincipalamt,0) else 0 end) as AdvanceFee, "// --应还提前还款手续费
				 +"sum(case when aps.paytype='A12' then nvl(aps.payprincipalamt,0) else 0 end) as PayInsuranceFee, "//--增值服务费
				 +"max(case when aps.paytype='1' then aps.serialno  end) as Payserialno, "//--本金ID
				 +"max(case when aps.paytype='A2' then aps.serialno end) as A2serialno, "//--客户服务费 id
				 +"max(case when aps.paytype='A7' then aps.serialno  end) as A7serialno, "//--财务管理费id
				 +"max(r.revision_serialno) as revisionSerialno "//--调整申请ID
				 +" from acct_payment_schedule aps "//
				 +"left join (select aprd.revision_serialno,aprd.payment_schedule_serialno, aprd.payprincipal_revision_amt,aprd.payprincipal_amt,aprd.payType"// 
						+" from ACCT_PAYMENT_REVERSION apr,ACCT_PAYMENT_REVERSION_DETAIL aprd " 
				 +"where apr.serialno = aprd.revision_serialno and apr.serialno = '"+revisionSerialNo+"')  r   on r.payment_schedule_serialno = aps.serialno  "//
				 +"left join acct_fee af on aps.objectno=af.serialno and af.feetype='A10'  "//
				 +  "where (aps.objectno='"+loanSerialNo+"' and aps.objecttype='jbo.app.ACCT_LOAN') or (aps.relativeobjectno='"+loanSerialNo+"' and aps.relativeobjecttype='jbo.app.ACCT_LOAN') "// 关联的借据
				 +  "group by SeqID,aps.PayDate,segfromdate order by SeqID,aps.PayDate ";

	 //设置DataObject				
	 ASDataObject doTemp = new ASDataObject(sSql);
	 
	 doTemp.setCheckFormat("PayDate","3");
	 doTemp.setHeader(sHeaders);
	 doTemp.setVisible("Payserialno,A2serialno,A7serialno,revisionSerialno", false);//主键不可见
	 doTemp.setAlign("TotalAmt,ActualTotalAmt,PayprincipalAmt,PayprincipalRrevisionAmt,CustomerServeRevisionFee,AccountManageRevisionFee,InteAmt,AccountManageFee,CustomerServeFee","3");
	 doTemp.setAlign("StampTax,PayInsuranceFee,OverDueAmt,AdvanceFee,PayOutSourceSum","3");
	 doTemp.setAlign("SeqID,PayDate","2");
	 doTemp.setCheckFormat("TotalAmt,ActualTotalAmt,PayprincipalAmt,PayprincipalRrevisionAmt,CustomerServeRevisionFee,AccountManageRevisionFee,InteAmt,,CustomerServeFee,AccountManageFee,PayOutSourceSum","2");
	 doTemp.setCheckFormat("StampTax,PayInsuranceFee,OverDueAmt,ActualOverDueAmt,AdvanceFee","2");
	 doTemp.setColumnType("TotalAmt,ActualTotalAmt,PayprincipalAmt,PayprincipalRrevisionAmt,InteAmt,AccountManageFee,CustomerServeFee,AccountManageRevisionFee,CustomerServeRevisionFee,StampTax,PayInsuranceFee,OverDueAmt,AdvanceFee,PayOutSourceSum","2");
	 doTemp.setHTMLStyle("PayDate","style={width:80px}");
	 doTemp.setHTMLStyle("SeqID","style={width:120px}");
	 doTemp.setHTMLStyle("ActualTotalAmt","style={color:red}");

	

	 ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	 dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	 dwTemp.ReadOnly = "1"; //设置为可写
	 dwTemp.ShowSummary = "1";//设置汇总
	//生成datawindow
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
		{"false","","Button","提交","提交申请","submitApp(2)",sResourcesPath},
		{"false","","Button","暂 存","暂时保存申请","submitApp(1)",sResourcesPath},
		{"false","","Button","导出Excel","导出Excel","exportAll()",sResourcesPath}
	
	};
	
	%> 
<%/*~END~*/%>
	
<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">
	function initMyRows(myiframe0){
		var myobj=frames[myiframe0];
		var trs = myobj.document.getElementsByTagName("table")[0].getElementsByTagName("tr");
		var tbody = myobj.document.getElementsByTagName("table")[0].getElementsByTagName("tbody");
		tbody[0].setAttribute("onmousedown","");
		if(trs.length>0){
			for(var i=0;i<trs.length;i++){
				if(i==0)continue;//分页控件点了一行
				var cells = trs[i].cells;
				if(i==1){//移除表头部点击事件
				  for(var j=0;j<trs[i].getElementsByTagName("th").length;j++){
				     trs[i].getElementsByTagName("th")[j].setAttribute("onclick","");
				  }
				 }else if(i==(trs.length-1) || i==(trs.length-2)){//小计总计
				}else{
					  var pay = trs[i].cells[7].innerText;
					  var pay1 = trs[i].cells[6].innerText;
					  pay = Trim(pay);
			          if(Trim(pay1)!=pay){
			        	  trs[i].cells[7].style.color="red"; 
			          }
					  var a2 = trs[i].cells[10].innerText;
					  var a21 = trs[i].cells[9].innerText;
					  a2 = Trim(a2);
					  if(Trim(a21)!=a2){
						  trs[i].cells[10].style.color="red"; 
			          }
					  var a7 = trs[i].cells[12].innerText;
					  var a71 = trs[i].cells[11].innerText;
					  a7 = Trim(a7);
					  if(Trim(a71)!=a7){
						  trs[i].cells[12].style.color="red"; 
			          }
				}
			}
		}
	}
	
	//去掉字串两头的空格
	function Trim(string){
		return string.replace(/( +)$/g,"").replace(/^( +)/g,"");
	}
	</script>
	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load_show(2,0,'myiframe0');
	initMyRows('myiframe0');
	//initRow(); //页面装载时，对DW当前记录进行初始化
</script>		
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
