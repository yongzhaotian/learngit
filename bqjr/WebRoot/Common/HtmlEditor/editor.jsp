<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%String sCommentItemid =  CurPage.getParameter("CommentItemID");%>
<HTML>
<html>
<head>
<title>HTML���߱༭��</title>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<link rel="STYLESHEET" type="text/css" href="editor.css">
<script type="text/javascript" src="editor.js"> </script>
</head>

<body leftmargin="0" topmargin="0" class="windowbackground">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
	<tr width=100% height=100%>
		<td valign="top">
			<table  border="0" cellspacing="0" cellpadding="0" width="100%" height="100%" class="content_table"  id="content_table">
				<tr> 
					<td id="myright" class="myright">
						<div  class="RightContentDiv" id="RightContentDiv"> 
                            <table width=100% height=100%>
                            <tr valign=top  height=5%>
                                <td nowrap >
                                    &nbsp;
                                    <a TITLE="ȫ��ѡ��" href="javascript:format('SelectAll')"> 
                                        <img border=0 valign=top src="<%=sWebRootPath%>/Common/HtmlEditor/Images/Editor/selectall.gif" WIDTH="18" HEIGHT="18"> 
                                    </a>
                                    <a TITLE="����" href="javascript:format('undo')"> 
                                        <img border=0 valign=top src="<%=sWebRootPath%>/Common/HtmlEditor/Images/Editor/undo.gif" WIDTH="18" HEIGHT="18"> 
                                    </a>
                                    <a TITLE="�ָ�" href="javascript:format('redo')"> 
                                        <img border=0 valign=top src="<%=sWebRootPath%>/Common/HtmlEditor/Images/Editor/redo.gif" WIDTH="18" HEIGHT="18"> 
                                    </a>
                                   <select id="FontName" onchange="format('fontname',this[this.selectedIndex].value);this.selectedIndex=0">
                                    <option >����</option>
                                    <option value="����">����</option>
                                    <option value="����">����</option>
                                    <option value="����_GB2312">����</option>
                                    <option value="����_GB2312">����</option>
                                    <option value="����">����</option>
                                    <option value="��Բ">��Բ</option>
                                    <option value="Arial">Arial</option>
                                    <option value="Arial Black">Arial Black</option>
                                    <option value="Arial Narrow">Arial Narrow</option>
                                    <option value="Brush Script	MT">Brush Script MT</option>
                                    <option value="Century Gothic">Century Gothic</option>
                                    <option value="Comic Sans MS">Comic Sans MS</option>
                                    <option value="Courier">Courier</option>
                                    <option value="Courier New">Courier New</option>
                                    <option value="MS Sans Serif">MS Sans Serif</option>
                                    <option value="Script">Script</option>
                                    <option value="System">System</option>
                                    <option value="Times New Roman">Times New Roman</option>
                                    <option value="Verdana">Verdana</option>
                                    <option value="Wide	Latin">Wide Latin</option>
                                    <option value="Wingdings">Wingdings</option>
                                  </select>
                                  <select id="FontSize" onchange="format('fontsize',this[this.selectedIndex].value);this.selectedIndex=0">
                                    <option >�ֺ�</option>
                                    <option value="7">һ��</option>
                                    <option value="6">����</option>
                                    <option value="5">����</option>
                                    <option value="4">�ĺ�</option>
                                    <option value="3">���</option>
                                    <option value="2">����</option>
                                    <option value="1">�ߺ�</option>
                                  </select>
                                </td>				
                            </tr>
                            <tr valign=top height=5%>	
                                <td nowrap >
                                    &nbsp;
                                    <a TITLE="�Ӵ�" href="javascript:format('bold')"> 
                                        <img border=0 valign=top src="<%=sWebRootPath%>/Common/HtmlEditor/Images/Editor/bold.gif" WIDTH="18" HEIGHT="18"> 
                                    </a>
                                    <a TITLE="б��" href="javascript:format('italic')"> 
                                        <img border=0 valign=top src="<%=sWebRootPath%>/Common/HtmlEditor/Images/Editor/italic.gif" WIDTH="18" HEIGHT="18"> 
                                    </a>
                                    <a TITLE="�»���" href="javascript:format('underline')"> 
                                        <img border=0 valign=top src="<%=sWebRootPath%>/Common/HtmlEditor/Images/Editor/underline.gif" WIDTH="18" HEIGHT="18"> 
                                    </a>
                                    <a TITLE="�����" NAME="Justify" href="javascript:format('justifyleft')"> 
                                        <img border=0 valign=top src="<%=sWebRootPath%>/Common/HtmlEditor/Images/Editor/aleft.gif" WIDTH="18" HEIGHT="18"> 
                                    </a>
                                    <a TITLE="����" NAME="Justify" href="javascript:format('justifycenter')"> 
                                        <img border=0 valign=top src="<%=sWebRootPath%>/Common/HtmlEditor/Images/Editor/acenter.gif" WIDTH="18" HEIGHT="18">
                                    </a>
                                    <a TITLE="�Ҷ���" NAME="Justify" href="javascript:format('justifyright')"> 
                                        <img border=0 valign=top src="<%=sWebRootPath%>/Common/HtmlEditor/Images/Editor/aright.gif" WIDTH="18" HEIGHT="18"> 
                                    </a>
                                    <a TITLE="���" href="javascript:format('insertorderedlist')"> 
                                        <img border=0 valign=top src="<%=sWebRootPath%>/Common/HtmlEditor/Images/Editor/num.gif" WIDTH="18" HEIGHT="18"> 
                                    </a>
                                    <a TITLE="��Ŀ����" href="javascript:format('insertunorderedlist')"> 
                                        <img border=0 valign=top src="<%=sWebRootPath%>/Common/HtmlEditor/Images/Editor/list.gif" WIDTH="18" HEIGHT="18"> 
                                    </a>
                                    <a TITLE="����������" href="javascript:format('outdent')"> 
                                        <img border=0 valign=top src="<%=sWebRootPath%>/Common/HtmlEditor/Images/Editor/outdent.gif" WIDTH="18" HEIGHT="18"> 
                                    </a>
                                    <a TITLE="����������" href="javascript:format('indent')"> 
                                        <img border=0 valign=top src="<%=sWebRootPath%>/Common/HtmlEditor/Images/Editor/indent.gif" WIDTH="18" HEIGHT="18"> 
                                    </a>
                                    <a TITLE="����ͼƬ��֧�ָ�ʽΪ��jpg��gif��bmp��png��" href="javascript:uploadImg()">
                                        <img border=0 valign=top src="<%=sWebRootPath%>/Common/HtmlEditor/Images/Editor/img.gif" WIDTH="18" HEIGHT="18"> 
                                    </a>
                                    <a TITLE="�鿴����:�����밴Shift+Enter,����һ���밴Enter,�����ͼƬ�������룬ѡ��ͼƬ���밴Ctrl+X��Ȼ��ѹ��ͣ����Ҫ�����λ�ã��ٰ�Ctrl+V��" href="javascript:help()">
                                        <img border=0 valign=top src="<%=sWebRootPath%>/Common/HtmlEditor/Images/Editor/help.gif" WIDTH="18" HEIGHT="18"> 
                                    </a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div id=HtmlEdit name=HtmlEdit contenteditable align=left class=CommentEditor>  
                                    </div>
                                    <iframe class="HtmlEdit" ID="HtmlPreview" MARGINHEIGHT="1" MARGINWIDTH="1" style="width=100%; height=100%; display:none"> </iframe>
                                </td>
                            </tr>
                        </table>
						<div>	
                    </td>
                </tr>
			</table>
		</td>
	</tr>
