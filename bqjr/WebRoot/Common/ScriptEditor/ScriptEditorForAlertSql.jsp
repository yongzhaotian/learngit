<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMD.jsp"%><%
	String sScriptText = CurComp.getParameter("ScriptText",10);
	String sSqlObjectType = CurComp.getParameter("SqlObjectType",10);
	if (sScriptText==null) sScriptText="";
	sScriptText = StringFunction.replace(sScriptText,"$[wave]","~");

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	//tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	int i=0;
	int j=0;
	String sFolder = "";
	String sSql2="";
	ASResultSet rs2=null;
	String sSql="select ObjectName,ObjectType from OBJECTTYPE_CATALOG where ObjectType =:ObjectType";
	ASResultSet rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType",sSqlObjectType));
	while(rs.next()){
	    j=0;
	    sFolder = tviTemp.insertFolder("root",rs.getString(1),"",i++);
	    sSql2 = "select distinct AttributeName,'<font color=red>{'||ObjectType||'}</font>.{'||AttributeName||'} ('||'MethodArgs' ||')',ltrim(rtrim(AttributeDescribe)),ltrim(rtrim(Remark)),SortNo from OBJECT_ATTRIBUTE "+
	            "where ObjectType=:ObjectType order by SortNo";
		//out.println(sSql2);
		//if(1==1) return;
		rs2 = Sqlca.getASResultSet(new SqlObject(sSql2).setParameter("ObjectType",rs.getString(2)));
	    while (rs2.next()){
	        tviTemp.insertPage(sFolder,rs2.getString(1),"javascript:parent.mySelection(\""+DataConvert.toString(rs.getString(1))+"\",\""+DataConvert.toString(rs2.getString(1))+"\",\""+DataConvert.toString(rs2.getString(2))+"\",\""+DataConvert.toString(rs2.getString(3))+"\",\""+DataConvert.toString(rs2.getString(4))+"\")",j++);
	    }
	    rs2.getStatement().close();
	}
	rs.getStatement().close();
%>
<HTML>
<html>
<head>
<title></title>
</head>

<body leftmargin="0" topmargin="0" class="windowbackground" onload="">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
	<tr height=1>
	    <td>
            <table>
                <tr>
                    <td >
                        <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","ȷ��","ȷ��","translateScriptText()",sResourcesPath)%>
                    </td>
                    <td>
                        <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","ȡ��","ȡ��","cancel()",sResourcesPath)%>
                    </td>
                    <td id="showTreeButtonTD">
                        <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��ʾ���������б�","��ʾ���������б�","showTree()",sResourcesPath)%>
                    </td>
                </tr>
            </table>
	    </td>
	</tr>
	<tr>
		<td valign="top">
			<table  border="0" cellspacing="0" cellpadding="0" width="100%" height="100%" class="content_table"  id="content_table">
				<tr> 
					<td id="myleft_left_top_corner" class="myleft_left_top_corner"></td>
					<td id="myleft_top" class="myleft_top"></td>
					<td id="myleft_right_top_corner" class="myleft_right_top_corner"></td>
					<td id="mycenter_top" class="mycenter_top"></td>
					<td id="myright_left_top_corner" class="myright_left_top_corner"></td>
					<td id="myright_top" class="myright_top"></td>
					<td id="myright_right_top_corner" class="myright_right_top_corner"></td>
				</tr>
				<tr> 
					<td id="myleft_leftMargin" class="myleft_leftMargin"></td>
					<td id="myleft" width=20%> 
						<iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe>
					</td>
					<td id="myleft_rightMargin" class="myleft_rightMargin"> </td>
					<td id="mycenter" class="mycenter">
						<div id=divDrag title='����ק�ı䴰�ڴ�С Drag to resize' style="z-index:0; CURSOR: url('<%=sResourcesPath%>/ve_split.cur') "	ondrag="if(event.x>16 && event.x<400) {myleft_top.style.display='block';myleft.style.display='block';myleft_bottom.style.display='block';myleft.width=event.x-6;}if(event.x<=16 && event.y>=4) {myleft_top.style.display='none';myleft.style.display='none';myleft_bottom.style.display='none';}if(event.x<4) window.event.returnValue = false;">
							<!--img name=imgDrag title='������' height=100% width=3 src="<%=sResourcesPath%>/line.gif"-->
							<img class=imgDrag src=<%=sResourcesPath%>/1x1.gif width="1" height="1">
						</div>
					</td>
					<td id="myright_leftMargin" class="myright_leftMargin"></td>
					<td id="myright" class="myright">
						<div  class="RightContentDiv" id="RightContentDiv"> 
							<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
								<tr> 
									<td colspan=2 id="myHelpText" height=10 class='Help_TextArea'>  ����
									</td>
								</tr>
                                <tr> 
									<td colspan=2 > 
										<div name="tt" class="groupboxmaxcontent" style="position:absolute; width: 100%;height:100%" id="window1"> 
                                        <iframe name="right" style="display:none"></iframe>
                                        <TEXTAREA name="myTextArea" ROWS="35" COLS="100" ONSELECT="storeCaret(this);" onCLICK="storeCaret(this);" onKEYUP="storeCaret(this);" WRAP=soft class="Script_TextArea"></TEXTAREA>
										</div>
									</td>
								</tr>
							</table>
						</div>
					</td>
					<td id="myright_rightMargin" class="myright_rightMargin"></td>
				</tr>
				<tr>
					<td id="myleft_left_bottom_corner" class="myleft_left_bottom_corner"></td>
					<td id="myleft_bottom" class="myleft_bottom"></td>
					<td id="myleft_right_bottom_corner" class="myleft_right_bottom_corner"></td>
					<td id="mycenter_bottom" class="mycenter_bottom"></td>
					<td id="myright_left_bottom_corner" class="myright_left_bottom_corner"></td>
					<td id="myright_bottom" class="myright_bottom"></td>
					<td id="myright_right_bottom_corner" class="myright_right_bottom_corner"></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</body>
