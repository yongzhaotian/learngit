package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class FirstPutOutCheck extends AlarmBiz{

	public Object run(Transaction Sqlca) throws Exception{
		//��ȡ�������������ͺͶ�����
		String sContractSerialNo = (String)this.getAttribute("ContractSerialNo");
		String sSql = "";
		int i = 0;
		ASResultSet rs = null;
		sSql = " select count(*) "+
		       " from BUSINESS_PUTOUT "+
		       " where ContractSerialNo = :ContractSerialNo";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ContractSerialNo", sContractSerialNo));
		if(rs.next()){
			i = rs.getInt(1);
		}
		rs.getStatement().close();
		if(i==1){
			putMsg("�˱ʷŴ�����Ϊ�״ηŴ����룬���ύ��������������Ҫ�޸ĺ�ͬ��Ϣ������Ҫ���˱����롰�˻ز������ϡ���ȡ���˱���������޸ģ�");
		}else{
			putMsg("�˱ʷŴ����벻���ױʷŴ����룬��ͬ���ڲ��ܸ���״̬��");
		}
		return null;
	}
}
