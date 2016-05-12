package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


/**
 * �ͻ���;ҵ���ѯ��<br/>
 * ��Ŀʵ�ʹ����п��Ը����Լ��������ʵ���޸�<br/>
 * Ŀǰֻ����������飬����ͻ�������ȫ���������ǩ����������Ϊ�ÿͻ�����;ҵ����<br/>
 * @author syang 2009/11/06
 *
 */
public class CustomerUnFinishedBiz extends Bizlet {

	/**
	 * �ͻ�ID
	 */
	private String sCustomerID = "";
	private Transaction Sqlca = null;
	
	/**
	 * @return 
	 * 0 δ�����ҵ�����Ϊ0(ͨ��)<br/>
	 * 1 ����;����<br/>
	 * 2 ��δ����ͨ���������������<br/>
	 * 3 ��δ�Ǽ���ɵĺ�ͬ<br/>
	 */
	public Object run(Transaction Sqlca) throws Exception{
		/*
		 * ��ȡ����
		 */
		this.sCustomerID = (String)this.getAttribute("CustomerID");
		this.Sqlca = Sqlca;
		
		/*
		 * ��������
		 */
		String sReturn = "0";
		
		if(businessApplyCount() > 0){
			sReturn = "1";
			return sReturn;
		}
		if(businessApproveCount() > 0){
			sReturn = "2";
			return sReturn;
		}
		if(businessContractCount() > 0){
			sReturn = "3";
			return sReturn;
		}
		if(evaluateCount() > 0){
			sReturn = "4";
			return sReturn;
		}
		return sReturn;
	}
	
	/**
	 * �ͻ���;����ͳ��
	 * @return
	 * ������;�������
	 * @throws Exception 
	 */
	private int businessApplyCount() throws Exception{
		int iResult = 0;
		//ͳ��ҵ��δǩ����������
		String sSql = " select count(SerialNo) from BUSINESS_APPLY where CustomerID =:CustomerID and Flag5 <> '020'";
		SqlObject so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
		String sCount = Sqlca.getString(so);
		if(sCount == null) sCount = "0";
		iResult = Integer.parseInt(sCount);
		return iResult;
	}
	
	/**
	 * �ͻ�δ������ɵ�����ͳ��
	 * @return��δ������ɵ�����
	 * @throws Exception 
	 */
	private int businessApproveCount() throws Exception{
		int iResult = 0;
		return iResult;
	}
	
	/**
	 * δ�ս�ĺ�ͬ���
	 * @return��δ��ֹ�ĺ�ͬ����select count(*) FROM evaluate_record e,flow_object f where e.serialno=f.objectno and e.objectno='2009120100000198' and phaseno <>'1000' and flowno='EvaluateFlow'
	 * @throws Exception 
	 */
	private int businessContractCount() throws Exception{
		int iResult = 0;
		return iResult;
	}
	
	/**
	 * ���ͻ���;�����õȼ�������������
	 * @return
	 * @throws Exception
	 */
	private int evaluateCount() throws Exception{
		int iResult = 0;
		
		
		SqlObject so = new SqlObject("select count(*) from EVALUATE_RECORD E,FLOW_OBJECT F where E.SerialNo = F.ObjectNo and E.ObjectNo =:ObjectNo  and F.FlowNo = 'EvaluateFlow' and F.PhaseNo <> '1000' ");
		so.setParameter("ObjectNo", sCustomerID);
		String sCount = Sqlca.getString(so);
		if(sCount == null) sCount = "0";
		iResult = Integer.parseInt(sCount);
		return iResult;
	}
}
