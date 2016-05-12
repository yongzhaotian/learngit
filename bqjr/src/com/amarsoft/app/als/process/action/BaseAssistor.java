package com.amarsoft.app.als.process.action;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.log.Log;

public class BaseAssistor {

	private BizProcessConfiguration bpConfiguration; //ҵ����������
	private String bizProcessObjectClaz;             //ҵ�����̶���
	private String bizProcessTaskClaz;               //ҵ����������
	private String bizProcessOpinionClaz;            //ҵ���������
	private String bizProcessMultiTaskClaz;          //ҵ�����̸�������
	
	private JBOTransaction tx;    //����
	private boolean isNewTX = false;//������ʹ�������Ƿ�Ϊ�´���
	
	private Log logger = ARE.getLog();

	public BaseAssistor() {

	}

	public BaseAssistor(JBOTransaction tx) {
		this.tx = tx;
	}

	public BaseAssistor(BizProcessConfiguration bpConfiguration) {
		this.bpConfiguration = bpConfiguration;
	}

	public BaseAssistor(String bizProcessObjectClaz, String bizProcessTaskClaz, String bizProcessOpinionClaz) {
		this.bizProcessObjectClaz = bizProcessObjectClaz;
		this.bizProcessTaskClaz = bizProcessTaskClaz;
		this.bizProcessOpinionClaz = bizProcessOpinionClaz;
	}
	
	/**
	 *  ȡ��ҵ�����̶���JBO
	 * @param processDefID
	 * @return
	 */
	public String getBizProcessObjectClaz(String processDefID){
		if(getBizProcessObjectClaz() == null){
			this.bizProcessObjectClaz = getBpConfiguration().getBizProcessObjectClaz(processDefID);
		}
		return bizProcessObjectClaz;
	}
	
	/**
	 * ȡ��ҵ����������JBO
	 * @param processDefID
	 * @return
	 */
	public String getBizProcessTaskClaz(String processDefID){
		if(getBizProcessTaskClaz() == null){
			this.bizProcessTaskClaz = getBpConfiguration().getBizProcessTaskClaz(processDefID);
		}
		return bizProcessTaskClaz;
	}
	
	/**
	 * ȡ��ҵ���������JBO
	 * @param processDefID
	 * @return
	 */
	public String getBizProcessOpinionClaz(String processDefID){
		if(getBizProcessOpinionClaz() == null){
			this.bizProcessOpinionClaz = getBpConfiguration().getBizProcessOpinionClaz(processDefID);
		}
		return bizProcessOpinionClaz;
	}
	
	/**
	 * ȡ��ҵ�����̸�������JBO
	 * @param processDefID
	 * @return
	 */
	public String getBizProcessMultiTaskClaz(String processDefID){
		if(getBizProcessMultiTaskClaz() == null){
			this.bizProcessMultiTaskClaz = getBpConfiguration().getBizProcessMultiTaskClaz(processDefID);
		}
		return bizProcessMultiTaskClaz;
	}
	
	/**
	 * �����ύ
	 */
	protected void commitTx(){
		if(tx != null && isNewTX){
			try {
				tx.commit();
			} catch (JBOException e){
				try {
					tx.rollback();
					logger.debug(e.getMessage(), e);
				} catch (JBOException je) {
					logger.debug(e.getMessage(), je);
				}
			}
		}
	}
	
	/**
	 * �ع�����
	 */
	protected void rollbackTx(){
		if(isNewTX && tx != null){
			try{
				tx.rollback();
			} catch (JBOException e) {
				logger.debug(e.getMessage(), e);
			}
		}
	}
	
	/********************************
	 * getters and setters
	 ********************************/

	public BizProcessConfiguration getBpConfiguration() {
		if(this.bpConfiguration == null){
			bpConfiguration = new BaseBizProcessConfiguration();
		}
		return bpConfiguration;
	}

	public void setBpConfiguration(BizProcessConfiguration bpConfiguration) {
		this.bpConfiguration = bpConfiguration;
	}
	
	public String getBizProcessObjectClaz() {
		return bizProcessObjectClaz;
	}

	public void setBizProcessObjectClaz(String bizProcessObjectClaz) {
		this.bizProcessObjectClaz = bizProcessObjectClaz;
	}

	public String getBizProcessTaskClaz() {
		return bizProcessTaskClaz;
	}

	public void setBizProcessTaskClaz(String bizProcessTaskClaz) {
		this.bizProcessTaskClaz = bizProcessTaskClaz;
	}

	public String getBizProcessOpinionClaz() {
		return bizProcessOpinionClaz;
	}

	public void setBizProcessOpinionClaz(String bizProcessOpinionClaz) {
		this.bizProcessOpinionClaz = bizProcessOpinionClaz;
	}
	
	public String getBizProcessMultiTaskClaz() {
		return bizProcessMultiTaskClaz;
	}

	public void setBizProcessMultiTaskClaz(String bizProcessMultiTaskClaz) {
		this.bizProcessMultiTaskClaz = bizProcessMultiTaskClaz;
	}

	public JBOTransaction getTx() {
		if(tx == null){
			try {
				tx = JBOFactory.createJBOTransaction();
			} catch (JBOException e) {
				e.printStackTrace();
			}
			isNewTX = true;
		}
		return tx;
	}

	public void setTx(JBOTransaction tx) {
		if(tx == null){
			try {
				tx = JBOFactory.createJBOTransaction();
			} catch (JBOException e) {
				e.printStackTrace();
			}
			isNewTX = true;
		}
		this.tx = tx;
	}

	public boolean isNewTX() {
		return isNewTX;
	}

	public void setNewTX(boolean isNewTX) {
		this.isNewTX = isNewTX;
	}
	
}
