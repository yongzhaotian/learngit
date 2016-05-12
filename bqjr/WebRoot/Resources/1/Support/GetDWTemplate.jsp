<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Resources/Include/IncludeBeginDWAJAX.jspf"%>
<%@page import="com.amarsoft.app.util.TemplateExport"%>
<%
	String sDWName = DataConvert.toRealString(iPostChange,(String)request.getParameter("dw"));
	String sType = DataConvert.toRealString(iPostChange,(String)request.getParameter("type"));

	ASResultSet rs = null;
	if(sDWName!=null && !sDWName.equals("")){
		ASDataWindow dwTemp = Component.getDW(sSessionID);
	
		Vector columns = dwTemp.DataObject.Columns;
		Vector tempElements = new Vector();
		for(int i=0;i<columns.size();i++){
			String tmp = "";
			//0  ����
			//1  ���뷽ʽ
			//2  ������Դ
			//3  ��ʾ��ʽ
			//4  ������
			//5  ����˵��
			//6 ��ע
			String[] elem = new String[7];
			ASColumn col = (ASColumn)columns.get(i);
			boolean isDDW = false;
			String sVisiable = col.getAttribute("Visible");
			//���Ϊ����ʾ�ģ�������ʾ��
			if(sVisiable == null) sVisiable = "";
			if(!sVisiable.equals("1")){
				continue;
			}
			//0 ����
			elem[0] = col.getAttribute("Header");
			//1 ���뷽ʽ
			elem[1] = (String)col.getAttribute("EditStyle");
			if(elem[1]== null) elem[1] = "";
			if(elem[1].equals("1")){
				elem[1] = "�ı���";
				//���Ϊ�ı����ټ���Ƿ������˸���ť��������˰�ť����Ϊѡ���
				String sExts = (String)col.getAttribute("Unit");
				if(sExts == null) sExts = "";
				if(sExts.indexOf("<input") >= 0&&sExts.indexOf("type=button") >= 0){
					elem[1] = "ѡ���";
				}
			}else if(elem[1].equals("2")){
				elem[1] = "�����б�";
				isDDW = true;
			}else if(elem[1].equals("3")){
				elem[1] = "�ı���";
			}else{
				elem[1] = "**������**";
			}
			//2 ������Դ
			elem[2] = (String)col.getAttribute("ReadOnly");
			if(elem[2]== null) elem[2] = "";
			if(elem[2].equals("1")){
				elem[2] = "�Զ���ʾ";
			}else if(elem[2].equals("0")){
				elem[2] = "�ֹ�����";
			}else{
				elem[2] = "**������**";
			}
			//3 ��ʾ��ʽ
			elem[3] = (String)col.getAttribute("CheckFormat");
			if(elem[3]== null) elem[3] = "";
			if(elem[3].equals("1")){
				elem[3] = "�ַ���";
			}else if(elem[3].equals("2")){
				elem[3] = "����";
			}else if(elem[3].equals("3")){
				elem[3] = "����";
			}else if(elem[3].equals("4")){
				elem[3] = "ʱ��";
			}else if(elem[3].equals("5")){
				elem[3] = "����";
			}else{
				if(Integer.parseInt(elem[3])>=10){
					elem[3] = "����";
				}else{
					elem[3] = "**������**";
				}
			}
			//4 ������
			elem[4] = (String)col.getAttribute("Required");
			if(elem[4]== null) elem[4] = "";
			if(elem[4].equals("1")){
				elem[4] = "��";
			}else if(elem[4].equals("0")){
				elem[4] = "��";
			}else{
				elem[4] = "**������**"; 
			}
			//5 ����˵��
			elem[5] = (String)col.getAttribute("Unit");
			if(elem[5]== null) elem[5] = "";
			if(elem[5].indexOf("(���� M)")>0){
				elem[5] = "������(M)";
			}else if(elem[5].indexOf("(���� C)")>0){
				elem[5] = "������ѡ��(C)";
			}else if(elem[5].indexOf("(���� O)")>0){
				elem[5] = "��ѡ(O)";
			}else{
				elem[5] = "";
			}
			//��ע�ֶδ���
			//1.�����������������ע��ʾ��������Ϣ
			//2.���û���������������Ƿ���������ص�λ���磺Ԫ���£���ȣ�
			//a.�ȼ���Ƿ�Ϊ������
			String sRemark = "";
			if(isDDW){
				//��� Ϊ������������������Դ
				String s = (String)col.getAttribute("EditSource");
				String sSourceType = s.split(":")[0];
				String sSource = s.split(":")[1];
				
				if(sSourceType == null) sSourceType = "";
				if(sSource == null) sSource = "";
				//���Ϊ���룬��ȡ����ֵ
				if(sSourceType.equalsIgnoreCase("Code")){
					sRemark = "�б������";
					rs = Sqlca.getASResultSet("select ItemName from CODE_LIBRARY where CodeNo='"+sSource+"' order by sortno asc");
					boolean f = true;
					int count=0;
					while(rs.next()){
						if(f)sRemark += "<br/>&nbsp;&nbsp;"+rs.getString("ItemName");
						else sRemark += "<br/>&nbsp;&nbsp;"+rs.getString("ItemName");
						f = false;
						count++;
					}
					rs.getStatement().close();
					rs = null;
					if(count>5){
						sRemark = "�ο������"+sSource;
					}
				}else if(sSourceType.equalsIgnoreCase("CodeTable")){
					sRemark = "�б������&nbsp;&nbsp;"+sSource;
				}else if(sSourceType.equalsIgnoreCase("SQL")){
					sRemark = "�б������&nbsp;&nbsp;";
					rs = Sqlca.getASResultSet(sSource);
					boolean f = true;
					int count=0;
					while(rs.next()){
						if(f)sRemark += "<br/>&nbsp;&nbsp;"+rs.getString(2);
						else sRemark += "<br/>&nbsp;&nbsp;"+rs.getString(2);
						f = false;
						count++;
					}
					rs.getStatement().close();
					rs = null;
					if(count>5){
						sRemark = "�ο������"+sSource;
					}
				}
			}else{
				String sUnit = (String)col.getAttribute("Unit");
				if(sUnit == null) sUnit = "";
				if(sUnit.indexOf("��")>=0 ||sUnit.indexOf("��")>=0 ||sUnit.indexOf("��")>=0
						||sUnit.indexOf("Ԫ")>=0 ||sUnit.indexOf("��")>=0 ||sUnit.indexOf("��")>=0
						||sUnit.indexOf("ƽ����")>=0 ||sUnit.indexOf("��")>=0){
					sRemark = "��λ��"+sUnit;
				}else if(sUnit.indexOf("%")>=0 ||sUnit.indexOf("��")>=0 ||sUnit.indexOf("��")>=0){
					sRemark = "��׺��"+sUnit;
				}
			}
			elem[6] = sRemark;
			tempElements.add(elem);
		}
		//sPhyRealPath = request.getSession(true).getServletContext().getRealPath("/DownLoad");
		Configure curConfig = Configure.getInstance(application);
		if(curConfig ==null) throw new Exception("��ȡ�����ļ����������Ӧxml�ļ�");
		String sPhyRealPath = curConfig.getConfigure("DWDownloadFilePath");
    	if(sPhyRealPath ==null) sPhyRealPath = "/tmp/DownLoad";
    	sPhyRealPath += "/Template";
		
		//�����ļ�
		TemplateExport te = new TemplateExport(sPhyRealPath);
		String sFile = te.genFile(tempElements,".xls");
%>
<html>
<head><title>���Ժ�...</title></head>
<body>
<div align=center>
<br>
<font style="font-size:9pt;color:red">���ڴӷ�������ȡ����,���Ժ�...</font>
</div>
<iframe name="MyAtt" src="<%=com.amarsoft.awe.util.Escape.getBlankJsp(sWebRootPath,"�������أ����Ժ�...")%>" width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>
<form name=form1 method=post action=<%=sWebRootPath%>/servlet/view/file target=MyAtt>
	<div style="display:none">
		<input name=filename value="<%=sFile%>">
		<input name=contenttype value="application/x-zip-compressed">
		<input name=viewtype value="download">
	</div>
</form>
<%
	}
%>
</body>
</html>
<script type="text/javascript">
	form1.submit();
	
	setTimeout('closeTop();',2000);	
	function closeTop(){
		top.close();
	}
</script>
<%@ include file="/Resources/Include/IncludeTail.jspf"%>