/**
 * 
 */
package com.amarsoft.app.als.product;

import com.amarsoft.app.als.credit.common.model.CreditConst;
import com.amarsoft.app.bizmethod.BizSort;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * ���ŷ�������ģ��:���顪��ͼ�ڵ�����
 * 
 * @author yzheng
 * @date 2013/05/23
 * 
 * @history 			
 * 		2013.05.25 yzheng �޸���ͼ�ڵ����ɷ�ʽ, ���CreditView
 * 		2013.06.14 yzheng �ϲ�CreditLineView
 * 		2013.06.27 yzheng �ϲ�InputCreditView
 */
public class PRDTreeViewNodeGenerator 
{
/*	private String businessType;  //��Ʒ���
	private String objectType;      //�׶�����
	private String occurType;       //�������͡���Զ������/����
	private String applyType;      //�������͡���Զ������/����*/	
	private String approveNeed;   //һ��ҵ��������Ƿ���Ҫ������������ͬ�׶Ρ���Զ������/��������
	private int schemeType;         //���ۺ����ű�š����Ŷ������
	private String creditLineID;     //���ŷ�������  0:���Ŷ������(����+�ǲ���) 1: �������/������������(����+�ǲ���)
	
	/**
	 * ���캯��
	 * @param approveNeed  һ��ҵ��������Ƿ���Ҫ������������ͬ�׶Ρ���Զ������/��������
	 * @param schemeType
	 * @param creditLineID
	 */
	public PRDTreeViewNodeGenerator(String approveNeed) {
		this.approveNeed = approveNeed;
		this.schemeType= 0; 
		this.creditLineID = "";
	}

