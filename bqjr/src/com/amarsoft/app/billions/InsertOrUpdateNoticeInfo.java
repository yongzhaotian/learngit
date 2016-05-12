package com.amarsoft.app.billions;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import oracle.jdbc.OracleConnection;
import oracle.jdbc.OracleDriver;
import oracle.jdbc.driver.OraclePreparedStatement;
import oracle.sql.CLOB;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * ¼�빫����Ϣ��¼��notice_info
 * 
 * @author huzp
 * @date 2015-07-31
 */
public class InsertOrUpdateNoticeInfo {
	private String noticeId;// ����ID
	private String noticeTitle;// �������
	private String noticePeople;// ���淢����
	private String noticeContent;// ��������

	// private String inputUser;//¼����
	private String inputOrg;// ¼�벿��
	private String updateUser;// ������
	private String updateTime;// ����ʱ��
	// private String inputTime;//¼��ʱ��
	private String noticeDate;// ����ʱ��
	private String auditPoint;
	private String addTime;
	private String typeNo;

	public String getAuditPoint() {
		return auditPoint;
	}

	public void setAuditPoint(String auditPoint) {
		this.auditPoint = auditPoint;
	}

	public String getAddTime() {
		return addTime;
	}

	public void setAddTime(String addTime) {
		this.addTime = addTime;
	}

	public String getTypeNo() {
		return typeNo;
	}

	public void setTypeNo(String typeNo) {
		this.typeNo = typeNo;
	}

