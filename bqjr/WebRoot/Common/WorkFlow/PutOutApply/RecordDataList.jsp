<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: �����͵ر��¼
		
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
	String PG_TITLE = "�����͵ر��¼"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sRelativeQualityGrade="";//�ϼ������ȼ�
	String sNowQualityGrade="";//��ǰ״̬�µ������ȼ�
	String sNowLandmarkStatus="";//����״̬�µĵر�
	String sRelativeSerialNo="";//�ϼ���ˮ��
	String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("serialNo"));
	String sQualityGrade  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("qualityGrade"));	
	String sLandmarkStatus  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("landmarkStatus"));	
	String oldLandmark  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("oldLandmark"));//�ϴ�δ���ĵر��״̬ 
	if(oldLandmark==null) oldLandmark="";	
	if(sSerialNo==null) sSerialNo="";	
	if(sQualityGrade==null) sQualityGrade="";	
	if(sLandmarkStatus==null) sLandmarkStatus="";
	
	 ASDataObject doTemp = null;
	 String	 sTempletNo = "RecordData";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//����ģ�ͣ�2013-5-9
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�����������ݣ�2013-5-9
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//��ǰ��ͬ�������ȼ�
	String realQualityGrade = Sqlca.getString("select * from (select q.qualitygrade from quality_grade q, code_library c where q.qualitygrade = c.itemno and c.codeno = 'QualityGrade' and c.isinuse = '1' and q.artificialno = '"+sSerialNo+"' order by c.itemattribute asc) where rownum=1");
	sRelativeQualityGrade = Sqlca.getString("select startQualityGrade from record_Data where recordID=(select max(recordID) from record_Data where artificialNo='"+sSerialNo+"')");
	if(sRelativeQualityGrade==null){
		sRelativeQualityGrade="�ϸ�";
	}
	if(realQualityGrade != null && realQualityGrade != ""){
		sNowQualityGrade = Sqlca.getString("select itemname from code_library where codeno='QualityGrade' and isinuse='1' and itemno='"+realQualityGrade+"' ");
	}
	
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
		{"false","","Button","ɾ��","ɾ����¼","deleteRecord()",sResourcesPath},
		};
	  
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List0577.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	
	
	function deleteRecord(){
		var sRecordID=getItemValue(0,getRow(),"recordID");
		if (typeof(sRecordID)=="undefined" || sRecordID.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			reloadSelf();
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

