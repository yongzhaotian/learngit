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
	String PG_TITLE = "还款计划修正"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得组件参数
    String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
    String sContractSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
    if(sContractSerialNo == null ) sContractSerialNo = "";
    if(sObjectType == null ) sObjectType = "";

	String customerID = Sqlca.getString(new SqlObject("select customerid from business_contract where serialno =:ObjectNo ").setParameter("ObjectNo", sContractSerialNo));
	String loanSerialNo = Sqlca.getString(new SqlObject("select serialno from acct_loan where putoutno =:ObjectNo").setParameter("ObjectNo", sContractSerialNo));
	String stypeNo = Sqlca.getString(new SqlObject("select BusinessType from acct_loan where putoutno =:ObjectNo").setParameter("ObjectNo", sContractSerialNo));
	String preBalance = Sqlca.getString(new SqlObject("select debitbalance from acct_subsidiary_ledger where accountcodeno='Customer21' and objectno=:customerID").setParameter("customerID", customerID));
 	if(loanSerialNo == null) loanSerialNo = "";
 	if(stypeNo == null) stypeNo = "";
 	if(customerID == null) customerID = "";
 	if(preBalance == null) preBalance = "";
 	
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
		    {"status","合同状态"},
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
								{"PayprincipalRrevisionAmt","本金金额(元)"},
								{"InteAmt","利息金额(元)"},
								{"CustomerServeFee","原客户服务费(元)"},
								{"CustomerServeRevisionFee","客户服务费(元)"},
								{"AccountManageFee","原财务管理费(元)"},
								{"AccountManageRevisionFee","财务管理费(元)"},
								{"StampTax","印花税(元)"},
								{"PayInsuranceFee","增值服务费(元)"},
								{"OverDueAmt","滞纳金(元)"},
								{"AdvanceFee","提前还款手续费(元)"},
								{"status","合同状态"},
								{"Payserialno","本金ID"},
								{"A2serialno","客户服务费 id"},
								{"A7serialno","财务管理费id"},
								{"revisionSerialno","调整申请id"}
							}; 

		 String sSql ="SELECT aps.seqid as SeqID,aps.paydate as PayDate, af.segfromdate as segfromdate, "
				 +"sum(case when r.payprincipal_revision_amt is null then nvl(aps.payprincipalamt,0) else r.payprincipal_revision_amt end +nvl(aps.payinteamt,0)) as TotalAmt, " //--应还总金额 
				 +"sum(nvl(aps.actualpayprincipalamt,0)+nvl(aps.actualpayinteamt,0)) as ActualTotalAmt, " //--实还总金额
				 +"sum(case when aps.paytype='1' then nvl(aps.payprincipalamt,0) else 0 end) as PayprincipalAmt, "//--原本金金额(元)
				 +"sum(case when r.paytype='1' then nvl(r.payprincipal_revision_amt,0) else 0 end) as PayprincipalRrevisionAmt, "//--本金 金额(元)
				 +"sum(case when aps.paytype='1' then nvl(aps.payinteamt,0) else 0 end) as InteAmt, "//--利息金额(元)
				 +"sum(case when aps.paytype='A2' then nvl(aps.payprincipalamt,0) else 0 end) as CustomerServeFee, "//--原应还客户服务费
				 +"SUM(case when r.paytype='A2' then nvl(r.payprincipal_revision_amt,0) else 0 end) as CustomerServeRevisionFee, "// --调整后的客户服务费 
				 +"sum(case when aps.paytype='A7' then nvl(aps.payprincipalamt,0) else 0 end) as AccountManageFee, "// --原应还财务管理费
				 +"SUM(case when r.paytype='A7' then nvl(r.payprincipal_revision_amt,0) else 0 end) as AccountManageRevisionFee, "// --调整后的财务管理费
				 +"sum(case when aps.paytype='A11' then nvl(aps.payprincipalamt,0) else 0 end) as StampTax, "// --印花税
				 +"sum(case when aps.paytype='A10' then nvl(aps.payprincipalamt,0) else 0 end) as OverDueAmt, "// --滞纳金
				 +"sum(case when aps.paytype='A9' then nvl(aps.payprincipalamt,0) else 0 end) as AdvanceFee, "// --应还提前还款手续费
				 +"sum(case when aps.paytype='A12' then nvl(aps.payprincipalamt,0) else 0 end) as PayInsuranceFee, "//--增值服务费
				 +"max(r.status) as status, "
				 +"max(case when aps.paytype='1' then aps.serialno  end) as Payserialno, "//--本金ID
				 +"max(case when aps.paytype='A2' then aps.serialno end) as A2serialno, "//--客户服务费 id
				 +"max(case when aps.paytype='A7' then aps.serialno  end) as A7serialno, "//--财务管理费id
				 +"max(r.revision_serialno) as revisionSerialno "//--调整申请ID
				 +" from acct_payment_schedule aps "//
				 +"left join (select aprd.revision_serialno,aprd.payment_schedule_serialno, aprd.payprincipal_revision_amt,aprd.payType,apr.status "// 
						+" from ACCT_PAYMENT_REVERSION apr,ACCT_PAYMENT_REVERSION_DETAIL aprd " 
				 +"where apr.serialno = (select max(SERIALNO) from ACCT_PAYMENT_REVERSION where  status in('1','2')  and CONTRACT_SERIALNO ='"+sContractSerialNo+"' )  and apr.serialno=aprd.revision_serialno )  r   on r.payment_schedule_serialno = aps.serialno  "//
				 +"left join acct_fee af on aps.objectno=af.serialno and af.feetype='A10'  "//
				 +  "where (aps.objectno='"+loanSerialNo+"' and aps.objecttype='jbo.app.ACCT_LOAN') or (aps.relativeobjectno='"+loanSerialNo+"' and aps.relativeobjecttype='jbo.app.ACCT_LOAN') "// 关联的借据
				 +  "group by SeqID,aps.PayDate,segfromdate order by SeqID,aps.PayDate ";

	 //设置DataObject				
	 ASDataObject doTemp = new ASDataObject(sSql);
	 
	 doTemp.setCheckFormat("PayDate","3");
	 doTemp.setHeader(sHeaders);
	 doTemp.setAlign("TotalAmt,ActualTotalAmt,PayprincipalAmt,PayprincipalRrevisionAmt,CustomerServeRevisionFee,AccountManageRevisionFee,InteAmt,AccountManageFee,CustomerServeFee","3");
	 doTemp.setAlign("StampTax,PayInsuranceFee,OverDueAmt,AdvanceFee,PayOutSourceSum","3");
	 doTemp.setAlign("SeqID,PayDate","2");
	 doTemp.setCheckFormat("TotalAmt,ActualTotalAmt,PayprincipalAmt,PayprincipalRrevisionAmt,CustomerServeRevisionFee,AccountManageRevisionFee,InteAmt,,CustomerServeFee,AccountManageFee,PayOutSourceSum","2");
	 doTemp.setCheckFormat("StampTax,PayInsuranceFee,OverDueAmt,ActualOverDueAmt,AdvanceFee","2");
	 doTemp.setColumnType("TotalAmt,ActualTotalAmt,PayprincipalAmt,PayprincipalRrevisionAmt,InteAmt,AccountManageFee,CustomerServeFee,AccountManageRevisionFee,CustomerServeRevisionFee,StampTax,PayInsuranceFee,OverDueAmt,AdvanceFee,PayOutSourceSum","2");
	 doTemp.setHTMLStyle("PayDate","style={width:80px}");
	 doTemp.setHTMLStyle("SeqID","style={width:30px}");

	

	 ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	 dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	 dwTemp.ReadOnly = "0"; //设置为可写
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
		{"true","","Button","提交","提交申请","submitApp(2)",sResourcesPath},
		{"true","","Button","保 存","暂时保存申请","submitApp(1)",sResourcesPath},
		{"true","","Button","删 除","删 除保存申请","deleteApp(5)",sResourcesPath},
		{"true","","Button","预 览","预览","view()",sResourcesPath}
