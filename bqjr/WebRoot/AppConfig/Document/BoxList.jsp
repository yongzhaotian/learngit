<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: �ÿ��¼�б�
		
		Input Param:
		SerialNo:��ˮ��
		ObjectType:��������
		ObjectNo��������
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����Ǽ�֤�鵵"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sTemp  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("temp"));	
    if(sTemp==null) sTemp="";	
	
     String sTempletNo="";
	 ASDataObject doTemp = null;
	 if(sTemp.equals("2")){
		 sTempletNo = "BoxList1";
	 }else{
		 sTempletNo = "BoxList";
	 }
	 
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//����ģ�ͣ�2013-5-9
	
	 doTemp.setColumnAttribute("boxID,boxName,carNumber","IsFilter","1");
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//�����������ݣ�2013-5-9
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
		{"true","","Button","�����ӵǼ�","�����ӵǼ�","newRecord()",sResourcesPath},
		{"true","","Button","�����Ǽ�֤�Ǽ�","�����Ǽ�֤�Ǽ�","carRegistration()",sResourcesPath},
		{"true","","Button","�鵵���","�鵵���","fileEnd()",sResourcesPath},
		};
	   if(sTemp.equals("2")){
		   sButtons[0][0]="false";
		   sButtons[1][0]="false";
		   sButtons[2][0]="false";
	   }
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		AsControl.OpenView("/AppConfig/Document/BoxInfo.jsp","","_self");		

	}
	
	function carRegistration(){
		var sBoxID=getItemValue(0,getRow(),"boxID");
		if(typeof(sBoxID)=="undefined" || sBoxID.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else{
			AsControl.OpenView("/AppConfig/Document/BoxFrame.jsp","boxID="+sBoxID,"_self");
		}
	}
	
	function fileEnd(){
		var sBoxID=getItemValue(0,getRow(),"boxID");
		var sCabinetID=getItemValue(0,getRow(),"cabinetID");
		var sCount =RunMethod("GetElement","GetElementValue","count(*),business_contract,boxID='"+sBoxID+"' and CreditAttribute='0001' and carRegistration='01'");//�жϸ��������Ƿ��Ѵ��ڵǼǹ��ĳ�����ͬ 
		if(typeof(sBoxID)=="undefined" || sBoxID.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		if(sCabinetID!=""){
			if(sCount>="1.0"){
				if(confirm("�����ȷ���鵵��")){
					RunMethod("ModifyNumber","GetModifyNumber","box,trueFalseFile='01',cabinetID='"+sCabinetID+"' and boxID='"+sBoxID+"'");
					RunMethod("ModifyNumber","GetModifyNumber","Box ,fileDate='<%=StringFunction.getToday()%>',cabinetID='"+sCabinetID+"' and boxID='"+sBoxID+"'");  //���¹鵵ʱ��
					alert("�鵵�ɹ���");
					reloadSelf();
				}
			}else{
				alert("���ȳ����Ǽ�֤�Ǽǣ�лл��");
			}
			
		}else{
			alert("��Ϣ��������û��ָ����Ź���");
		}
		
	}
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

