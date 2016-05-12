<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: ndeng 2005-03-16
		Tester:
		Describe: ���˷���֪ͨ�б�;
		Input Param:

		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���˷���֪ͨ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";

	//���ҳ�����

	//����������

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","������ˮ��"},
							{"ArtificialNo","��ͬ��"},
							{"CustomerName","�ͻ�����"},
				            {"BusinessTypeName","ҵ��Ʒ��"},
							{"CurrencyName","����"},
				            {"BusinessSum","���(Ԫ)"}				            
						  };

	sSql =  "select FO.ObjectType,FO.ObjectNo,FT.SerialNo as FSerialNo,BP.SerialNo,BP.ArtificialNo,BP.CustomerName,BP.BusinessType,getBusinessName(BP.BusinessType) as BusinessTypeName, "+
            " BP.BusinessCurrency,getItemName('Currency',BP.BusinessCurrency) as CurrencyName,BP.BusinessSum,FT.EndTime "+
            " from FLOW_TASK FT,FLOW_OBJECT FO,BUSINESS_PUTOUT BP "+
            " where FT.ObjectType=FO.ObjectType and FO.ObjectNo=BP.SerialNo and FT.ObjectNo=FO.ObjectNo "+
            " and FO.ObjectType='PutOutApply'and FO.ApplyType='PutOutApply' "+
            " and GetPhaseType(FT.FlowNo,FT.PhaseNo) ='1030' "+
            " and FT.PhaseNo = '3000' and  FT.UserID='"+CurUser.getUserID()+"' and FO.UserID != '"+CurUser.getUserID()+"'"+
            " and (FT.EndTime is null or FT.EndTime =' ')";

    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ,���±���,��ֵ,�ɼ����ɼ�,�Ƿ���Ը���
	doTemp.setHeader(sHeaders);
	
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("FSerialNo,ObjectType,ObjectNo,BusinessType,BusinessCurrency,EndTime",false);
	doTemp.setUpdateable("EntTime",true);

	//���ø�ʽ
	doTemp.setAlign("BusinessSum","3");
	doTemp.setCheckFormat("BusinessSum","2");
	doTemp.setHTMLStyle("BusinessSum"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:250px} ");

	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

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
		{"true","","Button","����","�鿴������Ϣ����","viewAndEdit()",sResourcesPath},
		{"true","","Button","�Ѳ���","�������","Finished()",sResourcesPath}
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
    //��ɲ��ĳ�����Ϣ
    function Finished(){
        var sFSerialNo = getItemValue(0,getRow(),"FSerialNo");
		if (typeof(sFSerialNo)=="undefined" || sFSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		} 
        if(confirm("��ȷ���Ѿ����������")){
            PopPageAjax("FinishPutOutAction","/DeskTop/FinishPutOutActionAjax.jsp","SerialNo="+sFSerialNo,"_blank","");
        }
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

<%@	include file="/IncludeEnd.jsp"%>