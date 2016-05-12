package com.amarsoft.app.als.alarm.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.als.credit.cl.model.CLDivide;
import com.amarsoft.app.als.credit.cl.model.CreditLine;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.Transaction;

public class CheckCreditLine extends AlarmBiz {

	boolean passFlag=true; 
	
	private void setPassFlag(boolean passFlag) {
		if(this.passFlag == true) this.passFlag = passFlag;//ֻҪ����һ������ͷ���false
	}

	@Override
	public Object run(Transaction Sqlca) throws Exception {
		/**ȡ����**/
		BizObject jboApply = (BizObject)this.getAttribute("BusinessApply");		//ȡ������JBO����  
		CreditLine line=new CreditLine(jboApply);
		line.check();
		
		
		checkLineValidity(line); //���������Ч�Լ��
		List<CLDivide> lst=line.getDivideList();
		boolean passFlagTemp=checkDivide(lst); //��ȷ�����Ч�Լ��
		this.setPassFlag(passFlagTemp);
		
		//����̽�����ͨ�����
		this.setPass(passFlag);  
		return null;
	}
	
	
	/**
	 * ������������Ч��У��
	 * @param line ���
	 * @throws Exception
	 */
	private void checkLineValidity(CreditLine line) throws Exception{
 		String sBusinessType=line.getAttribute("BusinessType").getString();
		List<CLDivide> lst=line.getDivideList();
		if(sBusinessType.equals("3005") || sBusinessType.equals("3008") )
		{
			if(lst.size()==0)
			{
				this.setPassFlag(false);
				this.putMsg("���ۺ����Ŷ��δ���з���!");
			}
		}
		 
		double divBusinessSum=0;
		double divExposureSum=0; 
		for(CLDivide divide:lst)
		{
			divBusinessSum+=divide.getBusinessSum();
			divExposureSum+=divide.getExposureSum();
			//У���ۺ�������ͬʱ����Ķ������ҵ���Ƿ���������  
			if(!line.getCycleFlag() && divide.getCycleflag())
			{
				this.setPassFlag(false);
				this.putMsg("�ö��Ϊ��ѭ������ȷ���["+divide.getDivideName()+"]Ϊѭ��");
			 }
			
		}
		if(lst.size()>0)
		{
			if(line.getAttribute("BusinessSum").getDouble()<divBusinessSum && line.bchBusinessSum)
			{
				this.setPassFlag(false);
				this.putMsg("��ȷ������������["+DataConvert.toMoney(divBusinessSum)+"]�����˶��������["+DataConvert.toMoney(line.getAttribute("BusinessSum").getDouble())+"]");
			}else if(divBusinessSum < line.getAttribute("BusinessSum").getDouble() && line.bchBusinessSum ){
				this.putMsg("[��ʾ]��ȷ������������["+DataConvert.toMoney(divBusinessSum)+"]С���˶��������["+DataConvert.toMoney(line.getAttribute("BusinessSum").getDouble())+"]");

			}
			if(line.getAttribute("ExposureSum").getDouble()<divExposureSum && line.bchExposureSum)
			{
				this.setPassFlag(false);
				this.putMsg("��ȷ��䳨�ڽ�����["+DataConvert.toMoney(divExposureSum)+"]�����˶�ȳ��ڽ��["+DataConvert.toMoney(line.getAttribute("ExposureSum").getDouble())+"]");
			} else if(divExposureSum < line.getAttribute("ExposureSum").getDouble() && line.bchBusinessSum ){
				this.putMsg("[��ʾ]��ȷ��䳨�ڽ�����["+DataConvert.toMoney(divExposureSum)+"]С���˶�ȳ��ڽ��["+DataConvert.toMoney(line.getAttribute("ExposureSum").getDouble())+"]");

			}
		}
	}
	
	/**
	 * �������Ⱥ͵�ǰҵ��
	 * @param lstdivide
	 * @return
	 * @throws JBOException
	 */
	private boolean  checkDivide(List<CLDivide> lstdivide) throws JBOException
	{
		boolean passFlag=true;
		for(CLDivide divide:lstdivide)
		{
			double dBusinessSum=divide.getBusinessSum();
			double dExposuresum=divide.getExposureSum();
			double dBusinessSum1=0;
			double dExposuresum1=0;
			//cjyu ����²���
			if(divide.getRelativeDivide().size()>0)
			{ 
				for(CLDivide div:divide.getRelativeDivide())
				{
					dBusinessSum1+=div.getBusinessSum();
					dExposuresum1+=div.getExposureSum();
					if(!divide.getCycleflag() && div.getCycleflag())
					{
						passFlag=false;
						putMsg("�²�["+divide.getDivideName()+"]��ȷ���Ϊѭ�������ϲ�["+div.getDivideName()+"]Ϊ��ѭ�������飡");
					}
				}
				if(dBusinessSum<dBusinessSum1)
				{
					passFlag=false;//�ϲ��ȷ���["+divide.getDivideName()+"]��
					putMsg("�²����������["+DataConvert.toMoney(dBusinessSum1)+"]�����ϲ�["+divide.getDivideName()+"]��������["+DataConvert.toMoney(dBusinessSum)+"]�����飡");
				}
				if(dExposuresum<dExposuresum1)
				{
					passFlag=false;
					putMsg("�²㳨�ڽ�����["+DataConvert.toMoney(dExposuresum1)+"]�����ϲ�["+divide.getDivideName()+"]�ĳ��ڽ��["+DataConvert.toMoney(dExposuresum)+"]�����飡");
				}
				
				
				 boolean passFlag2=checkDivide(divide.getRelativeDivide());
				 if(passFlag) passFlag=passFlag2;
			}
		}
		return passFlag; 
	}

}
