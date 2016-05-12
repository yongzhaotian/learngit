

package com.amarsoft.context;

import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.log.Log;
import com.amarsoft.are.security.MessageDigest;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.res.model.SkinItem;
import com.amarsoft.awe.util.*;
import java.io.Serializable;
import java.sql.Statement;
import java.util.ArrayList;



public class ASUser
    implements Serializable
{

    private ASUser(String sUserID)
    {
        belongLOB = null;
        skin = new SkinItem();
        userID = sUserID;
    }

    public boolean passwordValidate(String sPassword)
        throws Exception
    {
        return password.equalsIgnoreCase(StringX.bytesToHexString(MessageDigest.getDigest("MD5", sPassword), true));
    }

    public static ASUser getUser(String sUserID, Transaction Sqlca)
        throws Exception
    {
        ASResultSet rs;
        ASUser user;
        rs = null;
        SqlObject asql = null;
        user = new ASUser(sUserID);
        String sTempSql = "select * from USER_INFO where UserID =:UserID and Status=:Status";
        asql = (new SqlObject(sTempSql)).setParameter("UserID", sUserID).setParameter("Status", "1");
        rs = Sqlca.getASResultSet(asql);
        if(rs.next())
        {
            user.setUserID(rs.getString("UserID"));
            user.setUserName(rs.getString("UserName"));
            user.setOrgID(rs.getString("BelongOrg"));
            user.setStatus(rs.getString("Status"));
            user.setPassword(rs.getString("Password"));
            user.skin.setPath(rs.getString("SkinPath"));
            user.setIsCar(DataConvert.toString(rs.getString("isCar")));
            user.setAttribute8(DataConvert.toString(rs.getString("attribute8")));
            user.setBelongOrg(new ASOrg(rs.getString("BelongOrg"), Sqlca));
            try
            {
                user.setBelongLOB(rs.getString("LOB"));
            }
            catch(Exception e)
            {
                ARE.getLog().warn("\u6CA1\u6709\u5728USER_INFO\u8868\u4E2D\u5B9A\u4E49LOB\uFF08\u4E1A\u52A1\u6761\u7EBF\uFF09\u5B57\u6BB5\u3002", e);
            }
            rs.getStatement().close();
            rs = null;
            sTempSql = "select ur.RoleID from USER_ROLE ur, AWE_ROLE_INFO ri where ur.RoleID=ri.RoleID and ur.UserID=:UserID and ur.Status=:Status";
            asql = (new SqlObject(sTempSql)).setParameter("UserID", sUserID).setParameter("Status", "1");
            rs = Sqlca.getASResultSet(asql);
            ArrayList roles = user.getRoleTable();
            do
            {
                if(!rs.next())
                    break;
                String sTempRoleID = rs.getString("RoleID");
                if(sTempRoleID != null)
                    roles.add(sTempRoleID);
            } while(true);
            rs.getStatement().close();
            if(!roles.contains("800"))
                roles.add("800");
            rs = null;
            user.setTrueUser(true);
            user.setUserMessage("\u6B63\u5E38");
        } else
        {
            ARE.getLog().warn((new StringBuilder()).append("\u7528\u6237[").append(sUserID).append("]\u5728\u6570\u636E\u5E93\u4E2D\u4E0D\u5B58\u5728\uFF01").toString());
            user.setUserMessage((new StringBuilder()).append("\u7528\u6237[").append(sUserID).append("]\u5728\u6570\u636E\u5E93\u4E2D\u4E0D\u5B58\u5728\uFF01").toString());
        }
        if(rs != null) rs.getStatement().close();
        return user;
    }

    public boolean hasRole(String sRoleID)
        throws Exception
    {
        return getRoleTable().contains(sRoleID);
    }

    public boolean hasRole(String sRoleIDs[])
        throws Exception
    {
        for(int i = 0; i < sRoleIDs.length; i++)
            if(hasRole(sRoleIDs[i]))
                return true;

        return false;
    }

    public boolean isTrueUser()
    {
        return isTrueUser;
    }

    public void setTrueUser(boolean isTrueUser)
    {
        this.isTrueUser = isTrueUser;
    }

    public String getUserMessage()
    {
        return userMessage;
    }

    public void setUserMessage(String userMessage)
    {
        this.userMessage = userMessage;
    }

    public SkinItem getSkin()
    {
        return skin;
    }

    public String getUserID()
    {
        return userID;
    }

    public void setUserID(String userID)
    {
        this.userID = userID;
        isTrueUser = false;
    }

    public String getUserName()
    {
        return userName;
    }

    public void setUserName(String userName)
    {
        this.userName = userName;
    }

    public String getOrgID()
    {
        return orgID;
    }

    public void setOrgID(String orgID)
    {
        this.orgID = orgID;
    }

    public String getOrgName()
    {
        return getBelongOrg().getOrgName();
    }

    public String getOrgSortNo()
    {
        return getBelongOrg().getSortNo();
    }

    public String getOrgLevel()
    {
        return getBelongOrg().getOrgLevel();
    }

    public String getRelativeOrgID()
    {
        return getBelongOrg().getRelativeOrgID();
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getPassword()
    {
        return password;
    }

    public void setPassword(String password)
    {
        this.password = password;
    }

    public String getFormerPassword()
    {
        return formerPassword;
    }

    public void setFormerPassword(String formerPassword)
    {
        this.formerPassword = formerPassword;
    }

    public String getBelongLOB()
    {
        return belongLOB;
    }

    public void setBelongLOB(String belongLOB)
    {
        this.belongLOB = belongLOB;
    }

    public ASOrg getBelongOrg()
    {
        return belongOrg;
    }

    public void setBelongOrg(ASOrg belongOrg)
    {
        this.belongOrg = belongOrg;
    }

    public ArrayList getRoleTable()
    {
        if(roleTable == null)
            roleTable = new ArrayList();
        return roleTable;
    }

    public void setRoleTable(ArrayList roleTable)
    {
        this.roleTable = roleTable;
    }
    
    public String getIsCar() {
		return isCar;
	}

	public void setIsCar(String isCar) {
		this.isCar = isCar;
	}

	
	public String getAttribute8() {
		return attribute8;
	}

	public void setAttribute8(String attribute8) {
		this.attribute8 = attribute8;
	}


	private static final long serialVersionUID = 1L;
    private String isCar;
    private String attribute8;
    
    private String userID;
    private String userName;
    private String orgID;
    private String status;
    private String password;
    private String formerPassword;
    private String belongLOB;
    private ASOrg belongOrg;
    private boolean isTrueUser;
    private String userMessage;
    private SkinItem skin;
    private ArrayList roleTable;
}


