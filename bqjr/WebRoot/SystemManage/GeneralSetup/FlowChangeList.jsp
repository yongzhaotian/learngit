<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: ccxie 2010/03/15
		Tester:
		Describe: ��ת��¼�б�
		Input Param:
			ObjectNo��  	����ҵ�������
			ObjectType:	���̶�������
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ת��¼�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//��ò���	
  	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));  
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));  
  	String sFlowStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowStatus"));  
	if(sFlowStatus == null) sFlowStatus = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sTempletNo = "FlowChangeList";
	String sTempletFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20);
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+sObjectType);
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
			
		{"true","","Button","���̵���","���̵���","FlowAdjust()",sResourcesPath}
		};
	
		if(sFlowStatus.equals("02")){
			sButtons[0][0] = "false";
		}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	/*~[Describe=�鿴����;InputParam=��;OutPutParam=��;]~*/
	function FlowAdjust()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sPhaseName = getItemValue(0,getRow(),"PhaseName");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("��ѡ����Ҫ�������Ľ׶Σ�");//��ѡ��һ����Ϣ��
		}else
		{       
			sCurPhaseName = RunMethod("WorkFlowEngine","GetMaxPhaseName",sSerialNo);
			if(sPhaseName == sCurPhaseName){
				alert("����������"+sPhaseName+"��������ѡ��");
			}else{
				if(confirm("��ȷ��Ҫ�����̵�����"+sPhaseName+"��?")){
					sReturn = RunMethod("WorkFlowEngine","ChangeFlowPhase",sSerialNo+","+sObjectNo+","+sObjectType);
					if(typeof(sReturn) != "undefined" && sReturn == "success"){
						alert("���̵����ɹ���");
					}else{
						alert("���̵���ʧ�ܣ�");
					}
					reloadSelf();
				}
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
	showFilterArea();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>