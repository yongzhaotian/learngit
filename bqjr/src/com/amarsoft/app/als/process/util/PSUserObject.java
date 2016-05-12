package com.amarsoft.app.als.process.util;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * 用户对象
 * <p>
 * 流程引擎使用,其他用途不建议使用。 仅适用于一个用户对应唯一机构，不适用于一个用户对应多个机构。
 * </p>
 * 
 * @author zszhang
 * 
 */
public class PSUserObject {
	private static final long serialVersionUID = 1L;
	private String userID; // 用户编号
	private String userName; // 用户名称
	private String orgID; // 机构编号
	private String status; // 用户状态
	private String password; // 用户密码
	private PSOrgObject belongOrg; // 用户所属机构对象

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getOrgID() {
		return orgID;
	}

	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}

	public String getOrgName() {
		if (getBelongOrg() != null) {
			return getBelongOrg().getOrgName();
		} else {
			return "";
		}
	}

	public String getOrgSortNo() {
		if (getBelongOrg() != null) {
			return getBelongOrg().getSortNo();
		} else {
			return "";
		}
	}

	public String getOrgLevel() {
		if (getBelongOrg() != null) {
			return getBelongOrg().getOrgLevel();
		} else {
			return "";
		}
	}

	public String getParentOrgID() {
		if (getBelongOrg() != null) {
			return getBelongOrg().getParentOrgID();
		} else {
			return "";
		}
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public PSOrgObject getBelongOrg() {
		return belongOrg;
	}

	public void setBelongOrg(PSOrgObject belongOrg) {
		this.belongOrg = belongOrg;
	}

	private PSUserObject(String userID) {
		this.userID = userID;
	}

	/**
	 * 根据UserID简单构造用户对象，用于程序中取得用户关联属性。
	 * 
	 * @param userID
	 * @return PSUserObject
	 * @throws Exception
	 */
	static public PSUserObject getUser(String userID) throws Exception {

		// 创建用户对象
		PSUserObject user = new PSUserObject(userID);

		// 判断传入userID是否为空,是则返回一个空的用户对象
		if ("".equals(userID) || userID == null) {
			ARE.getLog().warn("当前传入用户为空！");
			user.setUserID(userID);
			return user;
		}

		// 判断传入的useID参数是否包含多个用户，
		// 如果多用户则以@分隔，如@test11@test12@，如果单用户则消去分割符，如test11
		if (userID.split(",").length > 2) {
			userID = userID.replace(",", "@");
			ARE.getLog().warn("当前存在多用户[" + userID + "]！");
		} else {
			userID = userID.replace(",", "");

			// 构造用户对象
			try {
				BizObjectQuery q = JBOFactory.getFactory().getManager(
						"jbo.sys.USER_INFO").createQuery(
						"UserID = :UserID and Status = :Status");
				q.setParameter("UserID", userID);
				q.setParameter("Status", "1");
				BizObject bo = q.getSingleResult(false);
				if (bo != null) {
					user.setUserID(bo.getAttribute("UserID").getString());
					user.setUserName(bo.getAttribute("UserName").getString());
					user.setOrgID(bo.getAttribute("BelongOrg").getString());
					user.setStatus(bo.getAttribute("Status").getString());
					user.setPassword(bo.getAttribute("Password").getString());
					user.setBelongOrg(new PSOrgObject(bo.getAttribute(
							"BelongOrg").getString()));
				} else if ("als".equals(userID) || "system".equals(userID)) {
					PSOrgObject belongOrg = new PSOrgObject();
					belongOrg.setOrgID("system");
					belongOrg.setOrgName("system");
					user.setBelongOrg(belongOrg);
					user.setUserID("system");
					user.setUserName("system");
				} else {
					ARE.getLog().warn("用户[" + userID + "]在数据库中不存在！");
				}
			} catch (Exception e) {
				ARE.getLog().error("实例化用户对象[" + userID + "]异常！", e);
			}
		}
		return user;
	}
}
