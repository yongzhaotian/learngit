package com.amarsoft.app.awe.framecase.dw;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.ui.htmlfactory.imp.DefaultListHtmlGenerator;

public class DemoListForCustomData2 extends DefaultListHtmlGenerator {

	/**
	 * ���ݲ���Ԥ������
	 */
	public void beforeRun(JBOTransaction transaction){
		super.beforeRun(transaction);
		//�Լ��߼�����
		System.out.println("this.transaction = "+ this.transaction);
	}

}