	public String getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}

	public String getNoticeDate() {
		return noticeDate;
	}

	public void setNoticeDate(String noticeDate) {
		this.noticeDate = noticeDate;
	}

	public String getNoticeContent() {
		return noticeContent;
	}

	public String getNoticeId() {
		return noticeId;
	}

	public void setNoticeId(String noticeId) {
		this.noticeId = noticeId;
	}

	public String getNoticeTitle() {
		return noticeTitle;
	}

	public void setNoticeTitle(String noticeTitle) {
		this.noticeTitle = noticeTitle;
	}

	public String getNoticePeople() {
		return noticePeople;
	}

	public void setNoticePeople(String noticePeople) {
		this.noticePeople = noticePeople;
	}

	public String getInputOrg() {
		return inputOrg;
	}

	public void setInputOrg(String inputOrg) {
		this.inputOrg = inputOrg;
	}

	public String getUpdateUser() {
		return updateUser;
	}

	public void setUpdateUser(String updateUser) {
		this.updateUser = updateUser;
	}

	public void setNoticeContent(String noticeContent) {
		this.noticeContent = noticeContent;
	}

	/****
	 * ��ӹ�����Ϣ
	 * 
	 * @param Sqlca
	 * @throws Exception
	 */
	public String addNotice(Transaction Sqlca) throws Exception {
		SqlObject osql = null;
		String sql = "insert into NOTICE_INFO (" + "NOTICEID," + "NOTICETITLE,"
				+ "NOTICEPEOPLE," + "NOTICECONTENT," + "INPUTORG,"
				+ "UPDATEUSER," + "noticeDate," + "updateTime" + ") values ("
				+ getvalus(noticeId) + "," + getvalus(noticeTitle) + ","
				+ getvalus(noticePeople) + "," + ":noticeContent" + ","
				+ getvalus(inputOrg) + "," + getvalus(updateUser) + ","
				+ ":noticeDate," + ":updateTime" + ")";
		osql = new SqlObject(sql);
		Sqlca.executeSQL(osql.setParameter("noticeContent", noticeContent)
				.setParameter("noticeDate", noticeDate)
				.setParameter("updateTime", updateTime));
		return "SUCCESS";
	}
	public void addNotice2(Transaction Sqlca) throws Exception {
		//String sql = "insert into gz_search_result(request_id,table_name,total_number,search_result,create_time,flag) values (?,?,?,?,to_date(?,'yyyy-MM-dd HH24:mi:ss'),?)";
		String sql = "insert into NOTICE_INFO (" + "NOTICEID," + "NOTICETITLE,"
				+ "NOTICEPEOPLE," + "NOTICECONTENT," + "INPUTORG,"
				+ "UPDATEUSER," + "noticeDate," + "updateTime" + ") values ("
				+ getvalus(noticeId) + "," + getvalus(noticeTitle) + ","
				+ getvalus(noticePeople) + "," + "?" + ","
				+ getvalus(inputOrg) + "," + getvalus(updateUser) + ",'"
				+ noticeDate+"','" + updateTime + "')";
		Connection dbcon = Sqlca.getConnection();
		CLOB clob = null;
		clob = oracle.sql.CLOB.createTemporary((OracleConnection) dbcon, true,1);
		clob.setString(1, noticeContent);
		OracleConnection OCon = (OracleConnection) dbcon;
		OraclePreparedStatement ps = (OraclePreparedStatement) OCon.prepareCall(sql);
		ps.setClob(1, clob);
		ps.executeUpdate();
		ps.close();
		ps = null;

		// OCon.commit();
		// dbcon.setAutoCommit(true);

	}
	public void addNotice3(Transaction Sqlca) throws Exception {
		SqlObject osql = null;
		String sql = "insert into NOTICE_INFO (" + "NOTICEID," + "NOTICETITLE,"
				+ "NOTICEPEOPLE," + "NOTICECONTENT," + "INPUTORG,"
				+ "UPDATEUSER," + "noticeDate," + "updateTime" + ") values ("
				+ getvalus(noticeId) + "," + getvalus(noticeTitle) + ","
				+ getvalus(noticePeople) + "," + ":noticeContent" + ","
				+ getvalus(inputOrg) + "," + getvalus(updateUser) + ","
				+ ":noticeDate," + ":updateTime" + ")";
		osql = new SqlObject(sql);
		Sqlca.executeSQL(osql.setParameter("noticeContent", noticeContent)
				.setParameter("noticeDate", noticeDate)
				.setParameter("updateTime", updateTime));

	}
	
	public void addNotice4(Transaction Sqlca) throws Exception {
		DriverManager.registerDriver(new OracleDriver());
		Connection conn = Sqlca.getConnection();// �õ����Ӷ���
		String text = "����Ҫ���뵽CLOB���������,�������ݣ�update����Ҫ���뵽CLOB���������,�������ݣ�update����Ҫ���뵽CLOB���������,�������ݣ�update����Ҫ���뵽CLOB���������,�������ݣ�update����Ҫ���뵽CLOB���������,�������ݣ�update����Ҫ���뵽CLOB���������,�������ݣ�update����Ҫ���뵽CLOB���������,�������ݣ�update����Ҫ���뵽CLOB���������,�������ݣ�update����Ҫ���뵽CLOB���������,�������ݣ�update����Ҫ���뵽CLOB���������,�������ݣ�update����Ҫ���뵽CLOB���������,�������ݣ�update����Ҫ���뵽CLOB���������,�������ݣ�update����Ҫ���뵽CLOB���������,�������ݣ�update����Ҫ���뵽CLOB���������,�������ݣ�update"
				
				;
		//String sql = "insert into notice_info(noticeid,NOTICETITLE,noticecontent) values ('201509100000000003','���Ա���',?)";// Ҫִ�е�SQL���
		//String sql = "insert into NOTICE_INFO (NOTICEID,NOTICETITLE,NOTICEPEOPLE,NOTICECONTENT,INPUTORG,UPDATEUSER,noticeDate,updateTime) values (?,?,?,?,?,?,?,?)";
//				+ getvalus(noticeId) + "," + getvalus(noticeTitle) + ","
//				+ getvalus(noticePeople) + "," + "?" + ","
//				+ getvalus(inputOrg) + "," + getvalus(updateUser) + ",'"
//				+ noticeDate+"','" + updateTime + "')";
		String sql = "insert into NOTICE_INFO (NOTICEID,NOTICETITLE,NOTICEPEOPLE,NOTICECONTENT) values (?,?,?,?)";
		String noticeIdStr="201509100000000006";
		String noticeTitleStr="��˹���";
		String noticePeopleStr="����";
//		String noticeContentStr=noticeContent;
		PreparedStatement stmt = conn.prepareStatement(sql);// ����SQL���
		// PreparedStatement֧��SQL�����ʺţ������Զ�̬�滻�������ݡ�
		Reader clobReader = new StringReader(text); // �� textת������ʽ
		stmt.setString(1, noticeIdStr);
		stmt.setString(2, noticeTitleStr);
		stmt.setString(3, noticePeopleStr);
		stmt.setCharacterStream(4, clobReader, text.length());// �滻sql����еģ�
		int num = stmt.executeUpdate();// ִ��SQL
		System.out.println("sql��������������������������"+sql);

		if (num > 0) {
			System.out.println("ok");
		} else {
			System.out.println("NO");
		}
		stmt.close();
		conn.close();
	}

	/****
	 * ��ѯCLOB���͵��ֶη�ʽ
	 * 
	 * @param Sqlca
	 * @throws Exception
	 */
	public String findNotice(Transaction Sqlca, String noticeid)
			throws Exception {
		CLOB clob = null;
		String sql = "select Noticecontent from NOTICE_INFO where noticeid = '"
				+ noticeid + "'";
		Connection conn = Sqlca.getConnection();
		PreparedStatement ps = conn.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		String content = "";
		if (rs.next()) {
			clob = (oracle.sql.CLOB) rs.getClob("Noticecontent");
			content = ClobToString(clob);
		}
		ps.close();
		conn.close();
		// System.out.println(URLDecoder.decode(content, "UTF-8"));
		return content;
	}

	// ����CLOBת��STRING����
	public String ClobToString(CLOB clob) throws SQLException, IOException {

		String reString = "";
		Reader is = clob.getCharacterStream();// �õ���
		BufferedReader br = new BufferedReader(is);
		String s = br.readLine();
		StringBuffer sb = new StringBuffer();
		while (s != null) {// ִ��ѭ�����ַ���ȫ��ȡ����ֵ��StringBuffer��StringBufferת��STRING
			sb.append(s);
			s = br.readLine();
		}
		reString = sb.toString();
		return reString;
	}

	/*****
	 * �޸ĸ��¹�����Ϣ
	 * 
	 * @param Sqlca
	 * @throws Exception
	 */

	public void updateNotice(Transaction Sqlca) throws Exception {
		SqlObject osql = null;
		String sql = "update notice_info t set " + "  t.noticetitle="
				+ getvalus(noticeTitle) + " ,t.updateuser="
				+ getvalus(updateUser) + " ,t.updatetime=:updatetime"
				+ " ,t.noticecontent=:noticecontent" + " where t.noticeid="
				+ getvalus(noticeId);
		osql = new SqlObject(sql);
		Sqlca.executeSQL(osql.setParameter("updatetime", updateTime)
				.setParameter("noticecontent", noticeContent));

	}

	/*****
	 * �������Ҫ��
	 * 
	 * @param Sqlca
	 * @throws Exception
	 */

	public void updateAuditPoints(Transaction Sqlca) throws Exception {
		SqlObject osql = null;
		String sql = "UPDATE ecm_image_type SET AUDITPOINTS=:auditPoint,ADDTIME=:addTime WHERE TYPENO="
				+ getvalus(typeNo);
		osql = new SqlObject(sql);
		Sqlca.executeSQL(osql.setParameter("auditPoint", auditPoint)
				.setParameter("addTime", addTime));

	}

	private String getvalus(String val) {
		if (null == val) {
			return val;
		}
		if ("undefined".equals(val)) {
			return null;
		}

		return "'" + val + "'";
	}
