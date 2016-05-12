
function TablePage(tableId,rowCount,displayPageSize,pageCount,curPage){
	this.tableId = tableId;
	this.rowCount = rowCount;
	this.displayPageSize = 10;
	this.pageCount = pageCount;
	this.curPage = curPage+1;
	//alert(this.curPage);
}
TablePage.from = "";
//�����Ҫ��ʾ����βҳ��
TablePage.prototype.getShowPages = function(){
	var firstPage = this.curPage - Math.round(this.displayPageSize/2)  + 1;
	//alert(firstPage);
	var lastPage = this.curPage + Math.round(this.displayPageSize/2);
	if(this.pageCount<this.displayPageSize){
		firstPage = 1;
		lastPage = this.pageCount;
	}
	else if(firstPage<1){
		firstPage = 1;
		lastPage = this.displayPageSize;
	}
	else if(lastPage>this.pageCount){
		lastPage = this.pageCount;
		firstPage =  this.pageCount - this.displayPageSize+1;
	}
	//alert(firstPage + "|" + lastPage);
	return [firstPage,lastPage];
};

TablePage.prototype.createPageHTML = function(){
	var sbResult = new StringBuffer();
	sbResult.append('<div class="list_page_topdiv" id="Page_'+ this.tableId +'">');
	sbResult.append('<div class="list_page_subdiv">');
	//�����һҳ
	var sCssPrePage = "list_page_nextpage";
	if(this.curPage<=1)sCssPrePage = "list_page_nolink";
	sbResult.append('<span class="'+ sCssPrePage +'" onclick="if(this.className!=\'list_page_nolink\')TablePage.changePage(\''+ this.tableId +'\','+ this.rowCount +','+ this.displayPageSize +','+ this.pageCount +','+ (this.curPage-1) +')">��һҳ</span>');
	//ҳ�����
	var showPages = this.getShowPages();
	for(var i=showPages[0];i<=showPages[1];i++){
		if(i==this.curPage)
			sbResult.append('<span class="list_page_current">'+ i +'</span>');
		else
			sbResult.append('<a href="javascript:TablePage.changePage(\''+ this.tableId +'\','+ this.rowCount +','+ this.displayPageSize +','+ this.pageCount +','+ i +')"><span>'+ i +'</span></a>');
	}
	//�����һҳ
	var sCssNextPage = "list_page_nextpage";
	if(this.curPage>=this.pageCount)sCssNextPage = "list_page_nolink";
	sbResult.append('<span class="'+ sCssNextPage +'" onclick="if(this.className!=\'list_page_nolink\')TablePage.changePage(\''+ this.tableId +'\','+ this.rowCount +','+ this.displayPageSize +','+ this.pageCount +','+ (this.curPage+1) +')">��һҳ</span>');
	
	//���ҳ�뼰������Ϣ
	sbResult.append('<div class="list_page_pageinfo">');
	sbResult.append('<table class="countwarning"><tr><td>'); // 1��ʽ��ť��
	sbResult.append('��'+this.pageCount +'ҳ '+ this.rowCount +'��&nbsp;');
	sbResult.append('����<input type="text" id="Page_Input_'+ this.tableId +'" size="4" maxlength="5">ҳ');
	// sbResult.append('<input type="button"  class="search" onclick="TablePage.changePage(\''+ this.tableId +'\','+ this.rowCount +','+ this.displayPageSize +','+ this.pageCount +',\'#\')"');// 2Ӳ����ťͼƬ��
	// sbResult.append('<input type="button"  value="ȷ��" onclick="TablePage.changePage(\''+ this.tableId +'\','+ this.rowCount +','+ this.displayPageSize +','+ this.pageCount +',\'#\')"');// 3ϵͳĬ����
	sbResult.append("</td><td>");// 1��ʽ��ť��
	
	//sbResult.append("<script type="text/javascript">hc_drawNewButtonWithTip(\"ȷ��\",\"\",\"TablePage.changePage(\'"+ this.tableId +"\',"+ this.rowCount +","+ this.displayPageSize +","+ this.pageCount +",\'#\')\",\""+sDWResourcePath+"\");</script>"); // 1.1��ʽ��ť�� ʧ��
	//sbResult.append("<script type="text/javascript">hc_drawNewButtonWithTip(\"ȷ��\",\"\",\"alert(1)\",\""+sDWResourcePath+"\");</script>"); // 1.1��ʽ��ť�� ʧ��
	//sbResult.append(hc_GetdrawNewButtonWithTip("ȷ��","","TablePage.changePage('"+this.tableId+"',"+this.rowCount+","+this.displayPageSize+","+this.pageCount+",'#')",sWebRootPath + "/Frame/Resources/images/button"));
	sbResult.append("<input type=button value='ȷ��' onclick=\"javascript:TablePage.changePage('"+this.tableId+"',"+this.rowCount+","+this.displayPageSize+","+this.pageCount+",'#')\" >");
	/*
	// 1.2��ʽ��ť��
	sbResult.append("<span id='buttonSerach' ");
	sbResult.append("      onclick='TablePage.changePage(\""+this.tableId+"\","+this.rowCount+","+this.displayPageSize+","+this.pageCount+",\"#\")' ");
	sbResult.append("      onMouseOver='overNewButton(\"Serach\",\"sys\")' ");
	sbResult.append("      onMouseOut='outNewButton(\"Serach\",\"sys\")' ");
	sbResult.append("      onMouseDown='downNewButton(\"Serach\",\"sys\")' ");
	sbResult.append("      onMouseUp='upNewButton(\"Serach\",\"sys\")'");
	sbResult.append(">\r");
	sbResult.append("  <table id='buttontableSerach' cellspacing=0 cellpadding=0 border=0>\r");
	sbResult.append("    <tr>\r");
	sbResult.append("      <td id='buttonlefttdSerach' class='buttonleft'>\r");
	sbResult.append("        <img class='buttonleftimg_sys' id='buttonimageleftSerach' src='"+sWebRootPath+"/Frame/Resources/images/button/1x1.gif' width='1' height='1' boder='0'>\r");
	sbResult.append("      </td>\r");
	sbResult.append("      <td id='buttonmiddletdSerach' class='button_sys' nowrap>\r");
	sbResult.append("        ȷ��\r");
	sbResult.append("      </td>\r");
	sbResult.append("      <td id='buttonrighttdSerach' class='buttonright'>\r");
	sbResult.append("        <img class='buttonrightimg_sys' id='buttonimagerightSerach' src='"+sWebRootPath+"/Frame/Resources/images/button/1x1.gif' width='1' height='1' boder='0'>\r");
	sbResult.append("      </td>\r");
    sbResult.append("    </tr>\r");
    sbResult.append("  </table>\r");
    sbResult.append("</span>\r");
	*/
	
    sbResult.append("</td></tr></table>");
	sbResult.append('</div>	');
	sbResult.append('</div>');
	sbResult.append('</div>');
	return sbResult.toString();
};

TablePage.changePage = function(tableId,rowCount,displayPageSize,pageCount,pageCode){
	
	var tableIndex = tableId.substring(8);
	if(window.beforeChangePage){
		window.changePage();
	}
	//���ҳ��
	if(pageCode=="#")
		pageCode = document.getElementById("Page_Input_"+ tableId).value;
	if(pageCode=='' || isNaN(pageCode))return;
	pageCode = parseInt(pageCode);
	if(pageCode>pageCount)pageCode = pageCount;
	//alert(pageCount);
	//�������õ�ǰҳ��
	s_c_p[0]= pageCode-1;
	//������ʾ����
	//alert(TablePage.from);
	openDWDialog();
	//alert(TablePage.from);
	submitFilterArea(TableFactory.SortParams);
	//TableFactory.search(tableIndex,undefined,v_g_DWIsSerializJbo,undefined,TablePage.from);
	//alert(2);
	autoCloseDWDialog();
};