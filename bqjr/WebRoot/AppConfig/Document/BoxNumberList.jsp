<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: ������ά��
		
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
	String PG_TITLE = "������ά��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sTemp  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("temp"));	
    if(sTemp==null) sTemp="";	
    
     String sTempletNo="BoxNumberList";
	 ASDataObject  doTemp = new ASDataObject(sTempletNo,Sqlca);//����ģ�ͣ�2013-5-9
	 doTemp.setColumnAttribute("CabinetName","IsFilter","1");
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
			{"true","","Button","����","����","newRecord()",sResourcesPath},
			{"true","","Button","����","����","newDetail()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
		};
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
		AsControl.OpenView("/AppConfig/Document/BoxNumberInfo.jsp","","_self");		

	}
	
	function newDetail(){
		var sCabinetID=getItemValue(0,getRow(),"CabinetID");
		if(typeof(sCabinetID)=="undefined" || sCabinetID.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		AsControl.OpenView("/AppConfig/Document/BoxNumberInfo.jsp","cabinetID="+sCabinetID+"&temp=modify","_self");
	}
	
	function deleteRecord(){
		var sCabinetID =getItemValue(0,getRow(),"CabinetID");//��ȡɾ����¼�ĵ�Ԫֵ
		var sCount=RunMethod("Unique","uniques","business_contract,count(1),boxNo='"+sCabinetID+"'");
		if (typeof(sCabinetID)=="undefined" || sCabinetID.length==0){
			alert(getHtmlMessage(1));
			return;
		}
		
		if(confirm("�������ɾ����������")){
			if(sCount!="0.0"){
				alert("�������´��к�ͬ������ɾ����");
				return;
			}else{
				as_del("myiframe0");
				as_save("myiframe0");  //�������ɾ������Ҫ���ô����
				reloadSelf();
			}
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

