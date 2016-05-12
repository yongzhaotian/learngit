package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.security.SecurityOptionManager;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * �����Ǳ��氲ȫѡ���Bizlet
 * @author sxjiang   2010/07/13
 *
 */
public class SaveAuditOption extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		//��ô�AuditOptionInfoҳ�洫�ݵ�5������
		String sItemNo = (String)this.getAttribute("ItemNo");
		String sItemValue = (String)this.getAttribute("ItemValue");
		String sIsInUse = (String)this.getAttribute("IsInUse");
		String schangeUserId = (String)this.getAttribute("changeUserId");
		String schangeUserName = (String)this.getAttribute("changeUserName");
				
		//�������ݣ������û�����
		SecurityOptionManager.setRulesState(Sqlca, sItemNo, sItemValue, sIsInUse,schangeUserId,schangeUserName);
		
		//�����쳣�򷵻�1����ҳ�����жϴ����Ƿ�ɹ�
		return "1";
	}
}
