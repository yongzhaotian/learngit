package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.util.DataConvertTools;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class IsStudent extends Bizlet{
	public Object run(Transaction Sqlca) throws Exception {
		//��ȡ�������������͡������š���ǰ�û�����ǰ��ɫ,������ֵΪnull,��ת�ɿ��ַ���
		String sObjectType = DataConvertTools.nullToEmptyString((String)this.getAttribute("ObjectType"));
		String sObjectNo = DataConvertTools.nullToEmptyString((String)this.getAttribute("ObjectNo"));
		String sUserID = DataConvertTools.nullToEmptyString((String)this.getAttribute("UserID"));
		String sRoleID = DataConvertTools.nullToEmptyString((String)this.getAttribute("RoleID"));
		
		//д�ж��Ƿ���ѧ�����߼�

		
		return "true";
	}
}

