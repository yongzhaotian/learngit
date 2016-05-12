package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetPutOutSum extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		// ��ͬ��ˮ��
		String sContractSerialNo = (String) this
				.getAttribute("ContractSerialNo");
		// ������ˮ��
		String sSerialNo = (String) this.getAttribute("SerialNo");
		// ����ֵת��Ϊ���ַ���
		if (sContractSerialNo == null)
			sContractSerialNo = "";
		if (sSerialNo == null)
			sSerialNo = "";

		// ��ͬ����ͬ����ͬ���³����ܶ� ����ݷǴ������ �� ��ݴ������
		double dBCBusinessSum = 0.0, dBCBalance = 0.0, dPutOutSum = 0.0, dBDBusinessSum = 0.0, dHisBusinessSum = 0.0;
		// Sql��䡢��ͬ���³����ܶѭ����־
		String sSql = null, sPutOutSum = "", sCycleFlag = "", sReinforceFlag = "";
		// ��ѯ�����
		ASResultSet rs = null;

		// ���ݺ�ͬ��ˮ�Ż�ȡѭ����־
		sSql = " select BusinessSum*GetErate(BusinessCurrency,'01','') as BusinessSum,Balance,CycleFlag,ReinforceFlag "
				+ " from BUSINESS_CONTRACT " + " where SerialNo = :sContractSerialNo";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sContractSerialNo", sContractSerialNo));
		if (rs.next()) {
			dBCBusinessSum = rs.getDouble("BusinessSum");
			dBCBalance = rs.getDouble("Balance");
			sCycleFlag = rs.getString("CycleFlag");
			sReinforceFlag = rs.getString("ReinforceFlag");
			if (sCycleFlag == null)
				sCycleFlag = "";
			if (sReinforceFlag == null)
				sReinforceFlag = "";
		}
		rs.getStatement().close();

		// ��ѯ������ݽ����ս�ݱ����м�¼�����˱����޼�¼��������ʶ������ݡ�add by djia 20100722
		//������ݶ��壺��ݱ����м�¼�����˱����޼�¼�Ľ��  
		//�Ǵ�����ݶ��壺��ݱ����¼���ʱ���Ҳ�м�¼�Ľ��
		
		    //��ѯ�Ǵ�����ݽ��
			sSql = " select sum(BD.BusinessSum*GetErate(BD.BusinessCurrency,'01','')) as BusinessSum "
					+ " from BUSINESS_DUEBILL BD, BUSINESS_PUTOUT BP"
					+ " where BD.RelativeSerialno1 = BP.Serialno"
					+ " and RelativeSerialno2 = :sContractSerialNo";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sContractSerialNo", sContractSerialNo));
			if (rs.next()) {
				//BusinessSum:�Ǵ�����ݽ��
				dBDBusinessSum = rs.getDouble("BusinessSum");
			}
			rs.getStatement().close();

		    //�����������ܽ��
			sSql = " select sum(BusinessSum*GetErate(BusinessCurrency,'01','')) as BusinessSum"
					+ " from BUSINESS_DUEBILL "
					+ " where RelativeSerialno2 = :sContractSerialNo ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sContractSerialNo", sContractSerialNo));
			if (rs.next()) {
				//HisBusinessSum:������ݽ�� = ����ܽ�� - �Ǵ�����ݽ��
				dHisBusinessSum = rs.getDouble("BusinessSum") - dBDBusinessSum;
			}
			rs.getStatement().close();
			
		// ��ѯ��ͬ���µĳ��ʽ��
		if (sSerialNo.equals("")) {
			sSql = " select sum(BusinessSum*GetErate(BusinessCurrency,'01','')) as BusinessSum "
					+ " from BUSINESS_PUTOUT " + " where ContractSerialNo = :sContractSerialNo";
			rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sContractSerialNo", sContractSerialNo));
		} else {
			sSql = " select sum(BusinessSum*GetErate(BusinessCurrency,'01','')) as BusinessSum "
					+ " from BUSINESS_PUTOUT " + " where SerialNo <> :sSerialNo"
					+ " and ContractSerialNo = :sContractSerialNo";
			rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sSerialNo", sSerialNo).setParameter("sContractSerialNo", sContractSerialNo));
		}

		if (rs.next()) {
			dPutOutSum = rs.getDouble("BusinessSum");
		}
		rs.getStatement().close();

		if (sCycleFlag.equals("1")) // ѭ����־��1���ǣ�2����
			// ��ѭ����ͬ�Ŀɳ��˽�� = ����ͬ��� - ���˱��ѳ����޽�ݵĽ�� - ��ͬ���
			//���˱��ѳ����޽�ݵĽ�� = (��ͬ���³����ܽ�� - �Ǵ�����ݽ��)
			dPutOutSum = (dBCBusinessSum - (dPutOutSum - dBDBusinessSum) - dBCBalance);
		else
			// ����ѭ����ͬ�Ŀɳ��˽�� = ��ͬ��� - ���˱��ѳ��ʽ�� - ��ݱ�������
			dPutOutSum = dBCBusinessSum - dPutOutSum - dHisBusinessSum;

		sPutOutSum = String.valueOf(dPutOutSum);
		return sPutOutSum;
	}

}
