package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.biz.reserve.batch.RCUnitForPage;



/**
 * ����PRH��Ԫ�����㵥�������
 * @author syang 2009/11/16
 *
 */
public class ReserveSingleReserveSum extends Bizlet {
	
	private String sAccountMonth = "";
	private String sDuebillNo = "";
	private String sFlag = "";
	
	/**
	 * @param AccountMonth ����·�,ͨ��this.setAttribute("AccountMonth","����·�")����ֵ
	 * @param DuebillNo ��ݺ�,ͨ��this.setAttribute("DuebillNo","��ݺ�")����ֵ
	 * @return 1 �ɹ�
	 */
	public Object run(Transaction Sqlca) throws Exception{
		/*
		 * ��ȡ����
		 */
		sAccountMonth = (String)this.getAttribute("AccountMonth");	//����·�
		sDuebillNo = (String)this.getAttribute("DuebillNo");			//��ݺ�
		sFlag = (String)this.getAttribute("Flag");			//���������¼�Ƿ��Զ�ת���
		
		if(sDuebillNo == null){
			sDuebillNo = "";
		}
		if(sAccountMonth == null){
			sAccountMonth = "";
		}
		if(sFlag == null){
			sFlag = "false";//Ĭ���ǹر��Զ�ת��ϵ����
		}
		String sReturn = "1";
		ARE.setProperty("autoSingle2Comp", sFlag);//�رյ��������ɺ��Զ�ת��ϵ����
		RCUnitForPage.calculateSingleReserve(sAccountMonth, sDuebillNo, Sqlca.getConnection(), !sFlag.equalsIgnoreCase("false"));
		return sReturn;
	}
}
