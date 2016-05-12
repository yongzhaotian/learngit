/*
 *	Author: jgao1 2009-10-22
 *	Tester:
 *	Describe: ��ֵ׼���������������߼����Զ����Ʊ��ڵļ�ֵ׼��������������ڲ����Ѵ��ڣ���������
 *	Input Param: 	
 *			AccountMonth:�������·�
 *			AssetsType:�����ʲ���
 *	        CustomerType:����ͻ�����
 *			Flag:�������·ݵĻ��ּ����1�����£�3��������6�������꣬12������
 *	Output Param:			
 *	HistoryLog:
 */

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.biz.reserve.business.DateTools;

public class ReserveCopyPara extends Bizlet {
	
	public Object  run(Transaction Sqlca) throws Exception {
		//�������·�
		String sInAccountMonth = (String)this.getAttribute("AccountMonth");
		//�����ʲ���
		String sAssetsType = (String)this.getAttribute("AssetsType");
		//����ͻ�����
		String sCustomerType = (String)this.getAttribute("CustomerType");
		//�������·ݼ����־
		String sFlag = (String)this.getAttribute("Flag");
		//�ж��Ƿ�Ϊ��
		if(sInAccountMonth == null) sInAccountMonth = "";
		if(sAssetsType == null) sAssetsType = "";
		if(sFlag == null) sFlag = "";
		if(sCustomerType == null) sCustomerType = "";
		
		String sCuAccountMonth = "";
		String sSql = "";
		String sTable = "";
		String sReturn = "";
		ASResultSet rs=null;
		SqlObject so; //��������
		int iCount = 0;
		int iFlag = DataConvert.toInt(sFlag);
		//���ݵײ��ֵ׼��֧�ְ������û�ñ��ڻ���·ݵĺ���
		sCuAccountMonth = DateTools.getAccountMonth("yyyy/MM/dd",iFlag);
		//ȡ�ò��������ݱ�
		//����ͻ�����Ϊ��˾�ͻ�
		if(sCustomerType.equals("01")) sTable = "RESERVE_ENTPARA";
		//����ͻ�����Ϊ���˿ͻ�
		if(sCustomerType.equals("03")) sTable = "RESERVE_INDPARA";
		
		//�жϱ��ڻ���·ݲ����Ƿ����
		sSql = " select count(*) from "+sTable+" where AccountMonth =:AccountMonth and AssetsType=:AssetsType";
		so = new SqlObject(sSql).setParameter("AccountMonth", sCuAccountMonth).setParameter("AssetsType", sAssetsType);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			iCount = rs.getInt(1);
		}
		rs.getStatement().close();
		if(iCount>0){
			//��ʾ���ڻ���·ݵĲ����Ѿ�����
			sReturn = "Exit";
		}else{
			//������ڻ���·ݵĲ��������ڣ����ƴ�������Ļ���·ݵ����ݵ�����
			sSql = " insert into "+sTable+"(ACCOUNTMONTH,ASSETSTYPE,LOSSRATECALTYPE,LOSSRATE1,LOSSRATE2,LOSSRATE3,LOSSRATE4,"+
			       " LOSSRATE5,LOSSRATE6,LOSSRATE7,LOSSRATE8,LOSSRATE9,LOSSRATE10,LOSSRATE11,LOSSRATE12,LOSSRATE13,LOSSRATE14,"+
			       " LOSSRATE15,LOSSRATE16,LOSSRATE17,LOSSRATE18,LOSSRATE19,LOSSRATE20,ADJUSTMODULUS,RATEOFLOSS)"+
			       " select '"+sCuAccountMonth+"',ASSETSTYPE,LOSSRATECALTYPE,LOSSRATE1,LOSSRATE2,LOSSRATE3,LOSSRATE4,LOSSRATE5,LOSSRATE6,"+
			       " LOSSRATE7,LOSSRATE8,LOSSRATE9,LOSSRATE10,LOSSRATE11,LOSSRATE12,LOSSRATE13,LOSSRATE14,LOSSRATE15,LOSSRATE16,LOSSRATE17,"+
			       " LOSSRATE18,LOSSRATE19,LOSSRATE20,ADJUSTMODULUS,RATEOFLOSS "+
			       " from "+sTable+
			       " where AccountMonth='"+sInAccountMonth+"' and AssetsType='"+sAssetsType+"'";
			Sqlca.executeSQL(sSql);
			sReturn = "SuccessFul";
		}
		return sReturn;
	}
}
