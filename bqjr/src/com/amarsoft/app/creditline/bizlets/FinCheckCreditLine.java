/**
 * 
 */
package com.amarsoft.app.creditline.bizlets;

import java.util.Vector;

import com.amarsoft.amarscript.ASDate;
import com.amarsoft.app.creditline.CreditLine;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * @author jbye
 */
public class FinCheckCreditLine extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	public Object run(Transaction Sqlca) throws Exception {
        String sLineID = (String)this.getAttribute("LineID");
        String sObjectType = (String)this.getAttribute("ObjectType");
        String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sSql = null;
		SqlObject so = null;
        
        //����
        Vector errors = new Vector();
        
		//��ʼ����ȶ���
		CreditLine line = new CreditLine(Sqlca,sLineID);
		double dBalance1 = line.getBalance(Sqlca,"LineSum1");
        double dBalance2 = line.getBalance(Sqlca,"LineSum2");
        
        //���¼���¼���еĶ�����ֵ
        String sCurCheckNo = line.getCurCheckNo();
        sSql = "update CL_CHECK_LOG set " +
				"LineSum1Balance=:LineSum1Balance, " +
				"LineSum2Balance=:LineSum2Balance " +
				"where LineID=:LineID  and CheckNo=:CheckNo ";
        so = new SqlObject(sSql);
		so.setParameter("LineSum1Balance", dBalance1);
		so.setParameter("LineSum2Balance", dBalance2);
		so.setParameter("LineID", line.id());
		so.setParameter("CheckNo", sCurCheckNo);
		Sqlca.executeSQL(so);
        
        if(sObjectType==null) throw new Exception("�����ʱ��������δ�ܻ�ò���ObjectType");
        if(sObjectNo==null) throw new Exception("�����ʱ��������δ�ܻ�ò���sObjectNo");
        
        //��ʼ��ҵ�����
        ASValuePool biz = new ASValuePool();
        if(sObjectType.equals("CreditApply")) initBizBusinessApply(Sqlca,biz,sObjectNo);
        else if(sObjectType.equals("AgreeApproveApply")) initBizBusinessApprove(Sqlca,biz,sObjectNo);
        else if(sObjectType.equals("BusinessContract")) initBizBusinessContract(Sqlca,biz,sObjectNo);
        
        
        //----------------------------����ҵ���������ж�-----------------------------
        double dBusinessSum = DataConvert.toDouble((String)biz.getAttribute("BusinessSum"));
        if(dBusinessSum > dBalance1) errors.add("ErrorType=EX_LINESUM1;MeasureColumn=LineSum1;");
        
        //----------------------------���ڽ�������ж�-----------------------------
        double dBailSum = DataConvert.toDouble((String)biz.getAttribute("BailSum"));//��֤��
        if(dBusinessSum-dBailSum > dBalance2) errors.add("ErrorType=EX_LINESUM2;MeasureColumn=LineSum2;");
        
        
        //----------------------------ҵ�����ս�ֹ���ж�-----------------------------
        //ȡ���ޣ���ת������
        String sPutOutDate = (String)biz.getAttribute("PutOutDate"); 
        if(sPutOutDate==null) sPutOutDate=StringFunction.getToday();
        int iTermDays = DataConvert.toInt((String)biz.getAttribute("TermYear")) 
        				+  DataConvert.toInt((String)biz.getAttribute("TermMonth")) 
        				+ DataConvert.toInt((String)biz.getAttribute("TermDay"));
        
        //���㵽����
        ASDate putOutDate = new ASDate(sPutOutDate);
        ASDate surposedFinishDate = putOutDate.getRelativeDate(iTermDays);
        
        //ȡ��ȵĵ����ս�ֹ��
        String sMaturityDeadLine = (String)line.getAttribute("MaturityDeadLine");
        if(sMaturityDeadLine==null) sMaturityDeadLine=StringFunction.getToday();
        ASDate maturityDeadLine = new ASDate(sMaturityDeadLine);
        
