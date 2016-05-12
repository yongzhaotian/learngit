package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 本类功能说明
 * @author ${作者}
 * @since ${日期}
 * 说明：1. 本类引入了对JBO的使用。场景中，当参数较多，且类型较为复杂时，简单的场景参数池使用起来变得有些困难
 *       	在这里，使用了JBO，运行初始化类，把相类似的参数封装为一个JBO对象，存放到场景参数池中，方便使用时调用
 *       	如果你不会使用JBO，也没关系，只要在场景初始化类中，把加载JBO那部分去掉或者不配置初始化类即可
 *       	在没有JBO的情况下，可以直接把相关业务参数放到场景参数池中，直接使用。只是这里，需要要注意参数不要相互覆盖
 *       2.如果检查比较简单，使用一个SQL语句即可完成，则不必要配置java类，直接在检查模型中配置一个检查项，把模型类型配置为SQL即可。
 *         具体实现请参考[场景号：001,模型编号：010880]
 * @updatesuer:yhshan
 * @updatedate:2012/09/11
 */
public class DemoCheck extends AlarmBiz {
	
	/* 成员变量定义 */
	/**
	 * 统计个数
	 */
	String sCount="";

	public Object run(Transaction Sqlca) throws Exception {
		
		/* 取参数 */
		String sObjectType = (String)this.getAttribute("ObjectType");			//ObjectType不属于任何业务对象，只能到场景中取,不过一般不用它
		String sObjectNo = (String)this.getAttribute("ObjectNo");				//ObjectNo不属于任何业务对象，只能到场景中取,不过一般不用它
		BizObject jboCustomer = (BizObject)this.getAttribute("CustomerInfo");	//取出客户JBO对象
		BizObject jboApply = (BizObject)this.getAttribute("BusinessApply");		//取出申请JBO对象
		
		
		/* 变量定义 */
		String sDirection = jboApply.getAttribute("Direction").getString();
		
		
		/* 程序体 */
		//使用申请的行业投向匹配数据库中配置的限制行业投向
		SqlObject so = new SqlObject("select count(CodeNo) from CODE_LIBRARY where CodeNo = 'IndustryType' and ItemNo =:ItemNo and ItemDescribe = '1'");
		so.setParameter("ItemNo", sDirection);
		sCount = Sqlca.getString(so);
		if( sCount != null && Integer.parseInt(sCount,10) > 0 ){				
			putMsg("该申请的行业投向为本行限制行业");
		}
		
		demoFunc(sObjectNo);
		demoFunc(jboCustomer);
		
		/* 返回结果处理 */
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
	
	/**
	 * 示例函数
	 * @param obj　参数对象
	 * @return
	 */
	public Object demoFunc(Object obj){
		return null;
	}
}
