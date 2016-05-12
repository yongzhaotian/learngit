package com.amarsoft.app.als.alarm.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.als.credit.cl.action.CheckCLOccupy;
import com.amarsoft.app.als.credit.cl.model.BusinessApproveAccount;
import com.amarsoft.app.als.credit.cl.model.CreditLine;
import com.amarsoft.app.als.credit.model.CreditObjectAction;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.Transaction;

/**
 * У������Ķ���Ƿ������������
 * @author Administrator
 *
 */
public class CheckDependentLineApprove extends AlarmBiz {
	
	boolean passFlag=true; 
	StringBuffer log = new StringBuffer();
	
	private void setPassFlag(boolean passFlag) {
		if(this.passFlag == true) this.passFlag = passFlag;//ֻҪ����һ������ͷ���false
	}
	
	/**
	 * ���ɷ���̽����־
	 * @param tempLog
	 */
	private void setLog(StringBuffer tempLog){
		String strArray[] = tempLog.toString().split("@");
		for(int i=0; i < strArray.length; i++){
			this.putMsg(strArray[i]);
		}
	}

	@Override
	public Object run(Transaction Sqlca) throws Exception {
		/**ȡ��������**/
		BizObject jboApprove = (BizObject)this.getAttribute("BusinessApprove");	//ȡ������ҵ������JBO����
		
		BusinessApproveAccount baAccount = new BusinessApproveAccount(jboApprove); //ת��Ϊ���ռ�ö���
		CreditObjectAction creditObjectAction = new CreditObjectAction(jboApprove.getAttribute("SerialNo").getString(),"ApproveApply");
		List<BizObject> lineList = creditObjectAction.getRelativeCreditLineList(); //��ȡ��������б�
		boolean tempFlag = true;
		for(BizObject bo:lineList){
			CreditLine line = new CreditLine(bo); //תΪ��ȶ���
			CheckCLOccupy checkCLOccupy = new CheckCLOccupy();
			tempFlag = checkCLOccupy.checkDependentValidity(line, baAccount);
			if(tempFlag == false){ //��鲻ͨ������ȡ����־
				log.append("@"+checkCLOccupy.getCheckLog());
			}
			setPassFlag(tempFlag);
		}
		
		if(passFlag == false){ //��鲻ͨ������д��־
			this.setLog(log);
		}
		
		this.setPass(this.passFlag);
		return null;
	}
}
