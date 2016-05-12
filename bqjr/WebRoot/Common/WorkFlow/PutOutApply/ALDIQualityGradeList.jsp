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
	String PG_TITLE = "��������ȼ�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sQualityGrade="";//�����ȼ�
	String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("serialNo"));	
	String sDoWhere  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("doWhere"));	
	String sCustomerName  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerName"));	
	if(sDoWhere==null) sDoWhere="";	
    if(sSerialNo==null) sSerialNo="";	
    if(sCustomerName==null) sCustomerName="";	
    
	
	 ASDataObject doTemp = null;
	 String	 sTempletNo = "QualityGrade";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//����ģ�ͣ�2013-5-9
	
	 doTemp.setColumnAttribute("errorType,qualityGrade","IsFilter","1");
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�����������ݣ�2013-5-9
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
    
	//��ǰ��ͬ�������ȼ�
	String realQualityGrade = Sqlca.getString("select * from (select q.qualitygrade from quality_grade q, code_library c where q.qualitygrade = c.itemno and c.codeno = 'QualityGrade' and c.isinuse = '1' and q.artificialno = '"+sSerialNo+"' order by c.itemattribute asc) where rownum=1");
	//�ж��Ƿ����йؼ�����
	String sTFError = Sqlca.getString("select count(1) from record_Data where artificialNo='"+sSerialNo+"' and (UPDATEQUALITYGRADE='�ؼ�����' or STARTQUALITYGRADE='�ؼ�����')");
	if(!sTFError.equals("0")){
		Sqlca.executeSQL(new SqlObject("update Business_Contract set TFError=1 where serialNO=:serialNo")
		.setParameter("serialNo", sSerialNo));
	}else{
		Sqlca.executeSQL(new SqlObject("update Business_Contract set TFError=0 where serialNO=:serialNo")
		.setParameter("serialNo", sSerialNo));
	}
	if(realQualityGrade != null && realQualityGrade != ""){
		sQualityGrade = Sqlca.getString("select itemname from code_library where codeno='QualityGrade' and isinuse='1' and itemno='"+realQualityGrade+"' ");
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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����¼","deleteRecord()",sResourcesPath},
		{"true","","Button","����","����ҳ��", "backRecord()",sResourcesPath},
		};
	  
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List0578.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		
		AsControl.OpenView("/Common/WorkFlow/PutOutApply/QualityGradeInfo.jsp","serialNo=<%=sSerialNo%>&qualityGrade=<%=sQualityGrade%>&CustomerName=<%=sCustomerName%>","_self");
	}
	
	function deleteRecord(){	
		var sSerialNo = getItemValue(0,getRow(),"serialNo");//��ȡɾ����¼�ĵ�Ԫֵ
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		var qualityTagging =getItemValue(0,getRow(),"qualityTagging");//������ע
		var errorType = getItemValue(0,getRow(),"ErrorTypeCode"); // ��������
		var qualityFile = getItemValue(0,getRow(),"QualityFile");//�ļ�����
		var serialNoss = '<%=DBKeyUtils.getSerialNo("rd")%>'; // ��ǰ�����к�
		
		var contractNo = '<%=sSerialNo%>';
		var upUserName = '<%=CurUser.getUserID()%>';
		
		if(confirm("�������ɾ������Ϣ��")){
			var args = "quSerialNo=" + sSerialNo+",contractNo="+contractNo+",reSerialNo=" + serialNoss + ",upUserName="+upUserName+",errorType="+errorType+",qualityTagging="+qualityTagging+",qualityFile="+qualityFile;
			var result = RunJavaMethodSqlca("com.amarsoft.app.billions.RunInTransaction", "delQualityGrade", args)
			if(result=="success"){
				as_del("myiframe0");
				as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			}else if(result=="sysBusy"){
				alert("ϵͳ��æɾ��ʧ�ܣ����Ժ����²���");
			}else if(result=="sysException"){
				alert("ϵͳ�쳣�����Ժ�����");
			}
		}	
		parent.reloadSelf();
	}
	
	function backRecord(){
		parent.AsControl.OpenView("/Common/WorkFlow/PutOutApply/ALDIContrackRegistrationList.jsp","doWhere=<%=sDoWhere%>","_self");		
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

