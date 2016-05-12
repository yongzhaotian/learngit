package demo;

import java.text.SimpleDateFormat;
import java.util.Date;

import com.amarsoft.are.ARE;
import com.amarsoft.are.AREException;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.oti.OTIConnection;
import com.amarsoft.oti.OTIManager;
import com.amarsoft.oti.OTITransaction;
import com.amarsoft.oti.TXException;
import com.amarsoft.oti.TXMessageBody;
import com.amarsoft.oti.TXResult;

//测试客户端。测试存款、保证金账号余额
public class DZTestClient {
	public static void main(String[] args){
		//初始ARE服务
		if(!ARE.isInitOk()) ARE.init();
		
		OTIManager manager = OTIManager.getManager();
		System.out.println(manager==null);

		try {
			//获取连接
			OTIConnection conn = manager.getConnectionInstance("DZconn");
			//OTIConnection conn = OTIManager.getConnection("DZconn");
			conn.open();
			//获取交易ID为88017的交易
			OTITransaction trans = manager.getTransactionInstance("88017");
			DataElement de	= null;
			//初始化报文头
			BizObject bo = trans.getRequestHeader();
			SimpleDateFormat df = new SimpleDateFormat("yyyy-mm-dd");
			Date date = new Date();
			
			de = bo.getAttribute("INPUTDATE");
			de.setValue(df.format(date));
			df.applyPattern("h:mm");
			de = bo.getAttribute("INPUTTIME");
			de.setValue(df.format(date));
			
			//初始化报文体 使用默认值或者accountno的值可以从页面传参数进来
			trans.initRequestBody("accountno in ('6229370101000008026' ,'6229370101000030368') and orgid='1000'");
			TXMessageBody requestBody = trans.getRequestBody();
			System.out.println("报文体的长度"+requestBody.size());			
					
			//执行交易
			TXResult result = conn.executeTransaction(trans);
			System.out.println(result.toString());
			BizObject bore = trans.getResponseHeader();
			
			int length = 0;
			
			for(int j=0; j<bore.getAttributeNumber(); j++){
				length += bore.getAttribute(j).getLength();
				System.out.println("反馈字段名："+bore.getAttribute(j).getName()+"  字段值:"+bore.getAttribute(j).getString());
			}
			
			TXMessageBody responsBody = trans.getResponseBody();
			if(responsBody != null){
			System.out.println("反馈报文体长度："+responsBody.size());
			for(int i=0; i<responsBody.size();i++){
				bo = responsBody.getObject(i);
				for(int j=0; j<bo.getAttributeNumber(); j++){
					length += bo.getAttribute(j).getLength();
					System.out.println("字段名："+bo.getAttribute(j).getName()+"  字段值:"+bo.getAttribute(j).getString());
				}
			}
			}else{
				System.out.println("反馈报文体为空");
			}
			
			conn.close();
		} catch (TXException e) {
			e.printStackTrace();
		} catch (JBOException e) {
			e.printStackTrace();
		}
	}
}
