<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	//取客户编号
	String customerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(customerID == null) customerID = "";
%>
<html>
<head>
    <script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/js/jquery/jquery.ui.js"></script>
    <link href="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/css/jquery.treeTable.css" rel="stylesheet" type="text/css" />
    <style>
    #searchArea{display:none;}
    body {
	  background: #fff;
	  color: #000;
	  font-family: Helvetica, Arial, sans-serif;
	  font-size: 1em;
	  line-height: 1.5;
	  vertical-align: text-top;
	  text-align: left;
	}
	/*最外层容器 table*/
	.main{
	  border-collapse: collapse;
	  border: none;
	  margin: 0;
	  padding: 0;
	  margin-top: 2px;
	  margin-left: 5px;
	  width: 101%;
	  height: 99%;
	}
	.main td{
	    margin: 0;padding: 0;
	}
	/*2.定义nav*/
	.main-nav{
	    /*
	    border: 1px solid #adbec7;
	    */
	    border-top: none;
	    border-bottom: 2px solid #adbec7;
	    vertical-align: middle;
	    text-align: left;
	    height: 20px;
	    background-color: #1A72B3;
	    background:url("../images/treetable/headerbg.gif") repeat-x left -18px;
	}
	/*导航内容table*/
	.main-nav table{
	    margin-left: 1em;
	    border-collapse: collapse;
	}
	.main-nav table td{
	    padding: 0.5em;
	}
	/*3.定义body*/
	.main-body{
	    border: 1px solid #adbec7;
	    border-top: none;
	    height: 720px;
	    border-bottom: none;
	}
	.main-body .main-body-content{
	    margin: 0;
	    padding: 0;
	    height: 100%;
	    width: 100%;
	/*    border-right: 2px solid #adbec7;*/
	}
	.main-body .main-body-content iframe,{
	    width: 100%;
	    height: 100%;
	    overflow: auto;
	}
    </style>
</head>
<script type="text/javascript">
	function searchRela(){
		var searchLevel = document.getElementById("SearchLevel").value;
		var sArgs = "CustomerID=<%=customerID%>&SearchLevel="+searchLevel;
		OpenComp("RelationTree","/CustomerManage/EntManage/RelationTree.jsp",sArgs,"content");
	}
	
</script>
<body>
    <table cellspacing="0" cellpadding="0" class="main">
        <tr id="searchArea">
            <td class="main-nav">
                <table cellspacing="0" cellpadding="0">
					<tr>
						<td><div id="searchMassage" style="color: red;"></div></td>
						<td>
							请选择搜查层级:
							<select id="SearchLevel">
								<option value="1">1</option>
								<option value="2">2</option>
								<option value="3" selected="selected">3</option>
								<option value="4">4</option>
								<option value="5">5</option>
							</select>
						</td>
			           	<td>
			           		<input type="button" value="开始搜索" onclick="javascript:searchRela();">
			           	</td>
					</tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class="main-body">
                <div class="main-body-content"><iframe id="content" name="content" src="<%=sWebRootPath%>/AppMain/Blank.html"></iframe></div>
            </td>
        </tr>
        <tr>
            <td class="main-footer"><span>&nbsp;</span></td>
        </tr>
    </table>
</body>
</html>
<script language="javascript">
$(document).ready(function(){
	$("#searchArea").show();
});
</script>
<%@ include file="/IncludeEnd.jsp"%>