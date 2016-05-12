package com.amarsoft.app.billions;


import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class DeleteUserListErrorInfo {
	private String orgId = null;
	public String getOrgId() {
		return orgId;
	}
	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}
	public void deleteErrorInfo(Transaction Sqlca) throws Exception {
		// �������
		ASResultSet rs = null;
		int info_num = 0;
		String userid = null;
		String sSql = null;
		SqlObject so;// ��������
		String dateTime = DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss");// ��ǰϵͳʱ��
		// ���ݷ����ѯ��endtimeΪ��ʱ���������ӦԱ����ţ���ز�����˲����Բ���Բ��ŵ���Ϣ������Ա��
		if(orgId.equals("10")){
			sSql = "SELECT COUNT(*) as info_num,t.userid FROM USER_LIST T WHERE T.ENDTIME IS NULL AND T.ORGID='10' group by t.userid ";

		}else if(orgId.equals("11")){
			sSql = "SELECT COUNT(*) as info_num,t.userid FROM USER_LIST T WHERE T.ENDTIME IS NULL AND T.ORGID='11' group by t.userid ";

		}else {
			sSql = "SELECT COUNT(*) as info_num,t.userid FROM USER_LIST T WHERE T.ENDTIME IS NULL AND T.ORGID in('10','11') group by t.userid ";

		}
		so = new SqlObject(sSql);
		rs = Sqlca.getResultSet(so);
		while (rs.next()) {
			info_num = Integer.parseInt(rs.getString("info_num"));
			userid = rs.getString("userid");
			if(info_num>1){
				//���ݲ�ѯ��������������1������ʱ��ɾ����ӦԱ���ĵ�¼��¼��Ϣ���������һ����¼��Ϣ
				if(orgId.equals("10")){//��������Ϊ���ų����ĵ�ǰ��¼�û�����Ϊ�յ�endtime���ݣ�����endtimeΪ�յķ������˳�����Ϣ�Զ�������endtime��ʱ���
					sSql = "update user_list t set t.endtime =:endtime where t.orgid = '10'  and t.endtime is null and t.begintime <> (select max(begintime) from user_list t where t.endtime is null and t.userid = :userid AND SUBSTR(t.begintime, 0, 10)=to_char(sysdate, 'yyyy/mm/dd')) and t.userid=:userid";

				}else if(orgId.equals("11")){
					sSql = "update user_list t set t.endtime =:endtime where t.orgid = '11'  and t.endtime is null and t.begintime <> (select max(begintime) from user_list t where t.endtime is null and t.userid = :userid AND SUBSTR(t.begintime, 0, 10)=to_char(sysdate, 'yyyy/mm/dd')) and t.userid=:userid";

				}else {
					sSql = "update user_list t set t.endtime =:endtime where t.orgid in ('10','11')  and t.endtime is null and t.begintime <> (select max(begintime) from user_list t where t.endtime is null and t.userid = :userid AND SUBSTR(t.begintime, 0, 10)=to_char(sysdate, 'yyyy/mm/dd')) and t.userid=:userid";

				}
				
				so = new SqlObject(sSql).setParameter("endtime", dateTime).setParameter("userid", userid)
						.setParameter("userid", userid);
				Sqlca.executeSQL(so);
			}
		}

		rs.getStatement().close();
	}
}
