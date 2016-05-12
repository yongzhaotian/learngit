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
	 * 构造函数，可使用函数roleAuthWholeCtrl(String[][], String)、roleAuthCtrl(String, String[][], String)
	 * @param doTemp
	 * @param roleId	-- 角色ID
	 * @param pageName	-- 页面名
	 * @param sqlca
	 * @param authCtrl	-- 00-配置了的时候隐藏；01-配置了的时候显示
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
	 * 构造函数，可使用函数roleAuthWholeCtrl、roleAuthCtrl(String, String[][])
	 * @param doTemp
	 * @param roleId	-- 角色ID
	 * @param pageName	-- 页面名
	 * @param sqlca
	 * @param authCtrl	-- 00-配置了的时候隐藏；01-配置了的时候显示
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
	 * 构造函数，可使用函数：roleTreeViewAuth
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
	 * 构造函数，可使用函数：roleTreeViewAuth
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
	 * 一次性授权函数(隐藏)
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
		// 控件授权
		if (dtList.size() > 0) {
			ctrlASDWAuth(doTemp, dtList, "");
		}
		// 按钮授权
		if (btnList.size() > 0) {
			ctrlButtonAuth(this.btns, btnList, "");
		}
		return true;
	}
	
	/**
	 * 一次性授权函数(显示)
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
		// 控件授权
		if (dtList.size() > 0) {
			ctrlASDWAuth(doTemp, dtList, attrNameList);
		}
		// 按钮授权
		if (btnList.size() > 0) {
			ctrlButtonAuth(this.btns, btnList, attrNameList);
		}
		return true;
	}
	
	/**
	 * 一次性授权函数
	 * @param btns
	 * @return
	 * @throws Exception
	 */
	public boolean roleAuthWholeCtrl(String[][] btns, String authCtrl) throws Exception {
		
		if (btns == null) {
			throw new Exception("按钮参数不能为空！");
		}
		this.btns = btns;
		if (doTemp == null) {
			throw new Exception("组件对象【ASDataObject】参数不能为空！");
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
	 * 一次性授权函数
	 * @param btns
	 * @return
	 * @throws Exception
	 */
	public boolean roleAuthWholeCtrl(String[][] btns) throws Exception {
		
		if (btns == null) {
			throw new Exception("按钮参数不能为空！");
		}
		this.btns = btns;
		if (doTemp == null) {
			throw new Exception("组件对象【ASDataObject】参数不能为空！");
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
	 * 角色授权
	 * @param type		-- DONO-系统模板或SQL模板；BUTTON-页面专用按钮（保存等按钮）
	 * @param btns		-- 控制按钮权限，如保存、暂存等按钮
	 * @param authCtrl	-- 00-配置了的时候隐藏；01-配置了的时候显示
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
	 * 角色授权
	 * @param type		-- DONO-系统模板或SQL模板；BUTTON-页面专用按钮（保存等按钮）
	 * @param btns		-- 控制按钮权限，如保存、暂存等按钮
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
	 * 控制配置了显示的实现
	 * @param type
	 * @param btns
	 * @return
	 * @throws Exception
	 */
	private boolean authCtrlShow(String type, String[][] btns) throws Exception {
		
		if (doTemp == null) {
			throw new Exception("组件对象【ASDataObject】参数不能为空！");
		}
		
		if (type == null || "".equals(type)) {
			throw new Exception("类型参数不能为空！");
		} else if ("BUTTON".equals(type)) {
			if (btns == null) {
				throw new Exception("按钮参数不能为空！");
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
	 * 控制配置了隐藏的实现
	 * @param type
	 * @param btns
	 * @return
	 * @throws Exception
	 */
	private boolean authCtrlUnshow(String type, String[][] btns) throws Exception {
		
		if (doTemp == null) {
			throw new Exception("组件对象【ASDataObject】参数不能为空！");
		}
		
		if (type == null || "".equals(type)) {
			throw new Exception("类型参数不能为空！");
		} else if ("BUTTON".equals(type)) {
			if (btns == null) {
				throw new Exception("按钮参数不能为空！");
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
	 * 设置DONO属性值
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
			if ("INVISIBLE".equals(attrValue)) {	// 隐藏的
				doTemp.setVisible(attrName, false);
			} else if ("DISABLED".equals(attrValue)) {	// 禁用的
				doTemp.setReadOnly(attrName, true);
			} else if ("READONLY".equals(attrValue)) {	// 只读的
				doTemp.setReadOnly(attrName, true);
			} else if ("ENCRYPTED".equals(attrValue)) {	// 加密的
				String str = "**********";
				doTemp.setDefaultValue(attrName, str);
			}
		}
	}
	
	/**
	 * 控制按钮权限，如保存、暂存等按钮，
	 * @param btns -- 结构模式和JSP的button是一致的
	 * @param raiList
	 */
	private String[][] ctrlButtonAuth(String[][] btns, List<RoleAuthInfo> raiList, String attrNameList) throws Exception {
		
		for (RoleAuthInfo rai : raiList) {		// 只要有配置就禁用
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
	 * 左边栏初始化授权(隐藏)
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
	 * 左边栏初始化授权(隐藏)
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
		
		/** ROLEID -- 角色ID **/
		private String roleId;
		
		/** PAGE_NAME -- 页面名 **/
		private String pageName;
		
		/** ATTR_NAME -- 属性名 **/
		private String attrName;
		
		/** ATTR_VALUE -- 属性值：INVISIBLE(隐藏的);DISABLED(禁用的);READONLY(只读的);ENCRYPTED(加密的) **/
		private String attrValue;
		
		/** TYPE -- 类型：DONO-系统模板或SQL模板；BUTTON-页面专用按钮（保存等按钮） **/
		private String type;
		
		/** 权限控制：00-配置了的时候隐藏；01-配置了的时候显示 **/
		private String authCtrl;
		
		/** STATUS -- 状态：0-禁用；1-启用 **/
		private int status;
		
		/** REMARK -- 备注 **/
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
