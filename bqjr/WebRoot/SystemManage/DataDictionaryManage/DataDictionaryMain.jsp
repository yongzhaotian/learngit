<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��:�����ֵ������ͼ
		author: yzheng
		date: 2013-6-6
	 */
	String PG_TITLE = "�����ֵ������ҳ��"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�����ֵ����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//���ҳ�����
// 	String sExampleID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));

	//�������
	String templateURL = "/SystemManage/DataDictionaryManage/DataDictionaryTemplateList.jsp";
	String codeURL = "/SystemManage/DataDictionaryManage/DataDictionaryCodeFrame.jsp";
	String tableURL = "/SystemManage/DataDictionaryManage/DataDictionaryTableFrame.jsp";
	String tableColURL = "/SystemManage/DataDictionaryManage/DataDictionaryTableColList.jsp";
	
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�����ֵ������ͼ","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sFolder1=tviTemp.insertFolder("root","�����ֵ����","",1);
	String DW_Template = tviTemp.insertPage(sFolder1,"ģ��", templateURL,"",2);
	String code = tviTemp.insertPage(sFolder1,"����",codeURL,"",3);
	String DB_Table = tviTemp.insertPage(sFolder1,"��",tableURL,"",4);
	String DB_TableCol = tviTemp.insertPage(sFolder1,"�ֶ�",tableColURL,"",5);
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	function openChildComp(sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		/*
		 * ������������
		 * ToInheritObj:�Ƿ񽫶����Ȩ��״̬��ر��������������
		 * OpenerFunctionName:�����Զ�ע�����������REG_FUNCTION_DEF.TargetComp��
		 */
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		AsControl.OpenView(sURL,sParaStringTmp,"right");
	}
	
	//treeview����ѡ���¼�
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		var nodeURL = getCurTVItem().value;

		//alert(sCurItemID);
		if(sCurItemID != "1"){  //�ų����ڵ�
			openChildComp(nodeURL, "");
		}
		setTitle(sCurItemname);
	}
	
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		expandNode('1');  //չ�����ڵ�
		selectItem('2');  //Ԥѡ��ģ��ڵ�
	}
		
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>