// 		{"true","","Button","导出Excel","导出Excel","exportAll()",sResourcesPath}
	
	};
	
	%> 
<%/*~END~*/%>
	
<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	function submitApp(type){
// 		if(getStatus()==2){
// 			alert("申请审批中，不能操作！");
// 			return;
// 		}
		var sContractSerialNo =  '<%=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo")) %>';
		var objectNo = '<%=loanSerialNo%>';
		var returnValue = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PayMentRevisionSchedule","validate","contractSerialNo="+sContractSerialNo+"");
		if(returnValue!="0"){
			alert(returnValue);
			reloadSelf();
			return;
		}
		if(!confirm("本金、财务管理费、客户服务费，如果新的数值不填，沿用原金额值,请确认是否提交")) return;
		if(validatePay()==false) return;
		var myobj=frames["myiframe0"];
		var trs = myobj.document.getElementsByTagName("table")[0].getElementsByTagName("tr");
		var userId = '<%=CurUser.getUserID() %>';
		var json ="userId="+userId+",submitType="+type+",objectNo="+objectNo+",contractSerialNo="+sContractSerialNo+",json=";
		var revisionSerialno ="" ;
		if(trs.length>0){
				for(var i=0;i<trs.length;i++){
					if(i==0 || i==1 || i==trs.length-1 || i==trs.length-2)continue;//分页控件一行
					var cells = trs[i].cells;
					var payid = cells[cells.length-4].innerText;
					var payValue = myobj.document.getElementById("pay"+i).value.replace(/,/g,"");//本金
					json += payid +":"+cells[6].innerText.replace(",","")+":"+payValue+"|";
				    var A2id = cells[cells.length-3].innerText;
				    var A2Value = myobj.document.getElementById("A2"+i).value.replace(/,/g,"");//客户服务费
				    json +=""+A2id+":"+cells[9].innerText.replace(",","")+":"+A2Value+"|";
				    var A7id = cells[cells.length-2].innerText;
				    var A7Value = myobj.document.getElementById("A7"+i).value.replace(/,/g,"");//财务管理费
				    json +=A7id+":"+cells[11].innerText.replace(",","")+":"+A7Value+"|";
				    revisionSerialno = cells[cells.length-1].innerText;
				}
			}
		 json = json.substring(0,json.length-1)
		 json +=",revisionSerialno="+revisionSerialno;
		 RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PayMentRevisionSchedule","onSubmitApp",json);
		 alert("操作成功！");
		 reloadSelf();
	}
	
	function deleteApp(){
		if(getStatus()==2){
			alert("申请审批中，不能操作！");
			return;
		}
		var myobj=frames["myiframe0"];
		var trs = myobj.document.getElementsByTagName("table")[0].getElementsByTagName("tr");
		var revisionSerialno ="" ;
		if(trs.length>0){
			for(var i=0;i<trs.length;i++){
				if(i==0 || i==1 || i==trs.length-1 || i==trs.length-2)continue;//分页控件一行
				var cells = trs[i].cells;
			    revisionSerialno = cells[cells.length-1].innerText;
			    revisionSerialno = Trim(revisionSerialno);
			    break;
			}
		}
		if(revisionSerialno==""){
			alert("没有要删除的申请！");
			return;
		}
		if(!confirm("请确认是否删除！")) return;
		RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PayMentRevisionSchedule","deleteApp","revisionSerialno="+revisionSerialno);
		 alert("删除成功！");
		 reloadSelf(); 
	}
	
	function view(){
		var myobj=frames["myiframe0"];
		var trs = myobj.document.getElementsByTagName("table")[0].getElementsByTagName("tr");
		var revisionSerialno ="" ;
		var contractSerialno = '<%=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"))%>';
		if(trs.length>0){
			for(var i=0;i<trs.length;i++){
				if(i==0 || i==1 || i==trs.length-1 || i==trs.length-2)continue;//分页控件一行
				var cells = trs[i].cells;
			    revisionSerialno = cells[cells.length-1].innerText;
			    revisionSerialno = Trim(revisionSerialno);
			    break;
			}
		}
		if(revisionSerialno==""){
			alert("没有要预览的申请！");
			return;
		}
		var sCompID = "CreditTab";
		var sCompURL = "/BusinessManage/QueryManage/PayMentRevisionScheduleView.jsp";
		var sParamString = "revisionSerialNo="+revisionSerialno+"&ObjectNo="+contractSerialno;
		openComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}
	
	function getStatus(){
		var myobj=frames["myiframe0"];
		var trs = myobj.document.getElementsByTagName("table")[0].getElementsByTagName("tr");
		if(trs.length>0){
			for(var i=0;i<trs.length;i++){
				if(i==0 || i==1 || i==trs.length-1 || i==trs.length-2)continue;//分页控件一行
				var cells = trs[i].cells;
				var status = cells[cells.length-5].innerText;
				return status;
			}
		}else{
			return 0;
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">
	//初始化表格，添加可个性的文本框
	function initMyRows(myiframe0)
	{
		var myobj=frames[myiframe0];
		var trs = myobj.document.getElementsByTagName("table")[0].getElementsByTagName("tr");
		var tbody = myobj.document.getElementsByTagName("table")[0].getElementsByTagName("tbody");
		tbody[0].setAttribute("onmousedown","");
		if(trs.length>0){
			for(var i=0;i<trs.length;i++){
				if(i==0)continue;//分页控件点了一行
				var cells = trs[i].cells;
				var dc = trs[i].cells[7].outerHTML;
				trs[i].cells[cells.length-5].style.display="none";
				trs[i].cells[cells.length-4].style.display="none";
				trs[i].cells[cells.length-3].style.display="none";
				trs[i].cells[cells.length-2].style.display="none";
				trs[i].cells[cells.length-1].style.display="none";
				if(i==1){//移除表头部点击事件
				  for(var j=0;j<trs[i].getElementsByTagName("th").length;j++){
				     trs[i].getElementsByTagName("th")[j].setAttribute("onclick","");
				  }
				 }else if(i==(trs.length-1) || i==(trs.length-2)){//小计总计
// 					  trs[i].deleteCell(7);//本金
// 					  trs[i].insertCell(7).innerHTML = "";
// 					  trs[i].deleteCell(10);//客户服务费
// 					  trs[i].insertCell(10).innerHTML = "11";
// 					  trs[i].deleteCell(12);//财务管理费
// 					  trs[i].insertCell(12).innerHTML = "";
				}else{
					  var pay = trs[i].cells[7].innerText;
					  pay = Trim(pay);
// 					  pay = amarMoney(pay,2);
			          if(Trim(cells[cells.length-1].innerText)==""){
			        	  pay=""; 
			          }
					  trs[i].deleteCell(7);//本金
					  trs[i].insertCell(7).innerHTML = "<input id='pay"+i+"' value='"+pay+"' type='text' style='border: 0px;text-align: right'  onbeforepaste='parent.myNumberBFP(this)' onblur='parent.myNumberBL(this);parent.getPayTotal(1);parent.getRealPay(this,1);'  onkeydown='parent.myNumberKD(this,event)' onfocus='parent.myNumberFC(this)' onkeypress='parent.myNumberKP(this,event)' onkeyup='javascript:parent.getMonthPayment()'  maxLength='24' size='12'/>";
					  var a2 = trs[i].cells[10].innerText;
					  a2 = Trim(a2);
					  if(Trim(cells[cells.length-1].innerText)==""){
						  a2=""; 
			          }
// 					  a2 = amarMoney(a2,2);
					  trs[i].deleteCell(10);//客户服务费
					  trs[i].insertCell(10).innerHTML = "<input id='A2"+i+"' value='"+a2+"' type='text' style='border: 0px;text-align: right' onbeforepaste='parent.myNumberBFP(this)' onblur='parent.myNumberBL(this);parent.getPayTotal(2);parent.getRealPay(this,2)'  onkeydown='parent.myNumberKD(this,event)' onfocus='parent.myNumberFC(this)' onkeypress='parent.myNumberKP(this,event)' onkeyup='javascript:parent.getMonthPayment()'  maxLength='24' size='12' />";
					  var a7 = trs[i].cells[12].innerText;
					  a7 = Trim(a7);
					  if(Trim(cells[cells.length-1].innerText)==""){
						  a7=""; 
			          }
// 					  a7 = amarMoney(a7,2);
					  trs[i].deleteCell(12);//财务管理费
					  trs[i].insertCell(12).innerHTML = "<input id='A7"+i+"' value='"+a7+"' type='text' style='border: 0px;text-align: right'  onbeforepaste='parent.myNumberBFP(this)' onblur='parent.myNumberBL(this);parent.getPayTotal(3);parent.getRealPay(this,3)'  onkeydown='parent.myNumberKD(this,event)' onfocus='parent.myNumberFC(this)' onkeypress='parent.myNumberKP(this,event)' onkeyup='javascript:parent.getMonthPayment()'  maxLength='24' size='12' />";
				}
			}
		}
	 }
	
	//去掉字串两头的空格
	function Trim(string){
		return string.replace(/( +)$/g,"").replace(/^( +)/g,"");
	}
	//总金额验证
	function validatePay(){
		var myobj=frames["myiframe0"];
		var trs = myobj.document.getElementsByTagName("table")[0].getElementsByTagName("tr");
		var total =0;
		if(trs.length>0){
			for(var i=0;i<trs.length;i++){
				if(i==0 || i==1)continue;//分页控件一行
				if(i!=(trs.length-1) && i!=(trs.length-2)){
					var payValue = myobj.document.getElementById("pay"+i).value.replace(/,/g,"");//本金
					if(payValue==""|| Trim(payValue)==""){
						myobj.document.getElementById("pay"+i).value = Trim(trs[i].cells[6].innerText.replace(/,/g,""));
						payValue =Trim(trs[i].cells[6].innerText.replace(/,/g,""));
					}
					var feeA2 = myobj.document.getElementById("A2"+i).value.replace(/,/g,"");//客户服务费
					if(feeA2==""|| Trim(feeA2)==""){
						myobj.document.getElementById("A2"+i).value = Trim(trs[i].cells[9].innerText.replace(/,/g,""));
						feeA2 =Trim(trs[i].cells[9].innerText.replace(/,/g,""));
					}
					var feeA7 =  myobj.document.getElementById("A7"+i).value.replace(/,/g,"");//客户服务费
					if(feeA7==""|| Trim(feeA7)==""){
						myobj.document.getElementById("A7"+i).value = Trim(trs[i].cells[11].innerText.replace(/,/g,""));
						feeA7 =Trim(trs[i].cells[11].innerText.replace(/,/g,""));
					}
					if(Number(Trim(payValue))<0){
						alert("本金不能为负数！")
						return false;
					}
					if(FormatNumber(Trim(payValue),99,2)==false){
						alert("本金只能为两位小数！");
						return false;
					}
					if(Number(Trim(feeA2))<0){
						alert("客户服务费不能为负数！")
						return false;
					}
					if(FormatNumber(Trim(feeA2),99,2)==false){
						alert("每月的客户服务费只能为两位小数！");
						return false;
					}
					if(Number(Trim(feeA2))>Number(Trim(trs[i].cells[9].innerText.replace(/,/g,"")))){
						alert("每月的客户服务费只能调小！")
						return false;
					}
					if(Number(Trim(feeA7))<0){
						alert("客户服务费不能为负数！")
						return false;
					}
					if(FormatNumber(Trim(feeA7),99,2)==false){
						alert("每月财务管理费只能为两位小数！");
						return false;
					}
					if(Number(Trim(feeA7))>Number(Trim(trs[i].cells[11].innerText.replace(/,/g,"")))){
						alert("每月财务管理费只能调小！")
						return false;
					}
					total = add(total,payValue);
				}
			}
		var totalo= trs[trs.length-1].cells[6].innerText.replace(/,/g,"");
// 		alert("totalo"+totalo+":total"+total.toFixed(2));
		if(Trim(totalo)!=total.toFixed(2)){
			alert("修改后的“修改后本金总金额”必须等于“原本金总金额”");
			return false;
		}
		}else{
			return false;
		}
	}
	
	function getPayTotal(type){
		var myobj=frames["myiframe0"];
		var trs = myobj.document.getElementsByTagName("table")[0].getElementsByTagName("tr");
		var total =0;
		if(trs.length>0){
			for(var i=0;i<trs.length;i++){
				if(i==0 || i==1)continue;//分页控件一行
				if(i!=(trs.length-1) && i!=(trs.length-2)){
					if(type==1){
						var payValue = myobj.document.getElementById("pay"+i).value.replace(/,/g,"");//本金
					}else if(type==2){
						var payValue = myobj.document.getElementById("A2"+i).value.replace(/,/g,"");//
					}else if(type==3){
						var payValue = myobj.document.getElementById("A7"+i).value.replace(/,/g,"");//
					}
					total = add(total,payValue);
				}
			}
			if(type==1){
				trs[trs.length-1].cells[7].innerText = total.toFixed(2);
				trs[trs.length-2].cells[7].innerText = total.toFixed(2);
			}else if(type==2){
				trs[trs.length-1].cells[10].innerText = total.toFixed(2);
				trs[trs.length-2].cells[10].innerText = total.toFixed(2);
			}else if(type==3){
				trs[trs.length-1].cells[12].innerText = total.toFixed(2);
				trs[trs.length-2].cells[12].innerText = total.toFixed(2);
			}
			
		}
	}
	
	function getRealPay(obj,type){
		var cells = obj.parentNode.parentNode.cells;
		var realPay = 0;
// 		var t =cells[4].innerText.replace(/,/g,"");
// 		realPay = add(realPay,Trim(t));
// 		alert(pay);
		var pay1 = cells[6].innerText.replace(/,/g,"");
		var pay2 = cells[7].getElementsByTagName("input")[0].value.replace(/,/g,"");
		
		if(Trim(pay2) !="" && add(Trim(pay2),0)>=0){
			realPay = add(realPay,Trim(pay2));
		}else{
			realPay = add(realPay,Trim(pay1));
		}
		
		var l = cells[8].innerText.replace(/,/g,"");//利息
		realPay = add(realPay,Trim(l));
		var a21 = cells[9].innerText.replace(/,/g,"");
		var a22 = cells[10].getElementsByTagName("input")[0].value.replace(/,/g,"");
		if(Trim(a22) !="" && add(Trim(a22),0)>=0){
			realPay = add(realPay,Trim(a22));
		}else{
			realPay = add(realPay,Trim(a21));
		}
		var a71 = cells[11].innerText.replace(/,/g,"");
		var a72 = cells[12].getElementsByTagName("input")[0].value.replace(/,/g,"");
		if(Trim(a72) !="" && add(Trim(a72),0)>=0){
			realPay = add(realPay,Trim(a72));
		}else{
			realPay = add(realPay,Trim(a71));
		}
		var a9 = cells[13].innerText.replace(/,/g,"");
		realPay= add(realPay,Trim(a9));
		var a10 = cells[14].innerText.replace(/,/g,"");
		realPay= add(realPay,Trim(a10));
		var a11 = cells[15].innerText.replace(/,/g,"");
		realPay= add(realPay,Trim(a11));
		var a12 = cells[16].innerText.replace(/,/g,"");
		realPay= add(realPay,Trim(a12));
		obj.parentNode.parentNode.cells[4].innerText = realPay.toFixed(2);
		
		var myobj=frames["myiframe0"];
		var trs = myobj.document.getElementsByTagName("table")[0].getElementsByTagName("tr");
		var total =0;
		if(trs.length>0){
			for(var i=0;i<trs.length;i++){
				if(i==0 || i==1)continue;//分页控件一行
				if(i!=(trs.length-1) && i!=(trs.length-2)){
					var payValue = trs[i].cells[4].innerText.replace(/,/g,"");
					total = add(total,Trim(payValue));
				}
			}
			trs[trs.length-1].cells[4].innerText = total.toFixed(2);
			trs[trs.length-2].cells[4].innerText = total.toFixed(2);
		}
	}
	function add(arg1,arg2){
		var r1,r2,m; 
	    try{r1=arg1.toString().split(".")[1].length}catch(e){r1=0} 
	    try{r2=arg2.toString().split(".")[1].length}catch(e){r2=0} 
	    m=Math.pow(10,Math.max(r1,r2)) 
	    return (arg1*m+arg2*m)/m 
	}
	//减法函数，用来得到精确的减法结果
    function Subtr(arg1, arg2) {
        var r1, r2, m, n;
        try { r1 = arg1.toString().split(".")[1].length } catch (e) { r1 = 0 }
        try { r2 = arg2.toString().split(".")[1].length } catch (e) { r2 = 0 }
        m = Math.pow(10, Math.max(r1, r2));
        //last modify by deeka
        //动态控制精度长度
        n = (r1 >= r2) ? r1 : r2;
        return ((arg1 * m - arg2 * m) / m).toFixed(n);
    }
	</script>
	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load_show(2,0,'myiframe0');
	initMyRows('myiframe0');
// 	getSerialNum();
	//initRow(); //页面装载时，对DW当前记录进行初始化
</script>		
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
