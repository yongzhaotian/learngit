package com.amarsoft.app.bizmethod;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class BizSort {
	
	private boolean liquidity ;//�����ʽ�����־λ
	private boolean fixed ;//�̶��ʲ������־λ
	private boolean project ;//��Ŀ���ʱ�־λ
	private boolean bizSort ;//��Ʒ�����־λ
	private String sSql = "";
	private Transaction Sqlca = null;
	private ASResultSet rs = null;//��ѯ�����
	
	/**
	 * @author smiao 2011-5-31
	 * <p>
	 * 	��֪��ҵ��Ʒ�ֱ��ʱ����֪������ҵ���ʱ��ʹ�øù��췽����ȡBUSINESS_TYPE�в�Ʒ�����־λ��
	 * </p>
	 * @param Sqlca
	 * @param typeNo
	 * @throws Exception
	 */
	public BizSort(Transaction Sqlca ,String typeNo)throws Exception{
		this.Sqlca = Sqlca;
		updateSortValue(typeNo);
	}
	
	/**
	 * <p>
	 * 	����������ͬ���Ŵ��Ƚ׶Σ�ʹ�øù��췽������ȡ����׶��е�IsLiquidity,IsFixed,IsProject��ֵ
	 * </p>
	 * @param Sqlca
	 * @param objectType
	 * @param objectNo
	 * @param approveNeed
	 * @param typeNo
	 * @throws Exception 
	 * @throw Exception
	 */		
	public BizSort(Transaction Sqlca ,String objectType,String objectNo,String approveNeed,String typeNo)throws Exception{

		this.Sqlca = Sqlca;
		
		/**
		 * ��ȡBUSINESS_TYPE�в�Ʒ�����־λ
		 */
		updateSortValue(typeNo);
		
		//��������ڴ����¹����Χ������Ĭ��ֵ
		if(this.bizSort == false){
			liquidity = false;
			fixed = false;
			project = false;
		}else{
			//����SortAttributes
			calculateSortAttributesValue(this.Sqlca,objectType,objectNo,approveNeed,typeNo);
		}
	}

	/**
	 * ����objecttype����Ϣ�ж�sortAttributesȡֵ
	 */
	private void calculateSortAttributesValue(Transaction Sqlca ,String objectType,String objectNo,String approveNeed,String typeNo) throws Exception{
		String bAPSerialNo = "";//BUSINESS_APPROVE��SerialNo
		String bASerialNo = "";//BUSINESS_APPLY��SerialNo
		
		//objectTypeΪ��ͬ���ߴ����ͬ
		if(objectType.equals("BusinessContract")||objectType.equals("AfterLoan"))
		{
			//����approveNeed���ж�ҵ���Ƿ���Ҫ����
			if(approveNeed.equals("true"))
			{
				//��ȡBUSINESS_APPROVE��SerialNo
				sSql = "select RelativeSerialNo from BUSINESS_CONTRACT where SerialNo = :SerialNo";
				rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", objectNo));
				if(rs.next())
				{
					bAPSerialNo = rs.getString("RelativeSerialNo");
				}
				rs.getStatement().close();
				//��ȡBUSINESS_APPLY��SerialNo
				sSql = "select RelativeSerialNo from BUSINESS_APPROVE where SerialNo = :SerialNo";
				rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", bAPSerialNo));
				if(rs.next())
				{
					bASerialNo = rs.getString("RelativeSerialNo");
				}
				rs.getStatement().close();
			}else
			{
				//��ȡBUSINESS_APPLY��SerialNo
				sSql = "select RelativeSerialNo from BUSINESS_CONTRACT where SerialNo = :SerialNo";
				rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", objectNo));
				if(rs.next())
				{
					bASerialNo = rs.getString("RelativeSerialNo");
				}
				rs.getStatement().close();
			}
			updateSortAttributesValueFromBA(bASerialNo);	
		}else if(objectType.equals("ApproveApply"))   //objectTypeΪ�����������
		{
			//��ȡBUSINESS_APPLY��SerialNo
			sSql = "select RelativeSerialNo from BUSINESS_APPROVE where SerialNo = :SerialNo";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", objectNo));
			if(rs.next())
			{
				bASerialNo = rs.getString("RelativeSerialNo");
			}
			rs.getStatement().close();
			updateSortAttributesValueFromBA(bASerialNo);	
		}else if(objectType.equals("CreditApply")) //objectTypeΪ��������
		{
			bASerialNo = objectNo;
			
			if(isDetailInCreditApply(bASerialNo)){
				updateSortAttributesValueFromBA(bASerialNo);	//���Ϊ����ҳ��ʱ��������־λ��BUSINESS_APPLY��ȡֵ
			}else{
				updateSortAttributesValueFromBS(typeNo);//���Ϊ����ҳ��ʱ��������־λ��BUSINESS_SORT��ȥĬ��ֵ
			}
		}else 
		{
			//���objectType�ǳ����������͵��������ͣ����BUSINESS_SORTȡϵͳĬ��ֵ
			updateSortAttributesValueFromBS(typeNo);
		}
	}
	
	/**
	 * ��ȡ����׶ε�IsLiquidity,IsFixed,IsProject
	 */
	private void updateSortAttributesValueFromBA(String serialNo) throws Exception{
		sSql = "select IsLiquidity,IsFixed,IsProject from BUSINESS_APPLY where SerialNo = :SerialNo";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", serialNo));
		if(rs.next())
		{		
				if(rs.getString("IsLiquidity") == null || rs.getString("IsFixed") == null || rs.getString("IsProject") == null ){
					throw new AmarBizMethodException("�ñ�ҵ������¹�����ֶ�������ֵ��");
				}else{
					liquidity = rs.getString("IsLiquidity").equals("1") ? true : false;
					fixed = rs.getString("IsFixed").equals("1") ? true : false;
					project = rs.getString("IsProject").equals("1") ? true : false;
				}		
		}
		rs.getStatement().close();	
	}
	
	/**
	 * ��ȡBUSINESS_SORT��IsLiquidity,IsFixed,IsProject,��ΪĬ��ֵ
	 */
	private void updateSortAttributesValueFromBS(String typeNo) throws Exception{
		sSql = "select IsLiquidity,IsFixed,IsProject from BUSINESS_SORT where TypeNo = :TypeNo";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("TypeNo", typeNo));
		if(rs.next())
		{
			if(rs.getString("IsLiquidity") == null || rs.getString("IsFixed") == null || rs.getString("IsProject") == null ){
				throw new AmarBizMethodException("��ҵ��Ʒ�ִ����¹�������ֵ��");
			}else{
				liquidity = rs.getString("IsLiquidity").equals("1") ? true : false;
				fixed = rs.getString("IsFixed").equals("1") ? true : false;
				project = rs.getString("IsProject").equals("1") ? true : false;
			}			
		}
		rs.getStatement().close();
	}
	
	
	/**
	 * 
	 * ��ȡBUSINESS_TYPE�в�Ʒ�����־λ
	 */
	private void updateSortValue(String typeNo) throws Exception{
		//��ȡBUSINESS_TYPE��Attribute3����Ʒ�����־λ��
		sSql = "select Attribute3 from BUSINESS_TYPE where TypeNo=:TypeNo";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("TypeNo", typeNo));
		if(rs.next()){
			if(rs.getString("Attribute3") == null){
				throw new AmarBizMethodException("��ҵ��Ʒ���ֶΣ��Ƿ����ڴ����¹���ֵ��");
			}else{
				bizSort = rs.getString("Attribute3").equals("1") ? true : false;
			}
		}
		rs.getStatement().close();
	}	
	
	/**
	 * �ж�����׶����������뻹�ǲ鿴������ҳ��
	 */
	private boolean isDetailInCreditApply(String serialNo) throws Exception{
		
		boolean isDetail = false;
		sSql = "select IsLiquidity,IsFixed,IsProject from BUSINESS_APPLY where SerialNo = :SerialNo";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", serialNo));
		if(rs.next())
		{		
				if(rs.getString("IsLiquidity") == null || rs.getString("IsFixed") == null || rs.getString("IsProject") == null ){
					isDetail = false;
				}else{
					isDetail = true;
				}		
		}else{//���ֻ����ˮ�ţ���û�ж�Ӧ��¼
			isDetail = false;
		}
		rs.getStatement().close();	
		return isDetail;
		
	}
	
	
	/**
	 * �Ƿ������ʽ����
	 * ��ʹ�ù��췽��BizSort(Transaction Sqlca ,String typeNo)�½�����ʱ��������ʹ�á�
	 * @return liquidity
	 */
	public boolean isLiquidity() {
		return liquidity;
	}

	/**
	 * �Ƿ�̶��ʲ�����
	 * ��ʹ�ù��췽��BizSort(Transaction Sqlca ,String typeNo)�½�����ʱ��������ʹ�á�
	 * @return fixed
	 */
	public boolean isFixed() {
		return fixed;
	}

	/**
	 * �Ƿ���Ŀ����
	 * ��ʹ�ù��췽��BizSort(Transaction Sqlca ,String typeNo)�½�����ʱ��������ʹ�á�
	 * @return project
	 */
	public boolean isProject() {
		return project;
	}
	
	/**
	 * �Ƿ����ڴ����¹����Χ
	 * @return bizSort
	 */
	public boolean isBizSort() {
		return bizSort;
	}
}
