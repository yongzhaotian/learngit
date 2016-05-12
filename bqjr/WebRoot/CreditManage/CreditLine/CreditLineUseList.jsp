<%@page import="com.amarsoft.app.als.credit.cl.model.*"%>
<%@page import="com.amarsoft.app.als.credit.cl.action.*"%>
<%@page import="com.amarsoft.app.als.credit.cl.model.*"%>
<%@page import="com.amarsoft.app.als.credit.cl.model.CLDivide"%>
<%@page import="com.amarsoft.app.als.credit.cl.model.CreditLine"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<style type="text/css">
<!--
body,table{
    font-size:12px;
}
table{
    table-layout:fixed;
    empty-cells:show; 
    border-collapse: collapse;
    margin:0 auto;
} 
h1,h2,h3{font-size:12px;margin:0;padding:0;} 
.title { background: #FFF; border: 1px solid #9DB3C5; padding: 1px; width:100%;margin:20px auto; }
.title h1 { line-height: 31px; text-align:center;  background: #2F589C url(th_bg2.gif); background-repeat: repeat-x; background-position: 0 0; color: #FFF; }
.title th, .title td { border: 1px solid #CAD9EA; padding: 1px; } 
/*����ǽ��һ����̳����ʽ*/
table.t1{border:1px solid #cad9ea;color:#666;}
table.t1 th { background-image: url(th_bg1.gif); background-repeat::repeat-x;height:30px;}
table.t1 td,table.t1 th{ border:1px solid #cad9ea; padding:0 1em 0;}
table.t1 tr.a1{background-color:#f5fafe;}
table.t2{ border:1px solid #9db3c5;color:#666;}
table.t2 th {background-image: url(th_bg2.gif);background-repeat::repeat-x; height:30px;color:#35031b;}
table.t2 td{border:1px dotted #cad9ea; padding:0 2px 0;height:30px;}
table.t2 th{ border:1px solid #a7d1fd;  padding:0 2px 0;height:30px;}
table.t2 tr.a1{background-color:#e8f3fd;}
table.t3{    border:1px solid #fc58a6;    color:#720337;}
table.t3 th {background-image: url(th_bg3.gif); background-repeat::repeat-x; height:30px; color:#35031b;}
table.t3 td{border:1px dashed #feb8d9;padding:0 1.5em 0;height:30px;}
table.t3 th{border:1px solid #b9f9dc;padding:0 2px 0;height:30px;}
table.t3 tr.a1{background-color:#fbd8e8;height:30px;} 

-->
</style>
<%!


%>
<%
	String sSerialNo=CurPage.getParameter("SerialNo");
	CreditLine line=new CreditLine(sSerialNo);
	line.check(); 
	CreditShow cs=new CreditShow();
	double dBusinessSum=line.getBusinessSum();
	double dExposuresum=line.getExposureSum();
	double dUseBusinessSum=line.getUseBusinessSum();
	double dUseExposuresum=line.getUseExposureSum();
	double dFreBusinessSum=line.getFreBusinessSum();
	double dFreExposuresum=line.getFreExposuresum(); 
	List<CLDivide> lstDivide=line.getDivideList();
	String sCustomerName=line.getAttribute("CustomerName").getString();
%>
<script type="text/javascript">
    function ApplyStyle(s){
        document.getElementById("mytab").className=s.innerText;
    }
</script>

<div class='title'>
 <h1 class='list_gridCell_standard'>[<% out.print(sCustomerName);  %>]�ۺ��������Ŷ��</h1> 
 <div class='title'>  
	    <table width="100%" id="mytab2"  border="1" class="t1">
		  <thead class='list_topdiv_header'>
		    <th width="20%">������</th>
		    <td width="30%"  align="right"><%=!line.bchBusinessSum?"-":DataConvert.toMoney(dBusinessSum)%></td>
		    
		    <th width="20%">���ڽ��</th>
		    <td width="30%"  align="right"><%=!line.bchExposureSum?"-":DataConvert.toMoney(dExposuresum)%> </td> 
		  </thead>
		   <thead>
		    <th width="20%">����������</th>
		    <td width="30%"  align="right"><%=!line.bchBusinessSum?"-":DataConvert.toMoney(dFreBusinessSum)%></td>
		    <th width="20%">���᳨�ڽ��</th>
		    <td width="30%"  align="right"><%=!line.bchExposureSum?"-":DataConvert.toMoney(dFreExposuresum)%> </td> 
		  </thead> 
		   <tr class="a1"> 
		    <th width="20%">��ʹ��������</th>
		    <td width="30%"  align="right"><%=!line.bchBusinessSum?"-":DataConvert.toMoney(dUseBusinessSum)%></td>
		    <th width="20%">��ʹ�ó��ڽ��</th>
		    <td width="30%"  align="right"><%=!line.bchExposureSum?"-":DataConvert.toMoney(dUseExposuresum)%> </td> 
		   </tr> 
		    <tr class="a1"> 
		    <th width="20%">����������</th>
		    <td width="30%"  align="right"><%=!line.bchBusinessSum?"-":DataConvert.toMoney(line.getUsableBusinessSum())%></td>
		    <th width="20%">���ó��ڽ��</th>
		    <td width="30%"  align="right"><%=!line.bchExposureSum?"-":DataConvert.toMoney(line.getUsableExposureSum())%> </td> 
		   </tr> 
		     </tr> 
		    <tr class="a1"> 
		    <th width="20%">�����ʼ��</th>
		    <td width="30%"  align="right"><%=line.getAttribute("PutOUtDate").getString()%></td>
		    <th width="20%">��ȵ�����</th>
		    <td width="30%"  align="right"><%=line.getAttribute("Maturity").getString()%> </td> 
		   </tr> 
		   
		    
		    <tr class="a1"> 
		    <th  colspan='4'><a href='#' onclick="javascript:showDetail('md',this)">�鿴ʹ�����</a></th> 
		   </tr> 
	  </table>
  </div>
  <div id='md' style='display:none' class='title'>
     <%=cs.getDetail(line.getAccountManager(),"md","��Э��")%>
  </div>
<%

	String sStyle="";
	if(line.getDivideList().size()==0) sStyle="style='display:none'";
%>
 <div class='title'> 
<table width="100%" id="mytab"  border="1" class="t1" <%=sStyle%>>
  <thead>
    <th width="5%">���</th>
    <th>��������</th>
    <th>������</th>
    <th>���ڽ��</th>
    <th>�Ƿ�ѭ��</th>
    <th>����������</th>
    <th>���ó��ڽ��</th>
    <th>����������</th>
    <th>���ó��ڽ��</th>
    <th >����</th>
  </thead>
  <%
  String sclassName="";
  String sdivideList="";
  out.print(cs.getDivideUse(lstDivide,""));
  if(lstDivide.size()==0)
  {
	  out.print("<tr><td colspan='8'>��������з�</td></tr>");
  }
  %> 
 </table> 
 <%

 out.print(cs.getUseInfo());
 %>
 </div>
</div>

 <script type="text/javascript">
 	var sdiv="md@<%=cs.getList()%>";
 	divArray=sdiv.split("@"); 
	var sid=new Array();
 	document.getElementById("mytab").className="t2";
	function showDetail(sid,obj)
	{
		if("<%=cs.getList()%>".length == 0){
			alert("�޶������ҵ��");
			return;
		}
		try{
			
			if(sid!="md") $("#md").hide(); 
			for(i=0;i<divArray.length;i++)
			{
				myid=divArray[i];
				if(sid==myid) continue;
	 				$("#"+myid).hide(); 
			}
			$("#"+sid).toggle(); 
		}catch(e)
		{
			alert(e.message);
		}
	}
	
	function showContract(sSerialNo)
	{
		
		 AsControl.PopComp("/CreditManage/CreditContract/ContractDetailTab.jsp","RightType=ReadOnly&SerialNo="+sSerialNo,"");
	}
</script>

<%@include file="/IncludeEnd.jsp"%>
