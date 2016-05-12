package com.amarsoft.app.check;

import java.util.List;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * ������ͬ����Զ�����̽�ⳡ��������ʼ����
 * �ڱ����У�ʹ����JBO������JBO��ʹ�ã���ο�JBO����ĵ�
 * @author zhuang
 * @date 2010/04/02
 *
 */
public class InitGuarantyContractScenario extends Bizlet{
    
    /**
     * ����ִ�г�ʼ��ʱ�����Զ����ô˷���
     */
    public Object run(Transaction Sqlca) throws Exception {
        ASValuePool vpJbo = new ASValuePool();
        
        String sTransFormNo = (String)this.getAttribute("ObjectNo");  //�ӳ�����ȡ��������ͬ��ˮ�ţ�TRANSFORM_RELATIVE SerialNo��   
        ARE.getLog().debug("����Ԥ����ʼ����.��ʼ����������JBO");
        BizObject[] jboGuaranty = getGuaranty(sTransFormNo);  //���ڵ�����ͬ�п��ܳ��ֶ�������������Ҫ�ö���������
                
        String sSerialNo = (String)this.getAttribute("SerialNo");    //�ӳ�����ȡ�� ��ͬ��
        ARE.getLog().debug("����Ԥ����ʼ����.��ʼ����ͬ����JBO");
        BizObject jboContract = getContract(sSerialNo);
              
        vpJbo.setAttribute("GuarantyContract", jboGuaranty);//��ص�����ͬ��Ϣ��װΪ����浽������   
        vpJbo.setAttribute("BusinessContract", jboContract);//��غ�ͬ��Ϣ��װΪ����浽������  
        return vpJbo;   //����ҵ����󼯺�
    }  
       /**
     * ��ʼ����ͬ��Ϣ
     * @param sContratNo ��ͬ��
     * @return
     * @throws Exception
     */
    public BizObject getContract(String sContratNo) throws Exception{
        if(sContratNo == null || sContratNo.length() == 0){
            throw new Exception("������ʼ����δ��ȡ����ͬ�ţ�");
        }
        BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
		BizObject jboTransForm = manager.createQuery("SerialNo = '" + sContratNo + "'").getSingleResult();
        return jboTransForm;
    }
    
    
    /**
     * ȡ��ͬ�����ĵ�����ͬ����
     * @param sApplyNo
     * @return
     */
    public BizObject[] getGuaranty(String sTransFormNo) throws Exception{
        BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.GUARANTY_CONTRACT");
		BizObjectQuery q = manager.createQuery("SerialNo in (select R.ObjectNo from jbo.app.TRANSFORM_RELATIVE R where R.SerialNo = '"+sTransFormNo+"' and R.ObjectType = 'GuarantyContract')");
		List jboList = q.getResultList(); //һ��BizObject��������Ϊ�����е�һ��
		Object[] o = jboList.toArray();
		BizObject[] bo = new BizObject[o.length];
		for(int i=0; i<o.length; i++){
			bo[i] = (BizObject)o[i];
		}
		return bo;
    }
}