        if(maturityDeadLine.compareTo(surposedFinishDate)<0) errors.add("ErrorType=EX_DEADLINE_MATURITY;");
        
        
        //----------------------------ҵ�����ս�ֹ���ж�-----------------------------
        String sPutOutDeadLine = (String)line.getAttribute("PutOutDeadLine");
        if(sPutOutDeadLine==null) sPutOutDeadLine=StringFunction.getToday();
        ASDate putOutDeadLine = new ASDate(sPutOutDeadLine);
        if(putOutDeadLine.compareTo(putOutDate)<0) errors.add("ErrorType=EX_DEADLINE_MATURITY;");
        
        
        //----------------------------ƴ�ӷ��ش�-------------------------------
        if(errors.size()<1) return "";
        else{
        	StringBuffer sbReturn = new StringBuffer("");
        	for(int i=0;i<errors.size();i++) sbReturn.append((String)errors.get(i)+"@");
        	return sbReturn.toString();
        }
        

	}
	
	private void initBizBusinessApply(Transaction Sqlca,ASValuePool biz,String sObjectNo)throws Exception{
		String sSql = "select BusinessSum,BailSum,TermYear,TermMonth,TermDay,OperateOrgID from BUSINESS_APPLY where SerialNo=:SerialNo ";
		SqlObject so = new SqlObject(sSql);
		so.setParameter("SerialNo", sObjectNo);
		ASResultSet rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			biz.setAttribute("PutOutDate",StringFunction.getToday());//����ҵ�����룬���赱��Ϊ������
			biz.setAttribute("BusinessSum",rs.getString("BusinessSum"));
			biz.setAttribute("BailSum",rs.getString("BailSum"));
			biz.setAttribute("TermYear",rs.getString("TermYear"));
			biz.setAttribute("TermMonth",rs.getString("TermYear"));
			biz.setAttribute("TermDay",rs.getString("TermDay"));
			biz.setAttribute("OrgID",rs.getString("OperateOrgID"));
		}
		rs.getStatement().close();
	}
	
	private void initBizBusinessApprove(Transaction Sqlca,ASValuePool biz,String sObjectNo)throws Exception{
		String sSql = "select BusinessSum,BailSum,TermYear,TermMonth,TermDay,OperateOrgID from BUSINESS_APPLY where SerialNo=:SerialNo ";
		SqlObject so = new SqlObject(sSql);
		so.setParameter("SerialNo", sObjectNo);
		ASResultSet rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			biz.setAttribute("PutOutDate",StringFunction.getToday());//�������������赱��Ϊ������
			biz.setAttribute("BusinessSum",rs.getString("BusinessSum"));
			biz.setAttribute("BailSum",rs.getString("BailSum"));
			biz.setAttribute("TermYear",rs.getString("TermYear"));
			biz.setAttribute("TermMonth",rs.getString("TermYear"));
			biz.setAttribute("TermDay",rs.getString("TermDay"));
			biz.setAttribute("OrgID",rs.getString("OperateOrgID"));
		}
		rs.getStatement().close();
		
	}
	
	private void initBizBusinessContract(Transaction Sqlca,ASValuePool biz,String sObjectNo)throws Exception{
		String sSql = "select BusinessSum,BailSum,TermYear,TermMonth,TermDay,OperateOrgID from BUSINESS_APPLY where SerialNo=:SerialNo ";
		SqlObject so = new SqlObject(sSql);
		so.setParameter("SerialNo", sObjectNo);
		ASResultSet rs = Sqlca.getASResultSet(so);
		
		if(rs.next()){
			biz.setAttribute("PutOutDate",rs.getString("PutOutDate"));
			biz.setAttribute("BusinessSum",rs.getString("BusinessSum"));
			biz.setAttribute("BailSum",rs.getString("BailSum"));
			biz.setAttribute("TermYear",rs.getString("TermYear"));
			biz.setAttribute("TermMonth",rs.getString("TermYear"));
			biz.setAttribute("TermDay",rs.getString("TermDay"));
			biz.setAttribute("OrgID",rs.getString("OperateOrgID"));
		}
		rs.getStatement().close();
		
	}
}
