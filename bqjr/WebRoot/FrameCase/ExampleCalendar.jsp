<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
<div style="padding-left:10px;">
	<tr>
		<td>������1��<input id="id" style="overflow:visible;" readonly="readonly"/></td>
		<td><button onclick="selectCalendar();"> ����������ѡ��</button></td>
	</tr>
	<tr><td>
		AsDialog.OpenCalender(obj, "yyyy/MM/dd");
	</td></tr>
	<br/><br/>
	<tr>
		<td>������2��<input id="id2" style="overflow:visible;" readonly="readonly" /></td>
		<td><button onclick="selectCalendarBegin();"> ����ʼ����ѡ��</button></td>
	</tr>
	<tr><td>
		AsDialog.OpenCalender(obj, "yyyy/MM/dd", "2012/08/19");
	</td></tr>
	<br/><br/>
	<tr>
		<td>������3��<input id="id3" style="overflow:visible;" readonly="readonly"/></td>
		<td><button onclick="selectCalendarEnd();"> �н�ֹ����ѡ��</button></td>
	</tr>
	<tr><td>
		AsDialog.OpenCalender(obj, "yyyy/MM/dd", "", "2013/02/18");
	</td></tr>
	<br/><br/>
	<tr>
		<td>������4��<input id="id4" style="overflow:visible;" readonly="readonly"/></td>
		<td><button onclick="selectCalendarRange();"> ������������ѡ��</button></td>
	</tr>
	<tr><td>
		AsDialog.OpenCalender(obj, "yyyy/MM/dd", "2012/08/19", "2013/02/18");
	</td></tr>
	<br/><br/>
	<tr>
		<td>������5��<input id="id5" style="overflow:visible;" readonly="readonly"/></td>
		<td><button onclick="selectCalendarFromToday();"> �����Ժ�����ѡ��</button></td>
	</tr>
	<tr><td>
		AsDialog.OpenCalender(obj, "yyyy/MM/dd", "today");
	</td></tr>
</div>
<script type="text/javascript">
	function selectCalendar(){
		var obj = document.getElementById("id");
		AsDialog.OpenCalender(obj, "yyyy/MM/dd");
	}
	function selectCalendarBegin(){
		var obj = document.getElementById("id2");
		AsDialog.OpenCalender(obj, "yyyy/MM/dd", "2012/08/19");
	}
	function selectCalendarEnd(){
		var obj = document.getElementById("id3");
		AsDialog.OpenCalender(obj, "yyyy/MM/dd", "", "2013/02/18");
	}
	function selectCalendarRange(){
		var obj = document.getElementById("id4");
		AsDialog.OpenCalender(obj, "yyyy/MM/dd", "2012/08/19", "2013/02/18");
	}
	function selectCalendarFromToday(){
		var obj = document.getElementById("id5");
		AsDialog.OpenCalender(obj, "yyyy/MM/dd", "today");
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>