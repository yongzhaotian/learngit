<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
   String sComponentURL=CurPage.getParameter("ComponentURL");
   String sParaString=CurPage.getParameter("CompPara");
	String sDialogTitle = CurPage.getParameter("DialogTitle");
	if (sParaString == null)  sParaString = "";
	else sParaString = StringFunction.replace(sParaString,"$[and]","&");
%>
<html>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/comp_dialog.css">
<link rel="stylesheet" type="text/css" href="<%=sSkinPath%>/css/comp_dialog.css">
<head> 
<!-- Ϊ��ҳ������,�벻Ҫɾ������ TITLE �еĿո� -->
<%
	//ȡϵͳ����
	String sImplementationName = CurConfig.getConfigure("ImplementationName");
%>
<title><%=sImplementationName%>
 ���������������������������������� ���������������������������������� ����������������������������������
 ���������������������������������� ���������������������������������� ����������������������������������
</title>
</head>
<body style="width:100%;height:100%;overflow:hidden;margin-left:0px;margin-right:0px;" scroll=no onBeforeUnload="onClose()" onunload="destroyComp()">
<table style="width:100%;height:100%;overflow:hidden;background:#fff" cellspacing="0" cellpadding="0" border="0">
	<tr style="height:1px;widht:100%" border=1 ><td style="width:100%" >
	<div class="opencomp_head">
		<div class="opencomp_titzone" id="TopTitle" style="display:none">
		</div>
		<div class="opencomp_btnzone">
			<table border="0" cellspacing="0" cellpadding="0">  
				<tr>
				  <td nowrap> &nbsp;&nbsp;
				    <script> 
					if('<%=sComponentURL%>'.indexOf("SponsorAgainWithhold")<0){
						/***	�����ٴδ��۵���ҳ�棬��ˢ��-����-ˢ��-���桱 �����������ظ���n����¼���������ȷ�ϴ�ҳ������ˢ�°�ť�� updated by lilong	***/
						drawImgButton("icon_refresh","Refresh ˢ��","refreshMe()","<%=sResourcesPath%>"); 
					}
					</script>
				    <script> drawImgButton("icon_close","Close �ر�","exitPopWindow()","<%=sResourcesPath%>"); </script>
				  </td>
				  <td nowrap> 
				    <span class="pageversion" >
				    </span>
				  </td>
				</tr>
				</table>
		</div>
	</div>
	</td></tr>
	<tr><td>
	<div class="opencomp_content">
		<iframe name="ObjectList" width=100% height=100% frameborder=0 scrolling="auto" src="<%=sWebRootPath%>/Blank.jsp"></iframe>
	</div>
	</td></tr>
</table>
</body>
</html>
<script type="text/javascript">
	var sObjectInfo="";
	function closeAndReturn(){
		if(sObjectInfo==""){
			if(confirm(getHtmlMessage("44"))){
				sObjectInfo="_NONE_";
			}else{
				return;
			}
		}
		self.returnValue=sObjectInfo;
		self.close();
	}
    
	function cancleAndReturn(){
		sObjectInfo="_NONE_";
        self.returnValue=sObjectInfo;
		self.close();
	}
	
	function openComponentInMe(){
		AsControl.OpenView("<%=sComponentURL%>","<%=sParaString%>","ObjectList","");
	}

	function onClose(){
		if(checkFrameModified(self,30)) 
			event.returnValue=sUnloadMessage;		
	}
	
	function destroyComp(){
		$.ajax({url: "<%=sWebRootPath%>/Frame/page/control/DestroyCompAction.jsp?ToDestroyClientID="+ObjectList.sCompClientID,async: false});
	}
	
	function checkFrameModified(oFrame,generations){
		if(typeof(generations)=="number")
			iGenerations = generations-1;
		else
			iGenerations = 0;
		
		if(iGenerations<0) return true;
		try{
        	if(oFrame.bEditHtml && oFrame.bEditHtmlChange )
				return true;
		}catch(e){}
        
		if(typeof(oFrame.isModified)!="undefined"){
			for(var j=0;j<oFrame.frames.length;j++){ 	
				try{
					if(oFrame.bCheckBeforeUnload==false) continue;
					if(oFrame.isModified(oFrame.frames[j].name)) return true;
				}catch(e){}
			}
		}

		//����¼�ҳ���dw
		if(oFrame.frames.length==0) return false;
		for(var i=0;i<oFrame.frames.length;i++){
			if(checkFrameModified(oFrame.frames[i],iGenerations)) return true;
		}
		return false;
	}
	
	function refreshMe(){
		try{
			openComponentInMe();
		}catch(e){}
    }
    
	function exitPopWindow(){
		self.close();
    }
	
	function setTopTitle(title){
    	$("#TopTitle").show();
		$("#TopTitle").html(title);
    }
	function getTopTitle(){
		return $("#TopTitle").html();
    }
	document.onready = function() {
       <%if(sDialogTitle!=null && !sDialogTitle.equals("")) { %>setTopTitle("<%=sDialogTitle%>"); <%}%>
       <%if(sComponentURL!=null && !sComponentURL.equals("")) { %>openComponentInMe(); <%}%>
    };
</script>
<%@ include file="/IncludeEnd.jsp"%>