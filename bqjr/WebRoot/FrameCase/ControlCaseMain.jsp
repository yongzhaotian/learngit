<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	ҳ��˵��:ϵͳ�ڽ���ģʽʾ����ҳ��
 */
	String PG_TITLE = "ϵͳ�ڽ���ģʽʾ��"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;ϵͳ�ڽ���ģʽʾ��&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//���ҳ�����	

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ϵͳ�ڽ���ģʽ","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	//������ͼ�ṹ
	String sFolder1=tviTemp.insertFolder("root","ҳ��������","",1);
	tviTemp.insertPage(sFolder1,"OpenViewʾ��","",1);
	tviTemp.insertPage(sFolder1,"PopViewʾ��","",2);
	String sFolder2=tviTemp.insertFolder("root","�������˷�������","",2);
	tviTemp.insertPage(sFolder2,"RunJavaMethodʾ��","",1);
	tviTemp.insertPage(sFolder2,"RunJavaMethodSqlcaʾ��","",2);
	tviTemp.insertPage(sFolder2,"RunJavaMethodTransʾ��","",3);
	String sFolder3=tviTemp.insertFolder("root","���Ƽ�ʹ��","",3);
	tviTemp.insertPage(sFolder3,"OpenPageʾ��","",1);
	tviTemp.insertPage(sFolder3,"PopPageʾ��","",2);
	tviTemp.insertPage(sFolder3,"RunMethodʾ��","",3);
	tviTemp.insertPage(sFolder3,"PopPageAjaxʾ��","",4);
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	
	<%/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/%>
	function TreeViewOnClick(){
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=='OpenViewʾ��'){
			//var text = "OpenComp(sCompID,sCompURL,sPara,sTargetWindow,sStyle)";//���ڵ�д����Ϊ�˼��ݶ�����
			//OpenComp("ExampleControl","/FrameCase/ExampleControl.jsp","ShowText="+text,"right","");
			var text = "AsControl.OpenView(sURL,sPara,sTargetWindow,sStyle)";//Ӧ����ôд
			AsControl.OpenView("/FrameCase/ExampleControl.jsp","ShowText="+text,"right","");
		}else if(sCurItemname=='PopViewʾ��'){
			//var text = "PopComp(sComponentID,sComponentURL,sParaString,sStyle,sDialogParameters)";//���ڵ�д����Ϊ�˼��ݶ�����
			//PopComp("ExampleControl","/FrameCase/ExampleControl.jsp","ShowText="+text,"","");
			var text = "AsControl.PopView(sURL,sPara,sStyle)";//Ӧ����ôд
			AsControl.PopView("/FrameCase/ExampleControl.jsp","ShowText="+text,"");
		}else if(sCurItemname=='RunJavaMethodʾ��'){
			AsControl.OpenView("/FrameCase/ExampleMethod.jsp","Flag=2","right","");
		}else if(sCurItemname=='RunJavaMethodSqlcaʾ��'){
			AsControl.OpenView("/FrameCase/ExampleMethod.jsp","Flag=3","right","");
		}else if(sCurItemname=='RunJavaMethodTransʾ��'){
			AsControl.OpenView("/FrameCase/ExampleMethod.jsp","Flag=4","right","");
		}else if(sCurItemname=='RunMethodʾ��'){
			AsControl.OpenView("/FrameCase/ExampleMethod.jsp","Flag=1","right","");
		}else if(sCurItemname=='OpenPageʾ��'){
			var text = "OpenPage(sURL,sTargetWindow,sStyle)";
			OpenPage("/FrameCase/ExampleControl.jsp?ShowText="+text,"top","");
		}else if(sCurItemname=='PopPageʾ��'){
			var text = "PopPage(sURL,sTargetWindow,sStyle)";
			PopPage("/FrameCase/ExampleControl.jsp?ShowText="+text,"","");
		}else if(sCurItemname=='PopPageAjaxʾ��'){//PopPageAjax���Ƽ�ʹ��,����ȫ������RunJavaMethod�������������
			var text = "PopPageAjax(sURL,sTargetWindow,sStyle)";
			AsControl.OpenView("/FrameCase/ExampleControl.jsp","Flag=1&ShowText="+text,"right","");
		}else{
			return;
		}
		setTitle(getCurTVItem().name);
	}
	
	<%/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("�������˷�������");
		selectItemByName("OpenViewʾ��");	//Ĭ�ϴ򿪵�(Ҷ��)ѡ��
	}

	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>