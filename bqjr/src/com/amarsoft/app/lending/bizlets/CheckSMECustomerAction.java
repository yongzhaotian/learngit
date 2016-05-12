package com.amarsoft.app.lending.bizlets;

import java.util.Hashtable;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
/**
 *  Description:  ��С��ҵ�ͻ��϶�ģ��ƥ�Լ��,���������ְ�����������۶�ʲ��ܶ��Զ�����ͻ���ģ
 *  			<p>
 *  				<h1>�����߼�</h1>
 *  				<ol>
 *  					<li>������ҵ����,�ҵ�����/С����ҵ������ò���</li>
 *  					<li>�������۶�ʲ��ܶ��ҵ��ģ,ƥ��������ҵ��Ȼ��ƥ��С����ҵ������ƥ�������ҵ</li>
 *  					<li>С����ҵֻҪ������һ��ƥ�����˾��϶�ΪС�ͣ���/���ͱ����ϸ�ƥ��</li>
 *  				</ol>
 *  			</p>
 *         Time:  2009/10/15   
 *       @author  pwang
 *       @history syang 2009/11/02 �޸��䴫��������жϷ�ʽ
 */
public class CheckSMECustomerAction extends Bizlet 
{
	/**
	 * �������
	 * @param
	 * 	<li>IndustryType ��С����ҵ��ҵ����</li>
	 * 	<li>EmployeeNum ְ������</li>
	 * 	<li>SaleSum ���۶�</li>
	 * 	<li>AssetSum �ʲ��ܶ�</li>
	 * @return 
	 * 	<li>3 ������ҵ</li>
	 * 	<li>4 С����ҵ</li>
	 * 	<li>0 ������ҵ��ϵͳ��Ŀǰδʹ�ã�</li>
	 * 	<li>9 ���������ͣ�С�;������㣩</li>
	 */
	public Object run(Transaction Sqlca) throws Exception{
		/*
		 * ��ȡ����
		 */
		String sIndustryType = (String)this.getAttribute("IndustryType");	
		String sEmployeeNum = (String)this.getAttribute("EmployeeNum");	
		String sSaleSum = (String)this.getAttribute("SaleSum");	
		String sAssetSum = (String)this.getAttribute("AssetSum");	
	
		if(sIndustryType == null) sIndustryType = "";
		if(sEmployeeNum == null) sEmployeeNum = "";
		if(sSaleSum == null) sSaleSum = "";
		if(sAssetSum == null) sAssetSum = "";
		
		
		/*
		 * �������
		 */
		String sReturn = "9";
		String sScope = "";
		Hashtable htIndustType = new Hashtable();	//��Щ������ҵ��Ҫ���ʲ��ܶ���ƥ��
		//��������ת����ı���
		int iEmployeeNum = Integer.parseInt(sEmployeeNum);	//ְ������
		double dSaleSum = Double.parseDouble(sSaleSum);		//���۶�
		double dAssetSum = Double.parseDouble(sAssetSum);	//�ʲ��ܶ�
		//���ݿ��в�������ݴ�ű���
		int iWorkerULimit = 0;
		int iWorkerDLimit = 0;
		double dSaleULimit = 0.0;
		double dSaleDLimit = 0.0;
		double dAssetULimit = 0.0;
		double dAssetDLimit = 0.0;
		String sSql = "";
		ASResultSet rs  = null;
		
		/*
		 * �����߼�
		 * ��ǰ��������Ϊ�α�ԣ�С�͡����͡�������ҵ����ƥ��
		 * 1.��С�����ϳ���������
		 * 2.���Ͳ�ƥ�������������ͣ�Ŀǰֻ�����ͣ�С�ͣ���֧�ִ��ͣ�
		 * 3.�����߿ռ������������ڶϵ�����
		 * 
		 */
		htIndustType.put("0130010", "1");	//��ҵ
		htIndustType.put("0130020", "1");	//����ҵ
		sSql = "select "
			+" EntScope,"			//��ҵ���ͣ�3 ������ҵ��4  С����ҵ��
			+" WorkerULimit,"		//ְ����������(��)
			+" WorkerDLimit,"		//ְ����������(��)
			+" SaleULimit,"			//���۶����ޣ�Ԫ��
			+" SaleDLimit,"			//���۶����ޣ�Ԫ��
			+" AssetULimit,"		//�ʲ��ܶ����ޣ�Ԫ��
			+" AssetDLimit"			//�ʲ��ܶ����ޣ�Ԫ��
			+" from SME_CONFMODE"
			+" where EntKind=:sIndustryType"
			+" order by EntScope desc"		//�������У�С�͡����Ͱ���ƥ�䣬�����ƥ�䲻�ϣ���Ĭ��Ϊ����
			;
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sIndustryType", sIndustryType));			
		while(rs.next()){
			boolean bMatched1 = false,bMatched2 = false,bMatched3 = false;
			boolean bIndustType = false;						//������ҵ��ʶ
			iWorkerDLimit = (int)rs.getDouble("WorkerDLimit");	//ְ����������(��)
			iWorkerULimit = (int)rs.getDouble("WorkerULimit");	//ְ����������(��)
			dSaleDLimit = rs.getDouble("SaleDLimit");			//���۶����ޣ�Ԫ��
			dSaleULimit = rs.getDouble("SaleULimit");			//���۶����ޣ�Ԫ
			dAssetDLimit = rs.getDouble("AssetDLimit");			//�ʲ��ܶ����ޣ�Ԫ��
			dAssetULimit = rs.getDouble("AssetULimit");			//�ʲ��ܶ����ޣ�Ԫ��
			sScope = rs.getString("EntScope");
			//1.ƥ��ְ������(���ް��������޲�����)
			if(iEmployeeNum>iWorkerDLimit&&iEmployeeNum<=iWorkerULimit){
				bMatched1 = true;
			}
			//2.ƥ�����۶���ް��������޲�������
			if(dSaleSum>dSaleDLimit&&dSaleSum<=dSaleULimit){
				bMatched2 = true;
			}
			//������ҵ��Ҫƥ���ʲ��ܶ�
			if(htIndustType.containsKey(sIndustryType)){
				bIndustType = true;
				//3.�ʲ��ܶ�ƥ�䣨���ް��������޲�������
				if(dAssetSum>dAssetDLimit&&dAssetSum<=dAssetULimit){
					bMatched3 = true;
				}
			//��Ϊ������ҵ����Ĭ���ʲ��ܶ���ƥ���
			}
			
			if(sScope == null) sScope = "";
			
			//����Ƿ��ܺ�С����ҵƥ��
			//С����ҵֻ��Ҫ����һ��ƥ�����˾��϶�ΪС����ҵ��
			if(sScope.equals("4")){
				//���Ϊ������ҵ����Ҫƥ�������ʲ��ܶ
				if(bIndustType){
					if(bMatched1 || bMatched2 || bMatched3){
						sReturn = sScope;
						break;
					}
				}else{
					if(bMatched1 || bMatched2){
						sReturn = sScope;
						break;
					}
				}
			//����ȫ��ƥ��
			}else{
				//���Ϊ������ҵ����Ҫƥ�������ʲ��ܶ
				if(bIndustType){
					if(bMatched1 && bMatched2 && bMatched3){
						sReturn = sScope;
						break;
					}
				}else{
					if(bMatched1 && bMatched2){
						sReturn = sScope;
						break;
					}
				}
			}
		}
		rs.getStatement().close();
		rs = null;
		return sReturn;
	}
}

