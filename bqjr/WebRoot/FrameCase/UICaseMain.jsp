<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��:UI���������ҳ��
	 */
	String PG_TITLE = "UI�������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;UI�������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"UI�������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	//������ͼ�ṹ
	String sFolder10=tviTemp.insertFolder("root","�������","",1);
	String sFolder11=tviTemp.insertFolder(sFolder10,"DataWindow","",1);
	tviTemp.insertPage(sFolder11,"DW���ݹ�����","",1);
	tviTemp.insertPage(sFolder11,"DWǰ��/�����¼�(����)","",2);
	tviTemp.insertPage(sFolder11,"DW����У��","",3);
	tviTemp.insertPage(sFolder11,"DW�����¼�","",4);
	tviTemp.insertPage(sFolder11,"DW�Զ��嵥Ԫ���¼�","",5);
	String sFolder12=tviTemp.insertFolder(sFolder10,"Button","",2);
	tviTemp.insertPage(sFolder12,"���鶨�尴ť","",1);
	tviTemp.insertPage(sFolder12,"Ӳ���밴ť","",2);
	String sFolder13=tviTemp.insertFolder(sFolder10,"TreeView","",3);
	tviTemp.insertPage(sFolder13,"SQL������ͼ","",1);
	tviTemp.insertPage(sFolder13,"����������ͼ","",2);
	tviTemp.insertPage(sFolder13,"�ֹ�������ͼ","",3);
	tviTemp.insertPage(sFolder13,"��ѡ��ͼ","",4);
	String sFolder15=tviTemp.insertFolder(sFolder10,"Selector","",5);
	tviTemp.insertPage(sFolder15,"��ͼ/�б���ѡ���","",1);
	tviTemp.insertPage(sFolder15,"����ѡ��","",3);
	
	String sFolder1=tviTemp.insertFolder("root","������ͼ","",2);
	String sFolder2=tviTemp.insertFolder(sFolder1,"List��ͼ","",1);
	tviTemp.insertPage(sFolder2,"����List","",1);
	tviTemp.insertPage(sFolder2,"��ѡList","",2);
	tviTemp.insertPage(sFolder2,"����List","",3);
	String sFolder3=tviTemp.insertFolder(sFolder1,"Info��ͼ","",2);
	tviTemp.insertPage(sFolder3,"����Info","",1);
	tviTemp.insertPage(sFolder3,"��Ϣ����","",2);
	tviTemp.insertPage(sFolder3,"InfoУ��","",3);
	tviTemp.insertPage(sFolder3,"js�ű�","",4);
	String sFolder7=tviTemp.insertFolder(sFolder1,"Main��ͼ","",4);
	tviTemp.insertPage(sFolder7,"һ��Main","",1);
	tviTemp.insertPage(sFolder7,"������������Main","",2);
	
	String sFolder4=tviTemp.insertFolder("root","��ͼ���","",3);
	tviTemp.insertPage(sFolder4,"��������","",1);
	tviTemp.insertPage(sFolder4,"��������","",2);
	tviTemp.insertPage(sFolder4,"��������","",3);
	tviTemp.insertPage(sFolder4,"��������","",4);
	tviTemp.insertPage(sFolder4,"Tab","",5);
	tviTemp.insertPage(sFolder4,"Strip","",6);
	
	String sFolder5 = tviTemp.insertFolder("root","���󴰿�(ObjectWindow)","",4);
	String sFolder51=tviTemp.insertFolder(sFolder5,"List��ʾ","",1);
	tviTemp.insertPage(sFolder51,"���б�[��������ͷ����]","",1);
	tviTemp.insertPage(sFolder51,"��ѡ�б�","",2);
	tviTemp.insertPage(sFolder51,"�༭�б�","",3);
	tviTemp.insertPage(sFolder51,"���ݵ���","",4);
	tviTemp.insertPage(sFolder51,"����jbo��������","",5);
	tviTemp.insertPage(sFolder51,"��ͼ���jbo��������","",6);
	tviTemp.insertPage(sFolder51,"�б���� С�ơ��ϼ�","",7);
	tviTemp.insertPage(sFolder51,"�Զ����б���ʽ","",8);
	tviTemp.insertPage(sFolder51,"�Զ���HTML�¼�","",9);
	tviTemp.insertPage(sFolder51,"����������������","",10);
	tviTemp.insertPage(sFolder51,"�Զ���������Դ","",11);
	tviTemp.insertPage(sFolder51,"�Զ��������˵�","",12);
	tviTemp.insertPage(sFolder51,"ÿ�з��Զ��尴ť","",13);
	tviTemp.insertPage(sFolder51,"�б��Զ����������","",14);
	String sFolder52=tviTemp.insertFolder(sFolder5,"Info��ʾ","",2);
	tviTemp.insertPage(sFolder52,"��Info","",1);
	tviTemp.insertPage(sFolder52,"�Զ���HTML�¼�(Info)","",2);
	tviTemp.insertPage(sFolder52,"�������","",3);
	tviTemp.insertPage(sFolder52,"���ڿؼ������Զ���","",4);
	tviTemp.insertPage(sFolder52,"����js�ű�","",5);
	tviTemp.insertPage(sFolder52,"ǰ��ͳһ�Զ���У��","",6);
	tviTemp.insertPage(sFolder52,"�Զ��������˵�(Info)","",7);
	tviTemp.insertPage(sFolder52,"����ҳ��","",8);
	tviTemp.insertPage(sFolder52,"���ǿؼ�","",9);
	
	String sFolder6 = tviTemp.insertFolder("root","SWFͼ��","",5);
	tviTemp.insertPage(sFolder6,"bar","",1);
	tviTemp.insertPage(sFolder6,"bar_stack","",2);
	tviTemp.insertPage(sFolder6,"hbar","",3);
	tviTemp.insertPage(sFolder6,"line","",4);
	tviTemp.insertPage(sFolder6,"area_hollow","",5);
	tviTemp.insertPage(sFolder6,"pie","",6);
	tviTemp.insertPage(sFolder6,"Chart����д��","",7);
	tviTemp.insertPage(sFolder6,"�Ǳ���","",8);
	tviTemp.insertPage(sFolder6,"DragNode","",9);
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	<%/*treeview����ѡ���¼�;���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������*/%>
	function TreeViewOnClick(){
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=='DW���ݹ�����'){
			AsControl.OpenView("/FrameCase/ExampleList08.jsp","","right","");
		}else if(sCurItemname=='DW����У��'){
			AsControl.OpenView("/FrameCase/ExampleInfo03.jsp","ExampleId=2013012300000001","right","");
		}else if(sCurItemname=='DWǰ��/�����¼�(����)'){
			AsControl.OpenView("/FrameCase/ExampleInfo04.jsp","ExampleId=2013012300000001","right","");
		}else if(sCurItemname=='DW�����¼�'){
			AsControl.OpenView("/FrameCase/ExampleList04.jsp","","right","");
		}else if(sCurItemname=='DW�Զ��嵥Ԫ���¼�'){
			AsControl.OpenView("/FrameCase/ExampleInfo05.jsp","ExampleId=2013012300000001","right","");
		}else if(sCurItemname=='���鶨�尴ť'){
			AsControl.OpenView("/FrameCase/ExampleButtonArray.jsp","","right","");
		}else if(sCurItemname=='Ӳ���밴ť'){
			AsControl.OpenView("/FrameCase/ExampleButtonHardCoding.jsp","","right","");
		}else if(sCurItemname=='SQL������ͼ'){
			AsControl.PopView("/FrameCase/ExampleView.jsp","ViewId=001","","");
		}else if(sCurItemname=='����������ͼ'){
			AsControl.PopView("/FrameCase/ExampleView01.jsp","ViewId=001","","");
		}else if(sCurItemname=='�ֹ�������ͼ'){
			AsControl.PopView("/FrameCase/ExampleView02.jsp","ViewId=001","","");
		}else if(sCurItemname=='��ѡ��ͼ'){
			AsControl.OpenView("/FrameCase/ExampleView04.jsp", "", "right", "");
		}else if(sCurItemname=='��ͼ/�б���ѡ���'){
			AsControl.OpenView("/FrameCase/ExampleSelect.jsp","","right","");
		}else if(sCurItemname=='����ѡ��'){
			AsControl.OpenView("/FrameCase/ExampleCalendar.jsp","","right");
		}else if(sCurItemname=='����List'){
			AsControl.OpenView("/FrameCase/ExampleList.jsp","","right","");
		}else if(sCurItemname=='��ѡList'){
			AsControl.OpenView("/FrameCase/ExampleList02.jsp","","right","");
		}else if(sCurItemname=='����List'){
			AsControl.OpenView("/FrameCase/ExampleList03.jsp","","right","");
		}else if(sCurItemname=='����Info'){
			AsControl.OpenView("/FrameCase/ExampleInfo.jsp","ExampleId=2013012300000001","right","");
		}else if(sCurItemname=='��Ϣ����'){
			AsControl.OpenView("/FrameCase/ExampleInfo01.jsp","ExampleId=2013012300000001","right","");
		}else if(sCurItemname=='InfoУ��'){
			AsControl.OpenView("/FrameCase/ExampleInfoWithValid.jsp","","right","");
		}else if(sCurItemname=='js�ű�'){
			AsControl.OpenView("/FrameCase/ExampleSpecJS.jsp","","right","");
		}else if(sCurItemname=='һ��Main'){
			AsControl.OpenView("/FrameCase/ExampleMain01.jsp","ComponentName=һ��Main&ComponentType=MainWindow","_self","");
		}else if(sCurItemname=='������������Main'){
			AsControl.OpenView("/FrameCase/ExampleMain02.jsp","ComponentName=������������Main&ComponentType=MainWindow","_self","");
		}else if(sCurItemname=='��������'){
			AsControl.OpenView("/FrameCase/ExampleFrame01.jsp","","right","");
		}else if(sCurItemname=='��������'){
			AsControl.OpenView("/FrameCase/ExampleFrame02.jsp","","right","");
		}else if(sCurItemname=='��������'){
			AsControl.OpenView("/FrameCase/ExampleFrame.jsp","","right","");
		}else if(sCurItemname=='��������'){
			AsControl.OpenView("/FrameCase/ExampleFrame03.jsp","","right","");
		}else if(sCurItemname=='Tab'){
			AsControl.OpenView("/FrameCase/ExampleTab.jsp","","right","");
		}else if(sCurItemname=='Strip'){
			AsControl.OpenView("/FrameCase/ExampleStrip.jsp","","right","");
		}
		else if(sCurItemname=='���б�[��������ͷ����]'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListSimple.jsp","","right");
		}
		else if(sCurItemname=='��ѡ�б�'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListMulty.jsp","","right");
		}
		else if(sCurItemname=='�༭�б�'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListEdit.jsp","","right");
		}
		else if(sCurItemname=='���ݵ���'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListExport.jsp","","right");
		}
		else if(sCurItemname=='����jbo��������'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListSimpleJBO.jsp","","right");
		}
		else if(sCurItemname=='��ͼ���jbo��������'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListSimpleJBO3.jsp","","right");
		}
		else if(sCurItemname=='�б���� С�ơ��ϼ�'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListCount.jsp","","right");
		}
		else if(sCurItemname=='�Զ����б���ʽ'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListRegular.jsp","","right");
		}
		else if(sCurItemname=='�Զ���HTML�¼�'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListEvent2.jsp","","right");
		}
		else if(sCurItemname=='����������������'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListSimpleArray.jsp","","right");
		}
		else if(sCurItemname=='�Զ���������Դ'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListCustomDataSource2.jsp","","right");
		}
		else if(sCurItemname=='�Զ��������˵�'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListDMenu.jsp","","right");
		}
		else if(sCurItemname=='ÿ�з��Զ��尴ť'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListWithAction.jsp","","right");
		}
		else if(sCurItemname=='�б��Զ����������'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoCustomListFilter.jsp","","right");
		}
		else if(sCurItemname=='��Info'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoInfoSimple.jsp","","right");
		}
		else if(sCurItemname=='�Զ���HTML�¼�(Info)'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoInfoEvent2.jsp","","right");
		}
		else if(sCurItemname=='�������'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoInfoGroup.jsp","","right");
		}
		else if(sCurItemname=='���ڿؼ������Զ���'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoInfoCalendarWidget.jsp","","right");
		}
		else if(sCurItemname=='����js�ű�'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoInfoSp.jsp","","right");
		}
		else if(sCurItemname=='ǰ��ͳһ�Զ���У��'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoInfoCValid.jsp","","right");
		}
		else if(sCurItemname=='�Զ��������˵�(Info)'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoInfoDMenu.jsp","","right");
		}
		else if(sCurItemname=='����ҳ��'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoMultiPage.jsp","","right");
		}
		else if(sCurItemname=='���ǿؼ�'){
			AsControl.OpenView("/FrameCase/widget/dw/FiveStarMark.jsp","","right");
		}
		else if(sCurItemname=='bar'){
			AsControl.OpenView("/FrameCase/Chart/ChartData.jsp","GraphType=bar","right");
		}
		else if(sCurItemname=='bar_stack'){
			AsControl.OpenView("/FrameCase/Chart/ChartData.jsp","GraphType=bar_stack","right");
		}
		else if(sCurItemname=='hbar'){
			AsControl.OpenView("/FrameCase/Chart/ChartData.jsp","GraphType=hbar","right");
		}
		else if(sCurItemname=='line'){
			AsControl.OpenView("/FrameCase/Chart/ChartData.jsp","GraphType=line","right");
		}
		else if(sCurItemname=='area_hollow'){
			AsControl.OpenView("/FrameCase/Chart/ChartData.jsp","GraphType=area_hollow","right");
		}
		else if(sCurItemname=='pie'){
			AsControl.OpenView("/FrameCase/Chart/ChartData.jsp","GraphType=pie","right");
		}
		else if(sCurItemname=='Chart����д��'){
			AsControl.OpenView("/FrameCase/Chart/ChartDataFile.jsp","GraphType=bar","right");
		}
		else if(sCurItemname=='�Ǳ���'){
			AsControl.OpenView("/FrameCase/Chart/CharDial.jsp","GraphType=bar","right");
		}
		else if(sCurItemname=='DragNode'){
			AsControl.OpenView("/FrameCase/Chart/DragNodeData.jsp","","right");
		}
		else{
			return;
		}
		setTitle(getCurTVItem().name);
	}
	
	<%/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/%>
	function initTreeVeiw(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("Border");
		selectItemByName("����List");
		selectItemByName("����Info");	//Ĭ�ϴ򿪵�(Ҷ��)ѡ��
		myleft.width = 250;
	}

	initTreeVeiw();
</script>
<%@ include file="/IncludeEnd.jsp"%>