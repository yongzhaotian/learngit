package com.amarsoft.app.awe.framecase.dw;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.ui.htmlfactory.imp.DefaultListHtmlGenerator;

public class DemoListForCustomData2 extends DefaultListHtmlGenerator {

	/**
	 * 数据操作预处理方法
	 */
	public void beforeRun(JBOTransaction transaction){
		super.beforeRun(transaction);
		//自己逻辑处理
		System.out.println("this.transaction = "+ this.transaction);
	}

}
