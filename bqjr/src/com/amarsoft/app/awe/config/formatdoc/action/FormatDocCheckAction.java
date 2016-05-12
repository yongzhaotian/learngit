package com.amarsoft.app.awe.config.formatdoc.action;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

/**
 *	��ʽ���������ݼ�飬�ж��Ƿ�ȫ������
 *  @author xhgao
 */
public class FormatDocCheckAction {
	private String objectType;	//��������
	private String objectNo;    //������ˮ��
	private String docID; //����ģ�ͱ��

	public String checkFormatDoc() throws Exception{
		boolean flag = true;
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager bm = f.getManager("jbo.app.FORMATDOC_DATA");
		String sQuery = "select O.CONTENTLENGTH from O,jbo.app.FORMATDOC_RECORD FR " +
					 " WHERE O.RelativeSerialNo=FR.SerialNo and FR.ObjectType=:ObjectType and FR.ObjectNo=:ObjectNo and FR.DocID=:DocID " +
					 " order by O.DirID";
		BizObjectQuery bq = bm.createQuery(sQuery);
		bq.setParameter("ObjectType",objectType).setParameter("ObjectNo",objectNo).setParameter("DocID", docID);
		@SuppressWarnings("unchecked")
		List<BizObject> list = bq.getResultList(false);
		if(list.size() == 0) return "notComplete";
		for(BizObject bo : list){
			if(bo.getAttribute("CONTENTLENGTH").getInt() == 0){
				flag = false;
				break;
			}
		}
		return flag?"complete":"notComplete";
	}

	public String getObjectType() {
		return objectType;
	}

	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}

	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}

	public String getDocID() {
		return docID;
	}

	public void setDocID(String docID) {
		this.docID = docID;
	}
}