<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --��������
			δ�õ��������ֶ���ʱ���أ������Ҫ��չʾ������
		Input Param:
        	TypeNo��    --���ͱ��
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//���ҳ�����
	String sTypeNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("typeNo"));	
    if(sTypeNo==null) sTypeNo="";
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	ASDataObject doTemp = new ASDataObject("JXSBusinessTypeInfo1",Sqlca);
    
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sTypeNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
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
			{"true","","Button","����","����","saveRecord()",sResourcesPath}
		    };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurTypeNo=""; //��¼��ǰ��ѡ���еĴ����
    var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{	
		insertTerm();
		bIsInsert = false;
	    as_save("myiframe0");
	}
    
	//�����������
	function insertTerm(){
		var sObjectNo = "<%=sTypeNo%>"+"-V1.0";
		var RATTerm = getItemValue(0, 0, "rateType");//��������
		var fixedInterestRate = getItemValue(0, 0, "fixedInterestRate");//���ʹ̶�ֵ
		var adjustmentMode = getItemValue(0, 0, "adjustmentMode");//���ʵ�����ʽ
		var productType = getItemValue(0, 0, "productType");//��Ʒ����
		
		if(RATTerm=="1"){//����
			RATTerm="RAT001";
			FINTerm="FIN003";
		}else if(RATTerm=="0"){//�̶�
			RATTerm="RAT002";
			FINTerm="FIN005";
		}
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,"+RATTerm);//��������
		if(RATTerm=="RAT001"){//����
			var sFloatType = getItemValue(0, 0, "floatingManner");//������ʽ
			var floatingRange = getItemValue(0, 0, "floatingRange");//��������
			var floatingRate = getItemValue(0, 0, "floatingRate");//��������
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+sFloatType+",PRODUCT_TERM_PARA,String@paraid@RateFloatType@String@termid@RAT001@String@ObjectNo@"+sObjectNo);//������ʽ
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+floatingRange+",PRODUCT_TERM_PARA,String@paraid@RateFloat@String@termid@RAT001@String@ObjectNo@"+sObjectNo);//��������
		}else if(RATTerm=="RAT002"){//�̶�
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+fixedInterestRate+",PRODUCT_TERM_PARA,String@paraid@ExecuteRate@String@termid@RAT002@String@ObjectNo@"+sObjectNo);//ִ������
		}
		
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,"+FINTerm);//��Ϣ
		if(FINTerm=="FIN003"){//����
			var FINFloatType = getItemValue(0, 0, "penaltyRate");//��Ϣ������ʽ
			var floatingRate = getItemValue(0, 0, "floatingRate");//��Ϣ��������
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+FINTerm+",PRODUCT_TERM_PARA,String@paraid@RateFloatType@String@termid@FIN003@String@ObjectNo@"+sObjectNo);//������ʽ
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+floatingRate+",PRODUCT_TERM_PARA,String@paraid@RateFloat@String@termid@FIN003@String@ObjectNo@"+sObjectNo);//��������		
		}else if(FINTerm=="FIN005"){//�̶�
/* 			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+fixedInterestRate+",PRODUCT_TERM_PARA,String@paraid@ExecuteRate@String@termid@RAT002@String@ObjectNo@"+sObjectNo);//ִ������
 */		}
		
		if(productType=="0"){//�������
			//�����������ʽ
			/* ���ð��¸�Ϣ�����ڻ������� */
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,RPT01");//���¼�Ϣ���⻹��
		}else if(productType == "1"){//�����ʽ����
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,RPT01");//���¼�Ϣ���ڻ���
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,RPT002");//������Ϣ���ڻ���
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,RPT05");//���ڻ�����Ϣ
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,RPT17");//�ȶϢ
			//����
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,QT100");//������
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,N300");//���������
		}
		//��������
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,N400");//������
		/* RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@03,PRODUCT_TERM_PARA,String@paraid@FeePayDateFlag@String@termid@N400@String@ObjectNo@"+sObjectNo);//�ֶ�һ������ȡ
		RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@01,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@N400@String@ObjectNo@"+sObjectNo);//�̶����		 */
		//��������
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA001");//�����ཻ��
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA002");//�����ձ��
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA004");//��ǰ����
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA005");//�����ཻ��
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,PS001");//����δ�����������
	}
    
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
		}
		setItemValue(0, 0, "inputOrgName", "<%=CurOrg.orgName %>");
		setItemValue(0,0,"inputOrg", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"inputUser", "<%=CurUser.getUserName()%>");
		setItemValue(0,0,"inputTime", "<%=StringFunction.getToday()%>");
		setItemValue(0,0,"updateOrg", "<%=CurOrg.orgID %>");
		setItemValue(0, 0, "updateOrgName", "<%=CurOrg.orgName %>");
		setItemValue(0,0,"updateUser", "<%=CurUser.getUserName()%>");
		setItemValue(0,0,"updateTime", "<%=StringFunction.getToday()%>");
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
