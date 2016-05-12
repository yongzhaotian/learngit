package com.amarsoft.app.lending.bizlets;
/**
 * �Զ�����̽���˻��Ƿ����˻������Ѿ��Ǽǣ����δ�Ǽǣ����ڱ�ACCOUNT_INFO����һ������
 * 
 * @author smiao 2011.06.08
 */

import com.amarsoft.amarscript.ASMethod;
import com.amarsoft.amarscript.Any;
import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.bizobject.AccountInfo;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;

public class InsertAccount extends AlarmBiz{
	
	public Object  run(Transaction Sqlca) throws Exception{
		
		//�Զ���ô���Ĳ���ֵ
		String sSerialNo = (String)this.getAttribute("ObjectNo");
		String sUserID = (String)this.getAttribute("UserID");
		
		//�������
		ASResultSet rs ;
		String sSql = "";
		String sContractSerialNo = "";//��ͬ��
		String sCustomerID = "";//�ͻ�ID
		String sCustomerName = "";//�ͻ�����
		String sRequitalAccount = "";//�ʽ�����˻�
		String sFundBackAccount = "";//����׼�����˻�
		String sAccount = "";//�˻�
		String flagRegister ="";//�˻��ǼǱ�־λ
		SqlObject so; //��������
		
		//ʵ�����û�����
		ASUser CurUser = ASUser.getUser(sUserID,Sqlca);
		
		//���ݲ�����ȡ��ͬ��
		sSql = "select ContractSerialNo from BUSINESS_PUTOUT where SerialNo =:SerialNo";
		so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo);
		rs = Sqlca.getResultSet(so);
		if(rs.next()){
			sContractSerialNo = rs.getString("ContractSerialNo");
		}
		rs.getStatement().close();
		//���ݺ�ͬ�Ż�ȡ�ͻ�ID,�ͻ�����,�ʽ�����˻�,����׼�����˻�
		sSql = "select CustomerID,CustomerName, RequitalAccount,FundBackAccount from BUSINESS_CONTRACT where SerialNo =:SerialNo";
		so = new SqlObject(sSql).setParameter("SerialNo", sContractSerialNo);
		rs = Sqlca.getResultSet(so);
		if(rs.next()){
			sCustomerID = rs.getString("CustomerID");
			sCustomerName = rs.getString("CustomerName");
			sRequitalAccount = rs.getString("RequitalAccount");
			sFundBackAccount = rs.getString("FundBackAccount");
		}
		rs.getStatement().close();
		//�ж��ʽ�����˻��ͻ���׼�����˻��Ƿ�Ϊ��
		if(sRequitalAccount == null && sFundBackAccount == null){
			putMsg("����׼�����˻����ʽ�����˻���ϢΪ��,����д�˻���Ϣ");
			setPass(false);
			return "failure";
		}else{			
			ASMethod asm = new ASMethod("BusinessManage","CheckRegister",Sqlca);//���÷�����ȡ�Ƿ����˻������ѽ��Ǽ�
			Any anyValue  = asm.execute(sFundBackAccount+","+sRequitalAccount+","+sCustomerID);
			flagRegister = anyValue.toStringValue();
			
				if(flagRegister.equals("true")){
					putMsg("�˻���Ϣ�Ѿ��Ǽ�");
					setPass(true);
				}else if(flagRegister.equals("false"))
				{
					putMsg("����׼�����˻����ʽ�����˻����˻�����δ�Ǽǣ�ϵͳ�����Զ���ӵ��˻�����");			
					sAccount = sRequitalAccount == null ?sFundBackAccount:sRequitalAccount;		
					//��ACCOUNT_INFO����һ����¼
					sSql = "insert into ACCOUNT_INFO (Account,CustomerID,CustomerName,AccountSource,InputUserID,InputOrgID,InputDate,UpdateUserID,UpdateDate) values" +
							" (:Account,:CustomerID,:CustomerName,:AccountSource,:InputUserID,:InputOrgID,:InputDate,:UpdateUserID,:UpdateDate)";
					so = new SqlObject(sSql);
					so.setParameter("Account", sAccount).setParameter("CustomerID", sCustomerID).setParameter("CustomerName", sCustomerName).setParameter("AccountSource", AccountInfo.ACCOUNTSOURCE_FROMCONTRACT)
					.setParameter("InputUserID", CurUser.getUserID()).setParameter("InputOrgID", CurUser.getOrgID()).setParameter("InputDate", StringFunction.getToday()).setParameter("UpdateUserID", CurUser.getUserID())
					.setParameter("UpdateDate", StringFunction.getToday());
					//ִ�и������
					Sqlca.executeSQL(so);
					setPass(true);
				}
			return "success";
		}
	}
}
