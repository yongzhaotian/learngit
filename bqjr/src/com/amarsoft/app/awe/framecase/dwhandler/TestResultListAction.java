package com.amarsoft.app.awe.framecase.dwhandler;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.awe.dw.handler.BusinessProcessData;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class TestResultListAction extends CommonHandler{
	
	protected boolean validityCheck(BizObject bo) {
		if(bo.getState()==BizObject.STATE_NEW){
			try{
				BizObjectQuery query = manager.createQuery("SERIALNO=:SERIALNO");
				query.setParameter("SERIALNO",bo.getAttribute("SERIALNO").getString());
				if(query.getSingleResult(false)!=null){
					this.errors += "\n�ؼ����ظ�����������:SERIALNO=" + bo.getAttribute("SERIALNO").getString();
					return false;
				}
				return true;
			}
			catch(Exception e){
				this.errors += e.toString();
				return false;
			}
		}
		return true;
	}
	
	public boolean test(BusinessProcessData bpData) {
		int[] rows = bpData.SelectedRows;
		if(rows==null)
			System.out.println("û���κ���ѡ��");
		else{
			System.out.println("ѡ���У�start");
			for(int i=0;i<rows.length;i++)
				System.out.print(rows[i] + " , ");
			System.out.println("\nѡ���У�end");
		}
		return true;
	}
}
