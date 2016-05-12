package com.amarsoft.app.awe.framecase;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
/**
 * RunMethod调用bizlet示例
 *
 */
public class GetExmapleName extends Bizlet {

	@Override
	public Object run(Transaction sqlca) throws Exception {
		String sExampleId = (String) this.getAttribute("ExampleId");//获取参数值
		SqlObject so = new SqlObject("select ExampleName from Example_Info where ExampleId=:ExampleId");
		so.setParameter("ExampleId", sExampleId);
		ASResultSet rs = sqlca.getASResultSet(so);
		if(rs.next()) return rs.getString(1);
		rs.getStatement().close();
		return "Hello World!";
	}

}
