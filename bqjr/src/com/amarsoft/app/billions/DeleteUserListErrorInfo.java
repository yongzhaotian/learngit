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
		// 定义变量
		ASResultSet rs = null;
		int info_num = 0;
		String userid = null;
		String sSql = null;
		SqlObject so;// 声明对象
		String dateTime = DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss");// 当前系统时间
		// 根据分组查询出endtime为空时的数量与对应员工编号（风控部、审核部各自查各自部门的信息。管理员）
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
				//根据查询出来的数量超过1条数据时，删除对应员工的登录记录信息并保留最近一条登录信息
				if(orgId.equals("10")){//更新条件为：排除最大的当前登录用户当天为空的endtime数据，其他endtime为空的非正常退出的信息自动更新上endtime的时间点
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
