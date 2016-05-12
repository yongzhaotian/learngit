package com.amarsoft.app.als.flow.cfg.web;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/*
 * add by phe 2015/04/26 
 * ���ڲ�ѯ������ͼ�Ĵ���������ĸ�������ͼ������ˢ�£�
 */
public class selectNewContract {
			private String ObjectType = null;
			private String TempFlowNo=null;
			private String UserId = null;
			private String orgId = null;
			
			public String getObjectType() {
				return ObjectType;
			}
			public void setObjectType(String objectType) {
				ObjectType = objectType;
			}
			public String getTempFlowNo() {
				return TempFlowNo;
			}
			public void setTempFlowNo(String tempFlowNo) {
				TempFlowNo = tempFlowNo;
			}
			public String getUserId() {
				return UserId;
			}
			public void setUserId(String userId) {
				UserId = userId;
			}
			public String getOrgId() {
				return orgId;
			}
			public void setOrgId(String orgId) {
				this.orgId = orgId;
			}
			
			
			public String selectNewContractString(Transaction Sqlca) {
				String sPageShow = null;
				String sFlowCount = null;
				String sSql = "";
				ASResultSet rsTemp = null;
			    try{
				TempFlowNo = TempFlowNo.replace("@", ",");
				/*
				sSql = "select count(1) as sCount from FLOW_TASK FT,BUSINESS_CONTRACT BC where FT.ObjectType = :ObjectType "+
						" and FT.Objectno = BC.Serialno"+
							" and FT.FlowNo in "+TempFlowNo+" "+
						" and (FT.UserID =:UserId or (FT.GroupInfo like '%"+UserId+"%' and FT.UserID is null)) and (FT.EndTime is  null or FT.EndTime =' ' or FT.EndTime ='') and FT.PhaseNo <> '0010'";
				*/
				//��ȥ�������������������ѯ  update huzp 20150611
				if( orgId.equals("10")){//��ز���¼��ִ��ֻ��ѯ��CEר����˵ĵ���
					sSql = "select count(1) as sCount from FLOW_TASK FT,BUSINESS_CONTRACT BC where FT.ObjectType = :ObjectType "+
							" and FT.Objectno = BC.Serialno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='')"+
								" and FT.FlowNo in "+TempFlowNo+" "+
							" and FT.GroupInfo like '%"+UserId+"%' and FT.UserID is null and (FT.EndTime is  null or FT.EndTime =' ' or FT.EndTime ='') and ft.phasetype ='1020'  and ft.phasename =  'CEר�����'";
			   	   	
			   	}else if(orgId.equals("11")){//��˲���¼��ִ��ֻ��ѯ�����רԱ�ĵ���
			   		sSql = "select count(1) as sCount from FLOW_TASK FT,BUSINESS_CONTRACT BC where FT.ObjectType = :ObjectType "+
							" and FT.Objectno = BC.Serialno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='')"+
								" and FT.FlowNo in "+TempFlowNo+" "+
							" and FT.GroupInfo like '%"+UserId+"%' and FT.UserID is null and (FT.EndTime is  null or FT.EndTime =' ' or FT.EndTime ='') and ft.phasetype ='1020'  and ft.phasename <>  'CEר�����'";
			   	   	
			   	}else{//�������Ȩ��������ҳ�汨����ѯ�����еĵ���
			   		sSql = "select count(1) as sCount from FLOW_TASK FT,BUSINESS_CONTRACT BC where FT.ObjectType = :ObjectType "+
							" and FT.Objectno = BC.Serialno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='')"+
								" and FT.FlowNo in "+TempFlowNo+" "+
							" and FT.GroupInfo like '%"+UserId+"%' and FT.UserID is null and (FT.EndTime is  null or FT.EndTime =' ' or FT.EndTime ='') and ft.phasetype ='1020' ";
			   	   	
			   	}
				rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter( "ObjectType", ObjectType));
				if (rsTemp.next()) {
					sFlowCount = DataConvert.toString(rsTemp.getString("sCount"));
				}
				sPageShow  = "��ǰ��������"+sFlowCount+"��";
				rsTemp.getStatement().close();
				

				
			    }catch (Exception e) {
			    	ARE.getLog("TempFlowNo============="+TempFlowNo);
			    	ARE.getLog("UserId============="+UserId);
			    	ARE.getLog("ObjectType============="+ObjectType);
			    	ARE.getLog("orgId============="+orgId);
			    	return "";
				}
			    return sPageShow;
			}
			
}
