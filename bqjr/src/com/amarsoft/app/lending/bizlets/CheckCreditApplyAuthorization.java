package com.amarsoft.app.lending.bizlets;

import com.amarsoft.amarscript.Any;
import com.amarsoft.amarscript.Expression;
import com.amarsoft.app.aa.AuthorizationException;
import com.amarsoft.app.aa.AuthorizationPoint;
import com.amarsoft.app.aa.Policy;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.res.AppBizObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * @author William
 * ��Bizlet���ڼ����Ȩ<br>
 * ��������һ����Ȩ����ʾ��������<br>
 *  - ��Ȩ��ά��Ϊ�����̽׶Ρ���������Ʒ��������ʽ<br>
 *  - ��Ȩ�Ķ���Ϊ������ҵ���ܽ�����ޡ��������޽�����Ȩ<br>
 *  - δ���Ƕ���ֵ�����<br>
 *  - ������ʽ�������в�θе�<br>
 *  - ��Ʒ���壨BUSINESS_TYPE����SortNo���в�θе�<br>
 * ����Ŀ�����е�����<br>
 */
public class CheckCreditApplyAuthorization extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		String sFlowNo = (String)this.getAttribute("FlowNo");
		String sPhaseNo = (String)this.getAttribute("PhaseNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sPolicyID = (String)this.getAttribute("PolicyID");
		String sOrgID = (String)this.getAttribute("OrgID");
		
		if(sObjectType==null || !sObjectType.equals("CreditApply")){
			throw new Exception("����Ķ�������:"+sObjectType);
		}
		AppBizObject bo = new AppBizObject(Sqlca,sObjectType,sObjectNo);
		
		if(sPolicyID==null){
			SqlObject so = new SqlObject("select AAPolicy from FLOW_CATALOG where FlowNo=:FlowNo ").setParameter("FlowNo", sFlowNo);
			sPolicyID = Sqlca.getString(so);
		}

		//��һ����ȡҵ������
		initBizObjectData(Sqlca,bo);
		
		//�ڶ������������ҵ�񡢸����̶�Ӧ��Ȩ�޵�
		Policy policy = new Policy(Sqlca,sPolicyID);
		
		AuthorizationPoint point = null;
		AuthorizationPoint[] aapoints = policy.getAuthPoints(Sqlca);
		
		//�Ӻ���ǰ�ң����ҵ��ĵ�һ����Ȩ��Ϊ׼
		for(int i=aapoints.length-1;i>=0;i--){
			//ע�⣺���н�����Ȩ��ƥ��Ļ������ǵ�ǰ���������ڻ���,����ҵ�����
			if(checkFlowPhaseCompliance(aapoints[i],sFlowNo,sPhaseNo)
				&& checkProductCompliance(aapoints[i],(String)bo.getAttribute("BusinessType"))
				&& checkVouchTypeCompliance(aapoints[i],(String)bo.getAttribute("VouchType"))
				&& checkOrgCompliance(aapoints[i],sOrgID)){
				point =  aapoints[i];
			}
		}
		if(point == null) return "û���ҵ��Ը���ҵ�����Ȩ���壨����:"+sFlowNo+",�׶�:"+sPhaseNo+",��Ʒ:"+bo.getAttribute("ProductSortNo")+",������ʽ���:"+bo.getAttribute("VouchType")+"����";
		
		//��������������Ȩ�㶨��������������壬ȡ�ø���Ȩ����������ʽ�����ޡ��������ʳ�����Ȩ���ޡ��������������Ȩ���ޡ���������������Ȩ���ޡ�������������
		double dBizBalanceCeiling = 0;
		double dBizExposureCeiling = 0;
		double dCustBalanceCeiling = 0;
		double dCustExposureCeilin = 0;
		double dInterestRateFloor = 0;
		
		/*
		 * ��˳�������ж�����������ֻҪ����һ�������������㣬
		 * ���Ը������������������ʽ�����ޡ��������ʳ�����Ȩ���ޡ�
		 * �������������Ȩ���ޡ���������������Ȩ���ޡ���Ȩ������Ϊ��Ȩ�����Ȩ����Ȩ����
		 */
		AuthorizationException matchedException = null;
		for(int i=0;i<point.countExceptions();i++){
			if(matchExceptionType(Sqlca,point,point.getException(i),bo)){
				matchedException=(AuthorizationException)point.getException(i);
				break;
			}
		}

		/*�����������������������������������������ʽ�����ޡ��������ʳ�����Ȩ���ޡ�
		 * �������������Ȩ���ޡ���������������Ȩ���ޡ���Ȩ����Ϊ׼��
		 * ��������Ȩ����������ʽ�����ޡ��������ʳ�����Ȩ���ޡ�
		 * �������������Ȩ���ޡ���������������Ȩ���ޡ���Ȩ����Ϊ׼*/
		if(matchedException!=null){
			dBizBalanceCeiling = toDouble(matchedException.getAttribute("AE.BizBalanceCeiling"));
			dBizExposureCeiling = toDouble(matchedException.getAttribute("AE.BizExposureCeiling"));
			dCustBalanceCeiling = toDouble(matchedException.getAttribute("AE.CustBalanceCeiling"));
			dCustExposureCeilin = toDouble(matchedException.getAttribute("AE.CustExposureCeilin"));
			dInterestRateFloor = toDouble(matchedException.getAttribute("AE.InterestRateFloor"));
		}else{
			dBizBalanceCeiling = toDouble(point.getAttribute("BizBalanceCeiling"));
			dBizExposureCeiling = toDouble(point.getAttribute("AE.BizExposureCeiling"));
			dCustBalanceCeiling = toDouble(point.getAttribute("AE.CustBalanceCeiling"));
			dCustExposureCeilin = toDouble(point.getAttribute("AE.CustExposureCeilin"));
			dInterestRateFloor = toDouble(point.getAttribute("InterestRateFloor"));
		}

		/*���Ĳ������������ʽ�����ޡ��������ʳ�����Ȩ���ޡ�
		 * �������������Ȩ���ޡ���������������Ȩ���ޡ���Ȩ����*/
		if(toDouble(bo.getAttribute("BusinessSum")) > dBizBalanceCeiling) return "������Ȩ�������ʽ������";
		if(toDouble(bo.getAttribute("Exposure")) > dBizExposureCeiling) return "������Ȩ�������ʳ��ڽ������";
		if(toDouble(bo.getAttribute("TotalSum")) > dCustBalanceCeiling) return "������Ȩ���������������";
		if(toDouble(bo.getAttribute("ExposureSum")) > dCustExposureCeilin) return "������Ȩ�����������ڽ������";
		if(toDouble(bo.getAttribute("BusinessRate")) > dInterestRateFloor) return "���ʳ�����Ȩ������������";

		/*���岽����������ľ�������Ƿ�������������*/
		if(!(checkOrgCompliance(point,(String)bo.getAttribute("OperateOrgID")))) return "����ľ������������Ȩ������Χ";

		/*����������������Ĳ�Ʒ�Ƿ�������������*/
		if(!(checkProductCompliance(point,(String)bo.getAttribute("BusinessType")))) return "����Ĳ�Ʒ������Ȩ��Ʒ��Χ";
			
		/*���߲��������������Ҫ������ʽ�Ƿ�������������*/
		if(!(checkVouchTypeCompliance(point,(String)bo.getAttribute("VouchType")))) return "�������Ҫ������ʽ������Ȩ������ʽ��Χ";

		/*�ڰ˲�����������ľ�������Ƿ�������������*/
		if(!(checkFlowPhaseCompliance(point,sFlowNo,sPhaseNo))) return "�������������̺ͽ׶γ�����Ȩ���̺ͽ׶η�Χ";
		
		/*�����Ŀ����Ҫ����������Ȩ�ھ������ڴ˽���������չ*/
		//------------------------------begin--------------------
		

		
		//------------------------------end----------------------
		//���ͨ����Ȩ�жϣ��򷵻ؿ��ַ���
		return "Pass";
	}
	
	
	private void initBizObjectData(Transaction Sqlca,AppBizObject bo) throws Exception{
		SqlObject so ;//��������
		String sSql = 	" select CustomerID,BusinessType,VouchType,OperateOrgID,OperateUserID,RiskRate, "+
		" BusinessSum*getERate(BusinessCurrency,'01','') as BusinessSum,BailSum,BusinessRate "+
		" from BUSINESS_APPLY where SerialNo=:SerialNo ";
		so = new SqlObject(sSql).setParameter("SerialNo", bo.getObjKey());
		ASResultSet rs = Sqlca.getASResultSet(so);
		if(rs.next()){	
			String sCustomerID = rs.getString("CustomerID");
			String sBusinessType = rs.getString("BusinessType");
			String sVouchType = rs.getString("VouchType");
			String sOperateOrgID = rs.getString("OperateOrgID");
			String sOperateUserID = rs.getString("OperateUserID");
			String sRiskRate = rs.getString("RiskRate");
			String sBusinessSum = rs.getString("BusinessSum");
			String sBailSum = rs.getString("BailSum");
			String sBusinessRate = rs.getString("BusinessRate");
			
			//����ֵת��Ϊ���ַ���
			if(sCustomerID == null) sCustomerID = "";
			if(sBusinessType == null) sBusinessType = "";
			if(sVouchType == null) sVouchType = "";
			if(sOperateOrgID == null) sOperateOrgID = "";
			if(sOperateUserID == null) sOperateUserID = "";
			if(sRiskRate == null) sRiskRate = "0.0";
			if(sBusinessSum == null) sBusinessSum = "0.0";
			if(sBailSum == null) sBailSum = "0.0";
			if(sBusinessRate == null) sBusinessRate = "0.0";
			
			//����ѯ����������Ϣ����bo����
			bo.setAttribute("CustomerID",sCustomerID);
			bo.setAttribute("BusinessType",sBusinessType);
			bo.setAttribute("VouchType",sVouchType);
			bo.setAttribute("OperateOrgID",sOperateOrgID);
			bo.setAttribute("OperateUserID",sOperateUserID);			
			bo.setAttribute("RiskRate",sRiskRate);			
			bo.setAttribute("BusinessSum",sBusinessSum);
			bo.setAttribute("BailSum",sBailSum);
			bo.setAttribute("BusinessRate",sBusinessRate);
			/*�ñ�����ҵ��ĳ��ڽ��=�ñ�����ҵ���������ñ�����ҵ��ı�֤����
			 * �����Щ���������뱣֤����ʣ��������뱣��ʱ����֤�����������������BailSum��
			 */
			bo.setAttribute("Exposure",String.valueOf(rs.getDouble("BusinessSum")-rs.getDouble("BailSum")));
			/*
			 * Ŀǰԭ��ϵͳ���������ִ�������ʣ�����ֱ�ӽ����жϡ�
			 * �����Ŀ�鲻��ֱ������ִ�������ʣ����ڴ˴������������Ϣ���м��㡣
			 */
			bo.setAttribute("BusinessRate",String.valueOf(rs.getDouble("BusinessRate")));
			/*��ȡ�ÿͻ��ĵ������
			 * Ŀǰԭ��ϵͳ����ҵ���ͬ���л�ȡ�ÿͻ��ۼƵķ��Ž��
			 * �����Ŀ����㵥����ͬ�����޸ĸ÷���
			 */
			bo.setAttribute("TotalSum",String.valueOf(getTotalSum(Sqlca,rs.getString("CustomerID"))));
			/*��ȡ�ÿͻ��ĵ������ڽ��
			 * Ŀǰԭ��ϵͳ����ҵ���ͬ���л�ȡ�ÿͻ��ۼƵķ��Ž���֤����
			 * �����Ŀ����㵥�����ڽ�ͬ�����޸ĸ÷���
			 */
			bo.setAttribute("Exposure",String.valueOf(getExposureSum(Sqlca,rs.getString("CustomerID"))));
			
		}else{
			rs.getStatement().close();
			throw new Exception("û���ҵ�����:["+bo.getType().getObjectType()+":"+bo.getObjKey()+"]");
		}
		rs.getStatement().close();
		
		so = new SqlObject("select SortNo from BUSINESS_TYPE where TypeNo=:TypeNo ").setParameter("TypeNo", (String)bo.getAttribute("BusinessType"));
		String sProductSortNo = Sqlca.getString(so);
		bo.setAttribute("ProductSortNo",sProductSortNo);
	}
	
	/**
	 * �������Ž��
	 * @param Sqlca ���ݿ�����
	 * @param sCustomerID �ͻ����
	 * @return �������Ž��
	 * @throws Exception
	 */
	private double getTotalSum(Transaction Sqlca,String sCustomerID) throws Exception{
		double dTotalSum = 0.0;
		String sSql = " select sum(BusinessSum*getERate(BusinessCurrency,'01','')) as BusinessSum "+
		" from BUSINESS_CONTRACT where CustomerID =:CustomerID and BusinessType not like  '3%' ";//�����֮��
		SqlObject so = new SqlObject(sSql).setParameter("CustomerID",sCustomerID);
		ASResultSet rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			dTotalSum = rs.getDouble("BusinessSum");
		}
		rs.getStatement().close();
		
		return dTotalSum;
	}
	
	/**
	 * �������ų��ڽ��
	 * @param Sqlca ���ݿ�����
	 * @param sCustomerID �ͻ����
	 * @return �������ų��ڽ��
	 * @throws Exception
	 */
	private double getExposureSum(Transaction Sqlca,String sCustomerID) throws Exception{
		double dExposureSum = 0.0;
		String sSql = " select sum(BusinessSum*getERate(BusinessCurrency,'01','')-BailSum) as ExposureSum "+
		" from BUSINESS_CONTRACT where CustomerID =:CustomerID and BusinessType not like  '3%' ";//�����֮��
		SqlObject so = new SqlObject(sSql).setParameter("CustomerID",sCustomerID);
		ASResultSet rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			dExposureSum = rs.getDouble("ExposureSum");
		}
		rs.getStatement().close();
		
		return dExposureSum;
	}
	
	/**
	 * ��Ʒ���ƥ��
	 * @param authPoint ��Ȩ��
	 * @param sProductSortNo ҵ��Ĳ�Ʒ�����
	 * @return �Ƿ�ƥ��
	 * @throws Exception
	 */
	private boolean checkProductCompliance(AuthorizationPoint authPoint,String sProductSortNo) throws Exception{
		String sAuthProduct = (String)authPoint.getAttribute("ProductID");
		if(sAuthProduct==null || sAuthProduct.equals("")) return true;
		else if(sProductSortNo.indexOf(sAuthProduct)>=0) return true;
		else return false;
	}

	/**
	 * �������ƥ��
	 * @param authPoint ��Ȩ��
	 * @param sGuarantyType ҵ��ĵ�������
	 * @return �Ƿ�ƥ��
	 * @throws Exception
	 */
	private boolean checkVouchTypeCompliance(AuthorizationPoint authPoint,String sGuarantyType) throws Exception{
		String sAuthGuarantyCategory = (String)authPoint.getAttribute("GuarantyCategory");
		if(sAuthGuarantyCategory==null || sAuthGuarantyCategory.equals("")) return true;
		else if(sGuarantyType.indexOf(sAuthGuarantyCategory)>=0) return true;
		else return false;
	}

	/**
	 * ����ƥ��
	 * @param authPoint ��Ȩ��
	 * @param sOrgID ��ǰ�����˵Ļ�����
	 * @return �Ƿ�ƥ��
	 * @throws Exception
	 */
	private boolean checkOrgCompliance(AuthorizationPoint authPoint,String sOrgID) throws Exception{
		String sAuthOrg = (String)authPoint.getAttribute("OrgID");
		if(sAuthOrg==null || sAuthOrg.equals("")) return true;
		else if(sOrgID.equals(sAuthOrg)) return true;
		else return false;
	}

	/**
	 * ���̽׶�ƥ��
	 * @param authPoint ��Ȩ��
	 * @param sFlowNo ���̱��
	 * @param sPhaseNo �׶α��
	 * @return �Ƿ�ƥ��
	 * @throws Exception
	 */
	private boolean checkFlowPhaseCompliance(AuthorizationPoint authPoint,String sFlowNo,String sPhaseNo) throws Exception{
		String sAuthFlow = (String)authPoint.getAttribute("FlowNo");
		String sAuthPhase = (String)authPoint.getAttribute("PhaseNo");
		if(sAuthFlow==null || sAuthFlow.equals("") || sAuthPhase==null || sAuthPhase.equals("")) return true;
		else if(sAuthFlow.equals(sFlowNo) && sAuthPhase.equals(sPhaseNo)) return true;
		else return false;
	}
	
	/**
	 * ��Ȩ��������ƥ��
	 * @param Sqlca
	 * @param ae
	 * @param bo
	 * @return
	 * @throws Exception 
	 */
	private boolean matchExceptionType(Transaction Sqlca,AuthorizationPoint point,AuthorizationException ae,AppBizObject bo) throws Exception{
		String sExpression = (String)ae.getAttribute("AET.ExceptionExpr");
		Any aReturn = null;
		boolean bReturn = false;
		if(sExpression!=null){
			try{
	        	sExpression = Expression.pretreatConstant(sExpression,ae.getConstants());
	        	sExpression = Expression.pretreatConstant(sExpression,bo.getConstants());
	        	sExpression = Expression.pretreatConstant(sExpression,point.getConstants());
		        aReturn = Expression.getExpressionValue(sExpression,Sqlca);
			}catch(Exception ex){
	        	throw new Exception("�������͹�ʽ�������󡣹�ʽ��"+sExpression+ex.getMessage());
	        }
			try{
	        	bReturn = aReturn.booleanValue();
	        	return bReturn;
			}catch(Exception ex){
	        	throw new Exception("�������͹�ʽ����ֵ���ʹ��󡣹�ʽ��"+sExpression);
	        }
		}
		return false;
	}
	
	private double toDouble(Object o){
		if(o==null) return 0;
		if(o.getClass().getName().equals("java.lang.String")){
			try{
				return DataConvert.toDouble((String)o);
			}catch(Exception e){
				return 0;
			}
		}else if(o.getClass().getName().equals("java.lang.Double")){
			return ((Double)o).doubleValue();
		}
		return 0;
	}
}