</table>
</body>
</html>
<script type="text/javascript">
	var EditMode=true;
    function cancel(){
		self.close();
	}
    
    function format(what,opt){
		if (!EditMode) return;
		if (opt=="removeFormat"){
         	what=opt;
         	opt=null;
       	}
       
       	if (opt==null) {
			document.execCommand(what);
       	}
       	else document.execCommand(what,"",opt);
       	pureText = false;
       	HtmlEdit.focus();
    }
    
    function uploadImg(){
		var str = PopPage("/Common/HtmlEditor/FileAdd.jsp?CommentItemid=<%=sCommentItemid%>&rand="+randomNumber(),"", "dialogWidth:280px; dialogHeight:200px; help: no; scroll: no; status: no");
		if(typeof(str) == "undefined" || str == "") {
			return ;
		}else {
			document.all("HtmlEdit").innerHTML += str ;
		}
	}

    function help(){
	  var arr = PopPage("/Common/HtmlEditor/editor_help.jsp?rand="+randomNumber(), "", "dialogWidth:580px; dialogHeight:460px; help: no; scroll: no; status: no");
	}

    function returnHTMLScript(){
        sReturnValue = real2Amarsoft(document.all("HtmlEdit").innerHTML);
        return sReturnValue;
    }

    function setHTMLScript(sHTMLScript){
        document.all("HtmlEdit").innerHTML=amarsoft2Real(sHTMLScript);
    }
    //��������
    function insertAtCaret (textEl, text) { 
    if (textEl.createTextRange && textEl.caretPos) { 
        var caretPos = textEl.caretPos; 
        caretPos.text =text; 
    }else 
        textEl.value = textEl.value+text; 
    } 
</script>
<%@ include file="/IncludeEnd.jsp"%>