<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Describe: ����ƻ�����ҳ��
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ƻ�����"; // ��������ڱ��� <title> PG_TITLE </title>
	//����������
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

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
		/*
			Describe: ����ƻ�����ҳ��
			��ҳ����������⴦���޸ĵ�ʱ���벻Ҫ���Ķ�sHeaders��˳��
			ȷ��PayprincipalAmt�ڵ�6�У�PayprincipalRrevisionAmt�ڵ�7��
			CustomerServeFee�ڵ�9�У�CustomerServeRevisionFee�ڵ�10��
			AccountManageFee�ڵ�11�У�AccountManageRevisionFee�ڵ�12�С�
			����Ϊ�������ݡ�
		    {"status","��ͬ״̬"},
			{"Payserialno","����ID"},
			{"A2serialno","�ͻ������ id"},
			{"A7serialno","��������id"},
			{"revisionSerialno","��������id"}
		 */
		%>
	<%
		String sHeaders[][] = { 
								{"SeqID","�ڴ�"},
								{"PayDate","Ӧ������"},
								{"segfromdate","���ɽ𴴽�����"},
								{"TotalAmt","Ӧ���ڿ��ܽ��(Ԫ)"},
								{"ActualTotalAmt","ʵ���ܽ��"},
								{"PayprincipalAmt","ԭ������(Ԫ)"},
								{"PayprincipalRrevisionAmt","������(Ԫ)"},
								{"InteAmt","��Ϣ���(Ԫ)"},
								{"CustomerServeFee","ԭ�ͻ������(Ԫ)"},
								{"CustomerServeRevisionFee","�ͻ������(Ԫ)"},
								{"AccountManageFee","ԭ��������(Ԫ)"},
								{"AccountManageRevisionFee","��������(Ԫ)"},
								{"StampTax","ӡ��˰(Ԫ)"},
								{"PayInsuranceFee","��ֵ�����(Ԫ)"},
								{"OverDueAmt","���ɽ�(Ԫ)"},
								{"AdvanceFee","��ǰ����������(Ԫ)"},
								{"status","��ͬ״̬"},
								{"Payserialno","����ID"},
								{"A2serialno","�ͻ������ id"},
								{"A7serialno","��������id"},
								{"revisionSerialno","��������id"}
							}; 

		 String sSql ="SELECT aps.seqid as SeqID,aps.paydate as PayDate, af.segfromdate as segfromdate, "
				 +"sum(case when r.payprincipal_revision_amt is null then nvl(aps.payprincipalamt,0) else r.payprincipal_revision_amt end +nvl(aps.payinteamt,0)) as TotalAmt, " //--Ӧ���ܽ�� 
				 +"sum(nvl(aps.actualpayprincipalamt,0)+nvl(aps.actualpayinteamt,0)) as ActualTotalAmt, " //--ʵ���ܽ��
				 +"sum(case when aps.paytype='1' then nvl(aps.payprincipalamt,0) else 0 end) as PayprincipalAmt, "//--ԭ������(Ԫ)
				 +"sum(case when r.paytype='1' then nvl(r.payprincipal_revision_amt,0) else 0 end) as PayprincipalRrevisionAmt, "//--���� ���(Ԫ)
				 +"sum(case when aps.paytype='1' then nvl(aps.payinteamt,0) else 0 end) as InteAmt, "//--��Ϣ���(Ԫ)
				 +"sum(case when aps.paytype='A2' then nvl(aps.payprincipalamt,0) else 0 end) as CustomerServeFee, "//--ԭӦ���ͻ������
				 +"SUM(case when r.paytype='A2' then nvl(r.payprincipal_revision_amt,0) else 0 end) as CustomerServeRevisionFee, "// --������Ŀͻ������ 
				 +"sum(case when aps.paytype='A7' then nvl(aps.payprincipalamt,0) else 0 end) as AccountManageFee, "// --ԭӦ����������
				 +"SUM(case when r.paytype='A7' then nvl(r.payprincipal_revision_amt,0) else 0 end) as AccountManageRevisionFee, "// --������Ĳ�������
				 +"sum(case when aps.paytype='A11' then nvl(aps.payprincipalamt,0) else 0 end) as StampTax, "// --ӡ��˰
				 +"sum(case when aps.paytype='A10' then nvl(aps.payprincipalamt,0) else 0 end) as OverDueAmt, "// --���ɽ�
				 +"sum(case when aps.paytype='A9' then nvl(aps.payprincipalamt,0) else 0 end) as AdvanceFee, "// --Ӧ����ǰ����������
				 +"sum(case when aps.paytype='A12' then nvl(aps.payprincipalamt,0) else 0 end) as PayInsuranceFee, "//--��ֵ�����
				 +"max(r.status) as status, "
				 +"max(case when aps.paytype='1' then aps.serialno  end) as Payserialno, "//--����ID
				 +"max(case when aps.paytype='A2' then aps.serialno end) as A2serialno, "//--�ͻ������ id
				 +"max(case when aps.paytype='A7' then aps.serialno  end) as A7serialno, "//--��������id
				 +"max(r.revision_serialno) as revisionSerialno "//--��������ID
				 +" from acct_payment_schedule aps "//
				 +"left join (select aprd.revision_serialno,aprd.payment_schedule_serialno, aprd.payprincipal_revision_amt,aprd.payType,apr.status "// 
						+" from ACCT_PAYMENT_REVERSION apr,ACCT_PAYMENT_REVERSION_DETAIL aprd " 
				 +"where apr.serialno = (select max(SERIALNO) from ACCT_PAYMENT_REVERSION where  status in('1','2')  and CONTRACT_SERIALNO ='"+sContractSerialNo+"' )  and apr.serialno=aprd.revision_serialno )  r   on r.payment_schedule_serialno = aps.serialno  "//
				 +"left join acct_fee af on aps.objectno=af.serialno and af.feetype='A10'  "//
				 +  "where (aps.objectno='"+loanSerialNo+"' and aps.objecttype='jbo.app.ACCT_LOAN') or (aps.relativeobjectno='"+loanSerialNo+"' and aps.relativeobjecttype='jbo.app.ACCT_LOAN') "// �����Ľ��
				 +  "group by SeqID,aps.PayDate,segfromdate order by SeqID,aps.PayDate ";

	 //����DataObject				
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
	 dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	 dwTemp.ReadOnly = "0"; //����Ϊ��д
	 dwTemp.ShowSummary = "1";//���û���
	//����datawindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
		String sButtons[][] = {
		{"true","","Button","�ύ","�ύ����","submitApp(2)",sResourcesPath},
		{"true","","Button","�� ��","��ʱ��������","submitApp(1)",sResourcesPath},
		{"true","","Button","ɾ ��","ɾ ����������","deleteApp(5)",sResourcesPath},
		{"true","","Button","Ԥ ��","Ԥ��","view()",sResourcesPath}
// 		{"true","","Button","����Excel","����Excel","exportAll()",sResourcesPath}
	
	};
	
	%> 