/*
	public int insertText(ContentText text) {
		int insertkey = -1;
		try {
			// ��������sequence�����ݿ���ȡcontent_text�������������
			ResultSet rs = executeQuery("select seq_content_text.nextval as pk_content_text from dual");
			rs.first();
			insertkey = rs.getInt(1);
			// �����CLOB
			String insertEmpty = "insert into content_text values(" + insertkey
					+ ",'" + text.getTextType() + "',empty_clob())";
			boolean insertResult = executeUpdate(insertEmpty);
			if (insertResult == false) {
				throw new SQLException();
			}
			// ��ȡCLOB������text_content������ȡ��������������ǰ��ֱ�����½���

			String getForUpdate = "select text_content from content_text where pk_content_text = "
					+ insertkey + " for update";
			rs = executeQuery(getForUpdate);
			rs.first();
			CLOB content = (CLOB) rs.getClob("text_content");
			rs.close();
			content.setString(1L, text.getContent());
			// ����text_content��
			String updateSQL = "update content_text set text_content = ? where pk_content_text = ?";
			PreparedStatement pst = conn.prepareStatement(updateSQL);
			pst.setClob(1, content);
			pst.setInt(2, insertkey);
			pst.execute();
			pst.close();
		} catch (SQLException e) {
			try {
				conn.rollback();
				conn.close();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
			System.out.println("Insert text failed!");
		}
		return insertkey;
	}
*/
}
