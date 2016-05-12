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
	String PG_TITLE = "����ƻ�����Ԥ��"; // ��������ڱ��� <title> PG_TITLE </title>
	//����������
	String revisionSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("revisionSerialNo"));
    String sContractSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
    if(sContractSerialNo == null ) sContractSerialNo = "";
    if(revisionSerialNo == null ) revisionSerialNo = "";

	String loanSerialNo = Sqlca.getString(new SqlObject("select serialno from acct_loan where putoutno =:ObjectNo").setParameter("ObjectNo", sContractSerialNo));
 	
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
								{"PayprincipalRrevisionAmt","�޸ĺ󱾽���(Ԫ)"},
								{"InteAmt","��Ϣ���(Ԫ)"},
								{"CustomerServeFee","ԭ�ͻ������(Ԫ)"},
								{"CustomerServeRevisionFee","�޸ĺ�ͻ������(Ԫ)"},
								{"AccountManageFee","ԭ��������(Ԫ)"},
								{"AccountManageRevisionFee","�޸ĺ��������(Ԫ)"},
								{"StampTax","ӡ��˰(Ԫ)"},
								{"PayInsuranceFee","��ֵ�����(Ԫ)"},
								{"OverDueAmt","���ɽ�(Ԫ)"},
								{"AdvanceFee","��ǰ����������(Ԫ)"},
								{"Payserialno","����ID"},
								{"A2serialno","�ͻ������ id"},
								{"A7serialno","��������id"},
								{"revisionSerialno","��������id"}
							}; 

		 String sSql ="SELECT aps.seqid as SeqID,aps.paydate as PayDate, af.segfromdate as segfromdate, "
				 +"sum(case when r.payprincipal_revision_amt is null then nvl(aps.payprincipalamt,0) else r.payprincipal_revision_amt end +nvl(aps.payinteamt,0)) as TotalAmt, " //--Ӧ���ܽ�� 
				 +"sum(nvl(aps.actualpayprincipalamt,0)+nvl(aps.actualpayinteamt,0)) as ActualTotalAmt, " //--ʵ���ܽ��
				 +"sum(case when aps.paytype='1' then nvl(r.payprincipal_amt,0) else 0 end) as PayprincipalAmt, "//--ԭ������(Ԫ)
				 +"sum(case when r.paytype='1' then nvl(r.payprincipal_revision_amt,0) else 0 end) as PayprincipalRrevisionAmt, "//--���� ���(Ԫ)
				 +"sum(case when aps.paytype='1' then nvl(aps.payinteamt,0) else 0 end) as InteAmt, "//--��Ϣ���(Ԫ)
				 +"sum(case when aps.paytype='A2' then nvl(r.payprincipal_amt,0) else 0 end) as CustomerServeFee, "//--ԭӦ���ͻ������
				 +"SUM(case when r.paytype='A2' then nvl(r.payprincipal_revision_amt,0) else 0 end) as CustomerServeRevisionFee, "// --������Ŀͻ������ 
				 +"sum(case when aps.paytype='A7' then nvl(r.payprincipal_amt,0) else 0 end) as AccountManageFee, "// --ԭӦ����������
				 +"SUM(case when r.paytype='A7' then nvl(r.payprincipal_revision_amt,0) else 0 end) as AccountManageRevisionFee, "// --������Ĳ�������
				 +"sum(case when aps.paytype='A11' then nvl(aps.payprincipalamt,0) else 0 end) as StampTax, "// --ӡ��˰
				 +"sum(case when aps.paytype='A10' then nvl(aps.payprincipalamt,0) else 0 end) as OverDueAmt, "// --���ɽ�
				 +"sum(case when aps.paytype='A9' then nvl(aps.payprincipalamt,0) else 0 end) as AdvanceFee, "// --Ӧ����ǰ����������
				 +"sum(case when aps.paytype='A12' then nvl(aps.payprincipalamt,0) else 0 end) as PayInsuranceFee, "//--��ֵ�����
				 +"max(case when aps.paytype='1' then aps.serialno  end) as Payserialno, "//--����ID
				 +"max(case when aps.paytype='A2' then aps.serialno end) as A2serialno, "//--�ͻ������ id
				 +"max(case when aps.paytype='A7' then aps.serialno  end) as A7serialno, "//--��������id
				 +"max(r.revision_serialno) as revisionSerialno "//--��������ID
				 +" from acct_payment_schedule aps "//
				 +"left join (select aprd.revision_serialno,aprd.payment_schedule_serialno, aprd.payprincipal_revision_amt,aprd.payprincipal_amt,aprd.payType"// 
						+" from ACCT_PAYMENT_REVERSION apr,ACCT_PAYMENT_REVERSION_DETAIL aprd " 
				 +"where apr.serialno = aprd.revision_serialno and apr.serialno = '"+revisionSerialNo+"')  r   on r.payment_schedule_serialno = aps.serialno  "//
				 +"left join acct_fee af on aps.objectno=af.serialno and af.feetype='A10'  "//
				 +  "where (aps.objectno='"+loanSerialNo+"' and aps.objecttype='jbo.app.ACCT_LOAN') or (aps.relativeobjectno='"+loanSerialNo+"' and aps.relativeobjecttype='jbo.app.ACCT_LOAN') "// �����Ľ��
				 +  "group by SeqID,aps.PayDate,segfromdate order by SeqID,aps.PayDate ";

	 //����DataObject				
	 ASDataObject doTemp = new ASDataObject(sSql);
	 
	 doTemp.setCheckFormat("PayDate","3");
	 doTemp.setHeader(sHeaders);
	 doTemp.setVisible("Payserialno,A2serialno,A7serialno,revisionSerialno", false);//�������ɼ�
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
	 dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	 dwTemp.ReadOnly = "1"; //����Ϊ��д
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
		{"false","","Button","�ύ","�ύ����","submitApp(2)",sResourcesPath},
		{"false","","Button","�� ��","��ʱ��������","submitApp(1)",sResourcesPath},
		{"false","","Button","����Excel","����Excel","exportAll()",sResourcesPath}
	
	};
	
	%> 
<%/*~END~*/%>
	
<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">
	function initMyRows(myiframe0){
		var myobj=frames[myiframe0];
		var trs = myobj.document.getElementsByTagName("table")[0].getElementsByTagName("tr");
		var tbody = myobj.document.getElementsByTagName("table")[0].getElementsByTagName("tbody");
		tbody[0].setAttribute("onmousedown","");
		if(trs.length>0){
			for(var i=0;i<trs.length;i++){
				if(i==0)continue;//��ҳ�ؼ�����һ��
				var cells = trs[i].cells;
				if(i==1){//�Ƴ���ͷ������¼�
				  for(var j=0;j<trs[i].getElementsByTagName("th").length;j++){
				     trs[i].getElementsByTagName("th")[j].setAttribute("onclick","");
				  }
				 }else if(i==(trs.length-1) || i==(trs.length-2)){//С���ܼ�
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
	
	//ȥ���ִ���ͷ�Ŀո�
	function Trim(string){
		return string.replace(/( +)$/g,"").replace(/^( +)/g,"");
	}
	</script>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load_show(2,0,'myiframe0');
	initMyRows('myiframe0');
	//initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>		
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