<%/*~END~*/%>
	
<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	function submitApp(type){
// 		if(getStatus()==2){
// 			alert("���������У����ܲ�����");
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
		if(!confirm("���𡢲������ѡ��ͻ�����ѣ�����µ���ֵ�������ԭ���ֵ,��ȷ���Ƿ��ύ")) return;
		if(validatePay()==false) return;
		var myobj=frames["myiframe0"];
		var trs = myobj.document.getElementsByTagName("table")[0].getElementsByTagName("tr");
		var userId = '<%=CurUser.getUserID() %>';
		var json ="userId="+userId+",submitType="+type+",objectNo="+objectNo+",contractSerialNo="+sContractSerialNo+",json=";
		var revisionSerialno ="" ;
		if(trs.length>0){
				for(var i=0;i<trs.length;i++){
					if(i==0 || i==1 || i==trs.length-1 || i==trs.length-2)continue;//��ҳ�ؼ�һ��
					var cells = trs[i].cells;
					var payid = cells[cells.length-4].innerText;
					var payValue = myobj.document.getElementById("pay"+i).value.replace(/,/g,"");//����
					json += payid +":"+cells[6].innerText.replace(",","")+":"+payValue+"|";
				    var A2id = cells[cells.length-3].innerText;
				    var A2Value = myobj.document.getElementById("A2"+i).value.replace(/,/g,"");//�ͻ������
				    json +=""+A2id+":"+cells[9].innerText.replace(",","")+":"+A2Value+"|";
				    var A7id = cells[cells.length-2].innerText;
				    var A7Value = myobj.document.getElementById("A7"+i).value.replace(/,/g,"");//��������
				    json +=A7id+":"+cells[11].innerText.replace(",","")+":"+A7Value+"|";
				    revisionSerialno = cells[cells.length-1].innerText;
				}
			}
		 json = json.substring(0,json.length-1)
		 json +=",revisionSerialno="+revisionSerialno;
		 RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PayMentRevisionSchedule","onSubmitApp",json);
		 alert("�����ɹ���");
		 reloadSelf();
	}
	
	function deleteApp(){
		if(getStatus()==2){
			alert("���������У����ܲ�����");
			return;
		}
		var myobj=frames["myiframe0"];
		var trs = myobj.document.getElementsByTagName("table")[0].getElementsByTagName("tr");
		var revisionSerialno ="" ;
		if(trs.length>0){
			for(var i=0;i<trs.length;i++){
				if(i==0 || i==1 || i==trs.length-1 || i==trs.length-2)continue;//��ҳ�ؼ�һ��
				var cells = trs[i].cells;
			    revisionSerialno = cells[cells.length-1].innerText;
			    revisionSerialno = Trim(revisionSerialno);
			    break;
			}
		}
		if(revisionSerialno==""){
			alert("û��Ҫɾ�������룡");
			return;
		}
		if(!confirm("��ȷ���Ƿ�ɾ����")) return;
		RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PayMentRevisionSchedule","deleteApp","revisionSerialno="+revisionSerialno);
		 alert("ɾ���ɹ���");
		 reloadSelf(); 
	}
	
	function view(){
		var myobj=frames["myiframe0"];
		var trs = myobj.document.getElementsByTagName("table")[0].getElementsByTagName("tr");
		var revisionSerialno ="" ;
		var contractSerialno = '<%=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"))%>';
		if(trs.length>0){
			for(var i=0;i<trs.length;i++){
				if(i==0 || i==1 || i==trs.length-1 || i==trs.length-2)continue;//��ҳ�ؼ�һ��
				var cells = trs[i].cells;
			    revisionSerialno = cells[cells.length-1].innerText;
			    revisionSerialno = Trim(revisionSerialno);
			    break;
			}
		}
		if(revisionSerialno==""){
			alert("û��ҪԤ�������룡");
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
				if(i==0 || i==1 || i==trs.length-1 || i==trs.length-2)continue;//��ҳ�ؼ�һ��
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


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">
	//��ʼ�������ӿɸ��Ե��ı���
	function initMyRows(myiframe0)
	{
		var myobj=frames[myiframe0];
		var trs = myobj.document.getElementsByTagName("table")[0].getElementsByTagName("tr");
		var tbody = myobj.document.getElementsByTagName("table")[0].getElementsByTagName("tbody");
		tbody[0].setAttribute("onmousedown","");
		if(trs.length>0){
			for(var i=0;i<trs.length;i++){
				if(i==0)continue;//��ҳ�ؼ�����һ��
				var cells = trs[i].cells;
				var dc = trs[i].cells[7].outerHTML;
				trs[i].cells[cells.length-5].style.display="none";
				trs[i].cells[cells.length-4].style.display="none";
				trs[i].cells[cells.length-3].style.display="none";
				trs[i].cells[cells.length-2].style.display="none";
				trs[i].cells[cells.length-1].style.display="none";
				if(i==1){//�Ƴ���ͷ������¼�
				  for(var j=0;j<trs[i].getElementsByTagName("th").length;j++){
				     trs[i].getElementsByTagName("th")[j].setAttribute("onclick","");
				  }
				 }else if(i==(trs.length-1) || i==(trs.length-2)){//С���ܼ�
// 					  trs[i].deleteCell(7);//����
// 					  trs[i].insertCell(7).innerHTML = "";
// 					  trs[i].deleteCell(10);//�ͻ������
// 					  trs[i].insertCell(10).innerHTML = "11";
// 					  trs[i].deleteCell(12);//��������
// 					  trs[i].insertCell(12).innerHTML = "";
				}else{
					  var pay = trs[i].cells[7].innerText;
					  pay = Trim(pay);
// 					  pay = amarMoney(pay,2);
			          if(Trim(cells[cells.length-1].innerText)==""){
			        	  pay=""; 
			          }
					  trs[i].deleteCell(7);//����
					  trs[i].insertCell(7).innerHTML = "<input id='pay"+i+"' value='"+pay+"' type='text' style='border: 0px;text-align: right'  onbeforepaste='parent.myNumberBFP(this)' onblur='parent.myNumberBL(this);parent.getPayTotal(1);parent.getRealPay(this,1);'  onkeydown='parent.myNumberKD(this,event)' onfocus='parent.myNumberFC(this)' onkeypress='parent.myNumberKP(this,event)' onkeyup='javascript:parent.getMonthPayment()'  maxLength='24' size='12'/>";
					  var a2 = trs[i].cells[10].innerText;
					  a2 = Trim(a2);
					  if(Trim(cells[cells.length-1].innerText)==""){
						  a2=""; 
			          }
// 					  a2 = amarMoney(a2,2);
					  trs[i].deleteCell(10);//�ͻ������
					  trs[i].insertCell(10).innerHTML = "<input id='A2"+i+"' value='"+a2+"' type='text' style='border: 0px;text-align: right' onbeforepaste='parent.myNumberBFP(this)' onblur='parent.myNumberBL(this);parent.getPayTotal(2);parent.getRealPay(this,2)'  onkeydown='parent.myNumberKD(this,event)' onfocus='parent.myNumberFC(this)' onkeypress='parent.myNumberKP(this,event)' onkeyup='javascript:parent.getMonthPayment()'  maxLength='24' size='12' />";
					  var a7 = trs[i].cells[12].innerText;
					  a7 = Trim(a7);
					  if(Trim(cells[cells.length-1].innerText)==""){
						  a7=""; 
			          }
// 					  a7 = amarMoney(a7,2);
					  trs[i].deleteCell(12);//��������
					  trs[i].insertCell(12).innerHTML = "<input id='A7"+i+"' value='"+a7+"' type='text' style='border: 0px;text-align: right'  onbeforepaste='parent.myNumberBFP(this)' onblur='parent.myNumberBL(this);parent.getPayTotal(3);parent.getRealPay(this,3)'  onkeydown='parent.myNumberKD(this,event)' onfocus='parent.myNumberFC(this)' onkeypress='parent.myNumberKP(this,event)' onkeyup='javascript:parent.getMonthPayment()'  maxLength='24' size='12' />";
				}
			}
		}
	 }
	
	//ȥ���ִ���ͷ�Ŀո�
	function Trim(string){
		return string.replace(/( +)$/g,"").replace(/^( +)/g,"");
	}
	//�ܽ����֤
	function validatePay(){
		var myobj=frames["myiframe0"];
		var trs = myobj.document.getElementsByTagName("table")[0].getElementsByTagName("tr");
		var total =0;
		if(trs.length>0){
			for(var i=0;i<trs.length;i++){
				if(i==0 || i==1)continue;//��ҳ�ؼ�һ��
				if(i!=(trs.length-1) && i!=(trs.length-2)){
					var payValue = myobj.document.getElementById("pay"+i).value.replace(/,/g,"");//����
					if(payValue==""|| Trim(payValue)==""){
						myobj.document.getElementById("pay"+i).value = Trim(trs[i].cells[6].innerText.replace(/,/g,""));
						payValue =Trim(trs[i].cells[6].innerText.replace(/,/g,""));
					}
					var feeA2 = myobj.document.getElementById("A2"+i).value.replace(/,/g,"");//�ͻ������
					if(feeA2==""|| Trim(feeA2)==""){
						myobj.document.getElementById("A2"+i).value = Trim(trs[i].cells[9].innerText.replace(/,/g,""));
						feeA2 =Trim(trs[i].cells[9].innerText.replace(/,/g,""));
					}
					var feeA7 =  myobj.document.getElementById("A7"+i).value.replace(/,/g,"");//�ͻ������
					if(feeA7==""|| Trim(feeA7)==""){
						myobj.document.getElementById("A7"+i).value = Trim(trs[i].cells[11].innerText.replace(/,/g,""));
						feeA7 =Trim(trs[i].cells[11].innerText.replace(/,/g,""));
					}
					if(Number(Trim(payValue))<0){
						alert("������Ϊ������")
						return false;
					}
					if(FormatNumber(Trim(payValue),99,2)==false){
						alert("����ֻ��Ϊ��λС����");
						return false;
					}
					if(Number(Trim(feeA2))<0){
						alert("�ͻ�����Ѳ���Ϊ������")
						return false;
					}
					if(FormatNumber(Trim(feeA2),99,2)==false){
						alert("ÿ�µĿͻ������ֻ��Ϊ��λС����");
						return false;
					}
					if(Number(Trim(feeA2))>Number(Trim(trs[i].cells[9].innerText.replace(/,/g,"")))){
						alert("ÿ�µĿͻ������ֻ�ܵ�С��")
						return false;
					}
					if(Number(Trim(feeA7))<0){
						alert("�ͻ�����Ѳ���Ϊ������")
						return false;
					}
					if(FormatNumber(Trim(feeA7),99,2)==false){
						alert("ÿ�²�������ֻ��Ϊ��λС����");
						return false;
					}
					if(Number(Trim(feeA7))>Number(Trim(trs[i].cells[11].innerText.replace(/,/g,"")))){
						alert("ÿ�²�������ֻ�ܵ�С��")
						return false;
					}
					total = add(total,payValue);
				}
			}
		var totalo= trs[trs.length-1].cells[6].innerText.replace(/,/g,"");
// 		alert("totalo"+totalo+":total"+total.toFixed(2));
		if(Trim(totalo)!=total.toFixed(2)){
			alert("�޸ĺ�ġ��޸ĺ󱾽��ܽ�������ڡ�ԭ�����ܽ�");
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
				if(i==0 || i==1)continue;//��ҳ�ؼ�һ��
				if(i!=(trs.length-1) && i!=(trs.length-2)){
					if(type==1){
						var payValue = myobj.document.getElementById("pay"+i).value.replace(/,/g,"");//����
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
		
		var l = cells[8].innerText.replace(/,/g,"");//��Ϣ
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
				if(i==0 || i==1)continue;//��ҳ�ؼ�һ��
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
	//���������������õ���ȷ�ļ������
    function Subtr(arg1, arg2) {
        var r1, r2, m, n;
        try { r1 = arg1.toString().split(".")[1].length } catch (e) { r1 = 0 }
        try { r2 = arg2.toString().split(".")[1].length } catch (e) { r2 = 0 }
        m = Math.pow(10, Math.max(r1, r2));
        //last modify by deeka
        //��̬���ƾ��ȳ���
        n = (r1 >= r2) ? r1 : r2;
        return ((arg1 * m - arg2 * m) / m).toFixed(n);
    }
	</script>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load_show(2,0,'myiframe0');
	initMyRows('myiframe0');
// 	getSerialNum();
	//initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>		
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
