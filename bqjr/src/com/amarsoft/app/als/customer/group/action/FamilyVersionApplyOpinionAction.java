package com.amarsoft.app.als.customer.group.action;

import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * ���ż����ύ����ǰ����GROUP_FAMILY_VERSION��GROUP_INFO
 * @author 
 */
public class FamilyVersionApplyOpinionAction extends Bizlet {
	//���ſͻ�ID
	private String sGroupID = "";
	//���װ汾ID
	private String sVersionSeq = "";
	//�û�ID
	private String sUserID = "";
	//���ݿ����� 
	private Transaction Sqlca = null;

	public Object run(Transaction Sqlca) throws Exception{
		 this.Sqlca = Sqlca;
		 //��ȡ����
		 sGroupID = (String)this.getAttribute("GroupID");
		 sVersionSeq = (String)this.getAttribute("VersionSeq");	
		 sUserID = (String)this.getAttribute("UserID");
		
		 //����ֵת��Ϊ���ַ���
		 if(sGroupID == null) sGroupID = "";
		 if(sVersionSeq == null) sVersionSeq = "";
		 if(sUserID == null) sUserID = "";
		 
		 //�������
		 String sReturn = "0";
		 String sSql = "";
		 ASResultSet rs = null;						//��ѯ�����
		 String sGroupType2="";
		 
		/** ���ݼ��ſͻ���ţ���ѯ*/
		 sSql = " select GroupType2 from GROUP_INFO where GroupID = :GroupID ";
	     rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("GroupID", sGroupID));
			
	        /** ��ȡ��ѯ��� */
			if(rs.next()){
				sGroupType2=rs.getString("GroupType2");
			}
			rs.getStatement().close();
			rs = null;	
			if(sGroupType2 == null) sGroupType2 = "";
		 
         //����GROUP_FAMILY_VERSION��GROUP_INFO
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
