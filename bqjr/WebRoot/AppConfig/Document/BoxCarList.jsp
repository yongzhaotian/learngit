<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 
 <%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//���ҳ�����
	String sTemp  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("temp"));
	String sBoxID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("boxID"));
	if(sBoxID == null) sBoxID = "";
    if(sTemp==null) sTemp="";
%>
<%/*~END~*/%>
 
 <%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "�����Ǽ�֤���� ";
	 String sTempletNo="";
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	if(sTemp.equals("1")){
		 sTempletNo = "CarRegistration";
	}else{
	    sTempletNo = "EndCarRegistration";
	}
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.setColumnAttribute("CarFrame,ArtificialNo,customerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sBoxID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","��Ϣ����","��Ϣ����","informationBoard()",sResourcesPath},
			{"true","","Button","���복���Ǽ�֤�Ǽ�","���복���Ǽ�֤�Ǽ�","carRegistration()",sResourcesPath}
	};
	
	if(sTemp.equals("2")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	<%/*��¼��ѡ��ʱ�����¼�*/%>
	function informationBoard(){
		var sSerialNo=getItemValue(0,getRow(),"serialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		var sCarNumber =RunMethod("GetElement","GetElementValue","carNumber,business_contract,serialNo='"+sSerialNo+"'");
		var sGreenDate =RunMethod("GetElement","GetElementValue","greenDate,business_contract,serialNo='"+sSerialNo+"'");
		var sScanBarCode=RunMethod("GetElement","GetElementValue","scanBarCode,business_contract,serialNo='"+sSerialNo+"'");
		if(sCarNumber=="" || sGreenDate=="" || sScanBarCode==""){
			sCompID = "BoxCarInfo";
			sCompURL = "/AppConfig/Document/BoxCarInfo.jsp";
		    popComp(sCompID,sCompURL,"serialNo="+sSerialNo,"dialogWidth=300px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		    reloadSelf();
		}else{
			alert("��Ϣ�Ѳ��ǣ���");
		}	
	}
   
	function carRegistration(){
		var sSerialNo=getItemValue(0,getRow(),"serialNo");	
		var sCarNumber =RunMethod("GetElement","GetElementValue","carNumber,business_contract,serialNo='"+sSerialNo+"'");
		var sGreenDate =RunMethod("GetElement","GetElementValue","greenDate,business_contract,serialNo='"+sSerialNo+"'");
		var sScanBarCode=RunMethod("GetElement","GetElementValue","scanBarCode,business_contract,serialNo='"+sSerialNo+"'");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		if(sCarNumber=="" || sGreenDate=="" || sScanBarCode==""){
			alert("������Ϣ���ǣ�");
			return;
		}
		if(confirm("�����ȷ�����복���Ǽ�֤�Ǽ���")){
			RunMethod("ModifyNumber","GetModifyNumber","business_contract,carStatus='02',serialNo="+sSerialNo);// �޸ĳ�������״̬ 
			RunMethod("ModifyNumber","GetModifyNumber","business_contract,boxID=<%=sBoxID%>,serialNo="+sSerialNo);  //�޸ĳ�������ĸ����ӵ�λ�� 
			as_save("myiframe0");  
			
			
		}
		 parent.reloadSelf();
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>