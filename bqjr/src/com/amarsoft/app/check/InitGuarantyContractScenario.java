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
 * 担保合同变更自动风险探测场景参数初始化类
 * 在本类中，使用了JBO，关于JBO的使用，请参考JBO相关文档
 * @author zhuang
 * @date 2010/04/02
 *
 */
public class InitGuarantyContractScenario extends Bizlet{
    
    /**
     * 场景执行初始化时，会自动调用此方法
     */
    public Object run(Transaction Sqlca) throws Exception {
        ASValuePool vpJbo = new ASValuePool();
        
        String sTransFormNo = (String)this.getAttribute("ObjectNo");  //从场景中取出担保合同流水号（TRANSFORM_RELATIVE SerialNo）   
        ARE.getLog().debug("风险预警初始化类.初始化担保对象JBO");
        BizObject[] jboGuaranty = getGuaranty(sTransFormNo);  //由于担保合同有可能出现多个，所以这里就要用对象数组了
                
        String sSerialNo = (String)this.getAttribute("SerialNo");    //从场景中取出 合同号
        ARE.getLog().debug("风险预警初始化类.初始化合同对象JBO");
        BizObject jboContract = getContract(sSerialNo);
              
        vpJbo.setAttribute("GuarantyContract", jboGuaranty);//相关担保合同信息封装为对象存到场景中   
        vpJbo.setAttribute("BusinessContract", jboContract);//相关合同信息封装为对象存到场景中  
        return vpJbo;   //返回业务对象集合
    }  
       /**
     * 初始化合同信息
     * @param sContratNo 合同号
     * @return
     * @throws Exception
     */
    public BizObject getContract(String sContratNo) throws Exception{
        if(sContratNo == null || sContratNo.length() == 0){
            throw new Exception("场景初始化，未获取到合同号！");
        }
        BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
		BizObject jboTransForm = manager.createQuery("SerialNo = '" + sContratNo + "'").getSingleResult();
        return jboTransForm;
    }
    
    
    /**
     * 取合同关联的担保合同对象
     * @param sApplyNo
     * @return
     */
    public BizObject[] getGuaranty(String sTransFormNo) throws Exception{
        BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.GUARANTY_CONTRACT");
		BizObjectQuery q = manager.createQuery("SerialNo in (select R.ObjectNo from jbo.app.TRANSFORM_RELATIVE R where R.SerialNo = '"+sTransFormNo+"' and R.ObjectType = 'GuarantyContract')");
		List jboList = q.getResultList(); //一个BizObject对象可理解为数据中的一行
		Object[] o = jboList.toArray();
		BizObject[] bo = new BizObject[o.length];
		for(int i=0; i<o.length; i++){
			bo[i] = (BizObject)o[i];
		}
		return bo;
    }
}
