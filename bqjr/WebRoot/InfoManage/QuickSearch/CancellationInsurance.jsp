<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�˱�����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//����������	����ͬ��
	String SerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("sSerialNo"));
	
	//����ֵת���ɿ��ַ���
	if(SerialNo == null) SerialNo = "";	
	
    //add  wlq  20140905  ͨ���ŵ������ڳ��в�ѯ����Ӧ�������ڵı��չ�˾���
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "CancellationInsuranceInfo";
	
	//����ģ�����������ݶ���	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//�����������ѯ�����
	ASResultSet rs = null;
	String sCreditId = "";
	String sCreditPerson = "";
	//���ñ��䱳��ɫ
	//doTemp.setHTMLStyle("CustomerType","style={background=\"#EEEEff\"} ");
	//���ͻ����ͷ����ı�ʱ��ϵͳ�Զ������¼�����Ϣ
	//doTemp.appendHTMLStyle("CustomerType"," onClick=\"javascript:parent.clearData()\" ");
	doTemp.WhereClause+=" and PUTOUTNO="+SerialNo;
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(SerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
			{"true","","Button","ȷ��","ȷ���˱�����","doCreation()",sResourcesPath},
			{"true","","Button","ȡ��","ȡ���˱�����","doCancel()",sResourcesPath}	
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">


	

		   
    /*~[Describe=ȡ���������ŷ���;InputParam=��;OutPutParam=ȡ����־;]~*/
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">

	/*~[Describe=����һ�����������¼;InputParam=��;OutPutParam=��;]~*/
	function doCreation(){
		var  status = getItemValue(0,0,"status");//�񰲱���״̬
		var PUTOUTNO = getItemValue(0,0,"PUTOUTNO");	
		var r_type = getItemValue(0,0,"R_TYPE");	
		if("1"==r_type){
			if(status =='2'){
			var updateBy = "<%=CurUser.getUserID()%>";
			var str=	RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateMinanSerialNo", "updateMinanSerialNo","serialNo="+PUTOUTNO+",updateBy="+updateBy+",r_type="+r_type);
				if(str=="S"){
					alert("�˱�����ɹ���");
					top.close();
				}
			}else{
				alert("�ú�ͬ�������˱�����");
			}
			
		}else{
			if(status =='1' || status =='5'){	//�˱�ʧ�ܿ��Լ�������.'1','Ͷ��','2','Ͷ��ʧ��','3','�˱�����','4','�˱��ɹ�','5','�˱�ʧ��','6','����ͨ��������'
				if(!confirm("����ɹ����޷�ȡ�����Ƿ�ȷ�����룿")){
					return;
				}
				//update by huanghui 20151231 PRM-728 ȡ���˱���������ʱ���������Ĺ���
				var updateBy = "<%=CurUser.getUserID()%>";
				/* var str=	 */RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateMinanSerialNo", "updateMinanSerialNo","serialNo="+PUTOUTNO+",updateBy="+updateBy+",r_type="+r_type);
					/* if(str=="S"){
						alert("�˱�����ɹ���");
						top.close();
					}  */
				//������
		    	policynos =getItemValue(0,getRow(),"policyno");
		    	if(policynos){
					var sUserID = "<%=CurUser.getUserID()%>";
					ShowMessage("�˱�һ����¼��Լ3�룬��ȴ�....",true,false);
					var str=	RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateMinanSerialNo", "httpPostPolicynoRealTime","policyno="+policynos+",updateBy="+sUserID);
					hideMessage();
					if(str=="S"){
							alert("�˱������������ݶԽӳɹ���");
					}else{
						alert(str);
					}
					top.close();	
				}
			}else{
				alert("�ú�ͬ�������˱�����");
			}
		}
	}

							


	
	
	</script>
	

<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>