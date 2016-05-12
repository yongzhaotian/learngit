package com.amarsoft.app.als.credit.cl.model;

import java.util.List;

import com.amarsoft.app.als.dict.ALSConst;
import com.amarsoft.app.util.GetCompareERate;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.StringFunction;

public class BusinessSumUnilt {

	private static String BUSINESS="BUSINESSSUM";
	private static String BALANCE="BALANCE";
	/**
	 * ���ҵ���������
	 * <table border="1"><tr><td>&nbsp;</td><td>��ѭ�����Ŷ��</td><td>��ѭ�����Ŷ��</td></tr>
	 * <tr><td>ѭ����ͬ</td><td><li>��ͬ������ ��ͬռ�ý��=��ͬ���
	 *	<li>��ͬ������ ��ͬռ�ý��=��ͬ���
	 *	</td><td>&nbsp;&nbsp;</td></tr>
	 * <tr><td>��ѭ����ͬ</td><td><li>��ͬ������  ��ͬռ�ý��=��ͬ���-��ͬ���ۼ��ջ�
	 * <br>ע����ͬ���ۼ��ջ�=��ͬ�½�ݷ��Ž��-��ͬ�½�����
	 *	<li>��ͬ������   ��ͬռ�ý��=��ͬ���
	 *	</td><td>&nbsp;ռ�ý��=��ͬ���</td></tr>
	 * </table>
	 * @param bcycfalg ���ѭ������ҵ��Ľ��
	 * @return
	 * @throws JBOException 
	 */
	public static double getBusinessSum(boolean bcycfalg,BizObject bizObject) throws JBOException
	{
		String sSerialNo=bizObject.getAttribute("SerialNo").getString();
		String sCycleflag=bizObject.getAttribute("Cycleflag").getString();//ҵ���Ƿ�ѭ��	
		String sObjectType=CLRelativeAction.getObjectType(bizObject); 
		String sToday=StringFunction.getToday(); 
		if(sCycleflag==null) sCycleflag="2";//Ϊ��Ĭ��Ϊ��ѭ��
		double dmyBusinessSum=0;
		double dBusinessSum=bizObject.getAttribute("BusinessSum").getDouble();
		String sCurrency=bizObject.getAttribute("BusinessCurrency").getString();
		dBusinessSum*=GetCompareERate.getConvertToRMBERate(sCurrency);//cjyu �������
		//cjyu ѭ�����ֱ��ʹ�ý��
		if(!bcycfalg) return dBusinessSum;
		if(!sObjectType.equalsIgnoreCase("BusinessContract"))//cjyu  �Ǻ�ͬ�׶Σ�������Ϊ������
		{
			return dBusinessSum;
		}
		String  sMaturity=bizObject.getAttribute("Maturity").getString();
		
		/**ȥ���ò���������Ŀ����ݾ���������@jschen20130109**/
		//if(bizObject.getAttribute("Maturity").isNull()) sMaturity="2001/01/01";//������Ϊ������Ϊ�ѵ��ڣ�
		
		int ioverDay=sMaturity.compareTo(sToday);//�ȵ�ǰ����С ��Ϊ-1 �ȵ�ǰ���ڴ��� 1
		if(getInvideBusiness(bizObject))  return 0;  
		double dBalace=dBusinessSum; 
		//cjyu ��ͬ�׶� ��Ҫ������;
		
		if(!bizObject.getAttribute("Balance").isNull())//���ΪNULL ��Ϊδ���ţ������ѷ���
		{
			dBalace=bizObject.getAttribute("Balance").getDouble();
			dBalace=dBalace*GetCompareERate.getConvertToRMBERate(sCurrency);// �������
		}
		boolean bcycleFlag=sCycleflag.equals(ALSConst.CYCLEFLAG_CYCLE);
		dmyBusinessSum=dBusinessSum;
		if(bcycfalg) //ѭ�����
		{
			if(bcycleFlag)//��ͬѭ��
			{
				if(ioverDay<0)//��ҵ���ͬ�������⣬����ͬ�ѵ���
				{
					dmyBusinessSum=dBalace;
				}
			}else{//��ѭ����ͬ
				if(ioverDay>0)//������ ��ͬ���-�ջ�
				{
					dmyBusinessSum=dBusinessSum-getBackSum(sSerialNo);
				}else{
					dmyBusinessSum=dBalace;
				}
			}
		}
		return dmyBusinessSum;
	}
	/**
	 * ���ҵ���Ƿ��Ѿ�ʧЧ�������гжһ�Ʊ���ں����ֵ��ں�ҵ�����ս�����
	 * @return
	 * @throws JBOException 
	 */
	public static boolean getInvideBusiness(BizObject bizObject) throws JBOException
	{
		String sObjectType=CLRelativeAction.getObjectType(bizObject);
		if(!sObjectType.equalsIgnoreCase("businessContract")) return false;//cjyu ���
 		String sFinishDate=bizObject.getAttribute("FinishDate").getString();//ҵ���Ƿ�ѭ��
		String sBusinessType=bizObject.getAttribute("BusinessType").getString();//ҵ��Ʒ��
  		if(sFinishDate==null) sFinishDate="";
		if(!"".equals(sFinishDate)) return true;//cjyu ҵ���ѽ��壬�򲻼���������
		String  sMaturity=bizObject.getAttribute("Maturity").getString();
		if(bizObject.getAttribute("Maturity").isNull()) sMaturity="1900/01/01";
		int ioverDay=sMaturity.compareTo(StringFunction.getToday());//�ȵ�ǰ����С ��Ϊ-1 �ȵ�ǰ���ڴ��� 1
		//�ѵ��ڵ����гжһ�Ʊ ����������
		//if(ioverDay<0 && (sBusinessType.startsWith("1050") || sBusinessType.startsWith("1060") || sBusinessType.startsWith("1090") || sBusinessType.startsWith("1100"))) return true; 
		return false;
	}
	/**
	 *��ͬ�½���ջؽ��
	 * @param contractNo
	 * @return
	 * @throws JBOException 
	 */
	public static double  getBackSum(String contractNo) throws JBOException
	{
		double dbackSum=0;//cjyu �ջؽ��
		BizObject biz=getDueBillInfo(contractNo);
		if(biz==null) return 0;
		double dBusinessSum=biz.getAttribute("BusinessSum").getDouble();
		double dBalance=biz.getAttribute("Balance").getDouble();
		dbackSum=dBusinessSum-dBalance;
		return dbackSum;
	}
	
	/**
	 * ��ý�ݽ�������Ϣ
	 * @param contractNo ��ͬ��ˮ��
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getDueBillInfo(String contractNo) throws JBOException
	{
 		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_DUEBILL");
		BizObject bo=m.createQuery("select sum(BusinessSum) as v.BusinessSum,sum(Balance) as v.Balance,sum(Bailsum) as v.BailSum from o where O.RelativeSerialNo2=:contract")
					.setParameter("contract", contractNo).getSingleResult(false);
		
		return bo;
	}
	 
	/**
	 * ��ú�ͬ�½����Ϣ
	 * @param contractNo ��ͬ��ˮ��
	 * @return
	 * @throws JBOException
	 */
	public static List<BizObject> getDueBillList(String contractNo) throws JBOException
	{
 		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_DUEBILL");
		List<BizObject> bo=m.createQuery("O.RelativeSerialNo2=:contract")
						.setParameter("contract", contractNo).getResultList(false); 
		return bo;
	}
	
}
