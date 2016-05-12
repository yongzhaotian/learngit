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
 * 校验关联的额度是否满足可用条件
 * @author Administrator
 *
 */
public class CheckDependentLineApprove extends AlarmBiz {
	
	boolean passFlag=true; 
	StringBuffer log = new StringBuffer();
	
	private void setPassFlag(boolean passFlag) {
		if(this.passFlag == true) this.passFlag = passFlag;//只要命中一条规则就返回false
	}
	
	/**
	 * 生成风险探测日志
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
		/**取场景参数**/
		BizObject jboApprove = (BizObject)this.getAttribute("BusinessApprove");	//取出项下业务申请JBO对象
		
		BusinessApproveAccount baAccount = new BusinessApproveAccount(jboApprove); //转换为额度占用对象
		CreditObjectAction creditObjectAction = new CreditObjectAction(jboApprove.getAttribute("SerialNo").getString(),"ApproveApply");
		List<BizObject> lineList = creditObjectAction.getRelativeCreditLineList(); //获取关联额度列表
		boolean tempFlag = true;
		for(BizObject bo:lineList){
			CreditLine line = new CreditLine(bo); //转为额度对象
			CheckCLOccupy checkCLOccupy = new CheckCLOccupy();
			tempFlag = checkCLOccupy.checkDependentValidity(line, baAccount);
			if(tempFlag == false){ //检查不通过，则取出日志
				log.append("@"+checkCLOccupy.getCheckLog());
			}
			setPassFlag(tempFlag);
		}
		
		if(passFlag == false){ //检查不通过，则写日志
			this.setLog(log);
		}
		
		this.setPass(this.passFlag);
		return null;
	}
}