	/**
	 * @param objectType  �׶�����
	 * @param objectNo     ��ˮ��
	 * 
	 * @return sSqlTreeView SQL�Ӿ������������޶�ѡȡ�Ľڵ�����������ͼ
	 * @throws Exception 
	 */
	public String generateSQLClause(Transaction Sqlca, String  objectType, String objectNo) throws Exception
	{
		//String customerID = "";
		String businessType = "";  //��Ʒ����
		String occurType = "";  //�������͡��������/����
		String applyType="";  //�������� ���������/����
		String table="";
		
		//����sObjectType�Ĳ�ͬ���õ���ͬ�Ĺ���������ģ����
		String sSql="select ObjectTable from OBJECTTYPE_CATALOG where ObjectType=:ObjectType";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType",objectType));
		if(rs.next()){ 
			table=DataConvert.toString(rs.getString("ObjectTable"));
		}
		rs.getStatement().close(); 
		
		sSql="select CustomerID,OccurType,ApplyType,ProductID from "+table+" where SerialNo= :SerialNo";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",objectNo));
		if(rs.next()){
			//customerID=DataConvert.toString(rs.getString("CustomerID"));  //���Ŷ��|����
			businessType=DataConvert.toString(rs.getString("ProductID"));  //���Ŷ��|����
			occurType=DataConvert.toString(rs.getString("OccurType"));  //�������/����
			applyType=DataConvert.toString(rs.getString("ApplyType"));  //�������/����
		}
		rs.getStatement().close(); 
		
		//if(occurType == null) occurType = "";
		if(applyType == null) applyType = "";
		
		//������ͼ�ڵ����
		String sSqlTreeView  = "from PRD_NODEINFO, PRD_NODECONFIG where PRD_NODEINFO.NODEID = PRD_NODECONFIG.NODEID and PrdId = '" + businessType + "' and";
		
		//������Ŷ������
		if(objectType.equals(CreditConst.CREDITOBJECT_REINFORCECONTRACT_VIRTUAL)){   //����
			sSql = " select LineID from CL_INFO where BCSerialNo =:BCSerialNo order by LineID";
			creditLineID = Sqlca.getString(new SqlObject(sSql).setParameter("BCSerialNo",objectNo));
			sSqlTreeView += " Fac4 = '1' ";  //(������������)
		}
		else{  //4��׶�
			if(objectType.equals(CreditConst.CREDITOBJECT_APPLY_REAL)){
				sSql = " select LineID from CL_INFO where ApplySerialNo =:ObjectNo and (Parentlineid is null or Parentlineid = ' ') order by LineID";
				sSqlTreeView += " Fac1 = '1' ";  //����
			}
			else if(objectType.equals(CreditConst.CREDITOBJECT_APPROVE_REAL)){
				sSql = " select LineID from CL_INFO where ApproveSerialNo =:ObjectNo and (Parentlineid is null or Parentlineid = ' ') order by LineID";
				sSqlTreeView += " Fac2 = '1' ";  //����
			}
			else if(objectType.equals(CreditConst.CREDITOBJECT_CONTRACT_REAL)){
				sSql = " select LineID from CL_INFO where BCSerialNo =:ObjectNo and (Parentlineid is null or Parentlineid = ' ') order by LineID";
				sSqlTreeView += " Fac3 = '1' ";  //��ͬ
			}
			else if(objectType.equals(CreditConst.CREDITOBJECT_CONTRACT_QUERY)){
				sSql = " select LineID from CL_INFO where BCSerialNo =:ObjectNo and (Parentlineid is null or Parentlineid = ' ') order by LineID";
				sSqlTreeView += " Fac5 = '8' ";  //��ͬ
			}
			else if(objectType.equals(CreditConst.CREDITOBJECT_AFTERLOANCONTRACT_VIRTUAL)){
				sSql = " select LineID from CL_INFO where BCSerialNo =:ObjectNo and (Parentlineid is null or Parentlineid = ' ') order by LineID";
				sSqlTreeView += " Fac4 = '1' ";  //����
			}
			creditLineID = Sqlca.getString(new SqlObject(sSql).setParameter("ObjectNo",objectNo));
		}
		
		if(creditLineID == null){  //�������/����(����+�ǲ���)
			schemeType = 1;
			creditLineID = "";
		}
		
		//�ж��׶�
/*	    if(objectType.equals(CreditConst.CREDITOBJECT_APPLY_REAL)){  
	    	sSqlTreeView += " Fac1 = '1' ";  //����
	    }
	    else if(objectType.equals(CreditConst.CREDITOBJECT_APPROVE_REAL)){      
	    	sSqlTreeView += " Fac2 = '1' ";  //����
        }
	    else if(objectType.equals(CreditConst.CREDITOBJECT_CONTRACT_REAL)){  
	    	sSqlTreeView += " Fac3 = '1' ";  //��ͬ
	    }
	    else if(objectType.equals(CreditConst.CREDITOBJECT_AFTERLOANCONTRACT_VIRTUAL) || objectType.equals(CreditConst.CREDITOBJECT_REINFORCECONTRACT_VIRTUAL)){  
	    	sSqlTreeView += " Fac4 = '1' ";  //����(������������)
	    }*/
	    
	    //�ж����ŷ�������
	    if(schemeType == 0){  //���Ŷ��
/*	    	if(businessType.startsWith("3020")){ 
	    		sSql += " and PRD_NODECONFIG.NodeID <> '080'";  //�����ۺ����Ŷ�����Ͳ�չʾ���ն������ڵ�(ID: '080')  �ýڵ��Ѿ�ͣ��
	    	}*/
	    	//Ԥ��
	    }
	    else if(schemeType == 1){  //�������/��������(����+�ǲ���)
			//�жϷ�������
/*			if(occurType.equals("010")){ //018��ͣ�ã�ͳһ�ɽ����Ϣ����
				sSqlTreeView += " and PRD_NODECONFIG.NodeID <> '018'";  //�·�����չʾ����ҵ����Ϣ�ڵ�(ID: '018')
			}*/
	    	if(!occurType.equals("015")){
	    		if(!objectType.equals(CreditConst.CREDITOBJECT_REINFORCECONTRACT_VIRTUAL) && !objectType.equals(CreditConst.CREDITOBJECT_AFTERLOANCONTRACT_VIRTUAL)){
	    			sSqlTreeView += " and PRD_NODECONFIG.NodeID <> '050'";  //չ��4���׶ζ�չʾ�����Ϣ(ID: '050')
	    		}
			}
			//�޸Ķ������ҵ����ͼ���ɷ�ʽ
			if(applyType.equals(CreditConst.APPLYTYPE_INDEPENDENT)){
				sSqlTreeView += " and PRD_NODECONFIG.NodeID <> '019'";  //���ʵ������Ͳ�չʾ���������Ϣ�ڵ�(ID: '019')
			}
			BizSort bs = new BizSort(Sqlca,objectType,objectNo,approveNeed,businessType);
		    //������������ʽ�������ʾ"��������������"�ڵ�    (ID: '090')
			if(bs.isLiquidity() != true){
				sSqlTreeView += " and PRD_NODECONFIG.NodeID <> '090'";
			}
	    }
		
		return sSqlTreeView;
	}
	
	/** 
	 * @return creditLineID ���ۺ����ű��
	 */
	public String getCreditLineID(){
		return creditLineID;
	}
	
	/**
	 * @return schemeType ��������
	 */
	public int getSchemeType(){
		return schemeType;
	}
}