<%@ page import="com.amarsoft.xquery.*,org.w3c.dom.*"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: �Բ�ѯ�������д���������ʾ���ݴ���
		Input Param:
	           --StatResult:�������
	                        1--���ܲ�ѯ
	                        2--��ϸ��ѯ
	           --querySql��  ��ѯ���
	 */
	String PG_TITLE = "��ѯ�����ʾ"; // ��������ڱ��� <title> PG_TITLE </title>

	//�������
	String argumentString="";//--�ϼ��ֶε���
	String sumString2="";//--����������
	String sumString1="";//--������
	String argumentValue="100";//--���ܲ�����ֵ

	//����������	������Ҫִ�е�sql��䡢��ͷ����ѯ����
	String querySql   =DataConvert.toRealString(iPostChange,(String)session.getAttribute("querySql"));
	String[][] header = (String[][])session.getAttribute("header");
	String sStatResult = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("StatResult")).trim();

	String sNumberString="",sSumString="",sUnVisibleString=""; 
	XQuery xQuery = (XQuery)session.getAttribute("XQuery");
	Vector vColumn=xQuery.getAllColumnsList();
	for(int ii=0;ii<vColumn.size();ii++){
		String[] sColumn=(String[])vColumn.get(ii);
		if(sColumn[6].equals("NUMBER")||sColumn[6].equals("NUMBERSCOPE")){
			//sNumberString+=sColumn[3]+",";
			
			if(sColumn[4]!=null && sColumn[4].length()>0){
				sNumberString+=sColumn[4]+",";		//�б�����ȡ����,��header����һ��
			}else{
				sNumberString+=sColumn[3]+",";
			}
		}
		if(sColumn[9].length()>0){
			if(sColumn[4].length()==0)
				sUnVisibleString+=sColumn[3]+",";
			else
				sUnVisibleString+=sColumn[4]+",";
		}
		if(xQuery.availableSummaryColumns.indexOf("."+sColumn[3])>=0){
			sSumString+=sColumn[3]+",";
		}
	}

	if(sNumberString.length()>=2) sNumberString=sNumberString.substring(0,sNumberString.length()-1);
	if(sSumString.length()>=2) sSumString=sSumString.substring(0,sSumString.length()-1);
	if(sUnVisibleString.length()>=2) sUnVisibleString=sUnVisibleString.substring(0,sUnVisibleString.length()-1);
  // out.print(querySql);
	ASDataObject doTemp = new ASDataObject(querySql);
	doTemp.setHeader(header);
	
	if(sStatResult.equals("1")){//���ܲ�ѯ
		argumentString = (String)session.getAttribute("Arguments");
		sumString2     = (String)session.getAttribute("sumString2");
		sumString1     = (String)session.getAttribute("sumString1");
		argumentValue  = (String)session.getAttribute("argumentValue");
		doTemp.Arguments= argumentString;
		doTemp.setAlign(sumString2,"3");
		doTemp.setColumnType("Sum0,"+sumString1,"2");
		doTemp.setType("Sum0,"+sumString2,"Number");
		doTemp.setCheckFormat(sumString2,"2");
	}
	//��number���͵�����
	if(!sNumberString.equals("")){
		doTemp.setAlign(sNumberString,"3");
		doTemp.setType(sNumberString,"Number");
		doTemp.setCheckFormat(sNumberString,"2");
	}
	//doTemp.setColumnType(sSumString,"2");
	doTemp.setCheckFormat("ERate","14");
	doTemp.setVisible(sUnVisibleString,false);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1";
	dwTemp.ShowSummary="1";//���úϼ���
	dwTemp.setPageSize(40);
	Vector vTemp = dwTemp.genHTMLDataWindow(argumentValue);
	for(int i = 0;i < vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//out.println(doTemp.SourceSql);

	String sButtons[][] = {
			{"false","","Button","�鿴�ͻ�����","�鿴�ͻ�����","my_CustomerInfo()",sResourcesPath},
			{"false","","Button","�鿴ҵ������","�鿴��ͬ����ϸ��Ϣ","my_ContractInfo()",sResourcesPath},
			{"true","","Button","ת�������ӱ��","ת�������ӱ��","saveResult()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~[Describe=�鿴�ͻ�����;]~*/
	function my_CustomerInfo(){
		sCustomerID=getItemValue(0,getRow(),"CustomerID");	
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
		}else{
			openObject("Customer",sCustomerID,"002");
		}
	}
   /*~[Describe=�鿴ҵ������;]~*/
	function my_ContractInfo(){

	}
   /*~[Describe=ת�����ӱ��;]~*/
	function saveResult(){
		amarExport("myiframe0");
	}

	AsOne.AsInit();
	init();
	//init_show();
	my_load(1,0,'myiframe0');
	//my_load_show(1,0,'myiframe0');
</script>
<%@ include file="/IncludeEnd.jsp"%>