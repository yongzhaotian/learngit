<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">

<title>������Ϣ</title>

</head>
<body style="background-color: #dae6ee;">
	<!-- ������Ϣ -->
	<h1 style="color: #204179; background-color: #66a1e2;" align="center">������Ϣ</h1>
	<div>
		<ul>
			<%
					String  noticetitle = "", noticecontent = "", noticedate = "", updateuser = "", content = "";
					ASResultSet rs = null;
					//add by byang CCS-1252 160304  �жϹ�������Ϣ�Ƿ��ǵ�ǰ�û��Ĳ��š��Ŷ��������Ĺ���
					String swhere = "";
					//�ж��Ƿ��ǿͷ���
					if(CurUser.getOrgID().equals("14")){
			 	   		//һ���û������ɫ,������һ����ɫ
			 	   		ArrayList<String> roleList = CurUser.getRoleTable();
			 	   		if(roleList.size()==1){
			 	   			swhere += " visibleRole like '%"+roleList.get(0)+"%' and ";
			 	   		}else{
			 	   			for(int i=0;i<roleList.size();i++){
			 	   				if(i==0){
			 	   					swhere += " (visibleRole like '%"+roleList.get(i)+"%'";
			 	   				}else if(i==roleList.size()-1){
			 	   					swhere += " or visibleRole like '%"+roleList.get(i)+"%') and ";
			 	   				}else{
			 	   					swhere += " or visibleRole like '%"+roleList.get(i)+"%'";
			 	   				}
			 	   			}
			 	   		}
					}
					String sql="select ni.noticeid,ni.noticetitle,ni.noticecontent,ni.noticedate,ni.updateuser from notice_info ni where "+swhere+" ni.noticeid not in "
							+" (select t.noticeid from USER_NOTICE t where t.isflag='1' and t.UserID=:UserID) and ni.inputorg='"+CurUser.getOrgID()+"'";
					rs = Sqlca.getASResultSet(new SqlObject(sql).setParameter("UserID",CurUser.getUserID()));
					int i = 0;
					while (rs.next()) {
						i++;
						noticetitle = rs.getString("noticetitle");
						noticecontent = rs.getString("noticecontent");
						noticecontent = noticecontent.replaceAll("hzp", "=");
						noticecontent = noticecontent.replaceAll("tlg", "\"");
						noticecontent = noticecontent.replaceAll("rlt", "#");
						noticecontent = noticecontent.replaceAll("nbsp", "&nbsp;");
						noticecontent = noticecontent.replaceAll("lt", "&lt;");
						noticecontent = noticecontent.replaceAll("gt", "&gt;");
						noticecontent = noticecontent.replaceAll("amp", "&amp;");
						noticedate = rs.getString("noticedate");
						updateuser = rs.getString("updateuser");
						content += ("<li >");
						content += (i + ".");
						content += ("<span onclick='javascript:openFile(\""+rs.getString("noticeid")+"\")'> ��"+rs.getString("noticetitle")+"<img src='"+sResourcesPath+"/new.gif' border=0 >�� "+noticecontent+"</span>");
					}
					content += "</li>";
					if (noticetitle == null)
						noticetitle = "";
					if (noticecontent == null)
						noticecontent = "";
					if (noticedate == null)
						noticedate = "";
					if (updateuser == null)
						updateuser = "";
					rs.getStatement().close();
					out.println(content);
					
			%>
		</ul>
	</div>
</body>
</html>
<script type="text/javascript">
	function openFile(noticeId){//δ����Ϣ��������flag=0������ҳ�����ں��水ť�ж�����
	    AsControl.OpenView("/Common/WorkFlow/UpEditorNoticeInfo.jsp","NoticeId="+noticeId+"&flag=0","_self","");
	}
	function openFile2(noticeId){//������Ϣ��������flag=1������ҳ�����ں��水ť�ж�����
	    AsControl.OpenView("/Common/WorkFlow/UpEditorNoticeInfo.jsp","NoticeId="+noticeId+"&flag=1","_self","");
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>