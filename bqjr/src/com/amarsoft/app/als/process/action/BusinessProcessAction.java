package com.amarsoft.app.als.process.action;

import java.awt.image.BufferedImage;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.process.Context;
import com.amarsoft.app.als.process.ProcessService;
import com.amarsoft.app.als.process.ProcessServiceFactory;
import com.amarsoft.app.als.process.data.HistoryTaskObject;
import com.amarsoft.app.als.process.data.ProcessObject;
import com.amarsoft.app.als.process.data.RelativeBusinessObject;
import com.amarsoft.app.als.process.util.PSUserObject;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.log.Log;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.core.object.ResultObject;

/**
 * ҵ�����̶�������.��Ҫ�����ύ/�˻�/�ջ�/�˻�ǰһ������/�˻ز�������  �����̶���
 * @author zszhang
 *
 */
public class BusinessProcessAction {
	private static final String SUCCESS_MESSAGE = "SUCCESS";
	private static final String FAILURE_MESSAGE = "FAILURE";
	
	private Transaction Sqlca;        //Ӧ�ò����ݿ�����
	private JBOTransaction tx;        //JBO����
	private boolean isNewTX = false;  //������ʹ�������Ƿ�Ϊ�´���
	
	private String userID;            //�û����
	private String orgID;             //�������
	private String objectNo;          //������
	private String objectType;		  //��������
	private String applyType;         //��������
	private String processDefID;      //���̶�����
	private String processInstID;     //����ʵ�����
	private String processTaskID;     //����������(���������������Ŷ�Ӧ)
	private String bizProcessObjectID;//ҵ�������(��Ӧ��ϵͳ���̶����Ŷ�Ӧ)
	private String bizProcessTaskID;  //ҵ��������(��Ӧ��ϵͳ���������Ŷ�Ӧ)
	private String phaseNo;           //��ǰ�׶α��(��������������Ŷ�Ӧ)
	private String phaseType;         //��ǰ�׶�����(������������̱���Ӧ)
	private String property;		  //���̽׶�����
	private String processAction;     //�����ύ����
	private String taskParticipants;  //�������������
	private String relativeData;      //�����������
	private String processState;      //����״̬
	private String bizAssignedTaskID; //ָ����һ�׶�����������
	private String voteSerialNo;      //���������

	
	private ProcessService ps = ProcessServiceFactory.getService();   //�����������
	private BusinessProcessActionAssistor bpActionAssistor;           //ҵ�����̲���������
	
	Log logger = ARE.getLog();
	
	/**
	 * Ĭ�Ϲ��캯��
	 */
	public BusinessProcessAction(){
		this.bpActionAssistor = new BusinessProcessActionAssistor(getTx());
		this.bpActionAssistor.setNewTX(isNewTX);
	}
	
	/**
	 * �����ⲿ����Ĺ��캯��
	 * @param tx
	 */
	public BusinessProcessAction(JBOTransaction tx){
		this.tx = tx;
		this.bpActionAssistor = new BusinessProcessActionAssistor(tx);
	}
	
