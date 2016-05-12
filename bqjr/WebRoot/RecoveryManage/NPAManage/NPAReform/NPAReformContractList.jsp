<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: XWu 2004-12-04
*	Tester:
*	Describe: δ�ַ������ʲ���Ϣ�б�
*	Input Param:
*	Output Param:  
*		RecoveryUserID  :��ȫ������ԱID
*   		SerialNo	:��ͬ��ˮ��
*		sShiftType	:�ƽ�����
*	
	HistoryLog:slliu 2004.12.17
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ�ַ������ʲ���Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSerialNo = "" ;    
	String sItemID = "" ; 
	String sFlag = "" ; 
	String sQueryFlag = "" ; 
	String sSql ="";

	//���ҳ�����
	//����������
	//������ˮ��	
	sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	
	//�б��ʶ
	sItemID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemID"));
	if(sItemID==null) sItemID="";
	
	//��ʶFlag=ReformCredit��ʾ�鿴�����������
	sFlag =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag"));
	if(sFlag==null) sFlag="";
	
	//��ʶQueryFlag=Query��ʾ�ӿ��ٲ�ѯ����鿴�����������
	sQueryFlag =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("QueryFlag"));
	if(sQueryFlag==null) sQueryFlag="";
	
	
	String sHeaders[][] = {
				{"SerialNo","��ͬ��ˮ��"},
				{"ArtificialNo","��ͬ���"},
				{"BusinessTypeName","ҵ��Ʒ��"},
				{"OccurTypeName","��������"},
				{"CustomerName","�ͻ�����"},
				{"BusinessCurrencyName","����"},
				{"BusinessSum","���(Ԫ)"},
				{"ShiftBalance","�ƽ����(Ԫ)"},
				{"Balance","��ǰ���(Ԫ)"},
				{"Maturity","��������"},				
				{"ClassifyResultName","�弶����"},
				{"ShiftTypeName","�ƽ�����"},
				{"ManageUserName","ԭ�ܻ���"},
				{"ManageOrgName","ԭ�ܻ�����"}
			}; 
	
	if(sFlag.equals("ReformCredit")) //��ʾ�鿴�����������
	{
		sSql = 	" select BC.SerialNo as SerialNo,BC.ArtificialNo as ArtificialNo," + 	
			   	" BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName," + 
			   	" getItemName('OccurType',BC.OccurType) as OccurTypeName," + 
			 	" BC.CustomerName as CustomerName," + 
			 	" getItemName('Currency',BC.BusinessCurrency) as BusinessCurrencyName," + 
			 	" BC.BusinessSum as BusinessSum,BC.Balance as Balance," + 
			 	" BC.FinishDate as FinishDate,BC.ClassifyResult as ClassifyResult,BC.Maturity as Maturity," +  
			 	" getUserName(BC.ManageUserID) as ManageUserName, " + 
			 	" getUserName(BC.ManageOrgID) as ManageOrgName " + 			
			 	" from BUSINESS_CONTRACT BC ,CONTRACT_RELATIVE CR " +		
			 	" where BC.SerialNo = CR.SerialNo "+			
			 	" and  CR.ObjectType = 'NPAReformApply' " +
			 	" and CR.ObjectNo = '"+sSerialNo+"' " ;
	
	}
	else
	{
 		sSql = " select SerialNo,ArtificialNo," + 	
			   " BusinessType,getBusinessName(BusinessType) as BusinessTypeName," + 
			   " getItemName('OccurType',OccurType) as OccurTypeName," + 
			   " CustomerName,getItemName('Currency',BusinessCurrency) as BusinessCurrencyName," + 
			   " BusinessSum,ShiftBalance,Balance,Maturity, "+
			   " ClassifyResult,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName," + 
			   " ShiftType,getItemName('ShiftType',ShiftType) as ShiftTypeName," + 
			   " getUserName(ManageUserID) as ManageUserName," + 
			   " getOrgName(ManageOrgID) as ManageOrgName" + 
			   " from BUSINESS_CONTRACT " +
			   " Where  SerialNo in (select ObjectNo from APPLY_RELATIVE where SerialNo='"+sSerialNo+"' and ObjectType='BusinessContract') "+
			   " order by SerialNo desc,ArtificialNo " ;
	}
	//out.println(sSql);	
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//���ù��ø�ʽ
	doTemp.setVisible("ArtificialNo,ShiftType,BusinessType,FinishType,FinishDate,ClassifyResult",false);
    
	//���ø��±�
	//doTemp.UpdateTable = "BUSINESS_CONTRACT";

	//����ѡ��˫�����п�	
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("RecoveryUserName"," style={width:80px} ");
	doTemp.setHTMLStyle("OccurTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName"," style={width:40px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("ShiftBalance,Balance"," style={width:95px} ");
	doTemp.setHTMLStyle("ClassifyResultName"," style={width:55px} ");
	doTemp.setHTMLStyle("ShiftTypeName"," style={width:56px} ");
	doTemp.setHTMLStyle("Maturity"," style={width:65px} ");
	doTemp.setHTMLStyle("ManageOrgName"," style={width:90px} ");
	doTemp.setHTMLStyle("ManageUserName"," style={width:60px} ");

	//���ý��Ϊ��λһ������
	doTemp.setType("BusinessSum,ShiftBalance,Balance,ActualPutOutSum","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("BusinessSum,Balance,ActualPutOutSum","2");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("BusinessSum,Balance,ActualPutOutSum","3");
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("ArtificialNo,CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20); 	//��������ҳ
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				

	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
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
				{"true","","Button","��ͬ����","�鿴�Ŵ���ͬ��������Ϣ���������Ϣ����֤����Ϣ�ȵ�","viewAndEdit()",sResourcesPath},
				{"true","","Button","��������","�鿴��������","viewApply()",sResourcesPath},
				{"true","","Button","����","������һҳ��","goBack()",sResourcesPath}
		};
	
	if(!sFlag.equals("ReformCredit")) //��ʾ�鿴�����������
	{
		sButtons[1][0]="false";
	}
	
	if(sQueryFlag.equals("Query")) //��ʾ�ӿ��ٲ�ѯ����鿴�����������
	{
		sButtons[2][0]="false";
	}

%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>

<%/*�鿴��ͬ��������ļ�*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>


<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	
	function mySelectRow()
	{ 
		if(myiframe0.event.srcElement.tagName=="BODY") return;
		setColor();		
	}
	
	//����������Ϣ
	function viewApply()
	{
		//��ú�ͬ��ˮ��
		var sContractNo=getItemValue(0,getRow(),"SerialNo");  //��ͬ��ˮ�Ż������
		
		if (typeof(sContractNo)=="undefined" || sContractNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}

		sReinforceFlag = RunMethod("��Ϣ����","GetReinforceFlag",sContractNo);
		if(sReinforceFlag == '020' || sReinforceFlag == '120'){
			alert("������ɵĺ�ͬ���ܲ鿴�������飡");
			return;
		}
		
		var sReturn = PopPageAjax("/RecoveryManage/NPAManage/NPAReform/NPAReformActionAjax.jsp?ContractNo="+sContractNo+"&Flag=ReformApply","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
		
		if(typeof(sReturn) != "undefined" && sReturn.length != 0 && sReturn != '')
		{
			
			var sObjectNo = sReturn;
			var sObjectType = 'CreditApply';
			
			openObject(sObjectType,sObjectNo,"002");
		}
	}
    	
		
	/*~[Describe=����;InputParam=��;OutPutParam=SerialNo;]~*/
	function goBack()
	{
		OpenComp("NPAReformList","/RecoveryManage/NPAManage/NPAReform/NPAReformList.jsp","ComponentName=���鷽���б�&ComponentType=MainWindow&ItemID=<%=sItemID%>","right",OpenStyle);
	}

</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>
