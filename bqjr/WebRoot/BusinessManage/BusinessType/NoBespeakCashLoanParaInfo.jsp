<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="java.util.Date"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --��Ʒ��������
			δ�õ��������ֶ���ʱ���أ������Ҫ��չʾ������
		Input Param:
        	TypeNo��    --���ͱ��
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ�����ԡ�ҳ�����;]~*/%>
<%
	String isInert = "0"; //�Ƿ�����[0:��,1:��]
	String PG_TITLE = "��ԤԼ�ֽ���ⲿ�ͻ���������"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//���ҳ�����
	String serialno = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("serialno"));	
	if(serialno==null || "".equals(serialno)){
		/** --update Object_Maxsnȡ���Ż� tangyb 20150817 start-- 
		serialno = DBKeyHelp.getSerialNo("NOORDERDCASH_PARA", "SERIALNO");*/
						
		serialno = DBKeyUtils.getSerialNo("NP");
		/** --end --*/
		
		isInert = "1";
		PG_TITLE = "��ԤԼ�ֽ���ⲿ�ͻ���������"; // ��������ڱ��� <title> PG_TITLE </title>
	}
%>
<%/*~END~*/%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sTempletNo = "NoBespeakCashLoanParaInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//������
	if("0".equals(isInert)){
		doTemp.setUnit("areacodename", ""); //���س���ѡ��ť
		doTemp.setUnit("productname", ""); //���ز�Ʒѡ��ť
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(serialno);
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
			{"true","","Button","����","����","saveRecord()",sResourcesPath},
			{"true","","Button","ȡ��","ȡ��","goBack()",sResourcesPath}
		    };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurTypeNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(){
		var startdate = getItemValue(0, 0, "startdate"); //��ʼ����
		var enddate = getItemValue(0, 0, "enddate"); //��������
		var flag = checkDateTime(startdate, enddate);
		if (flag == -1) {
			alert("��ʼ���ڲ������ڽ�������");
			setItemValue(0, 0, "enddate", "");
			return;
		}
		
		//��������
		if ('<%=isInert %>'== '1') {
			var areacode = getItemValue(0, 0, "areacode"); //���д���
			var businesstype = getItemValue(0, 0, "businesstype"); //��Ʒ����
			
			var areacodename = getItemValue(0, 0, "areacodename"); //��������
			var productname = getItemValue(0, 0, "productname"); //��Ʒ����
			
			var count =  RunMethod("Unique","uniques","noorderdcash_para,count(1),areacode='"+areacode+"' and businesstype = '"+businesstype+"'");
			if (parseInt(count)> 0){
				alert("����Ϊ["+areacodename+"]����ƷΪ["+productname+"]�Ĳ��������ã������ظ�����");
				return;
			} 
		}
		
	    as_save("myiframe0","self.close();");
	}

    /*~[Describe=ȡ��;InputParam=�����¼�;OutPutParam=��;]~*/
	function goBack(){
		self.returnValue = "_CANCEL_";
		self.close();
	}
   
	/*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode() {
		
		var retVal = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		
		if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("��ѡ����Ҫѡ��ĳ��У�");
			return;
		}
		
		setItemValue(0, 0, "areacode", retVal.split("@")[0]);
		setItemValue(0, 0, "areacodename", retVal.split("@")[1]);
	}
	
	/*
	 *������Ʒѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������
	 */
	function selectProductID() {
		var sParaString = "pID,020";
		setObjectValue("QueryBusinessInfoList",sParaString,"@productname@1@businesstype@2",0,0,"");
	}
	
	
	/*
	 * У����ʼ�������������
	 * [-1:��ʼ����>��������;0:��ʼ����==��������;1:��ʼ����<��������]
	 */
	function checkDateTime(startValue, endValue) {
		var flag = 0;
		if (startValue != null && startValue != "" && endValue != null
				&& endValue != "") {
			var dateS = startValue.split('/');//��������'-'�ָ�,�����������'/'�ָ��Ļ�,�㽫���к����е�'-'����'/'����
			var dateE = endValue.split('/');
			var startDate = new Date(dateS[0], dateS[1], dateS[2])
					.getTime();//������ڸ�ʽ����������,��Ҫ��new Date�Ĳ�������
			var endDate = new Date(dateE[0], dateE[1], dateE[2]).getTime();
			if (startDate > endDate) {
				flag = -1; //��ʼ����>��������
			} else if (startDate == endDate) {
				flag = 0; //��ʼ����==��������
			} else {
				flag = 1; //��ʼ����<��������
			}
		}
		return flag;
	}
	
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">	
	/**
	 * ��ʼ������
	 **/
	function initRow(){
		//���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		if ('<%=isInert %>'== '1') {
			as_add("myiframe0");//������¼
			setItemValue(0,0,"serialno", "<%=serialno %>"); //�Ǽǻ���
			setItemValue(0,0,"inputorg", "<%=CurOrg.orgID %>"); //�Ǽǻ���
			setItemValue(0,0,"inputuser", "<%=CurUser.getUserID() %>"); //�Ǽ���
			setItemValue(0,0,"inputtime", "<%=StringFunction.getToday() %>"); //�Ǽ�ʱ��
		}else{
			setItemValue(0,0,"updateuser", "<%=CurUser.getUserID()%>"); //������
			setItemValue(0,0,"updatetime", "<%=StringFunction.getToday()%>"); //����ʱ��
		}
	}

	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();//��ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