	/**
	 * ��������
	 * <ul>�������:
	 * <li>processDefID:���̶�����
	 * <li>userID:���̷����˱��(�û����)
	 * <li>objectNo:������
	 * <li>objectType:��������
	 * <li>applyType:��������
	 * </ul>
	 * <ul>��ѡ����:
	 * <li>processState:����״̬�����������Ĭ��Ϊ1010��
	 * <li>relativeData:�����������
	 * <li>tx:������ʹ�õ�����
	 * </ul>
	 * @return SUCCESS
	 * @throws Exception
	 */
	public String start() throws Exception {
		
		List<ProcessObject> processObjects = null;//�����ύ�����������̶���
		RelativeBusinessObject businessObject = initBusinessObject(); //��ʼ��Ĭ��ҵ�����,����ҵ�����
		
		try{
			//�������̵�Ԥ����,��ʼ�������������
			relativeData = bpActionAssistor.preStart(businessObject, relativeData);
		
        	logger.info("********PE_ACTION_START_BEGIN:" + this.getClass().getName() + ".start:"+processDefID);
        	initPSContext();//��ʼ�������������������
        	processObjects = ps.startProcessInst(processDefID, userID, relativeData); //��������
        	logger.info("********PE_ACTION_START_END:" + this.getClass().getName() + ".start:"+processDefID);
        	
        	//�������̵ĺ���,����ҵ����������
        	bpActionAssistor.postStart(processDefID, userID, processState, businessObject, processObjects);
        	commitTx();
        } catch (Exception e){
        	logger.debug("ProcessEngine start process instance["+processDefID+"] error."+e.getMessage(), e);
        	rollbackTx();
        	throw new Exception("ProcessEngine start process instance["+processDefID+"] error."+e.getMessage(), e);
        }
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * ��������.���������൱�����·���һ��,��Ҫע����Ǹ�������ǰӦ�ȸ���ҵ����Ϣ
	 * <ul>�������:
	 * <li>processDefID:���̶�����
	 * <li>userID:���̷����˱��(�û����)
	 * <li>objectNo:ҵ��������,�˴��Ķ�����ӦΪ�µ�ҵ����
	 * <li>applyType:ҵ����������
	 *  </ul>
	 * <ul>��ѡ����:
	 * <li>relativeData:�����������
	 * <li>tx:������ʹ�õ�����
	 * </ul>
	 * @return SUCCESS/FAILURE
	 * @throws Exception
	 */
	public String copy() throws Exception {
		return start();
	}

	/**
	 * ��������.<br>
	 * Modify:������׶ο��Է�������,Ĭ���ύ���ͻ��������һ���׶�
	 * <ul>�������Ϊ:
	 * <li>�رյ�ǰ��������
	 * <li>Task����һ����������
	 * <li>����Object��ؼ�¼
	 * </ul>
	 * <ul>�������:
	 * <li>processDefID:���̶�����
	 * <li>bizProcessTaskID:����������
	 *  </ul>
	 * <ul>��ѡ����:
	 * <li>processState:����״̬�������������Ĭ��Ϊ�׶�����
	 * <li>tx:������ʹ�õ�����
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String reConsider() throws Exception {
		String result = "";
		try{
			result = bpActionAssistor.postReConsider(processDefID, bizProcessTaskID, processState);
			if(SUCCESS_MESSAGE.equals(result)){
	        	commitTx();
	        } else {
	        	rollbackTx();
	        }
		} catch (Exception e) {
			logger.debug("ProcessEngine reConsider process ["+processDefID+"] error."+e.getMessage(), e);
			rollbackTx();
			throw new Exception("ProcessEngine reConsider process ["+processDefID+"] error."+e.getMessage(), e);
		}
		return result;
	}
	
	/**
	 * ȡ������<br>
	 * ȡ�����������´���<br>
	 * 1.Ӧ��ϵͳɾ��Object/Task<br>
	 * 2.��������ɾ������ʵ��<br>
	 * <ul>�������:
	 * <li>processDefID:���̶�����
	 * <li>processInstID:����ʵ�����
	 * <li>bizProcessObjectID:ҵ�����̶�����
	 * </ul>
	 * <ul>��ѡ����:
	 * <li>tx:������ʹ�õ�����
	 * </ul>
	 * @return SUCCESS/FAILURE
	 * @throws Exception
	 */
	public String delete() throws Exception {
		String result = FAILURE_MESSAGE;
		try{
			//Ӧ��ϵͳɾ��ҵ������
			result = bpActionAssistor.doDelete(processDefID, bizProcessObjectID);
			if(!SUCCESS_MESSAGE.equals(result)){
				throw new Exception("Ӧ��ϵͳɾ��ҵ������ʧ��:[bizProcessObjectID="+bizProcessObjectID+"]");
			}
			
			//��������ɾ������ʵ��
			logger.info("PE_ACTION_DELETE_BEGIN:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.delete:"+processDefID);
			initPSContext();//��ʼ�������������������
	        ps.deleteProcessInst(processInstID); //ɾ������ʵ��
	        logger.info("PE_ACTION_DELETE_END:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.delete:"+processDefID);
	        if(SUCCESS_MESSAGE.equals(result)){
	        	commitTx();
	        }else{
	        	rollbackTx();
	        }
	        
		} catch (Exception e) {
			logger.debug("ProcessEngine delete process instance["+processDefID+":"+processInstID+"] error."+e.getMessage(), e);
			rollbackTx();
			throw new Exception("ProcessEngine delete process instance["+processDefID+":"+processInstID+"] error."+e.getMessage(), e);
		}
		
		return result;
	}
	
	/**
	 * ȡ�������ύʱ����һ�׶ζ����б�
	 * @param processDefID ���̶�����
	 * @param processTaskID ��ǰ������
	 * @param userID �û����(�Ǳ���)
	 * @param Sqlca Transaction
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> getTaskActions(String processDefID,String processTaskID,String userID, Transaction Sqlca) throws Exception {
		ps.set(Context.CONTEXTNAME_SQLCA, Sqlca);
		return ps.getTaskActions(processDefID, processTaskID, userID);
	}
	
	/**
	 * ȡ�������ύʱ����һ�׶η�֧�����б�
	 * @param processDefID ���̶�����
	 * @param processTaskID ��ǰ������
	 * @param phaseNo �׶α��
	 * @param Sqlca Transaction
	 * @return
	 * @throws Exception
	 */
	public String getForkActions(Transaction Sqlca) throws Exception {
		ps.set(Context.CONTEXTNAME_SQLCA, Sqlca);
		Map<String,String> actions = new LinkedHashMap<String,String>();
		actions = ps.getForkActions(processDefID, processTaskID, phaseNo);
		
		String options = "";
		//����JSON
		for(int i=0;i<actions.size();i++){
			options += ("[\""+actions.keySet().toArray()[i]+"\"],[\""+actions.values().toArray()[i]+"\"],");
		}
		if(options.length() > 0){
			options = options.substring(0,options.length()-1);
		}
		return options;
	}
	
	/**
	 * ȡ�������������û����봦���ĳ�ڵ��������
	 * <ul>���������
	 * <li>processInstID:����ʵ�����
	 * <li>processDefID:���̶�����
	 * <li>phaseNo:����
	 * <li>userID:�û����
	 * </ul>
	 * @return
	 */
	public String getUnfinishedPETaskID() throws Exception {
		return ps.getUnfinishedTaskNo(processInstID, processDefID, phaseNo, userID);
	}
	
	/**
	 * ȡ��Ӧ��ϵͳ��ǰ����ʵ�����µ�������
	 * <ul>���������
	 * <li>bizProcessObjectID:ҵ�����̶�����
	 * <li>processDefID:���̶�����
	 * </ul>
	 * <ul>��ѡ������
	 * <li>userID:������
	 * </ul>
	 * @return
	 */
	public String getUnfinishedBusinessTaskID(){
		String serialNo = "";
		BizObjectQuery q = null;
		try{
			JBOFactory f = JBOFactory.getFactory();
			BizObjectManager bom = f.getManager("jbo.app.Flow_Task");
			
			if("".equals(userID.trim()) || userID == null){
				String query = "RelativeObjectNo =:RelativeObjectNo and TaskState <> '1' and TaskState <> '2' and TaskState <> '99'";
				q = bom.createQuery(query).setParameter("RelativeObjectNo", bizProcessObjectID);
				
			}else{
				String query = "RelativeObjectNo =:RelativeObjectNo and UserID = :UserID and TaskState <> '1' and TaskState <> '2' and TaskState <> '99'";
				q = bom.createQuery(query).setParameter("RelativeObjectNo", bizProcessObjectID)
									  .setParameter("UserID", userID);
			}
			BizObject o = q.getSingleResult(false);
			if(o != null) serialNo = o.getAttribute("SerialNo").getString();
			else
				ARE.getLog().error("com.amarsoft.app.als.process.action.BusinessTaskAction.getUnfinishedBusinessTaskID: Can't find this task!");
		} catch(JBOException e){
			ARE.getLog().debug("��ȡӦ��ϵͳҵ�������ų���",e);
		}
		return serialNo;
	}
	
	/**
	 * �ύ����
	 * <ul>�������:
	 * <li>processDefID:���̶�����
	 * <li>processInstID:����ʵ�����
	 * <li>processTaskID:����������
	 * <li>processAction:�����ύ����
	 * <li>userID:�����ύ��
	 * <li>taskParticipants:���̴�����
	 * <li>bizProcessObjectID:ҵ�����̶�����
	 * <li>bizProcessTaskID:ҵ������������
	 * </ul>
	 * <ul>��ѡ����:
	 * <li>processState:����״̬�����������Ĭ��Ϊ1020��
	 * <li>relativeData:�����������
	 * <li>VoteSerialNo:���������
	 * <li>bizAssignedTaskID:ָ������׶����������ţ��ಽ�ö��ŷָ���
	 * <li>tx:������ʹ�õ�����
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String commit(Transaction Sqlca) throws Exception {
		//�жϵ�ǰ�����Ƿ����ύ
		if(this.isCommited(bizProcessTaskID)) return FAILURE_MESSAGE;
		
		String result = "";
		//����Sqlca
		this.Sqlca = Sqlca;
		//��ʼ��ҵ�����,����ҵ�����
		RelativeBusinessObject businessObject = initBusinessObject(); 
		//��ʼ�������������������
		initPSContext();
		
		try {
			//��ǩ�ύ
			if(businessObject.getPhaseNo().startsWith("CounterSign")){
				//�ύ���̵�Ԥ����,��ʼ�������������
				relativeData = bpActionAssistor.preCommit(businessObject, relativeData);
				//�����������ύ����
				logger.info("PE_ACTION_COMMIT_BEGIN:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.commit:"+processDefID);
				
				//���δ�����ǩ�����Ĭ��Ϊͨ��
				if(processAction == null || "".equals(processAction)) processAction = "1";
				//��ǩ�ύ
		        ProcessObject processObject = ps.commitVote(processDefID, processInstID, processTaskID, userID, processAction, taskParticipants, relativeData);
		        logger.info("PE_ACTION_COMMIT_END:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.commit:"+processDefID);
		        
		        result = bpActionAssistor.commitVoteAssistant(processDefID, bizProcessObjectID, bizProcessTaskID, voteSerialNo, userID, processAction, taskParticipants, businessObject, processObject);
		        
		        if(SUCCESS_MESSAGE.equals(result)) {
		        	commitTx();
		        } else {
		        	rollbackTx();
		        	//logger.debug("[PROCESS ENGINE][RESOTRETASK][Method=com.amarsoft.app.als.process.action.BusinessProcessAction.commit()][ProcessDefID="+processDefID+"][ProcessTaskID="+processTaskID+"]");
		        	//ps.restoreTask(processDefID, processTaskID);//��������ع��ύ
		        }
			}else{
				//�ύ���̵�Ԥ����,��ʼ�������������
				relativeData = bpActionAssistor.preCommit(businessObject, relativeData);
				//�����������ύ����
				logger.info("PE_ACTION_COMMIT_BEGIN:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.commit:"+processDefID);
				//�ύ����
				String[] users = ps.getNextOptionalUsers(processDefID, processAction, processTaskID, userID);
				
		        List<ProcessObject> processObjects = ps.commitProcessInst(processDefID, processInstID, processTaskID, processAction, taskParticipants, relativeData);
		        logger.info("PE_ACTION_COMMIT_END:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.commit:"+processDefID);
		        
		        //ֻ�ύ����ɫ���ύ��������Ա������£���ȡ�������ύ����Ա�б�
				if (taskParticipants == null) {
					taskParticipants = "";
					if (users != null) {
						for (int i = 0; i < users.length; i++) {
							taskParticipants = taskParticipants + users[i] + ",";
						}
					}
					if (!"".equals(taskParticipants))
						taskParticipants = taskParticipants.substring(0,
								taskParticipants.length() - 1);
				}
				
		        result = bpActionAssistor.commitAssistant(processDefID, bizProcessObjectID, bizProcessTaskID, voteSerialNo, userID, processAction, taskParticipants, businessObject, processObjects, processState, bizAssignedTaskID);
		        if(SUCCESS_MESSAGE.equals(result)) {
		        	commitTx();
		        } else {
		        	rollbackTx();
		        	//logger.debug("[PROCESS ENGINE][RESOTRETASK][Method=com.amarsoft.app.als.process.action.BusinessProcessAction.commit()][ProcessDefID="+processDefID+"][ProcessTaskID="+processTaskID+"]");
		        	//ps.restoreTask(processDefID, processTaskID);//��������ع��ύ
		        }
			}
		} catch (Exception e){
			logger.debug("ProcessEngine commit process instance["+processDefID+":"+processInstID+"] error."+e.getMessage(), e);
			rollbackTx();
			//logger.debug("[PROCESS ENGINE][RESOTRETASK][Method=com.amarsoft.app.als.process.action.BusinessProcessAction.commit()][ProcessDefID="+processDefID+"][ProcessTaskID="+processTaskID+"]");
			//ps.restoreTask(processDefID, processTaskID);//��������ع��ύ
			throw new Exception("ProcessEngine commit process instance["+processDefID+":"+processInstID+"] error."+e.getMessage(), e);
		}
		
		return result;
	}
	
	/**
	 * �ύ���̵�ָ���׶Σ��ý׶�Ϊ����������ת���Ľ׶Σ�
	 * <ul>�������:
	 * <li>processDefID:���̶�����
	 * <li>processInstID:����ʵ�����
	 * <li>processTaskID:����������
	 * <li>bizProcessObjectID:ҵ�����̶�����
	 * <li>bizProcessTaskID:ҵ������������
	 * <li>bizAssignedTaskID:ָ���׶�����������
	 * </ul>
	 * <ul>��ѡ����:
	 * <li>processState:����״̬�����������Ĭ��Ϊ1020��
	 * <li>relativeData:�����������
	 * <li>tx:������ʹ�õ�����
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String commitToAssignedTask(Transaction Sqlca) throws Exception {
		String result = "";
		//����Sqlca
		this.Sqlca = Sqlca;
		//��ʼ��ҵ�����,����ҵ�����
		RelativeBusinessObject businessObject = initBusinessObject(); 
		//��ʼ�������������������
		initPSContext();
		
		try {
			//�ύ���̵�Ԥ����,��ʼ�������������
			relativeData = bpActionAssistor.preCommit(businessObject, relativeData);
			//�����������ύ����
			logger.info("PE_ACTION_COMMIT_BEGIN:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.commit:"+processDefID);
			
			//�ύǰ��������
			String returnMsessage = bpActionAssistor.preCommitAssistant(processDefID, bizAssignedTaskID);
			processAction = returnMsessage.split("@")[0];
			taskParticipants = returnMsessage.split("@")[1];
			if("".equals(processAction) || processAction ==null || "".equals(taskParticipants) || taskParticipants == null){
				logger.error("preCommitAssistant error. processAction["+processAction+"] or taskParticipants["+taskParticipants+"] illegal.");
				throw new Exception("preCommitAssistant error. processAction["+processAction+"] or taskParticipants["+taskParticipants+"] illegal.");
			}
			//�ύ����
	        List<ProcessObject> processObjects = ps.commitProcessInst(processDefID, processInstID, processTaskID, processAction, taskParticipants, relativeData);
	        logger.info("PE_ACTION_COMMIT_END:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.commit:"+processDefID);
	        
	        result = bpActionAssistor.commitAssistant(processDefID, bizProcessObjectID, bizProcessTaskID, voteSerialNo, userID, processAction, taskParticipants, businessObject, processObjects, processState, "");
	        
	        if(SUCCESS_MESSAGE.equals(result)) {
	        	commitTx();
	        } else {
	        	rollbackTx();
	        	//logger.debug("[PROCESS ENGINE][RESOTRETASK][Method=com.amarsoft.app.als.process.action.BusinessProcessAction.commitToAssignedTask()][ProcessDefID="+processDefID+"][ProcessTaskID="+processTaskID+"]");
	        	//ps.restoreTask(processDefID, processTaskID);//��������ع��ύ
	        }
		} catch (Exception e){
			logger.debug("ProcessEngine commit process instance["+processDefID+":"+processInstID+"] error."+e.getMessage(), e);
			rollbackTx();
			//logger.debug("[PROCESS ENGINE][RESOTRETASK][Method=com.amarsoft.app.als.process.action.BusinessProcessAction.commitToAssignedTask()][ProcessDefID="+processDefID+"][ProcessTaskID="+processTaskID+"]");
			//ps.restoreTask(processDefID, processTaskID);//��������ع��ύ
			throw new Exception("ProcessEngine commit process instance["+processDefID+":"+processInstID+"] error."+e.getMessage(), e);
		}
		
		return result;
	}
	
	
	/**
	 * ���Ӵ�����Ա
	 * <ul>�������:
	 * <li>processDefID:���̶�����
	 * <li>bizProcessTaskID:ҵ��������(��Ӧ��ϵͳ�����Ŷ�Ӧ)
	 * <li>processTaskID:������
	 * <li>userID:�����ӵĳ�Ա,�����ǵ����û�user1��Ҳ�������б� user1@user2@user3
	 * </ul>
	 * @return SUCCESS/FAILURE/USERID ������ӵ��û����ڻ�ǩ�б���򷵻��ظ����û����
	 */
	public String addVote() {
		String result = "";
		userID = userID.replace("@", ",");
		try {
			// ȡ�õ�ǰ�����û��б�
			result = ps.getTask(processDefID, processTaskID);
			ResultObject rObject = new ResultObject(result);
			String users = rObject.getResult("TASK.ASSIGNEE", "");
			String user[] = userID.split(",");
			for (int i = 0; i < user.length; i++) {
				if(users.indexOf(user[i])>0){
					//logger.info("������Ա"+user[i]+"�Ѵ��ڣ�");
					return user[i];
				}
			}
			result = ps.addVote(processDefID, processTaskID, userID);
			if("SUCCESS".equals(result)){
				result = bpActionAssistor.addVoteAssistant(processDefID, bizProcessTaskID, userID);
			}
	        
		} catch (Exception e) {
			logger.error("����������Աʧ��", e);
			return "FAILURE";
		}
		return "SUCCESS";
	}
	
	/**
	 * ɾ��������Ա
	 * <ul>�������:
	 * <li>processDefID:���̶�����
	 * <li>bizProcessTaskID:ҵ��������(��Ӧ��ϵͳ�����Ŷ�Ӧ)
	 * <li>processTaskID:������
	 * <li>userID:��ɾ���ĳ�Ա,�����ǵ����û�user1��Ҳ�������б� user1@user2@user3
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String removeVote(){
		String result = "";
		userID = userID.replace("@", ",");
		try {
			result = ps.removeVote(processDefID, processTaskID, userID);
			if("SUCCESS".equals(result)){
				result = bpActionAssistor.removeVoteAssistant(processDefID, bizProcessTaskID, userID);
			}
		} catch (Exception e) {
			logger.error("ɾ��������Աʧ��", e);
			return "FAILURE";
		}
		return "SUCCESS";
	}
	
	/**
	 * ��������л�ȡ����
	 * <ul>�������:
	 * <li>processDefID:���̶�����
	 * <li>bizProcessTaskID:ҵ��������(��Ӧ��ϵͳ�����Ŷ�Ӧ)
	 * <li>processTaskID:������
	 * <li>userID:��ȡ������û�
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String takeTaskFromPool(){
		String result = "";
		try {
			result = ps.takeTaskFromPool(processDefID, processTaskID, userID);
			if("SUCCESS".equals(result)){
				result = bpActionAssistor.takeTaskFromPoolAssistant(processDefID, bizProcessTaskID, userID);
			}
		} catch (Exception e) {
			logger.error("��������л�ȡ����ʧ��", e);
			return "FAILURE";
		}
		return "SUCCESS";
	}
	
	/**
	 * ������������
	 * <ul>�������:
	 * <li>processDefID:���̶�����
	 * <li>bizProcessTaskID:ҵ��������(��Ӧ��ϵͳ�����Ŷ�Ӧ)
	 * <li>processTaskID:������
	 * <li>phaseNo:�׶α��
	 * <li>userID:��Ҫ���������û�
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String taskPoolAdjust(){
		String result = "";
		try {
			List<ProcessObject> processObjects = ps.commitProcessInst(processDefID, "", processTaskID, phaseNo, userID, "");
			if(processObjects == null || processObjects.size() ==0){
	        	return FAILURE_MESSAGE;
			}else{
				result = bpActionAssistor.taskPoolAdjustAssistant(processDefID, bizProcessTaskID, userID);
			}
		} catch (Exception e) {
			logger.error("������������ʧ��:[bizProcessTaskID="+bizProcessTaskID+"]", e);
			return FAILURE_MESSAGE;
		}
		return result;
	}
	
	/**
	 * �������˻������
	 * <ul>�������:
	 * <li>processDefID:���̶�����
	 * <li>bizProcessTaskID:ҵ��������(��Ӧ��ϵͳ�����Ŷ�Ӧ)
	 * <li>phaseNo:��ǰ�׶α��
	 * <li>processTaskID:��ǰ������
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String returnToPool(){
		String role = "";
		try {
			role = bpActionAssistor.getRole(processDefID,bizProcessTaskID);
			//�ύ������׶Σ��Ӷ��ı��û�
			ps.commitProcessInst(processDefID, processInstID, processTaskID, phaseNo, role, "");
			
			bpActionAssistor.returnToPoolAssistant(processDefID, bizProcessTaskID);
			
		} catch (Exception e) {
			logger.error("�˻������ʧ��", e);
			return "FAILURE";
		}
		return "SUCCESS";
	}
	

	/**
	 * �˻���һ�׶�.
	 * �˻�֮ǰ������������߼��ж�:<br>
	 * 1.�������Ƿ���ǩ�����,����ǩ�������˻�<br>
	 * �����еĸ÷������������ж���ͨ��,���Խ����˻ز���<br>
	 * <ul>�������
	 * <li>processDefID:���̶�����
	 * <li>processInstID:����ʵ�����
	 * <li>bizProcessTaskID:ҵ������������
	 * <li>processTaskID:����������
	 * <li>userID:�û����
	 * </ul>
	 * <ul>��ѡ����:
	 * <li>processState:����״̬�����������Ĭ��Ϊ�˻أ�
	 * <li>relativeData:�����������
	 * <li>tx:������ʹ�õ�����
	 * </ul>
	 * @return
	 */
	public String takeback(Transaction Sqlca) throws Exception {
		String returnMessage = "";
		this.Sqlca = Sqlca;

		try {
			//Ӧ��ϵͳ�в�ѯ��Ҫ�˻صĽ׶�
			String doTakebackMessage = bpActionAssistor.doTakeback(processDefID, bizProcessTaskID);
			if(doTakebackMessage.indexOf("@") > 0){
				String taskID = doTakebackMessage.split("@")[0];
				String nextAction = doTakebackMessage.split("@")[1];
				String nextOpinion = doTakebackMessage.split("@")[2];
				String oldBizProcessTaskID = doTakebackMessage.split("@")[3];
				String backTaskID = doTakebackMessage.split("@")[4];
				
				if(nextAction == null || "".equals(nextAction) || nextOpinion == null || "".equals(nextOpinion) ||
						taskID == null || "".equals(taskID) || oldBizProcessTaskID == null || "".equals(oldBizProcessTaskID)){
					rollbackTx();
					logger.error("Takeback error. NextAction["+nextAction+"] or NextOpinion["+nextOpinion+"] or TaskID["+taskID+"] or oldBizProcessTaskID["+oldBizProcessTaskID+"] illegal.");
					throw new Exception("Takeback error. NextAction["+nextAction+"] or NextOpinion["+nextOpinion+"] or TaskID["+taskID+"] or oldBizProcessTaskID["+oldBizProcessTaskID+"] illegal.");
				} else {
					//���������н������˻ص���Ӧ�׶�
					logger.info("PE_ACTION_TAKEBACK_COMMIT_BEGIN:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.takeback:"+processDefID);
					initPSContext();//��ʼ�������������������
			        List<ProcessObject> processObjects = ps.returnProcessInst(processDefID, processInstID, taskID, backTaskID, nextAction, nextOpinion, relativeData, userID);
			        logger.info("PE_ACTION_TAKEBACK_COMMIT_END:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.takeback:"+processDefID);
					//Task������¼��Object���¼�¼
			        returnMessage = bpActionAssistor.postTakeback(processDefID, bizProcessTaskID, oldBizProcessTaskID, processState, processObjects, userID);
			        
			        if(SUCCESS_MESSAGE.equals(returnMessage)){
			        	commitTx();
			        } else {
			        	rollbackTx();
			        }
				}
			} else {
				rollbackTx();
				logger.warn(doTakebackMessage);
				returnMessage = FAILURE_MESSAGE;
			}
		} catch (Exception e) {
			logger.error("�˻ػ��������"+e.getMessage(), e);
			rollbackTx();
			throw new Exception("�˻��������"+e.getMessage(), e);
		}
		
		return returnMessage;
	}
	
	/**
	 * ��ȡ������ʷ������.(phaseNo���ظ�,����������ؽ׶�)
	 * <li>processDefID:���̶�����
	 * <li>bizProcessObjectID:ҵ�����̶�����
	 * <li>bizProcessTaskID:ҵ������������
	 * @return List<HistoryTaskObject> 
	 * @throws Exception 
	 */
	public List<HistoryTaskObject> getProcessHistory() throws Exception{
		List<HistoryTaskObject> historyTaskObjects = new ArrayList<HistoryTaskObject>();
		try {
			historyTaskObjects = bpActionAssistor.getProcessHistory(processDefID, bizProcessObjectID ,bizProcessTaskID);
			if(historyTaskObjects == null){
				throw new Exception("��ѯ������ʷ��¼����, ��ѯ��¼Ϊ��");
			}
		} catch (JBOException e) {
			logger.error("��ѯ������ʷ��¼����:[ProcessDefID="+processDefID+"]"+",[BizObjectObjectID="+bizProcessObjectID+"]",e);
		}
		return historyTaskObjects;
	}
	
	/**
	 * ��ȡ������ʷ������.(���ͻ��������һ��)
	 * <li>processDefID:���̶�����
	 * <li>bizProcessObjectID:ҵ�����̶�����
	 * @return List<HistoryTaskObject> 
	 * @throws Exception 
	 */
	public List<HistoryTaskObject> getPartProcessHistory() throws Exception{
		List<HistoryTaskObject> historyTaskObjects = new ArrayList<HistoryTaskObject>();
		try {
			historyTaskObjects = bpActionAssistor.getPartProcessHistory(processDefID, bizProcessObjectID);
			if(historyTaskObjects == null){
				rollbackTx();
				throw new Exception("��ѯ������ʷ��¼����, ��ѯ��¼Ϊ��");
			}else{
				commitTx();
				logger.info("��ѯ������ʷ��¼�ɹ��������¼"+historyTaskObjects.size()+"��");
			}
		} catch (JBOException e) {
			rollbackTx();
			logger.error("��ѯ������ʷ��¼����:[ProcessDefID="+processDefID+"]"+",[BizObjectObjectID="+bizProcessObjectID+"]",e);
		}
		return historyTaskObjects;
	}
	
	/**
	 * �˻�����׶�.
	 * <ul>�������
	 * <li>processDefID:���̶�����
	 * <li>processInstID:����ʵ�����
	 * <li>userID:��ǰ�û����
	 * <li>bizProcessTaskID:Ҫ�˻ص���ҵ������������
	 * <li>processTaskID:����������
	 * </ul>
	 * <ul>��ѡ����:
	 * <li>processState:����״̬�����������Ĭ��Ϊ�˻أ�
	 * <li>bizAssignedTaskID:ָ����һ�׶ε����������ţ����������Ĭ��Ϊ�գ�
	 * <li>relativeData:�����������
	 * <li>tx:������ʹ�õ�����
	 * </ul>
	 * @return
	 */
	public String taskReturn() throws Exception {
		String returnMessage = FAILURE_MESSAGE;
		try {
			returnMessage = bpActionAssistor.preTaskReturn(processDefID,bizProcessTaskID);
			String nextAction = returnMessage.split("@")[0];
			String nextOpinion = returnMessage.split("@")[1];
			String backTaskID = returnMessage.split("@")[2];
			if (nextAction == null || "".equals(nextAction)
					|| nextOpinion == null || "".equals(nextOpinion)) {
				logger.error("Takeback error. NextAction[" + nextAction
						+ "] or NextOpinion[" + nextOpinion + "] illegal.");
				throw new Exception("Takeback error. NextAction[" + nextAction
						+ "] or NextOpinion[" + nextOpinion + "] illegal.");
			} else {
				// ���������н������˻ص���Ӧ�׶�
				logger.info("PE_ACTION_TAKEBACK_COMMIT_BEGIN:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.takeback:" + processDefID);
				initPSContext();// ��ʼ�������������������
				List<ProcessObject> processObjects = ps.returnProcessInst(processDefID, processInstID, processTaskID, backTaskID, nextAction, nextOpinion, relativeData, userID);
				logger.info("PE_ACTION_TAKEBACK_COMMIT_END:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.takeback:" + processDefID);
				// Task�и���ProcessTaskNo
				returnMessage = bpActionAssistor.postTaskReturn(processDefID, bizProcessTaskID, bizAssignedTaskID, processState, processObjects, userID);

				if (SUCCESS_MESSAGE.equals(returnMessage)) {
					commitTx();
				} else {
					rollbackTx();
					returnMessage = FAILURE_MESSAGE;
				}
			}
		} catch (Exception e) {
			logger.error("�˻�����׶�"+e.getMessage(), e);
			rollbackTx();
			throw new Exception("�˻�����׶�"+e.getMessage(), e);
		}
		
		return returnMessage;
	}
	
	/**
	 * ת��
	 * <ul>�������:
	 * <li>processDefID:���̶�����
	 * <li>bizProcessTaskID:ҵ��������(��Ӧ��ϵͳ�����Ŷ�Ӧ)
	 * <li>processTaskID:������
	 * <li>userID:��Ҫ���������û�
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String changeUser(){
		String result = "";
		try {
			result = ps.takeTaskFromPool(processDefID, processTaskID, userID);
			if("SUCCESS".equals(result)){
				result = bpActionAssistor.changeUserAssistant(processDefID, bizProcessTaskID, userID);
			}
		} catch (Exception e) {
			logger.error("����ת��ʧ��", e);
			return "FAILURE";
		}
		return "SUCCESS";
	}
	
	/**
	 * �����Ƿ���ջ��ж�<br>
	 * <ul>�������:
	 * <li>processDefID:���̶�����
	 * <li>bizProcessTaskID:ҵ������������
	 * <li>userID:��ǰ�����˱��
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String canWithdraw() throws Exception {
		//�ж������Ƿ���ջ�
		if(bpActionAssistor.canWithdraw(processDefID, bizProcessTaskID, userID)==true){
			return SUCCESS_MESSAGE;
		}
		return FAILURE_MESSAGE;
	}
	
	/**
	 * ����鵵
	 * <ul>�������:
	 * <li>processDefID:���̶�����
	 * <li>bizProcessObjectID ҵ�����̶�����
	 * </ul>
	 * <ul>��ѡ����:
	 * <li>tx:������ʹ�õ�����
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String taskArchive(){
		String returnMessage = "";
		try {
			returnMessage = bpActionAssistor.taskAchive(processDefID,bizProcessObjectID);
		} catch (Exception e) {
			logger.error("�鵵ʧ��", e);
			return "FAILURE";
		}
		return returnMessage;
	}
	
	/**
	 * ȡ���鵵
	 * <ul>�������:
	 * <li>processDefID:���̶�����
	 * <li>bizProcessObjectID ҵ�����̶�����
	 * </ul>
	 * <ul>��ѡ����:
	 * <li>tx:������ʹ�õ�����
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String cancelArchive(){
		String returnMessage = "";
		try {
			returnMessage = bpActionAssistor.cancelAchive(processDefID,bizProcessObjectID);
		} catch (Exception e) {
			logger.error("ȡ���鵵ʧ��", e);
			return "FAILURE";
		}
		return returnMessage;
	}
	
	/**
	 * �������̶���
	 * <ul>�������:
	 * <li>processTaskID:����������
	 * <li>relativeData: �������ҵ������,@�ָ�,eg:OrgInfo.OrgID=1@OrgInfo.OrgName=2
	 * </ul>
	 * @return SUCCESS/FAILURE
	 * @throws Exception 
	 */
	public String setProcessObject() throws Exception{
		String ObjectName="";
		String ObjectValue="";
		try {
			String processData[] = relativeData.split("@");
			for(int i = 0;i<processData.length;i++){
				ObjectName = processData[i].split("=")[0];
				if(processData[i].split("=").length<=1){
					ObjectValue = "";
				}else{
					ObjectValue = processData[i].split("=")[1];
				}
				try {
					ps.setProcessObject(processTaskID, ObjectName, ObjectValue);
				} catch (Exception e) {
					throw new Exception("�������̶���ʧ��,KEY=["+ObjectName+"],VALUE=["+ObjectValue+"]", e);
				}
			}
		}catch (Exception ex){
			throw new Exception("�������̶���ʧ��,processTaskID=["+processTaskID+"],relativeData=["+relativeData+"]",ex);
		}
		return "SUCCESS";
	}
	
	/**
	 * ���̽�����ָ�������ǰ�Ľ׶�
	 * <ul>�������:
	 * @param processDefID ���̶�����
	 * @param processInstID ����ʵ�����
	 * </ul>
	 * @return SUCCESS/FAILURE
	 * @throws Exception 
	 */
	public String restoreInstance() throws Exception{
			String result = "";
		try {
        	result = ps.restoreInstance(processDefID, processInstID);
        	if("SUCCESS".equals(result)){
        		logger.info("�ָ����̳ɹ��������ѻָ���������ǰһ�׶�");
        	}else{
        		logger.info("�ָ�����ʧ��");
        	}
		}catch (Exception ex){
			throw new Exception("���ָ̻�ʧ��,processDefID=["+processDefID+"],processInstID=["+processInstID+"]",ex);
		}
		return result;
	}
	
	/**
	 * �鿴����ͼ
	 * <ul>���������
	 * <li>processDefID:���̶�����
	 * <li>ProcessTaskID:����������
	 * </ul>
	 * @return
	 */
	public BufferedImage getFlowGraph(String processDefID, String processTaskNo) throws Exception {
		BufferedImage image = null;
		try {
			image = ps.getFlowGraph(processDefID, processTaskNo);
		} catch (Exception e) {
			logger.error("��ȡ����ͼʧ��", e);
		}
		return image;
	}
	
	
	/**
	 * �ջ�����.��������ֻ֧�����̵ĵ�����ģʽ
	 * �ջ�֮ǰ������������߼��ж�:<br>
	 * 1. �����ջ�ʱ�����жϸ������Ƿ��Ѿ��Ǽ��������������������������ջ�<br>
	 * 2. ��������������ջز��������жϸñ�������������Ƿ��Ѿ�ǩ���˺�ͬ������������ջ�<br>
	 * �����еĸ÷������������ж���ͨ��,���Խ����ջز���.<br>
	 * <ul>�������
	 * <li>processDefID:���̶�����
	 * <li>processInstID:����ʵ�����
	 * <li>bizProcessTaskID:ҵ������������(δ�ύ������������)
	 * <li>processTaskID:����������
	 * <li>userID:�û����
	 * </ul>
	 * <ul>��ѡ����:
	 * <li>relativeData:�����������
	 * <li>tx:������ʹ�õ�����
	 * </ul>
	 * @return SUCCESS/FAILURE/�½׶��������ύ����ǩ�����,�����ջ�
	 */
	public String withdraw(Transaction Sqlca) throws Exception {
		String returnMessage = "";
		this.Sqlca = Sqlca;
		try {
			//Ӧ��ϵͳ�в�ѯ��Ҫ���صĽ׶�
			String doWithdrawMessage = bpActionAssistor.doWithdraw(processDefID, bizProcessTaskID);
			if(doWithdrawMessage.indexOf("@") > 0){
				String currentTaskID = doWithdrawMessage.split("@")[0];
				String nextAction = doWithdrawMessage.split("@")[1];
				String nextOpinion = doWithdrawMessage.split("@")[2];
				String oldBizProcessTaskID = doWithdrawMessage.split("@")[3];
				String arriveTaskID = doWithdrawMessage.split("@")[4];
				if (currentTaskID == null || "".equals(currentTaskID)
						|| nextAction == null || "".equals(nextAction)
						|| nextOpinion == null || "".equals(nextOpinion)
						|| bizProcessTaskID == null || "".equals(bizProcessTaskID)) {
					rollbackTx();
					logger.error("Withdraw error. WithdrawTaskID["+currentTaskID+"] or NextAction["+nextAction+"] or NextOpinion["+nextOpinion+"] illegal.");
					throw new Exception("Withdraw error. WithdrawTaskID["+currentTaskID+"] or NextAction["+nextAction+"] or NextOpinion["+nextOpinion+"] illegal.");
				}
				//���������н������ύ����Ӧ�׶�
				logger.info("PE_ACTION_WITHDRAW_COMMIT_BEGIN:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.withdraw:"+processDefID);
				initPSContext();//��ʼ�������������������
		        List<ProcessObject> processObjects = ps.withdrawProcessInst(processDefID, processInstID, currentTaskID, arriveTaskID, doWithdrawMessage, "", "", userID);
		        logger.info("PE_ACTION_WITHDRAW_COMMIT_END:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.withdraw:"+processDefID);
		        
				//Task������¼��Object���¼�¼
		        returnMessage = bpActionAssistor.postWithdraw(processDefID, bizProcessTaskID, oldBizProcessTaskID, processObjects);
		        
		        if(SUCCESS_MESSAGE.equals(returnMessage)){
		        	commitTx();
		        } else {
		        	rollbackTx();
		        }
			} else {
				rollbackTx();
				returnMessage = FAILURE_MESSAGE;
			}
		} catch (Exception e) {
			logger.error("�ջ��������"+e.getMessage(), e);
			rollbackTx();
			throw new Exception("�ջ��������"+e.getMessage(), e);
		}
		
		return returnMessage;
	}
	
	/**
	 * �������أ�������Ա�������أ�
	 * <ul>���������
	 * <li>processDefID:���̶�����
	 * <li>processTaskID:����������
	 * <li>userID:�����������û����
	 * </ul>
	 * @return
	 */
	public String withdrawForVote() throws Exception{
		
		//��������˴���
		try {
			ps.removeVote(processDefID, processTaskID, userID);
			ps.addVote(processDefID, processTaskID, userID);
		}catch (Exception ex){
			throw new Exception("����������������ʧ��,ProcessTaskID["+processTaskID+"]"+",userID["+userID+"]",ex);
		}
		//Ӧ��ϵͳ�˴���
		try {
			bpActionAssistor.withdrawForVoteAssistant(processDefID, bizProcessTaskID, userID);
		} catch (Exception e) {
			throw new Exception("������Ա�������ظ�������ʧ��,ProcessTaskID["+processTaskID+"]"+",userID["+userID+"]", e);
		}
		return "SUCCESS";
	}

	private void initPSContext() throws Exception {
		ps.set(Context.CONTEXTNAME_SQLCA, getSqlca());
		ps.set(Context.CONTEXTNAME_TRANSACTION, getTx());
	}
	
	//��ʼ�����ҵ����󣬲����ö�����������
	private RelativeBusinessObject initBusinessObject() throws JBOException{
		RelativeBusinessObject businessObject = new RelativeBusinessObject();
		
		if(bizProcessTaskID!=null){
			BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_TASK");
			BizObjectQuery bq = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", bizProcessTaskID);
			BizObject bo = bq.getSingleResult(false);
			String phaseNo = bo.getAttribute("PhaseNo").toString();
			String phaseType = bo.getAttribute("phaseType").toString();
			businessObject.setPhaseNo(phaseNo);
			businessObject.setPhaseType(phaseType);
		}
		
		PSUserObject user = null;
		businessObject.setObjectNo(objectNo);
		businessObject.setObjectType(objectType);
		businessObject.setApplyType(applyType);
		businessObject.setProcessDefID(processDefID);

		if(userID != null && !"".equals(userID)){
			businessObject.setUserID(userID);
			try {
				user = PSUserObject.getUser(userID);
				if(user != null){
					businessObject.setOrgID(user.getOrgID());
					businessObject.setOrgName(user.getOrgName());
					businessObject.setUserName(user.getUserName());
				}
			} catch (Exception e) {
				logger.debug(e.getMessage(), e);
			}
		}
		try {
			//��objectNo,objectType,applyType,userID,OrgID��������
			if(objectNo != null && !"".equals(objectNo)){ps.setProcessObject(processTaskID, "S_BizObject.ObjectNo", objectNo);}
			if(objectType != null && !"".equals(objectType)){ps.setProcessObject(processTaskID, "S_BizObject.objectType", objectType);}
			if(applyType != null && !"".equals(applyType)){ps.setProcessObject(processTaskID, "S_BizObject.ApplyType", applyType);}
			ps.setProcessObject(processTaskID, "S_UserInfo.UserID", userID);
			ps.setProcessObject(processTaskID, "S_UserInfo.OrgID", user.getOrgID());
		} catch (Exception e) {
			logger.error("�������̲�������",e);
		}
		return businessObject;
	}
	
	/**
	 * �жϵ�ǰ�����Ƿ��Ѿ��ύ
	 * @return
	 */
	public boolean isCommited(String bizProcessTaskID) throws JBOException {
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_TASK");
		BizObjectQuery bq = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", bizProcessTaskID);
		BizObject bo = bq.getSingleResult(false);
		if(bo == null) return true;
		return false;
	}
	
	/**
	 * �ж������Ƿ����
	 * <p>
	 * �������ύ����ã������ж��Ƿ�����ֹ�ڵ㣬�Ա�������������
	 * </p>
	 * <ul>���������
	 * <li>bizProcessTaskID:ҵ��������(��Ӧ��ϵͳ�����Ŷ�Ӧ)
	 * </ul>
	 * @return String �ɹ�����<String>ture</String> ʧ�ܷ���<String>false</String>
	 */
	public String isFinishedFlow(){
		try {
			JBOFactory f = JBOFactory.getFactory();
			BizObjectManager bom = f.getManager("jbo.app.Flow_Task");
			String query = "SerialNo=:BizProcessTaskID";
			BizObjectQuery q = bom.createQuery(query).setParameter("BizProcessTaskID", bizProcessTaskID);
			BizObject bo = q.getSingleResult(false);
			if(bo == null){
				ARE.getLog().debug("com.amarsoft.app.als.process.action.BusinessTaskAction.isFinishedFlow: ��ѯ��ʼ�������!");
			} else {
				if("2".equals(bo.getAttribute("SerialNo").getString()))return "true";
			}
		} catch(JBOException e){
			ARE.getLog().debug("��ȡ�����Ƿ����״̬����"+e.getMessage(),e);
		}
		return "false";
	}
	
	/**
	 * �ر�����
	 * <p>
	 * �ر����̣��߼�ɾ�����ɻָ���
	 * </p>
	 * <ul>���������
	 * <li>processDefID:���̶�����(��Ӧ��ϵͳ���̱�Ŷ�Ӧ)
	 * <li>bizProcessTaskID:ҵ��������(��Ӧ��ϵͳ�����Ŷ�Ӧ)
	 * </ul>
	 * <ul>��ѡ������
	 * <li>tx:�ⲿ����
	 * </ul>
	 * @return String �ɹ�����<String>SUCCESS</String>
	 * @throws Exception
	 */
	public String closeProcess() throws Exception{
		try {
			JBOFactory f = JBOFactory.getFactory();
			BizObjectManager bom = f.getManager("jbo.app.Flow_Task");
			getTx().join(bom);
			String query = "SerialNo=:BizProcessTaskID";
			BizObjectQuery q = bom.createQuery(query).setParameter("BizProcessTaskID", bizProcessTaskID);
			BizObject bo = q.getSingleResult(true);
			if(bo == null){
				ARE.getLog().debug("com.amarsoft.app.als.process.action.BusinessTaskAction.closeProcess: ��Ҫ�رյ����񲻴���!");
				throw new Exception("��Ҫ�رյ����񲻴���:[bizProcessTaskID="+bizProcessTaskID+"]");
			} else {
				bo.setAttributeValue("TaskState", BusinessProcessConst.BUSINESS_PROCESS_CLOSE);
			}
			bom.saveObject(bo);
			commitTx();
		} catch(JBOException e){
			rollbackTx();
			ARE.getLog().debug("�ر����̳���"+e.getMessage(),e);
			throw new Exception("�ر����̳���",e);
		}
		return "SUCCESS";
	}
	
	/**
	 * ������
	 * <p>
	 * �����̣�ֻ��Ӧ���رյ����̣�����״̬�����ã�
	 * </p>
	 * <ul>���������
	 * <li>processDefID:���̶�����(��Ӧ��ϵͳ���̱�Ŷ�Ӧ)
	 * <li>bizProcessTaskID:ҵ��������(��Ӧ��ϵͳ�����Ŷ�Ӧ)
	 * </ul>
	 * <ul>��ѡ������
	 * <li>tx:�ⲿ����
	 * </ul>
	 * @return String �ɹ�����SUCCESS ʧ�ܷ���FAILURE
	 * @throws Exception
	 */
	public String openProcess() throws Exception{
		try {
			JBOFactory f = JBOFactory.getFactory();
			BizObjectManager bom = f.getManager("jbo.app.Flow_Task");
			getTx().join(bom);
			String query = "SerialNo=:BizProcessTaskID and TaskState=:TaskState";
			BizObjectQuery q = bom.createQuery(query)
					.setParameter("BizProcessTaskID", bizProcessTaskID)
					.setParameter("TaskState",BusinessProcessConst.BUSINESS_PROCESS_CLOSE);
			BizObject bo = q.getSingleResult(true);
			if(bo == null){
				ARE.getLog().debug("com.amarsoft.app.als.process.action.BusinessTaskAction.closeProcess: ��Ҫ�رյ����񲻴��ڻ�����Ϊ�ǹر�״̬!");
				throw new Exception("��Ҫ�رյ����񲻴��ڻ�����Ϊ�ǹر�״̬:[bizProcessTaskID="+bizProcessTaskID+"]");
			} else {
				bo.setAttributeValue("TaskState", BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);
			}
			bom.saveObject(bo);
			commitTx();
		} catch(JBOException e){
			rollbackTx();
			ARE.getLog().debug("�����̳���"+e.getMessage(),e);
			throw new JBOException("�����̳���");
		}
		return "SUCCESS";
	}
	
	/**
	 * ȡ���������������ִ���ջز�����������(ҵ��������)
	 * <p>
	 * �ò���һ������ĳ�û������ҵ������,���е���������׶�ʱ,���û��������б����ջظñ�ҵ��,�������տ���Ȩ
	 * </p>
	 * <p>
	 * �����ִ�иò���ʱ,���뱣֤��ҵ�����ɵ�ǰ�û�����
	 * </p>
	 * <ul>���������
	 * <li>bizProcessObjectID:ҵ�����̶�����
	 * <li>processDefID:���̶�����
	 * <li>userID:�û����
	 * </ul>
	 * @return
	 */
	public String getWithdrawTaskID(){
		String withdrawTaskID = "";
		try {
			JBOFactory f = JBOFactory.getFactory();
			BizObjectManager bom = f.getManager("jbo.app.Flow_Task");
			String query = "RelativeObjectNo =:RelativeObjectNo order by SerialNo";
			BizObjectQuery q = bom.createQuery(query)
								  .setParameter("RelativeObjectNo", bizProcessObjectID);
			BizObject bo = q.getSingleResult(false);//����ȡ��һ����¼
			if(bo == null){
				ARE.getLog().debug("com.amarsoft.app.als.process.action.BusinessTaskAction.getWithdrawTaskID: ��ѯ��ʼ�������!");
			} else {
				if(userID.equals(bo.getAttribute("UserID").getString())){//�ױ������ɵ�ǰ�û�����
					withdrawTaskID = bo.getAttribute("SerialNo").getString();
				}
			}
		} catch(JBOException e){
			ARE.getLog().debug("ȡ���������������ִ���ջز�����������"+e.getMessage(),e);
		}
		return withdrawTaskID;
	}
	
	/**
	 * ȡ�����̶�����ָ���ڵ����һ���ڵ�
	 * <ul>���������
	 * <li>processDefID:���̶�����
	 * <li>processTaskID:����������
	 * </ul>
	 * <ul>��ѡ������
	 * <li>phaseNo:ָ���ڵ��ţ�Ϊ��Ϊ��ǰ����ڵ�
	 * </ul>
	 * @return String �ɹ����ؽ�ɫ�б�
	 */
	public String getPreActivityID() throws Exception {
		String preActivityID = "";
		try{
			//����������ȡ�����̽ڵ����һ���ڵ�
			preActivityID = ps.getPreActivity(processDefID, processTaskID, phaseNo);
			if("".equals(preActivityID)){
				throw new Exception("������һ�ڵ㲻Ψһ���������̡�processTaskID["+processTaskID+"],phaseNo["+phaseNo+"]");
			}
		}catch (Exception e){
			throw new Exception("��ȡ������һ�ڵ�ʧ�ܡ�processTaskID["+processTaskID+"],phaseNo["+phaseNo+"]",e);
		}
		return preActivityID;
	}
	
	/**
	 * ��ȡ��һ�׶ν�ɫ�б�
	 * <ul>���������
	 * <li>processAction:�����ύ����
	 * <li>processDefID:���̶�����
	 * <li>processTaskID:����������
	 * </ul>
	 * @return String �ɹ����ؽ�ɫ�б�
	 */
	public String getNextTaskRole() throws Exception {
		String sRole = "";
		//����������ȡ�ö���Ľ�ɫ�б�
		sRole = ps.getNextOptionalRole(processDefID, processAction, processTaskID);
		return sRole;
	}
	
	/**
	 * ��ȡ��һ�׶β������б�
	 * <ul>���������
	 * <li>processAction:�����ύ����
	 * <li>userID:��ǰ�û����
	 * <li>processDefID:���̶�����
	 * <li>processTaskID:����������
	 * </ul>
	 * @return
	 */
	public String getTaskParticipants(Transaction Sqlca) throws Exception {
		String sReturn = "";
		
		//����������ȡ�ö���Ĳ������б�
		ps.set(Context.CONTEXTNAME_SQLCA, Sqlca);
		PSUserObject user = PSUserObject.getUser(userID);
		ps.setProcessObject(processTaskID, "S_UserInfo.UserID", userID);
		ps.setProcessObject(processTaskID, "S_UserInfo.OrgID", user.getOrgID());
		String[] users = ps.getNextOptionalUsers(processDefID, processAction, processTaskID, userID);
		
		if(users == null || users.length == 0) { 
			users = new String[1];
			users[0] = "";
		}
		
		String sUserValue[] = new String[users.length];

		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager bom = f.getManager("jbo.sys.USER_INFO");

		for(int i=0; i<users.length; i++){
			System.out.println("i===="+users[i]);
			if(users[i] != null && users[i].split(" ").length >= 1){
				String sql = "select \"O.*\",RI.RoleID,RI.RoleName from "
						+ " O,jbo.sys.USER_ROLE UR,jbo.sys.ROLE_INFO RI "
						+ " where O.UserID = UR.UserID "
						+ " and UR.RoleID = RI.RoleID "
						+ " and O.UserID='"
						+ users[i].split(" ")[0] + "'"
						+ " and O.Status='1'";
				if(users[i].split(" ").length >=2)
					sql +=" and UR.RoleID='"+users[i].split(" ")[1]+"'";
				BizObjectQuery query = bom.createQuery(sql);
				BizObject bo = query.getSingleResult(false);
				if(bo!=null){
					sUserValue[i] = bo.getAttribute("UserID").toString()
							+ " " + bo.getAttribute("UserName").toString()
							+ " " + bo.getAttribute("RoleID").toString()
							+ " " + bo.getAttribute("RoleName").toString();
				}
			}
		}
		
		if(sUserValue[0] == null){
			sUserValue = users;
		}
		
		//����JSON
		for(int i=0;i<sUserValue.length;i++){
			sReturn += ("[\""+sUserValue[i]+"\"],");
		}
		if(sReturn.length() > 0){
			sReturn = sReturn.substring(0,sReturn.length()-1);
		}
		return sReturn;
	}
	
	/**
	 * ��ȡ��ǰ�������б�
	 * <ul>���������
	 * <li>processAction:�����ύ����
	 * <li>userID:��ǰ�û����
	 * <li>processDefID:���̶�����
	 * <li>processTaskID:����������
	 * </ul>
	 * @return
	 */
	public String getCurTaskParticipants(Transaction Sqlca) throws Exception {
		String sReturn = "";
		
		//����������ȡ�ö���Ĳ������б�
		ps.set(Context.CONTEXTNAME_SQLCA, Sqlca);
		String[] users = ps.getCurOptionalUsers(processDefID, processAction, processTaskID, userID);
		
		if(users == null || users.length == 0) { 
			users = new String[1];
			users[0] = "";
		}
		
		String sUserValue[] = new String[users.length];
		
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager bom = f.getManager("jbo.sys.USER_INFO");

		for(int i=0; i<users.length; i++){
			if(users[i] != null && users[i].split(" ").length >= 1){
				String sql = "select O.*,RI.RoleID,RI.RoleName from "
						+ " O,jbo.sys.USER_ROLE UR,jbo.awe.AWE_ROLE_INFO RI "
						+ " where O.UserID = UR.UserID "
						+ " and UR.RoleID = RI.RoleID "
						+ " and O.UserID='"
						+ users[i].split(" ")[0] + "'";
				BizObjectQuery query = bom.createQuery(sql);
				BizObject bo = query.getSingleResult(false);
				if(bo!=null){
					sUserValue[i] = bo.getAttribute("UserID").toString()
							+ " " + bo.getAttribute("UserName").toString()
							+ " " + bo.getAttribute("RoleID").toString()
							+ " " + bo.getAttribute("RoleName").toString();
				}
			}
		}
		
		if(sUserValue[0] == null){
			sUserValue = users;
		}
		
		//����JSON
		for(int i=0;i<sUserValue.length;i++){
			sReturn += ("[\""+sUserValue[i]+"\"],");
		}
		if(sReturn.length() > 0){
			sReturn = sReturn.substring(0,sReturn.length()-1);
		}
		return sReturn;
	}
	
	/**
	 * ͬ��һ����,�������ƴ��JSON����
	 * @param processDefID
	 * @param processAction
	 * @param processTaskID
	 * @param userID
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String[] getTaskParticipants(String processDefID, String processAction, String processTaskID, String userID, Transaction Sqlca) throws Exception {
		
		//����������ȡ�ö���Ĳ������б�
		ps.set(Context.CONTEXTNAME_SQLCA, Sqlca);
		PSUserObject user = PSUserObject.getUser(userID);
		ps.setProcessObject(processTaskID, "S_UserInfo.UserID", userID);
		ps.setProcessObject(processTaskID, "S_UserInfo.OrgID", user.getOrgID());
		String[] users = ps.getNextOptionalUsers(processDefID, processAction, processTaskID, userID);
		
		if(users == null || users.length == 0) { 
			users = new String[1];
			users[0] = "";
		}
		
		String sUserValue[] = new String[users.length];

		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager bom = f.getManager("jbo.sys.USER_INFO");
		
		for(int i=0; i<users.length; i++){
			if(users[i] != null && users[i].split(" ").length >= 1){
				String sql = "select O.*,RI.RoleID,RI.RoleName from "
						+ " O,jbo.sys.USER_ROLE UR,jbo.awe.AWE_ROLE_INFO RI "
						+ " where O.UserID = UR.UserID "
						+ " and UR.RoleID = RI.RoleID "
						+ " and O.UserID='"
						+ users[i].split(" ")[0] + "'";
				BizObjectQuery query = bom.createQuery(sql);
				BizObject bo = query.getSingleResult(false);
				if(bo!=null){
					sUserValue[i] = bo.getAttribute("UserID").toString()
							+ " " + bo.getAttribute("UserName").toString()
							+ " " + bo.getAttribute("RoleID").toString()
							+ " " + bo.getAttribute("RoleName").toString();
				}
			}
		}
		
		if(sUserValue[0] == null){
			sUserValue = users;
		}
		
		return sUserValue;
	}

	/**
	 * ȡ����һ�ڵ�����
	 * <ul>���������
	 * <li>processAction:�����ύ����
	 * </ul>
	 * <ul>��ѡ������
	 * <li>processDefID:���̶�����
	 * <li>processInstID:����ʵ�����
	 * <li>processTaskID:����������
	 * <li>taskParticipants:�����ύ���
	 * </ul>
	 * @return
	 */
	public String getNextActivityName(Transaction Sqlca) throws Exception {
		String sNextPhaseName="";//���ؽ׶���Ϣ���׶�����
		ps.set(Context.CONTEXTNAME_SQLCA, Sqlca);
		sNextPhaseName = ps.getNextActivityName(processDefID, processInstID, processTaskID, processAction, taskParticipants);
		return sNextPhaseName;
	}
	
	/**
	 * ȡ����һ�ڵ���ʾ��Ϣ
	 * <ul>���������
	 * <li>processAction:�����ύ����
	 * </ul>
	 * <ul>��ѡ������
	 * <li>processDefID:���̶�����
	 * <li>processInstID:����ʵ�����
	 * <li>processTaskID:����������
	 * <li>processOpinion:�����ύ���
	 * </ul>
	 * @return
	 */
	public String getNextActivityInfo(Transaction Sqlca) throws Exception {
		String sPhaseInfo = "��һ�׶�:";
		String sNextPhaseName = getNextActivityName(Sqlca);
		sPhaseInfo = sPhaseInfo + " " + sNextPhaseName;//ƴ����ʾ��Ϣ
		return sPhaseInfo;
	}
	
	/**
	 * ȡ�ú���������
	 * <ul>���������
	 * <li>processAction:�����ύ����
	 * </ul>
	 * <ul>��ѡ������
	 * <li>processDefID:���̶�����
	 * <li>processInstID:����ʵ�����
	 * <li>processTaskID:����������
	 * </ul>
	 * @return
	 */
	public String getNextState(Transaction Sqlca) throws Exception {
		String TaskName="";//����������
		ps.set(Context.CONTEXTNAME_SQLCA, Sqlca);
		TaskName = ps.getNextState(processDefID, processInstID, processTaskID, processAction);
		if(TaskName.startsWith("CounterSign")){
			return "CounterSign";
		}else{
			return "Task";
		}
	}
	
	/**
	 * �ж�ĳһ�׶��Ƿ��������
	 * <ul>���������
	 * <li>processDefID:��ǰ���̶�����
	 * <li>bizProcessTaskID:��Ҫ�жϵ�ҵ������������
	 * <li>processTaskID:��ǰ����������
	 * <li>phaseNo:��Ҫ�жϵĽ׶κ�
	 * </ul>
	 * @return TRUE/FALSE
	 */
	public String isTaskPool() throws Exception {
		
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager bom = f.getManager("jbo.app.Flow_Task");
		BizObjectQuery query = bom.createQuery("SerialNo =:SerialNo").setParameter("SerialNo", bizProcessTaskID);
		BizObject bo = query.getSingleResult(false);
		if(bo!=null){
			phaseNo = bo.getAttribute("PhaseNo").toString(); 
		}else{
			ARE.getLog().error("��ȡӦ��ϵͳ�׶α�ų���");
		}
		
		String isPool = ps.getActivityProperty(processDefID, processTaskID, phaseNo, "ISPOOL");
		if ("".equals(isPool) || isPool == null) {
			return "FALSE";
		} else {
			return "TRUE";
		}
	}
	
	/**
	 * �ж�ĳһ�׶��ǲ������̽ڵ�
	 * <ul>���������
	 * <li>processDefID:��ǰ���̶�����
	 * <li>phaseNo:��Ҫ�жϵĽ׶α��
	 * <li>processTaskID:��ǰ����������
	 * </ul>
	 * @return TRUE/FALSE
	 */
	public String isFork() throws Exception {
		String isFork = ps.getActivityProperty(processDefID, processTaskID, phaseNo, "ISFORK");
		if ("".equals(isFork) || isFork == null) {
			return "FALSE";
		} else {
			return "TRUE";
		}
	}
	
	/**
	 * �жϵ�ǰ��������
	 * <ul>���������
	 * <li>phaseNo:���̽׶α��
	 * </ul>
	 * @return
	 */
	public String getCurrentState() throws Exception {
		if(phaseNo.startsWith("CounterSign")){
			return "CounterSign";
		}
		if(phaseNo.startsWith("Task")){
			return "Task";
		}
		if(phaseNo.startsWith("End")){
			return "End";
		}
		if(phaseNo.startsWith("Fork")){
			return "Fork";
		}
		return "Task";
	}
	
	/**
	 * �����ύ�Ľ׶α���Ƿ���Object��¼�ĵ�ǰ�׶�ƥ��,һ�����ڼ���Ƿ��ظ��ύ
	 * <ul>���������
	 * <li>bizProcessObjectID:ҵ�����̶�����
	 * <li>processDefID:���̶�����
	 * <li>phaseNo:�������
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String checkActivityID(){
		String curPhaseNo = "";
		
		try {
			JBOFactory f = JBOFactory.getFactory();
			BizObjectManager bom = f.getManager("jbo.app.Flow_Object");
			BizObjectQuery query = bom.createQuery("SerialNo = :SerialNo").setParameter("SerialNo", bizProcessObjectID);
			BizObject bo = query.getSingleResult(false);
			curPhaseNo = bo.getAttribute("PhaseNo").getString();
		} catch(JBOException e){
			ARE.getLog().debug("��ȡӦ��ϵͳ�׶α�ų���",e);
		}
		
		String[] phaseNos = StringFunction.toStringArray(curPhaseNo, ",");
		boolean flag = false;
		for(int i = 0; i < phaseNos.length; i++){
			if(phaseNo.equals(phaseNos[i])){
				flag = true;
				break;
			}
		}
		
		if(flag) return "SUCCESS";
		
		return "FAILURE";
	}
	
	/**
	 * ȡ�ý׶ζ��������
	 * <ul>���������
	 * <li>processDefID:���̶�����
	 * <li>processTaskID:����������
	 * <li>phaseNo:�������
	 * <li>property:��������
	 * </ul>
	 * @return
	 * @throws JBOException 
	 */
	public String getPhaseProperty() throws JBOException{
		if(bizProcessTaskID == null || bizProcessTaskID.equals("") || !isCommited(bizProcessTaskID)) {
			ProcessService ps = ProcessServiceFactory.getService();
			String propertyValue = ps.getActivityProperty(processDefID, processTaskID, phaseNo, property);
			return propertyValue;
		}
		else
			return ""; 
	}
	
	
	/**
	 * �����ύ
	 */
	private void commitTx(){
		if(tx != null && isNewTX){
			try {
				tx.commit();
			} catch (JBOException e){
				try {
					logger.debug("com.amarsoft.app.lending.process.action.BusinessProcessAction.commitTx:�����ύ�쳣", e);
					tx.rollback();
				} catch (JBOException je) {
					logger.debug("com.amarsoft.app.lending.process.action.BusinessProcessAction.commitTx:����ع��쳣", je);
				}
			}
		}
	}
	
	/**
	 * �ع�����
	 */
	private void rollbackTx(){
		if(isNewTX && tx != null){
			try{
				tx.rollback();
			} catch (JBOException je) {
				logger.debug("com.amarsoft.app.lending.process.action.BusinessProcessAction.rollbackTx:����ع��쳣", je);
			}
		}
	}

	/**************************************
	 * getters and setters
	 **************************************/

	public Transaction getSqlca() {
		return Sqlca;
	}

	public void setSqlca(Transaction sqlca) {
		Sqlca = sqlca;
	}
	
	public JBOTransaction getTx() {
		if(tx == null){
			try {
				tx = JBOFactory.createJBOTransaction();
			} catch (JBOException e) {
				e.printStackTrace();
				logger.error("��������ʧ��",e);
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
				logger.error("��������ʧ��",e);
			}
			isNewTX = true;//��ʶΪ�´�������
		}else{
			isNewTX = false;//��ʶΪ���´�������
		}
		this.tx = tx;//�������
		this.bpActionAssistor.setTx(tx);//Ϊ�����������������
		this.bpActionAssistor.setNewTX(isNewTX);//������������ʶ�Ƿ��´�������
	}

	public void setNewTX(boolean isNewTX) {
		this.isNewTX = isNewTX;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}
	
	public void setApplyType(String applyType) {
		this.applyType = applyType;
	}

	public void setProcessDefID(String processDefID) {
		this.processDefID = processDefID;
	}

	public void setProcessInstID(String processInstID) {
		this.processInstID = processInstID;
	}

	public void setProcessTaskID(String processTaskID) {
		this.processTaskID = processTaskID;
	}

	public void setBizProcessObjectID(String bizProcessObjectID) {
		this.bizProcessObjectID = bizProcessObjectID;
	}

	public void setBizProcessTaskID(String bizProcessTaskID) {
		this.bizProcessTaskID = bizProcessTaskID;
	}

	public void setPhaseNo(String phaseNo) {
		this.phaseNo = phaseNo;
	}

	public void setPhaseType(String phaseType) {
		this.phaseType = phaseType;
	}

	public void setProperty(String property) {
		this.property = property;
	}

	public void setProcessAction(String processAction) {
		this.processAction = processAction;
	}

	public void setTaskParticipants(String taskParticipants) {
		this.taskParticipants = taskParticipants;
	}

	public void setRelativeData(String relativeData) {
		this.relativeData = relativeData;
	}

	public void setProcessState(String processState) {
		this.processState = processState;
	}

	public void setBizAssignedTaskID(String bizAssignedTaskID) {
		this.bizAssignedTaskID = bizAssignedTaskID;
	}

	public void setVoteSerialNo(String voteSerialNo) {
		this.voteSerialNo = voteSerialNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}

	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}

}
