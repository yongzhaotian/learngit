package com.amarsoft.app.als.customer.group.action;

import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 集团家谱提交复核前更新GROUP_FAMILY_VERSION和GROUP_INFO
 * @author 
 */
public class FamilyVersionApplyOpinionAction extends Bizlet {
	//集团客户ID
	private String sGroupID = "";
	//家谱版本ID
	private String sVersionSeq = "";
	//用户ID
	private String sUserID = "";
	//数据库连接 
	private Transaction Sqlca = null;

	public Object run(Transaction Sqlca) throws Exception{
		 this.Sqlca = Sqlca;
		 //获取参数
		 sGroupID = (String)this.getAttribute("GroupID");
		 sVersionSeq = (String)this.getAttribute("VersionSeq");	
		 sUserID = (String)this.getAttribute("UserID");
		
		 //将空值转化为空字符串
		 if(sGroupID == null) sGroupID = "";
		 if(sVersionSeq == null) sVersionSeq = "";
		 if(sUserID == null) sUserID = "";
		 
		 //定义变量
		 String sReturn = "0";
		 String sSql = "";
		 ASResultSet rs = null;						//查询结果集
		 String sGroupType2="";
		 
		/** 根据集团客户编号，查询*/
		 sSql = " select GroupType2 from GROUP_INFO where GroupID = :GroupID ";
	     rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("GroupID", sGroupID));
			
	        /** 获取查询结果 */
			if(rs.next()){
				sGroupType2=rs.getString("GroupType2");
			}
			rs.getStatement().close();
			rs = null;	
			if(sGroupType2 == null) sGroupType2 = "";
		 
         //更新GROUP_FAMILY_VERSION和GROUP_INFO
		 Sqlca.executeSQL(new SqlObject("update GROUP_FAMILY_VERSION set EffectiveStatus=:EffectiveStatus,SubmitTime=:SubmitTime where GroupID=:GroupID and VersionSeq=:VersionSeq").
				setParameter("GroupID",sGroupID).
				setParameter("VersionSeq",sVersionSeq).
				setParameter("EffectiveStatus","1").
				setParameter("SubmitTime",DateX.format(new java.util.Date(), "yyyy/MM/dd")));
		
		 Sqlca.executeSQL(new SqlObject("update GROUP_INFO set FamilyMapStatus = :FamilyMapStatus where GroupID=:GroupID").
				setParameter("GroupID",sGroupID).
				setParameter("FamilyMapStatus","1"));
		
		 return sReturn;	
	}				
}