</html>

<script type="text/javascript">
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
    
    function translateScriptText(){
		top.returnValue = amarsoft2Real(document.all("myTextArea").value);
		top.close();
    }
	
    function cancel(){
    	top.close();
	}
    
    //ѡ���������͡�������
	function clickMyColOption(sPara1,sPara2){
        sCurOptValue=sPara1;
        sCurOptName=sPara2;
    }

    function mySelection(sObjectTypeName,sAttributeName,sMethod,sAttributeDescribe,sRemark){
        var sReturnValue="{"+sObjectTypeName+"}.{"+sAttributeName+"}";
        var sHelpText=sReturnValue+"<br>"+sAttributeDescribe+"<br>"+sRemark;
        sHelpText = sHelpText+"<br><br><a href=\"javascript:insertHelp('"+sReturnValue+"')\"><font color=red>�����괦</font></a>";
//        alert(sHelpText);
        document.all("myHelpText").innerHTML=sHelpText;
    }
    
	function insertHelp(tmp){
        insertAtCaret(document.all("myTextArea"),tmp);
    }

    //ȷ��ѡ���λ��
    function storeCaret (textEl) { 
	    if (textEl.createTextRange) 
	        textEl.caretPos = document.selection.createRange().duplicate(); 
    } 
    
    //��������
    function insertAtCaret (textEl, text) { 
	    if (textEl.createTextRange && textEl.caretPos) { 
	        var caretPos = textEl.caretPos; 
	        caretPos.text =text; 
	    }else 
	        textEl.value = textEl.value+text; 
    } 
    
    //����String.replace���������ַ����������ߵĿո��滻�ɿ��ַ���
	function Trim (sTmp){
        return sTmp.replace(/^(\s+)/,"").replace(/(\s+)$/,"");
    }
    
	function showTree(){
		myleft.width=200;
		startMenu();
		expandNode('root');
		showTreeButtonTD.style.display="none";
	}
</script>

<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Tree06;Describe=��ҳ��װ��ʱִ��,��ʼ��]~*/%>
	<script type="text/javascript">
	myleft.width=1;
    //����ʱȥ��ֵ���ߵĿո�
    document.all("myTextArea").value = amarsoft2Real("<%=sScriptText.trim()%>");
	</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>