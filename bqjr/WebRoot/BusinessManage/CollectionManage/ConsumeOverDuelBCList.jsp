<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "�����������ں�ͬ�б����";
	//���ҳ�����
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	
	if(sCustomerID==null) sCustomerID="";
	

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ConsumeOverDuelContractList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setHTMLStyle("CUSTOMERID", "style={width:80px}");
	doTemp.setHTMLStyle("CustomerName","style={width:100px} ");  
	doTemp.setHTMLStyle("BusinessSum","style={width:80px} ");  
	doTemp.setHTMLStyle("PayinteAmt","style={width:80px} ");  
	doTemp.setHTMLStyle("BUSINESSNAME","style={width:100px} ");  
	doTemp.setHTMLStyle("company","style={width:100px} ");  
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		  {"true","","Button","��ͬ����","��ͬ����","contractDetail()",sResourcesPath},
		  {"false","","Button","��������","��������","yanDate()",sResourcesPath},
		  {"false","","Button","�ٴδ���","�ٴδ���","BatchLasCore()",sResourcesPath}
	};
	
	
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	//�ٴδ���
	function BatchLasCore(){
		var sPayinteAmt = getItemValue(0,getRow(),"PayinteAmt");//�������
		var sPutoutNo = getItemValue(0,getRow(),"PutoutNo");//��ͬ��
		var sSerialNo = getSerialNo("Batch_las_core","SerialNo","");//������ˮ��
		var myDate = "<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>";//��ȡ����
		
		if (typeof(sPutoutNo)=="undefined" || sPutoutNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("��ȷ��Ҫ���������")){
			//��ѯ�ñʺ�ͬ���ʽ�Ƿ��Ǵ���
			var sRepaymentWay=RunMethod("BusinessManage","GetRepaymentWay",sPutoutNo);
			if(sRepaymentWay==1){//����
				//��ѯ��ͬ�Ƿ���������
				var flag=RunMethod("BusinessManage","SelectBatchLasCore",myDate+","+sPutoutNo);
			     //alert("-----"+flag);
				if(flag =="Null"){
					//ִ�в��뷽��
					RunMethod("BusinessManage","InsertBatchLasCore",myDate+","+sSerialNo+","+sPutoutNo+","+"jbo.app.ACCT_LOAN"+","+sPayinteAmt);
					alert("���������ɣ�");
				}else{
					alert("�˺�ͬ�����ѷ�������ۣ����飡");
				}
			
			}else{//�Ǵ���
				alert("�˺�ͬ���ʽ�ǷǴ��ۣ��޷�������ۣ�");
			}
			
			reloadSelf();//ˢ��
		}
	}
	

	//add  wlq  �����Ƿ�����    20140725  --
	function yanDate(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sCaseDelay = getItemValue(0,getRow(),"CaseDelay");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(sCaseDelay=="2"){
			if(confirm("��ȷ��Ҫ������")){
				RunMethod("ModifyNumber","GetModifyNumber","business_contract,CaseDelay='1',serialno='"+sSerialNo+"'");
				reloadSelf();
			}
		}else{
			if(confirm("��ȷ������������")){
				RunMethod("ModifyNumber","GetModifyNumber","business_contract,CaseDelay='2',serialno='"+sSerialNo+"'");
				reloadSelf();
			}
		}	
	}
	
    //��ͬ����
	function contractDetail(){
		var sSerialNo = getItemValue(0,getRow(),"PutoutNo");
		sObjectType="BusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}
	

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
