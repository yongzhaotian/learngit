<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	/*
		ҳ��˵��: ���ұ�׼��ҵѡ��
	 */
	String sIndustryTypeValue = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("IndustryTypeValue"));
	String sIndustryType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("IndustryType"));
	String sOpen = "";
	String sDefaultItem = "";
	//�����жϣ���ֹ���� null���� add by jbye 2009/03/30
	if(sIndustryType.length()>3) sDefaultItem = sIndustryType.substring(0,3);
	if(sIndustryType!=null&&sIndustryType.length()>3) sOpen = "YES";
%>
<html>
<head>
<title>��ѡ����ҵ����</title>
<style>
.black9pt {font-size: 11pt; font-weight: bolder; color: #000000; text-decoration: none;}
</style>
</head>
<script type="text/javascript">
	//��ȡ�û�ѡ�����ҵ����
	function TreeViewOnClick(){
		var sIndustryType=getCurTVItem().id;
		var sIndustryTypeName=getCurTVItem().name;
		buff.IndustryType.value=sIndustryType+"@"+sIndustryTypeName;
		//ѡ�������ҵ����ʱ�����Զ������ұ߽�Ŀ
	<%	if(sIndustryTypeValue == null){	%>
			newBusiness();
	<%	}%>
	}
	
	//modify by hwang,�޸�˫����Ӧ������function TreeViewOnDBClick()�޸�Ϊfunction TreeViewOnDBLClick() 
	function TreeViewOnDBLClick(){
		newBusiness();
	}

	//��ѡһ����ҵ����
	function newBusiness(){
	//ѡ�������ҵ����ʱ�����Զ������ұ߽�Ŀ
	<%	if(sIndustryTypeValue == null){	%>
			if(buff.IndustryType.value!=""){
				sReturnValue = buff.IndustryType.value;
				parent.OpenPage("/Common/ToolsA/IndustryTypeSelect.jsp?IndustryTypeValue="+getCurTVItem().id,"frameright","");
			}else{
				alert(getBusinessMessage('247'));//��ѡ����ҵ����ϸ�
			}
	<%	}else{ %>
			var s,sValue,sName;
			var sReturnValue = "";
			s=buff.IndustryType.value;
			s = s.split('@');
			sValue = s[0];
			sName = s[1];
			if((sValue=="C371")||(sValue=="C372")||(sValue=="C375")||(sValue=="C376")||(sValue=="F553")||(sValue=="L741")){
				alert(getBusinessMessage('248'));//��ѡ�����ҵ��Ҫϸ�ֵ�С�࣡
			}else{
				if(buff.IndustryType.value.length<3){
					alert(getBusinessMessage('247'));//��ѡ����ҵ����ϸ�
				}else{
					if(sValue.length==5){
						top.returnValue = buff.IndustryType.value;
						top.close();
					}else{
						alert(getBusinessMessage('247'));//��ѡ����ҵ����ϸ�
					}
				}
			}
	<%	}%>
	}
	//��չ��ܵ�ʵ��
	function clearAll(){
		top.returnValue='_CLEAR_';
		top.close();
	}

	function goBack(){
		top.close();
	}
	//����ѯ������ҵ���Ͱ���TreeViewչʾ
	function startMenu(){
	<%
		HTMLTreeView tviTemp = new HTMLTreeView("��ҵ�����б�","right");
		tviTemp.TriggerClickEvent=true;
		//ѡ����ҵ����һ
		if(sIndustryTypeValue == null)
			tviTemp.initWithSql("ItemNo","ItemName","ItemNo","","from Code_Library where CodeNO='IndustryType' and length(ItemNo) <= 3",Sqlca);
		else
			tviTemp.initWithSql("ItemNo","ItemName","ItemNo","","from Code_Library where CodeNO='IndustryType' and ItemNo like '"+sIndustryTypeValue+"%'",Sqlca);
		
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		out.println(tviTemp.generateHTMLTreeView());
	%>
	}
</script>

<body bgcolor="#DCDCDC">
<center>
<form  name="buff">
<input type="hidden" name="IndustryType" value="">
<table width="90%" align=center border='1' height="98%" cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
<tr>
	<td id="myleft"  colspan='3' align=center width=100%><iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe></td>
</tr>
<tr height=4%>
	<%
		if(sIndustryTypeValue == null){
	%>
	<span class="STYLE9"></span>
	<p align="left" class="black9pt">��ҵ���ʹ���</p>
	<td nowrap align="right" class="black9pt" bgcolor="#F0F1DE" ></td>
	<%
		}else{
	%>
	<span class="STYLE9"></span>
	<p align="left" class="black9pt">��ҵ��������</p>
	<td nowrap align="center" valign="baseline">
		<table>
	        <tr>
		       <td><%=HTMLControls.generateButton("ȷ��","ȷ��","javascript:newBusiness()",sResourcesPath)%></td>
		       <td><%=HTMLControls.generateButton("ȡ��","ȡ��","javascript:goBack()",sResourcesPath)%></td>
		       <td><%=HTMLControls.generateButton("���","���","javascript:clearAll()",sResourcesPath)%></td>
	        </tr>
	    </table>
	</td>
	<%}%>
</tr>
</table>
</form>
</center>
</body>
</html>
<script type="text/javascript">
	startMenu();
	// Ctrl + F�����һ������Ϊ���õķ�����ǰ��Ĳ�����Ϊ����ֵ
	setQuick(17, 70, showTVSearch);
	expandNode('root');
	selectItem('<%=sDefaultItem%>');//�Զ������ͼ��Ŀǰд����Ҳ�������õ� code_library�н����趨
	selectItem('<%=sIndustryType%>');//�Զ������ͼ��Ŀǰд����Ҳ�������õ� code_library�н����趨
	expandNode('<%=sIndustryTypeValue%>');
</script>
<%@ include file="/IncludeEnd.jsp"%>