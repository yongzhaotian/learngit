package com.amarsoft.app.util;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.web.dw.ASDataObject;

public class RoleAuthController implements Cloneable, Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -3836771389828953435L;

	private ASDataObject doTemp;
	
	private List<String> roleIdList; 
	
	private String pageName;
	
	private Transaction sqlca;
	
	private Connection conn;
	
	private String[][] btns;
	
	private String authCtrl;
	
	private List<RoleAuthInfo> raiList = new ArrayList<RoleAuthInfo>();
	
	/**
	 * ���캯������ʹ�ú���roleAuthWholeCtrl(String[][], String)��roleAuthCtrl(String, String[][], String)
	 * @param doTemp
	 * @param roleId	-- ��ɫID
	 * @param pageName	-- ҳ����
	 * @param sqlca
	 * @param authCtrl	-- 00-�����˵�ʱ�����أ�01-�����˵�ʱ����ʾ
	 * @throws SQLException
	 */
	@SuppressWarnings("deprecation")
	public RoleAuthController(ASDataObject doTemp, List<String> roleIdList,
			String pageName, Transaction sqlca, String authCtrl) throws SQLException {
		this.doTemp = doTemp;
		this.roleIdList = roleIdList;
		this.pageName = pageName;
		this.sqlca = sqlca;
		this.authCtrl = authCtrl;
		this.conn = this.sqlca.getConnection();
	}
	
	/**
	 * ���캯������ʹ�ú���roleAuthWholeCtrl��roleAuthCtrl(String, String[][])
	 * @param doTemp
	 * @param roleId	-- ��ɫID
	 * @param pageName	-- ҳ����
	 * @param sqlca
	 * @param authCtrl	-- 00-�����˵�ʱ�����أ�01-�����˵�ʱ����ʾ
	 * @throws SQLException
	 */
	@SuppressWarnings("deprecation")
	public RoleAuthController(ASDataObject doTemp, List<String> roleIdList,
			String pageName, Transaction sqlca) throws SQLException {
		this.doTemp = doTemp;
		this.roleIdList = roleIdList;
		this.pageName = pageName;
		this.sqlca = sqlca;
		this.conn = this.sqlca.getConnection();
	}
	
	/**
	 * ���캯������ʹ�ú�����roleTreeViewAuth
	 * @param roleId
	 * @param pageName
	 * @param sqlca
	 * @throws SQLException
	 */
	@SuppressWarnings("deprecation")
	public RoleAuthController(List<String> roleIdList,
			String pageName, Transaction sqlca, String authCtrl) throws SQLException {
		this.roleIdList = roleIdList;
		this.pageName = pageName;
		this.sqlca = sqlca;
		this.authCtrl = authCtrl;
		this.conn = this.sqlca.getConnection();
	}
	
	/**
	 * ���캯������ʹ�ú�����roleTreeViewAuth
	 * @param roleId
	 * @param pageName
	 * @param sqlca
	 * @throws SQLException
	 */
	@SuppressWarnings("deprecation")
	public RoleAuthController(List<String> roleIdList,
			String pageName, Transaction sqlca) throws SQLException {
		this.roleIdList = roleIdList;
		this.pageName = pageName;
		this.sqlca = sqlca;
		this.conn = this.sqlca.getConnection();
	}
	
	/**
	 * һ������Ȩ����(����)
	 * @param btns
	 * @param authType
	 * @return
	 * @throws Exception
	 */
	private boolean roleAuthWholeCtrlUnshow(String[][] btns) throws Exception {
		
		String roleSql = "";
		for (String roleId : roleIdList) {
			roleSql += "'" + roleId + "', ";
		}
		if ("".equals(roleSql)) {
			return true;
		} else {
			roleSql = roleSql.substring(0, roleSql.length() - 2);
		}
		
		String sql = "SELECT ROLEID, PAGE_NAME, ATTR_NAME, ATTR_VALUE, TYPE, STATUS, REMARK "
				+ "FROM ROLE_AUTH_INFO WHERE ROLEID IN (" + roleSql + ") "
				+ "AND PAGE_NAME = ? AND STATUS = '1' AND AUTH_CTRL = '00'";
		PreparedStatement ps = conn.prepareStatement(sql);
		ps.setString(1, pageName);
		ResultSet rs = ps.executeQuery();
		List<RoleAuthInfo> dtList = new ArrayList<RoleAuthInfo>();
		List<RoleAuthInfo> btnList = new ArrayList<RoleAuthInfo>();
		while (rs.next()) {
			RoleAuthInfo rai = new RoleAuthInfo();
			rai.setAttrName(rs.getString("ATTR_NAME"));
			rai.setAttrValue(rs.getString("ATTR_VALUE"));
			rai.setPageName(rs.getString("PAGE_NAME"));
			rai.setRemark(rs.getString("REMARK"));
			rai.setRoleId(rs.getString("ROLEID"));
			rai.setStatus(rs.getInt("STATUS"));
			rai.setType(rs.getString("TYPE"));
			if ("DONO".equals(rs.getString("TYPE"))) {
				dtList.add(rai);
			} else if ("BUTTON".equals(rs.getString("TYPE"))) {
				btnList.add(rai);
			} 
		}
		if (rs != null) {
			rs.close();
		}
		// �ؼ���Ȩ
		if (dtList.size() > 0) {
			ctrlASDWAuth(doTemp, dtList, "");
		}
		// ��ť��Ȩ
		if (btnList.size() > 0) {
			ctrlButtonAuth(this.btns, btnList, "");
		}
		return true;
	}
	
	/**
	 * һ������Ȩ����(��ʾ)
	 * @param btns
	 * @param authType
	 * @return
	 * @throws Exception
	 */
	private boolean roleAuthWholeCtrlShow(String[][] btns) throws Exception {
		
		String roleStr = "";
		for (String roleId : roleIdList) {
			roleStr += "" + roleId + ", ";
		}
		if ("".equals(roleStr)) {
			return true;
		} else {
			roleStr = roleStr.substring(0, roleStr.length() - 2);
		}
		
		String sql = "SELECT ROLEID, PAGE_NAME, ATTR_NAME, ATTR_VALUE, TYPE, STATUS, REMARK "
				+ "FROM ROLE_AUTH_INFO WHERE PAGE_NAME = ? AND STATUS = '1' AND AUTH_CTRL = '01'";
		PreparedStatement ps = conn.prepareStatement(sql);
		ps.setString(1, pageName);
		ResultSet rs = ps.executeQuery();
		List<RoleAuthInfo> dtList = new ArrayList<RoleAuthInfo>();
		List<RoleAuthInfo> btnList = new ArrayList<RoleAuthInfo>();
		String attrNameList = "";
		while (rs.next()) {
			RoleAuthInfo rai = new RoleAuthInfo();
			rai.setAttrName(rs.getString("ATTR_NAME"));
			rai.setAttrValue(rs.getString("ATTR_VALUE"));
			rai.setPageName(rs.getString("PAGE_NAME"));
			rai.setRemark(rs.getString("REMARK"));
			rai.setRoleId(rs.getString("ROLEID"));
			rai.setStatus(rs.getInt("STATUS"));
			rai.setType(rs.getString("TYPE"));
			if ("DONO".equals(rs.getString("TYPE")) && (!roleStr.contains(rs.getString("ROLEID")))) {
				dtList.add(rai);
			} else if ("BUTTON".equals(rs.getString("TYPE")) && (!roleStr.contains(rs.getString("ROLEID")))) {
				btnList.add(rai);
			} else {
				if (roleStr.contains(rs.getString("ROLEID"))) {
					attrNameList += rs.getString("ATTR_NAME") + ",";
				}
			}
		}
		if (rs != null) {
			rs.close();
		}
		// �ؼ���Ȩ
		if (dtList.size() > 0) {
			ctrlASDWAuth(doTemp, dtList, attrNameList);
		}
		// ��ť��Ȩ
		if (btnList.size() > 0) {
			ctrlButtonAuth(this.btns, btnList, attrNameList);
		}
		return true;
	}
	
	/**
	 * һ������Ȩ����
	 * @param btns
	 * @return
	 * @throws Exception
	 */
	public boolean roleAuthWholeCtrl(String[][] btns, String authCtrl) throws Exception {
		
		if (btns == null) {
			throw new Exception("��ť��������Ϊ�գ�");
		}
		this.btns = btns;
		if (doTemp == null) {
			throw new Exception("�������ASDataObject����������Ϊ�գ�");
		}
		if (authCtrl == null || "".equals(authCtrl)) {
			authCtrl = "01";
		}
		boolean flag = true;
		if ("00".equals(authCtrl)) {
			flag = roleAuthWholeCtrlUnshow(btns);
		} else if ("01".equals(authCtrl)) {
			flag = roleAuthWholeCtrlShow(btns);
		}
		
		
		return flag;
	}
	
	/**
	 * һ������Ȩ����
	 * @param btns
	 * @return
	 * @throws Exception
	 */
	public boolean roleAuthWholeCtrl(String[][] btns) throws Exception {
		
		if (btns == null) {
			throw new Exception("��ť��������Ϊ�գ�");
		}
		this.btns = btns;
		if (doTemp == null) {
			throw new Exception("�������ASDataObject����������Ϊ�գ�");
		}
		if (this.authCtrl == null || "".equals(this.authCtrl)) {
			this.authCtrl = "01";
		}
		boolean flag = true;
		if ("00".equals(this.authCtrl)) {
			flag = roleAuthWholeCtrlUnshow(btns);
		} else if ("01".equals(this.authCtrl)) {
			flag = roleAuthWholeCtrlShow(btns);
		}
		
		return flag;
	}

	/**
	 * ��ɫ��Ȩ
	 * @param type		-- DONO-ϵͳģ���SQLģ�壻BUTTON-ҳ��ר�ð�ť������Ȱ�ť��
	 * @param btns		-- ���ư�ťȨ�ޣ��籣�桢�ݴ�Ȱ�ť
	 * @param authCtrl	-- 00-�����˵�ʱ�����أ�01-�����˵�ʱ����ʾ
	 * @return
	 * @throws SQLException 
	 */
	public boolean roleAuthCtrl(String type, String[][] btns, String authCtrl) throws Exception {
		
		if (authCtrl == null || "".equals(authCtrl)) {
			authCtrl = "01";
		}
		boolean flag = true;
		if ("00".equals(authCtrl)) {
			flag = authCtrlUnshow(type, btns);
		} else if ("01".equals(authCtrl)) {
			flag = authCtrlShow(type, btns);
		}
		
		return flag;
	}
	
	/**
	 * ��ɫ��Ȩ
	 * @param type		-- DONO-ϵͳģ���SQLģ�壻BUTTON-ҳ��ר�ð�ť������Ȱ�ť��
	 * @param btns		-- ���ư�ťȨ�ޣ��籣�桢�ݴ�Ȱ�ť
	 * @return
	 * @throws SQLException 
	 */
	public boolean roleAuthCtrl(String type, String[][] btns) throws Exception {
		
		if (this.authCtrl == null || "".equals(this.authCtrl)) {
			this.authCtrl = "01";
		}
		boolean flag = true;
		if ("00".equals(this.authCtrl)) {
			flag = authCtrlUnshow(type, btns);
		} else if ("01".equals(this.authCtrl)) {
			flag = authCtrlShow(type, btns);
		}
		
		return flag;
	}
	
	/**
	 * ������������ʾ��ʵ��
	 * @param type
	 * @param btns
	 * @return
	 * @throws Exception
	 */
	private boolean authCtrlShow(String type, String[][] btns) throws Exception {
		
		if (doTemp == null) {
			throw new Exception("�������ASDataObject����������Ϊ�գ�");
		}
		
		if (type == null || "".equals(type)) {
			throw new Exception("���Ͳ�������Ϊ�գ�");
		} else if ("BUTTON".equals(type)) {
			if (btns == null) {
				throw new Exception("��ť��������Ϊ�գ�");
			}
			this.btns = btns;
		} 
		String sql = "SELECT ROLEID, PAGE_NAME, ATTR_NAME, ATTR_VALUE, TYPE, STATUS, REMARK "
				+ "FROM ROLE_AUTH_INFO WHERE PAGE_NAME = ? AND TYPE = ? AND STATUS = '1' AND AUTH_CTRL = '01'";
		PreparedStatement ps = this.conn.prepareStatement(sql);
		ps.setString(1, this.pageName);
		ps.setString(2, type);
		ResultSet rs = ps.executeQuery();
		String roleStr = "";
		for (String roleId : roleIdList) {
			roleStr += roleId + ", ";
		}
		if ("".equals(roleStr)) {
			return true;
		} else {
			roleStr = roleStr.substring(0, roleStr.length() - 2);
		}
		String attrNameList = "";
		while (rs.next()) {
			if (!roleStr.contains(rs.getString("ROLEID"))) {
				RoleAuthInfo rai = new RoleAuthInfo();
				rai.setAttrName(rs.getString("ATTR_NAME"));
				rai.setAttrValue(rs.getString("ATTR_VALUE"));
				rai.setPageName(rs.getString("PAGE_NAME"));
				rai.setRemark(rs.getString("REMARK"));
				rai.setRoleId(rs.getString("ROLEID"));
				rai.setStatus(rs.getInt("STATUS"));
				rai.setType(rs.getString("TYPE"));
				raiList.add(rai);
			} else {
				attrNameList += rs.getString("ATTR_NAME") + ",";
			}
		}
		
		if ("DONO".equals(type)) {
			ctrlASDWAuth(doTemp, raiList, attrNameList);
			return true;
		} else if ("BUTTON".equals(type)) {
			ctrlButtonAuth(this.btns, raiList, attrNameList);
			return true;
		}
		
		return true;
	}

	/**
	 * �������������ص�ʵ��
	 * @param type
	 * @param btns
	 * @return
	 * @throws Exception
	 */
	private boolean authCtrlUnshow(String type, String[][] btns) throws Exception {
		
		if (doTemp == null) {
			throw new Exception("�������ASDataObject����������Ϊ�գ�");
		}
		
		if (type == null || "".equals(type)) {
			throw new Exception("���Ͳ�������Ϊ�գ�");
		} else if ("BUTTON".equals(type)) {
			if (btns == null) {
				throw new Exception("��ť��������Ϊ�գ�");
			}
			this.btns = btns;
		} 
		String roleSql = "";
		for (String roleId : roleIdList) {
			roleSql += "'" + roleId + "', ";
		}
		if ("".equals(roleSql)) {
			return true;
		} else {
			roleSql = roleSql.substring(0, roleSql.length() - 2);
		}
		
		String sql = "SELECT ROLEID, PAGE_NAME, ATTR_NAME, ATTR_VALUE, TYPE, STATUS, REMARK "
				+ "FROM ROLE_AUTH_INFO WHERE ROLEID IN (" + roleSql + ") AND PAGE_NAME = ? "
				+ "AND TYPE = ? AND STATUS = '1' AND AUTH_CTRL = '00'";
		PreparedStatement ps = conn.prepareStatement(sql);
		ps.setString(1, pageName);
		ps.setString(2, type);
		ResultSet rs = ps.executeQuery();
		raiList = new ArrayList<RoleAuthInfo>();
		while (rs.next()) {
			RoleAuthInfo rai = new RoleAuthInfo();
			rai.setAttrName(rs.getString("ATTR_NAME"));
			rai.setAttrValue(rs.getString("ATTR_VALUE"));
			rai.setPageName(rs.getString("PAGE_NAME"));
			rai.setRemark(rs.getString("REMARK"));
			rai.setRoleId(rs.getString("ROLEID"));
			rai.setStatus(rs.getInt("STATUS"));
			rai.setType(rs.getString("TYPE"));
			raiList.add(rai);
		}
		
		if (rs != null) {
			rs.close();
		}
		
		if (raiList.size() == 0) {
			return true;
		}
		
		if ("DONO".equals(type)) {
			ctrlASDWAuth(doTemp, raiList, "");
			return true;
		} else if ("BUTTON".equals(type)) {
			ctrlButtonAuth(this.btns, raiList, "");
			return true;
		}
		
		return true;
	}
	
	/**
	 * ����DONO����ֵ
	 * @param doTemp
	 * @param raiList
	 */
	private static void ctrlASDWAuth(ASDataObject doTemp, List<RoleAuthInfo> raiList, String attrNameList) {
		
		for (RoleAuthInfo rai : raiList) {
			if (attrNameList.contains(rai.getAttrName())) {
				continue;
			}
			String attrValue = rai.getAttrValue();
			String attrName = rai.getAttrName();
			if ("INVISIBLE".equals(attrValue)) {	// ���ص�
				doTemp.setVisible(attrName, false);
			} else if ("DISABLED".equals(attrValue)) {	// ���õ�
				doTemp.setReadOnly(attrName, true);
			} else if ("READONLY".equals(attrValue)) {	// ֻ����
				doTemp.setReadOnly(attrName, true);
			} else if ("ENCRYPTED".equals(attrValue)) {	// ���ܵ�
				String str = "**********";
				doTemp.setDefaultValue(attrName, str);
			}
		}
	}
	
	/**
	 * ���ư�ťȨ�ޣ��籣�桢�ݴ�Ȱ�ť��
	 * @param btns -- �ṹģʽ��JSP��button��һ�µ�
	 * @param raiList
	 */
	private String[][] ctrlButtonAuth(String[][] btns, List<RoleAuthInfo> raiList, String attrNameList) throws Exception {
		
		for (RoleAuthInfo rai : raiList) {		// ֻҪ�����þͽ���
			for (String[] str : btns) {
				if (str != null && str[3].equals(rai.getAttrName())) {
					str[0] = "false";
				}
			}
		}
		
		return btns;
	}
	
	public String roleTreeViewAuth(String treeViewSql) throws Exception {
		
		if (this.authCtrl == null || "".equals(this.authCtrl)) {
			this.authCtrl = "01";
		}
		
		if ("00".equals(this.authCtrl)) {
			treeViewSql = roleTreeViewAuthUnshow(treeViewSql);
		} else if ("01".equals(this.authCtrl)) {
			treeViewSql = roleTreeViewAuthShow(treeViewSql);
		}
		
		return treeViewSql;
	}
	
	/**
	 * �������ʼ����Ȩ(����)
	 * @param sql
	 * @return
	 * @throws Exception
	 */
	public String roleTreeViewAuthUnshow(String treeViewSql) throws Exception {
		
		if (this.authCtrl == null || "".equals(this.authCtrl)) {
			this.authCtrl = "01";
		}
		String roleSql = "";
		for (String roleId : roleIdList) {
			roleSql += "'" + roleId + "', ";
		}
		if ("".equals(roleSql)) {
			return treeViewSql;
		} else {
			roleSql = roleSql.substring(0, roleSql.length() - 2);
		}
		
		String sql = "SELECT ROLEID, PAGE_NAME, ATTR_NAME, ATTR_VALUE, TYPE, STATUS, REMARK "
				+ "FROM ROLE_AUTH_INFO WHERE ROLEID IN (" + roleSql + ") AND PAGE_NAME = ? "
				+ "AND TYPE = ? AND STATUS = '1' AND AUTH_CTRL = '00'";
		PreparedStatement ps = conn.prepareStatement(sql);
		ps.setString(1, pageName);
		ps.setString(2, "TREEVIEW");
		ResultSet rs = ps.executeQuery();
		raiList = new ArrayList<RoleAuthInfo>();
		while (rs.next()) {
			RoleAuthInfo rai = new RoleAuthInfo();
			rai.setAttrName(rs.getString("ATTR_NAME"));
			rai.setAttrValue(rs.getString("ATTR_VALUE"));
			rai.setPageName(rs.getString("PAGE_NAME"));
			rai.setRemark(rs.getString("REMARK"));
			rai.setRoleId(rs.getString("ROLEID"));
			rai.setStatus(rs.getInt("STATUS"));
			rai.setType(rs.getString("TYPE"));
			raiList.add(rai);
		}
		if (rs != null) {
			rs.close();
		}
		if (raiList.size() == 0) {
			return treeViewSql;
		}
		
		String str = " AND ";
		for (RoleAuthInfo rai : raiList) {
			str += rai.getAttrName() + " <> '" + rai.getAttrValue() + "' AND ";
		}
		if (str.length() > 5) {
			str = str.substring(0, str.length() - 5);
		}
		treeViewSql += str;
		
		return treeViewSql;
	}
	
	/**
	 * �������ʼ����Ȩ(����)
	 * @param sql
	 * @return
	 * @throws Exception
	 */
	public String roleTreeViewAuthShow(String treeViewSql) throws Exception {
		
		String roleStr = "";
		for (String roleId : roleIdList) {
			roleStr += "" + roleId + ", ";
		}
		if ("".equals(roleStr)) {
			return treeViewSql;
		} else {
			roleStr = roleStr.substring(0, roleStr.length() - 2);
		}
		
		String sql = "SELECT ROLEID, PAGE_NAME, ATTR_NAME, ATTR_VALUE, TYPE, STATUS, REMARK "
				+ "FROM ROLE_AUTH_INFO WHERE PAGE_NAME = ? AND TYPE = ? AND STATUS = '1' AND AUTH_CTRL = '01'";
		PreparedStatement ps = conn.prepareStatement(sql);
		ps.setString(1, pageName);
		ps.setString(2, "TREEVIEW");
		ResultSet rs = ps.executeQuery();
		raiList = new ArrayList<RoleAuthInfo>();
		String attrNameList = "";
		while (rs.next()) {
			if (!roleStr.contains(rs.getString("ROLEID"))) {
				RoleAuthInfo rai = new RoleAuthInfo();
				rai.setAttrName(rs.getString("ATTR_NAME"));
				rai.setAttrValue(rs.getString("ATTR_VALUE"));
				rai.setPageName(rs.getString("PAGE_NAME"));
				rai.setRemark(rs.getString("REMARK"));
				rai.setRoleId(rs.getString("ROLEID"));
				rai.setStatus(rs.getInt("STATUS"));
				rai.setType(rs.getString("TYPE"));
				raiList.add(rai);
			} else {
				attrNameList += rs.getString("ATTR_NAME") + ",";
			}
		}
		if (rs != null) {
			rs.close();
		}
		if (raiList.size() == 0) {
			return treeViewSql;
		}
		
		String str = " AND ";
		for (RoleAuthInfo rai : raiList) {
			if (attrNameList.contains(rai.getAttrName())) {
				continue;
			}
			str += rai.getAttrName() + " <> '" + rai.getAttrValue() + "' AND ";
		}
		if (str.length() >= 5) {
			str = str.substring(0, str.length() - 5);
		}
		treeViewSql += str;
		
		return treeViewSql;
	}
	
	
	static class RoleAuthInfo {
		
		/** ROLEID -- ��ɫID **/
		private String roleId;
		
		/** PAGE_NAME -- ҳ���� **/
		private String pageName;
		
		/** ATTR_NAME -- ������ **/
		private String attrName;
		
		/** ATTR_VALUE -- ����ֵ��INVISIBLE(���ص�);DISABLED(���õ�);READONLY(ֻ����);ENCRYPTED(���ܵ�) **/
		private String attrValue;
		
		/** TYPE -- ���ͣ�DONO-ϵͳģ���SQLģ�壻BUTTON-ҳ��ר�ð�ť������Ȱ�ť�� **/
		private String type;
		
		/** Ȩ�޿��ƣ�00-�����˵�ʱ�����أ�01-�����˵�ʱ����ʾ **/
		private String authCtrl;
		
		/** STATUS -- ״̬��0-���ã�1-���� **/
		private int status;
		
		/** REMARK -- ��ע **/
		private String remark;

		public String getRoleId() {
			return roleId;
		}

		public void setRoleId(String roleId) {
			this.roleId = roleId;
		}

		public String getPageName() {
			return pageName;
		}

		public void setPageName(String pageName) {
			this.pageName = pageName;
		}

		public String getAttrName() {
			return attrName;
		}

		public void setAttrName(String attrName) {
			this.attrName = attrName;
		}

		public String getAttrValue() {
			return attrValue;
		}

		public void setAttrValue(String attrValue) {
			this.attrValue = attrValue;
		}

		public String getType() {
			return type;
		}

		public void setType(String type) {
			this.type = type;
		}

		public String getAuthCtrl() {
			return authCtrl;
		}

		public void setAuthCtrl(String authCtrl) {
			this.authCtrl = authCtrl;
		}

		public int getStatus() {
			return status;
		}

		public void setStatus(int status) {
			this.status = status;
		}

		public String getRemark() {
			return remark;
		}

		public void setRemark(String remark) {
			this.remark = remark;
		}
	}
}
