package demo;

import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.oti.OTIConnection;
import com.amarsoft.oti.OTIManager;
import com.amarsoft.oti.OTITransaction;
import com.amarsoft.oti.TXException;
import com.amarsoft.oti.TXMessageBody;
import com.amarsoft.oti.TXResult;

//测试个人贷款放款业务 
public class Tester {
	public static void main(String[] args){
		//初始ARE服务
		if(!ARE.isInitOk()) ARE.init();
		
		OTIManager manager = OTIManager.getManager();
		System.out.println(manager==null);
		try {
			//获取连接
			Connection conn =  ARE.getDBConnection("als");
			System.out.println(conn);
			/*OTIConnection conn = manager.getConnectionInstance("als");
			conn.open();
			//获取交易
			OTITransaction trans = manager.getTransactionInstance("88011");
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
						
			//初始化报文体
			trans.initRequestBody(" bp.SerialNO='BP20090106000010' and bp.ContractSerialNo=bc.SerialNO");
			
			
			//初始化报文体 使用默认值
			TXMessageBody requestBody = trans.getRequestBody();
			BizObject biz = bo = requestBody.getObject(0);
			//放款类型[0普通放款1按揭放款]
			de = biz.getAttribute("CREDITTYPE");
			de.setValue("0");
					
			//执行交易s
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
			}*/
			
			conn.close();
		}  catch (Exception e) {
			// TODO: handle exception
		}
	}
}
