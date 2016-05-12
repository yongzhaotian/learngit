package com.amarsoft.app.als.process.action;

import java.util.ArrayList;
import java.util.List;

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

/**
 * ����������ת��ظ������������������������ǰ��������Ӧ��ϵͳ���̱��¼�ĸ��£����߻�ȡ��ؼ�¼��
 * @author zszhang
 *
 */
public class BusinessProcessActionAssistor extends BaseAssistor {
	
	private static final String SUCCESS_MESSAGE = "SUCCESS";
	private static final String FAILURE_MESSAGE = "FAILURE";
	
	private Log logger = ARE.getLog();
	
	public BusinessProcessActionAssistor() {
		super();
	}

	public BusinessProcessActionAssistor(JBOTransaction tx) {
		super(tx);
	}

	public BusinessProcessActionAssistor(BizProcessConfiguration bpConfiguration) {
		super(bpConfiguration);
	}

	public BusinessProcessActionAssistor(String bizProcessObjectClaz, String bizProcessTaskClaz, String bizProcessOpinionClaz) {
		super(bizProcessObjectClaz, bizProcessTaskClaz, bizProcessOpinionClaz);
	}
	
	/**
	 * �������̵�ǰ�������,һ��Ϊ��ʼ���������
	 * @param businessObject ����ҵ�����
	 * @param relativeData ������ض���
	 * @return String
	 * @throws Exception
	 */
	public String preStart(RelativeBusinessObject businessObject, String relativeData) throws Exception {
		return initRelativeData(businessObject, relativeData);
	}
	
	/**
	 * �������̵ĸ�������,��Object������һ����¼,��Task������һ����¼����ʼ��ֱ��ͣ���ڵ�һ�����̽׶Σ������ڶ�����¼��
	 * @param processDefID ���̶�����
	 * @param userID �û����
	 * @param processState ����״̬
	 * @param businessObject ���������ص�ҵ�����
	 * @param processObjects �������淵�ص����̶����б�
	 * @throws Exception
	 */
	public void postStart(String processDefID, String userID, String processState, RelativeBusinessObject businessObject, List<ProcessObject> processObjects) throws Exception {
		String objectSerialNo = "";
		String taskSerialNo = "";
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom,taskBom;
		BizObject bo;
		try {
			bom = factory.getManager(getBizProcessObjectClaz(processDefID));
			getTx().join(bom);

			PSUserObject curUser = PSUserObject.getUser(userID); //�û�����
			
			bo = bom.newObject();
	        bo.getAttribute("ObjectNo").setValue(businessObject.getObjectNo()); //������
	        bo.getAttribute("ObjectType").setValue(businessObject.getObjectType()); //��������
	        bo.getAttribute("ApplyType").setValue(businessObject.getApplyType());//��������
	        bo.getAttribute("FlowNo").setValue(processDefID);//���̶�����
	        bo.getAttribute("OrgID").setValue(curUser.getOrgID());//�������
	        bo.getAttribute("OrgName").setValue(curUser.getOrgName());//��������
	        bo.getAttribute("UserID").setValue(curUser.getUserID());//�û����
	        bo.getAttribute("UserName").setValue(curUser.getUserName());//�û�����
	        bo.getAttribute("InputDate").setValue(StringFunction.getTodayNow());//��������
	        
	        if(processObjects == null || processObjects.size() ==0){
	        	throw new Exception("********�������̵ĺ���ʧ�ܣ����̶���Ϊ��********");
	        } else if(processObjects.size() == 1){//����ֻ��һ����¼
	        	ProcessObject processObject = (ProcessObject)processObjects.get(0);
	        	bo.getAttribute("FlowName").setValue(processObject.getProcessDefName());//���̶�������
	        	bo.getAttribute("ProcessInstNo").setValue(processObject.getProcessInstID());//����ʵ�����
	        	bo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());//����������
	            bo.getAttribute("PhaseType").setValue(processObject.getMilestone());//�׶�����
	        	bo.getAttribute("PhaseNo").setValue(processObject.getActivityID());//�׶α��
	            bo.getAttribute("PhaseName").setValue(processObject.getActivityName());//�׶�����
	            bo.getAttribute("OBJDESCRIBE").setValue(processObject.getObjectDescribe());//���������̶�����
	            //����״̬Ĭ�ϳ�ʼ��Ϊ1010������ͨ���ⲿ�����޸�
	            if(processState==null || "".equals(processState)){
	            	bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_APPLY);
	            }else{
	            	bo.getAttribute("FlowState").setValue(processState);
	            }
	            bo.getAttribute("ARCHIVE").setValue("0");//�鵵�ų�ʼ��Ϊ0

	            //д��ҵ�����̶��������һ����
	            bom.saveObject(bo);
	            objectSerialNo = bo.getAttribute("ObjectNo").toString();
	            
	            //д��ҵ���������������һ����
	            taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
	            getTx().join(taskBom);
	            BizObject taskBo = taskBom.newObject();
	            taskBo.setAttributesValue(bo);
	            //taskBo.getAttribute("SerialNo").setNull(); //��ˮ���������ÿգ�Ȼ������JBO����
	            taskBo.getAttribute("RelativeObjectNo").setValue(objectSerialNo);
	            taskBo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());
	            taskBo.getAttribute("BegInTime").setValue(StringFunction.getTodayNow());
	            taskBom.saveObject(taskBo);
	            taskSerialNo = taskBo.getAttribute("SerialNo").toString();
	            
	            //��taskSerialNo������ҵ�����̶����
	            bo.getAttribute("RelativeTaskNo").setValue(taskSerialNo);
	            bom.saveObject(bo);
	        }else{
	        	throw new Exception("********�������̵ĺ���ʧ�ܣ����̶����¼̫��********");
	        }
		} catch (JBOException e) {
			logger.debug("********�������̵ĺ������ݿ����ʧ��********"+e.getMessage(), e);
			throw new Exception("********�������̵ĺ������ݿ����ʧ��********"+e.getMessage(), e);
		} catch (Exception e) {
			logger.debug("********�������̵ĺ������ʧ��********"+e.getMessage(), e);
			e.printStackTrace();
			throw new Exception("********�������̵ĺ������ʧ��********"+e.getMessage(), e);
		}
	}
	
	/**
	 * ��������:
	 * @param processDefID ���̶�����
	 * @param businessObject ���ҵ�����
	 * @param processState ����״̬
	 * @return
	 * @throws Exception
	 */

	public String postReConsider(String processDefID, String bizProcessTaskID, String processState) throws Exception{
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom,taskBom;
		BizObjectQuery query;
		BizObject bo;
		try {
			//�رյ�ǰ����
			taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
			getTx().join(taskBom);
			query = taskBom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", bizProcessTaskID);
			BizObject curBo = query.getSingleResult(true);
			if(curBo != null){
				curBo.setAttributeValue("EndTime", StringFunction.getTodayNow());
				curBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_CLOSE);
			}else{
				return FAILURE_MESSAGE;
			}
			
			//��ѯ�����̷���׶ε���һ�׶�
			String relativeObjectNo = curBo.getAttribute("RelativeObjectNo").toString();
			query = taskBom.createQuery("RelativeObjectNo = :RelativeObjectNo order by SerialNo asc")
									.setParameter("RelativeObjectNo", relativeObjectNo);
			@SuppressWarnings("unchecked")
			List boList = query.getResultList(false);
			BizObject firstBo = (BizObject)boList.get(1);
			if(firstBo == null)return FAILURE_MESSAGE;
			
			curBo.setAttributeValue("PhaseAction", firstBo.getAttribute("PhaseNo"));
			curBo.setAttributeValue("PhaseOpinion", firstBo.getAttribute("UserID"));
			taskBom.saveObject(curBo);
			
			if (processState == null || "".equals(processState)) {
				processState = BusinessProcessConst.FLOWSTATE_RECONSIDER;
			}
			
			//����һ����¼
			BizObject taskbo = taskBom.newObject();
			taskbo.setAttributesValue(curBo);
			taskbo.getAttribute("SerialNo").setNull();
			taskbo.setAttributeValue("RelativeSerialNo", bizProcessTaskID);
			taskbo.setAttributeValue("RelativeObjectNo", relativeObjectNo);
			taskbo.getAttribute("OrgID").setValue(firstBo.getAttribute("OrgID"));//�������
			taskbo.getAttribute("OrgName").setValue(firstBo.getAttribute("OrgName"));//��������
			taskbo.getAttribute("UserID").setValue(firstBo.getAttribute("UserID"));//�û����
			taskbo.getAttribute("UserName").setValue(firstBo.getAttribute("UserName"));//�û�����
			taskbo.setAttributeValue("PhaseNo", firstBo.getAttribute("PhaseNo"));
			taskbo.setAttributeValue("PhaseName", firstBo.getAttribute("PhaseName"));
			taskbo.setAttributeValue("PhaseType", firstBo.getAttribute("PhaseType"));
			taskbo.getAttribute("InfoArea").setValue(firstBo.getAttribute("InfoArea"));//��Ϣ��
			taskbo.getAttribute("OperateArea").setValue(firstBo.getAttribute("OperateArea"));//��ҵ��
			taskbo.getAttribute("ButtonArea").setValue(firstBo.getAttribute("ButtonArea"));//��ť��
			taskbo.setAttributeValue("BeginTime", StringFunction.getTodayNow());
			taskbo.getAttribute("EndTime").setNull();
			taskbo.setAttributeValue("TaskState", BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);
			taskbo.setAttributeValue("FlowState", processState);
			taskBom.saveObject(taskbo);
			
			String newSerialNo = taskbo.getAttribute("SerialNo").toString();
			//����Object��¼
			bom = factory.getManager(getBizProcessObjectClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("ObjectNo = :SerialNo").setParameter("SerialNo", relativeObjectNo);
			bo = query.getSingleResult(true);
			bo.setAttributeValue("PhaseType", firstBo.getAttribute("PhaseType"));
			bo.setAttributeValue("PhaseNo", firstBo.getAttribute("PhaseNo"));
			bo.setAttributeValue("PhaseName", firstBo.getAttribute("PhaseName"));
			bo.setAttributeValue("FlowState", processState);
			bo.setAttributeValue("RelativeTaskNo", newSerialNo);
			bom.saveObject(bo);
			commitTx();
		} catch (JBOException e){
			rollbackTx();
			logger.debug("�����������ʧ��", e);
			return FAILURE_MESSAGE;
		}
		
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * ҵ��ϵͳ��ɾ������:ɾ��Object/Task��ؼ�¼
	 * @param processDefID ���̶�����
	 * @param bizProcessObjectID ҵ�������
	 * @return SUCCESS/FAILURE
	 * @throws Exception
	 */
	public String doDelete(String processDefID, String bizProcessObjectID) throws Exception {
		String result = FAILURE_MESSAGE;
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		try{
			//ɾ��Object��ؼ�¼
			bom = factory.getManager(getBizProcessObjectClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("ObjectNo =:SerialNo").setParameter("SerialNo", bizProcessObjectID);
			bo = query.getSingleResult(true);
			if (bo != null) {
				bom.deleteObject(bo);
			} else {
				logger.error("ɾ�����̶����¼ʧ�ܣ���ˮ��Ϊ["+bizProcessObjectID+"]�ļ�¼δ�ҵ�");
				rollbackTx();
				return result;
			}
			
			//ɾ��Task��ؼ�¼
			bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("RelativeObjectNo =:SerialNo").setParameter("SerialNo", bizProcessObjectID);
			@SuppressWarnings("unchecked")
			List bos = query.getResultList(true);
			if(bos != null && bos.size() > 0){
				for(int i=0; i < bos.size(); i++){
					bom.deleteObject((BizObject)bos.get(i));
				}
			}else{
				logger.error("ɾ�����������¼ʧ�ܣ��������̶�����ˮ��Ϊ["+bizProcessObjectID+"]�ļ�¼δ�ҵ�");
				rollbackTx();
				return result;
			}
			result = SUCCESS_MESSAGE;
			logger.info("Ӧ��ϵͳɾ��ҵ�����ݳɹ�,����ⲿ�������������ⲿ�ύ����");
		} catch (JBOException e){
			rollbackTx();
			logger.debug("Ӧ��ϵͳɾ��ҵ������ʧ��" + e.getMessage(), e);
			throw new Exception("Ӧ��ϵͳɾ��ҵ������ʧ��" + e.getMessage(), e);
		}
		return result;
	}
	
	public String preCommit(RelativeBusinessObject businessObject, String relativeData) throws Exception {
		return initRelativeData(businessObject, relativeData);
	}
	
	/**
	 * �ύǰ��������
	 * @param processDefID ���̶�����
	 * @param bizProcessTaskID ҵ������������
	 * @return �ɹ������������������Ϣ��ʧ�ܷ��� ""
	 */
	public String preCommitAssistant(String processDefID, String bizProcessTaskID) throws Exception {
		String returnMessage = "";
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		try {
			//��ѯҪ�ύ�������������Ϣ
			bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("SerialNo =:SerialNo").setParameter("SerialNo", bizProcessTaskID);
			bo = query.getSingleResult(false);
			if (bo != null) {
				returnMessage = bo.getAttribute("PhaseNo").toString() + "@"
						+ bo.getAttribute("UserID").toString().replace("@", "");
			}
			commitTx();
		} catch (JBOException e){
			rollbackTx();
			logger.debug("�����ύǰ��������ʧ��"+e.getMessage(), e);
			throw new Exception("�����ύǰ��������ʧ��"+e.getMessage(), e);
		}
		return returnMessage;
	}
	
	/**
	 * �ύ���̵ĸ�������.����Object/Task��¼,����Task������һ���������¼
	 * @param processDefID ���̶�����
	 * @param bizProcessObjectID ���̶�����
	 * @param bizProcessTaskID ����������
	 * @param voteSerialNo �������
	 * @param curUserID �����ύ��
	 * @param processAction �����ύ����
	 * @param taskParticipants ���̴�����
	 * @param businessObject �뱾������ص�ҵ�����
	 * @param processObjects �������淵�ص����̶����б�
	 * @param processState ����״̬
	 * @param bizAssignedTaskID ָ����һ�׶�����������
	 * @return
	 */
	public String commitAssistant(String processDefID,
			String bizProcessObjectID, String bizProcessTaskID,
			String voteSerialNo, String curUserID, String processAction,
			String taskParticipants, RelativeBusinessObject businessObject,
			List<ProcessObject> processObjects, String processState,
			String bizAssignedTaskID) {
		String taskSerialNo = "";
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom,taskBom,mTaskBom;
		BizObjectQuery query;
		BizObject bo,taskBo;
		if(processState==null||"".equals(processState)||"null".equalsIgnoreCase(processState)){
			processState = BusinessProcessConst.FLOWSTATE_APPROVE;
		}
		try {
			
		    String multiUsers [] = taskParticipants.split(",");
			for(int k = 0 ; k < multiUsers.length ; k++){
				bom = factory.getManager(getBizProcessObjectClaz(processDefID));
				getTx().join(bom);
				
				query = bom.createQuery("ObjectNo = :ObjectNo and ObjectType = :ObjectType and PhaseNo=:PhaseNo")
										.setParameter("ObjectNo", bizProcessObjectID)
										.setParameter("ObjectType", businessObject.getObjectType())
										.setParameter("PhaseNo", businessObject.getPhaseNo());
				bo = query.getSingleResult(true);
				
				if(processObjects == null || processObjects.size() ==0){
		        	return FAILURE_MESSAGE;
		        } else if(processObjects.size() == 1){//�󲿷������Ϊһ����¼(���̵ĵ�����ģʽ)
		        	ProcessObject processObject = (ProcessObject)processObjects.get(0);
		            
		            //д��ҵ�����������
		            taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
		            getTx().join(taskBom);
		            
		            //����Ƿ�Ϊ����û�,ȥ����һ�����ţ��ָ�����顣
					String users = processObject.getUserID();
					String[] userID = null;
					if (users != null) {
						if (users.startsWith(","))users = users.substring(1);
						userID = users.split(",");
						userID = multiUsers[k].split(" ");
					}
					
		            //��֧�ľۺϽڵ㴦��ʽ
		            if (processAction.startsWith("Join")){
		            	query = taskBom.createQuery("RelativeObjectNo=:RelativeObjectNo and TaskState=0")
		            						.setParameter("RelativeObjectNo",bizProcessObjectID);
		            	List<BizObject> bos = query.getResultList(false);
		            	
		            	
		            	//�������һ�����ϵļ�¼δ�ۺϣ���ɾ��������¼���ȴ�������֧�ۺ���ɡ�
		            	//��������һ����¼�ύ�ľۺϣ�����ɾۺϣ��������ύ���¸��ڵ㡣
		            	if(bos!=null && bos.size()>1){
		            		//���̶������
			            	query = bom.createQuery("ObjectNo=:SerialNo and PhaseNo=:PhaseNo")
    											.setParameter("SerialNo",bizProcessObjectID)
    											.setParameter("PhaseNo", businessObject.getPhaseNo());
			            	bo = query.getSingleResult(true);
			            	bom.deleteObject(bo);
		            	}else{

				            //����ҵ�����̶����
				            bom.saveObject(bo);
				            
				            //�����������
							taskBo = taskBom.newObject();
							taskBo.setAttributesValue(bo);
							taskBo.getAttribute("SerialNo").setNull(); // ��ˮ���������ÿգ�Ȼ������JBO����
							taskBo.getAttribute("RelativeObjectNo").setValue(bizProcessObjectID);// ������̶�����
							taskBo.getAttribute("RelativeSerialNo").setValue(bizProcessTaskID);// �����ˮ��
							taskBo.getAttribute("PhaseType").setValue(processObject.getMilestone());//�׶�����
							taskBo.getAttribute("PhaseNo").setValue(processObject.getActivityID());//�׶α��
							taskBo.getAttribute("PhaseName").setValue(processObject.getActivityName());//�׶�����
							taskBo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());//�������������
							taskBo.getAttribute("BeginTime").setValue(StringFunction.getTodayNow());//��ʼʱ��
							taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);//״̬����Ϊδ�ύ
							taskBo.getAttribute("FlowState").setValue(processState);//����״̬
							taskBo.getAttribute("InfoArea").setValue(processObject.getInfoArea());//��Ϣ��
							taskBo.getAttribute("OperateArea").setValue(processObject.getOperateArea());//��ҵ��
							taskBo.getAttribute("ButtonArea").setValue(processObject.getButtonArea());//��ť��
							taskBo.getAttribute("GroupID").setValue(processObject.getGroupID());//��ɫ��Ϣ
							taskBo.getAttribute("AssignedTaskNo").setValue(bizAssignedTaskID);//ָ����һ�׶�����������
							
			                //��ȡ�������û����ơ�������š���������
			                PSUserObject user = PSUserObject.getUser(processObject.getUserID());
			                taskBo.getAttribute("UserID").setValue(user.getUserID());
			                taskBo.getAttribute("UserName").setValue(user.getUserName());
			                taskBo.getAttribute("OrgID").setValue(user.getOrgID());
			                taskBo.getAttribute("OrgName").setValue(user.getOrgName());
			                taskBo.getAttribute("BeginTime").setValue(StringFunction.getTodayNow());
							taskBom.saveObject(taskBo);
							
							
		            		//���̶������
			            	query = bom.createQuery("ObjectNo=:SerialNo and PhaseNo=:PhaseNo")
												.setParameter("SerialNo",bizProcessObjectID)
												.setParameter("PhaseNo", businessObject.getPhaseNo());
			            	bo = query.getSingleResult(true);
				            bo.getAttribute("PhaseType").setValue(processObject.getMilestone());//�׶�����
				        	bo.getAttribute("PhaseNo").setValue(processObject.getActivityID());//�׶α��
				            bo.getAttribute("PhaseName").setValue(processObject.getActivityName());//�׶�����
				            bo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());//������
				            bo.getAttribute("FlowState").setValue(processState);//����״̬
				            taskSerialNo = taskBo.getAttribute("SerialNo").toString();
				            bo.getAttribute("RelativeTaskNo").setValue(taskSerialNo);//������������������
				            bom.saveObject(bo);
		            	}
		            }
		            
		            //һ������ڵ������ڵ㴦��ʽ
					if (processAction.startsWith("Task") || processAction.startsWith("End")) {
						
			            bo.getAttribute("PhaseType").setValue(processObject.getMilestone());//�׶�����
			        	bo.getAttribute("PhaseNo").setValue(processObject.getActivityID());//�׶α��
			            bo.getAttribute("PhaseName").setValue(processObject.getActivityName());//�׶�����
			            bo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());//������
			            bo.getAttribute("FlowState").setValue(processState);//����״̬
						if("1000".equals(processObject.getMilestone())){
							bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_AGREE);
						}
						if("8000".equals(processObject.getMilestone())){
							bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_REJECT);
						}
			            //д��ҵ�����̶����
			            bom.saveObject(bo);
						
			            //��ȡ�û����ơ�������š���������
						PSUserObject user = null;
						if(userID.length==0){
							user = PSUserObject.getUser("");
						}else{
							user = PSUserObject.getUser(userID[0]);
						}
		            	query = taskBom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo",bizProcessTaskID);
		            	taskBo = query.getSingleResult(false);
		            	String forkState = taskBo.getAttribute("ForkState").getString();
						
						taskBo = taskBom.newObject();
						taskBo.setAttributesValue(bo);
						taskBo.getAttribute("SerialNo").setNull(); // ��ˮ���������ÿգ�Ȼ������JBO����
						taskBo.getAttribute("RelativeObjectNo").setValue(bizProcessObjectID);// ������̶�����
						taskBo.getAttribute("RelativeSerialNo").setValue(bizProcessTaskID);// �����ˮ��
						taskBo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());
						taskBo.getAttribute("BeginTime").setValue(StringFunction.getTodayNow());
						taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);//״̬����Ϊδ�ύ
						taskBo.getAttribute("FlowState").setValue(processState);//����״̬
						taskBo.getAttribute("InfoArea").setValue(processObject.getInfoArea());//��Ϣ��
						taskBo.getAttribute("OperateArea").setValue(processObject.getOperateArea());//��ҵ��
						taskBo.getAttribute("ButtonArea").setValue(processObject.getButtonArea());//��ť��
						taskBo.getAttribute("GroupID").setValue(processObject.getGroupID());//��ɫ��Ϣ
						taskBo.getAttribute("AssignedTaskNo").setValue(bizAssignedTaskID);//ָ����һ�׶�����������
						if(forkState!=null){
							String forkNum = forkState.substring(1, forkState.length());
							taskBo.getAttribute("ForkState").setValue(BusinessProcessConst.FORKSTATE_MIDDLE + forkNum);//��֧״̬-��֧��
						}
						if(voteSerialNo!=null){
							taskBo.getAttribute("RelativeVoteNo").setValue(voteSerialNo);//���������
						}
						if("1".equals(processObject.getIsSecretary())){
							taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_SECRETARY);//���������״̬
							taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_SECRETARY);//���������״̬
							bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_SECRETARY);//���������״̬
						}
			            if("1".equals(processObject.getIsPool())){
			            	taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_TASKPOOL);//�����״̬
			            	taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_POOL);//�����״̬
			            	bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_POOL);//�����״̬
							taskBo.getAttribute("GroupID").setValue(processObject.getUserID());
							taskBo.getAttribute("UserID").setValue("");//�����״̬�û�����ÿ�
							taskBo.getAttribute("UserName").setValue("");//�����״̬�û����ÿ�
							taskBo.getAttribute("OrgID").setValue("");//�����״̬��������ÿ�
							taskBo.getAttribute("OrgName").setValue("");//�����״̬�������ÿ�
			            }else{
							taskBo.getAttribute("UserID").setValue(user.getUserID());
							taskBo.getAttribute("UserName").setValue(user.getUserName());
							taskBo.getAttribute("OrgID").setValue(user.getOrgID());
							taskBo.getAttribute("OrgName").setValue(user.getOrgName());
			            }
		
						// ���Ϊ����׶�,�����ý���ʱ��
						if (processObject.getActivityID().startsWith("End")) {
							BizObject oldTaskBo = taskBom.createQuery("RelativeObjectNo =:RelativeObjectNo and userID = :UserID order by SerialNo desc")
													.setParameter("RelativeObjectNo", bizProcessObjectID)
													.setParameter("UserID", curUserID).getSingleResult(false);
							taskBo.getAttribute("UserID").setValue(oldTaskBo.getAttribute("UserID"));
							taskBo.getAttribute("UserName").setValue(oldTaskBo.getAttribute("UserName"));
							taskBo.getAttribute("OrgID").setValue(oldTaskBo.getAttribute("OrgID"));
							taskBo.getAttribute("OrgName").setValue(oldTaskBo.getAttribute("OrgName"));
							taskBo.getAttribute("EndTime").setValue(StringFunction.getTodayNow());
							taskBo.getAttribute("PhaseOpinion").setValue("AutoFinish");
							//�����ս��־
							taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_END);
							if("1000".equals(processObject.getMilestone())){
								taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_AGREE);
							}
							if("8000".equals(processObject.getMilestone())){
								taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_REJECT);
							}
						}
						taskBom.saveObject(taskBo);
						taskSerialNo = taskBo.getAttribute("SerialNo").toString();
						
			            //��taskSerialNo������ҵ�����̶����
			            bo.getAttribute("RelativeTaskNo").setValue(taskSerialNo);
			            bom.saveObject(bo);
			            
			            
			            //��֧�еĽ�������
			            if(processAction.startsWith("End")){
				            query = taskBom.createQuery("RelativeObjectNo =:RelativeObjectNo and TaskState='0' and PhaseNo <> :PhaseNo")
				            				.setParameter("RelativeObjectNo", bizProcessObjectID).setParameter("PhaseNo", businessObject.getPhaseNo());
				            List<BizObject> bos = query.getResultList(true);
							if (bos != null) {
								for (int i = 0; i < bos.size(); i++) {
									bo = bos.get(i);
									taskBom.deleteObject(bo);
								}
							}
							
							query = bom.createQuery("ObjectNo =:SerialNo and PhaseNo not in (:PhaseNo,:NewPhaseNo)")
											.setParameter("SerialNo", bizProcessObjectID)
											.setParameter("PhaseNo", businessObject.getPhaseNo())
											.setParameter("NewPhaseNo", processObject.getActivityID());
							bos = query.getResultList(true);
							if (bos != null) {
								for (int i = 0; i < bos.size(); i++) {
									bo = bos.get(i);
									bom.deleteObject(bo);
								}
							}
			            }
		            }
		            
					//��ǩ�ڵ㴦��ʽ
		            if(processObject.getActivityID().startsWith("CounterSign")){
		            	
			            bo.getAttribute("PhaseType").setValue(processObject.getMilestone());//�׶�����
			        	bo.getAttribute("PhaseNo").setValue(processObject.getActivityID());//�׶α��
			            bo.getAttribute("PhaseName").setValue(processObject.getActivityName());//�׶�����
			            bo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());//������
			            bo.getAttribute("FlowState").setValue(processState);//����״̬
						if("1000".equals(processObject.getMilestone())){
							bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_AGREE);
						}
						if("8000".equals(processObject.getMilestone())){
							bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_REJECT);
						}
			            //д��ҵ�����̶����
			            bom.saveObject(bo);
		            	
						taskBo = taskBom.newObject();
						taskBo.setAttributesValue(bo);
						taskBo.getAttribute("SerialNo").setNull(); // ��ˮ���������ÿգ�Ȼ������JBO����
						taskBo.getAttribute("RelativeObjectNo").setValue(bizProcessObjectID);// ������̶�����
						taskBo.getAttribute("RelativeSerialNo").setValue(bizProcessTaskID);// �����ˮ��
						taskBo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());
						
						taskBo.getAttribute("UserID").setValue("@"+users.replace(",", "@"));
						taskBo.getAttribute("UserName").setValue("");
						taskBo.getAttribute("OrgID").setValue("");
						taskBo.getAttribute("OrgName").setValue("");
						
						taskBo.getAttribute("BeginTime").setValue(StringFunction.getTodayNow());
						taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);//״̬����Ϊδ�ύ
						taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_VOTE);//����״̬
						taskBo.getAttribute("InfoArea").setValue(processObject.getInfoArea());//��Ϣ��
						taskBo.getAttribute("OperateArea").setValue(processObject.getOperateArea());//��ҵ��
						taskBo.getAttribute("ButtonArea").setValue(processObject.getButtonArea());//��ť��
						taskBo.getAttribute("GroupID").setValue(processObject.getGroupID());
						if(voteSerialNo!=null){
							taskBo.getAttribute("RelativeVoteNo").setValue(voteSerialNo);//���������
						}
			            if("1".equals(processObject.getIsPool())){
			            	taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_TASKPOOL);//�����״̬
			            	taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_POOL);//�����״̬
			            	bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_POOL);//�����״̬
							taskBo.getAttribute("GroupID").setValue(processObject.getUserID());
							taskBo.getAttribute("UserID").setValue("");//�����״̬�û�����ÿ�
							taskBo.getAttribute("UserName").setValue("");//�����״̬�û����ÿ�
							taskBo.getAttribute("OrgID").setValue("");//�����״̬��������ÿ�
							taskBo.getAttribute("OrgName").setValue("");//�����״̬�������ÿ�
			            }
		
						// ���Ϊ����׶�,�����ý���ʱ��
						if (processObject.getActivityID().startsWith("End")) {
							taskBo.getAttribute("EndTime").setValue(StringFunction.getTodayNow());
							taskBo.getAttribute("PhaseOpinion").setValue("AutoFinish");
							//�����ս��־
							taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_END);
							if("1000".equals(processObject.getMilestone())){
								taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_AGREE);
							}
							if("8000".equals(processObject.getMilestone())){
								taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_REJECT);
							}
						}
						taskBom.saveObject(taskBo);
						taskSerialNo = taskBo.getAttribute("SerialNo").toString();
						
			            // ��taskSerialNo������ҵ�����̶����
			            bo.getAttribute("RelativeTaskNo").setValue(taskSerialNo);
			            bom.saveObject(bo);
		            	
			            // ����д��ҵ�����̸��������
	    	            mTaskBom = factory.getManager(getBizProcessMultiTaskClaz(processDefID));
	    	            getTx().join(mTaskBom);
		            	for(int i = 0 ; i < userID.length ; i++){
		    	            BizObject mTaskbo = mTaskBom.newObject();
		    	            //��ȡ�û����ơ�������š���������
		    	            PSUserObject user = PSUserObject.getUser(userID[i]);
		    	            mTaskbo.getAttribute("SerialNo").setNull();
		    	            mTaskbo.setAttributeValue("RelativeTaskNo", taskSerialNo);
		    	            mTaskbo.setAttributeValue("UserID", user.getUserID());
		    	            mTaskbo.setAttributeValue("UserName", user.getUserName());
		    	            mTaskbo.setAttributeValue("OrgID", user.getOrgID());
		    	            mTaskbo.setAttributeValue("OrgName", user.getOrgName());
		    	            mTaskbo.setAttributeValue("BeginTime", StringFunction.getTodayNow());
		    	            mTaskbo.setAttributeValue("VoteState", BusinessProcessConst.UNFINISHED);
		    	            mTaskBom.saveObject(mTaskbo);
		            	}
		            }
		        } else{
		        	//������¼����������֧��
		        	for(int i=0;i<processObjects.size();i++){
		        		ProcessObject processObject = processObjects.get(i);

		        		//������������β����¼
		                taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
		                getTx().join(taskBom);
		                
		                query = taskBom.createQuery("RelativeObjectNo=:RelativeObjectNo and ForkState is not null order by ForkState desc")
		                							.setParameter("RelativeObjectNo", bizProcessObjectID);
		                BizObject boMax = query.getSingleResult(false);
		                Integer maxForkState=10;
		                if(boMax!=null){
		                		maxForkState = boMax.getAttribute("ForkState").getInt()+1;
		                }
		                
		                taskBo = taskBom.newObject();
		                taskBo.setAttributesValue(bo);
		                taskBo.getAttribute("SerialNo").setNull(); //��ˮ���������ÿգ�Ȼ������JBO����
						taskBo.getAttribute("RelativeObjectNo").setValue(bizProcessObjectID);
		                taskBo.getAttribute("RelativeSerialNo").setValue(bizProcessTaskID);//�����ˮ��
		                taskBo.getAttribute("PhaseType").setValue(processObject.getMilestone());//�׶�����
		                taskBo.getAttribute("PhaseNo").setValue(processObject.getActivityID());//�׶α��
		                taskBo.getAttribute("PhaseName").setValue(processObject.getActivityName());//�׶�����
		                taskBo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());
		                taskBo.getAttribute("UserID").setValue(processObject.getUserID());
						taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);//����״̬-δ�ύ
						taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_APPROVE);//����״̬-������
						taskBo.getAttribute("InfoArea").setValue(processObject.getInfoArea());//��Ϣ��
						taskBo.getAttribute("OperateArea").setValue(processObject.getOperateArea());//��ҵ��
						taskBo.getAttribute("ButtonArea").setValue(processObject.getButtonArea());//��ť��
						taskBo.getAttribute("GroupID").setValue(processObject.getGroupID());//��ɫ��Ϣ
						taskBo.getAttribute("ForkState").setValue(BusinessProcessConst.FORKSTATE_START+maxForkState);//��֧״̬-��ʼ
	
		                //��ȡ�������û����ơ�������š���������
		                PSUserObject user = PSUserObject.getUser(processObject.getUserID());
		                taskBo.getAttribute("UserID").setValue(user.getUserID());
		                taskBo.getAttribute("UserName").setValue(user.getUserName());
		                taskBo.getAttribute("OrgID").setValue(user.getOrgID());
		                taskBo.getAttribute("OrgName").setValue(user.getOrgName());
		                taskBo.getAttribute("BeginTime").setValue(StringFunction.getTodayNow());
		                taskBom.saveObject(taskBo);
		                
		                //���̶������»�������¼
		        		if(i==0){
			        		//�������̶����
				            bo.getAttribute("PhaseType").setValue(processObject.getMilestone());//�׶�����
				        	bo.getAttribute("PhaseNo").setValue(processObject.getActivityID());//�׶α��
				            bo.getAttribute("PhaseName").setValue(processObject.getActivityName());//�׶�����
				            bo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());//������
				            bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_APPROVE);//����״̬
				            bo.setAttributeValue("RELATIVETASKNO", taskBo.getAttribute("SerialNo"));
			                bom.saveObject(bo);
		        		}else{
		        			BizObject boNew = bom.newObject();
			        		//���̶��������¼�¼
		        			boNew.setAttributesValue(bo);
				            boNew.getAttribute("PhaseType").setValue(processObject.getMilestone());//�׶�����
		        			boNew.getAttribute("PhaseNo").setValue(processObject.getActivityID());//�׶α��
		        			boNew.getAttribute("PhaseName").setValue(processObject.getActivityName());//�׶�����
		        			boNew.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());//������
		        			boNew.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_APPROVE);//����״̬
		        			boNew.setAttributeValue("RELATIVETASKNO", taskBo.getAttribute("SerialNo"));
		        			bom.saveObject(boNew);
		        		}
		        	}
		        }
				//����ҵ�������
		        bom = factory.getManager(getBizProcessTaskClaz(processDefID));
		        getTx().join(bom);
		        BizObject bizOldTaskObject = bom.createQuery("SerialNo=:SerialNo")
		        				   				.setParameter("SerialNo", bizProcessTaskID)
		        				   				.getSingleResult(true);
		        bizOldTaskObject.getAttribute("EndTime").setValue(StringFunction.getTodayNow());//���ý���ʱ��
		        bizOldTaskObject.getAttribute("PhaseOpinion").setValue(taskParticipants);//�ύ����
		        bizOldTaskObject.getAttribute("PhaseAction").setValue(processAction);//�ύ���
		        bizOldTaskObject.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_FINISHED);//״̬����Ϊ���ύ
		        bom.saveObject(bizOldTaskObject);
		        
		        //ɾ���������������¼--�ύ����ɫ�����ύ��������Աר�ã���Ӱ����������
		        String relativeSerialNo = bizOldTaskObject.getAttribute("RelativeSerialNo").toString();
		        BizObjectManager oldTaskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
		        getTx().join(oldTaskBom);
		        List deleteBos = oldTaskBom.createQuery("RelativeSerialNo=:RelativeSerialNo and TaskState = '0' and PhaseNo =:PhaseNo")
							        					.setParameter("RelativeSerialNo", relativeSerialNo)
							        					.setParameter("PhaseNo", businessObject.getPhaseNo())
							        					.getResultList(true);
		        if(deleteBos!=null){
		        	for(int i = 0 ; i< deleteBos.size();i++){
		        		BizObject deleteBo = (BizObject)deleteBos.get(i);
		        		oldTaskBom.deleteObject(deleteBo);
		        	}
		        }
		        commitTx();
			}
		} catch (JBOException e){
			rollbackTx();
			logger.debug("�ύ���̸����������", e);
			return FAILURE_MESSAGE;
		} catch (Exception e) {
			rollbackTx();
			logger.debug("�ύ���̵ĸ�������ʧ��,ʵ�����û��������", e);
			return FAILURE_MESSAGE;
		}
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * ����������Ա�ĸ�������.MultiTask���Ӽ�¼
	 * @param processDefID ���̶�����
	 * @param bizProcessTaskID ҵ��������(��Ӧ��ϵͳ�����Ŷ�Ӧ)
	 * @param users �û��б�
	 * @return
	 */
	public String addVoteAssistant(String processDefID, String bizProcessTaskID, String users){
		//��ѯ��TASK��¼������������Ա
		//if(users.startsWith(","))users.substring(1);
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom,taskBom;
		BizObject bo;
		String [] userID = users.split(",");
		try {
			users = users.replace(",", "@");
            //����ҵ�����������
            taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
            getTx().join(taskBom);
            BizObject taskBo = taskBom.createQuery("SerialNo =:SerialNo")
            						.setParameter("SerialNo", bizProcessTaskID).getSingleResult(true);
            String oldUsers = taskBo.getAttribute("UserID").toString();
			users = oldUsers + users + "@";
            taskBo.setAttributeValue("UserID", users);
            taskBom.saveObject(taskBo);
			
			bom = factory.getManager(getBizProcessMultiTaskClaz(processDefID));
			getTx().join(bom);
			for (int i = 0; i < userID.length; i++) {
				PSUserObject user = PSUserObject.getUser(userID[i]);
				bo = bom.newObject();
				bo.getAttribute("SerialNo").setNull();
				bo.setAttributeValue("RelativeTaskNo", bizProcessTaskID);
				bo.setAttributeValue("UserID", user.getUserID());
				bo.setAttributeValue("UserName", user.getUserName());
				bo.setAttributeValue("OrgID", user.getOrgID());
				bo.setAttributeValue("OrgName", user.getOrgName());
				bo.setAttributeValue("BeginTime", StringFunction.getTodayNow());
				bo.setAttributeValue("VoteState", BusinessProcessConst.UNFINISHED);
				bom.saveObject(bo);
			}
			commitTx();
		} catch (Exception e) {
			rollbackTx();
			logger.debug("����������Ա�����������", e);
			return FAILURE_MESSAGE;
		}
		
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * ɾ��������Ա�ĸ�������.ɾ��MultiTask��¼
	 * @param processDefID ���̶�����
	 * @param bizProcessTaskID ҵ��������(��Ӧ��ϵͳ�����Ŷ�Ӧ)
	 * @param users �û��б�
	 * @return
	 */
	public String removeVoteAssistant(String processDefID, String bizProcessTaskID, String users){
		//��ѯ��MULTITASK��¼��ɾ��������Ա
		//if(users.startsWith(","))users.substring(1);
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom,taskBom;
		BizObjectQuery query;
		BizObject bo;
		String [] userID = users.split(",");
		try {
            //����ҵ�����������
            taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
            getTx().join(taskBom);
            BizObject taskBo = taskBom.createQuery("SerialNo =:SerialNo")
					.setParameter("SerialNo", bizProcessTaskID).getSingleResult(false);
            String oldUsers = taskBo.getAttribute("UserID").toString();
            
			bom = factory.getManager(getBizProcessMultiTaskClaz(processDefID));
			getTx().join(bom);
			for (int i = 0; i < userID.length; i++) {
				oldUsers = oldUsers.replace(userID[i]+"@", "");
				query = bom.createQuery("RelativeTaskNo=:RelativeTaskNo and UserID=:UserID and VoteState<>'99'")
										.setParameter("RelativeTaskNo", bizProcessTaskID)
										.setParameter("UserID", userID[i]);
				bo = query.getSingleResult(true);
				if(bo!=null){
					bo.setAttributeValue("voteState", BusinessProcessConst.BUSINESS_PROCESS_CLOSE);
					bom.saveObject(bo);
				}
			}
			taskBo.setAttributeValue("UserID", oldUsers);
			taskBom.saveObject(taskBo);
			commitTx();
		} catch (Exception e) {
			rollbackTx();
			logger.debug("ɾ��������Ա�����������", e);
			return FAILURE_MESSAGE;
		}
		
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * �ύͶƱ���̵ĸ�������.����Object/Task��¼,����Task������һ���������¼
	 * @param processDefID ���̶�����
	 * @param bizProcessObjectID ���̶�����
	 * @param bizProcessTaskID ����������
	 * @param voteSerialNo ���������
	 * @param userID �����ύ��
	 * @param voteOpinion �����ύ����
	 * @param taskParticipants ���̴�����
	 * @param businessObject �뱾������ص�ҵ�����
	 * @param processObject �������淵�ص����̶���
	 * @return
	 */
	public String commitVoteAssistant(String processDefID, String bizProcessObjectID,String bizProcessTaskID, String voteSerialNo, String userID,String voteOpinion,String taskParticipants, RelativeBusinessObject businessObject, ProcessObject processObject){
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom,taskBom,mTaskBom;
		BizObjectQuery query;
		BizObject bo;
		if(processObject == null )return FAILURE_MESSAGE;
		try {
			if(processObject.getActivityID()==null || "".equals(processObject.getActivityID())){
				//���¸��������
				mTaskBom = factory.getManager(getBizProcessMultiTaskClaz(processDefID));
				getTx().join(mTaskBom);
		        BizObject mTaskBo = mTaskBom.createQuery("RelativeTaskNo=:RelativeTaskNo and UserID=:UserID")
		        					.setParameter("RelativeTaskNo", bizProcessTaskID)
		        					.setParameter("UserID", userID).getSingleResult(true);
		        if(mTaskBo != null){
		        	mTaskBo.setAttributeValue("EndTime", StringFunction.getTodayNow());
		        	mTaskBo.setAttributeValue("VoteState", BusinessProcessConst.FINISHED);
		        	mTaskBo.setAttributeValue("VoteOpinion", voteOpinion);
		        	mTaskBom.saveObject(mTaskBo);
		        }
	            //����ҵ�����������
	            taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
	            getTx().join(taskBom);
	            BizObject taskBo = taskBom.createQuery("SerialNo =:SerialNo")
    					.setParameter("SerialNo", bizProcessTaskID).getSingleResult(true);
	            //��ѯ����ͶƱ���û���Ϣ
	            String RelativeUser = taskBo.getAttribute("RelativeUser").toString();
				if (RelativeUser == null) {
					RelativeUser = "@" + processObject.getUserVote() + "@";
				} else {
					RelativeUser = RelativeUser + processObject.getUserVote() + "@";
				}
	            taskBo.setAttributeValue("RelativeUser", RelativeUser);
	            taskBom.saveObject(taskBo);
			}else{
				bom = factory.getManager(getBizProcessObjectClaz(processDefID));
				getTx().join(bom);
				
				query = bom.createQuery("ObjectNo=:SerialNo").setParameter("SerialNo", bizProcessObjectID);
				bo = query.getSingleResult(true);
				
	            bo.getAttribute("PhaseType").setValue(processObject.getMilestone());//�׶�����
	        	bo.getAttribute("PhaseNo").setValue(processObject.getActivityID());//�׶α��
	            bo.getAttribute("PhaseName").setValue(processObject.getActivityName());//�׶�����
	            bo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());//������
	            bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_APPROVE);//����״̬
	            //д��ҵ�����̶����
	            bom.saveObject(bo);
	            
	            //д��ҵ�����������
	            taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
	            getTx().join(taskBom);
	            
	            //��ȡ�û����ơ�������š���������
	            PSUserObject user = PSUserObject.getUser(processObject.getUserID());
	            
				BizObject taskBo = taskBom.newObject();
				taskBo.setAttributesValue(bo);
				taskBo.getAttribute("SerialNo").setNull(); //��ˮ���������ÿգ�Ȼ������JBO����
				taskBo.getAttribute("RelativeObjectNo").setValue(bizProcessObjectID); //������̶�����
				taskBo.getAttribute("RelativeSerialNo").setValue(bizProcessTaskID); //�����ˮ��
				taskBo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());
				taskBo.getAttribute("UserID").setValue(user.getUserID());
				taskBo.getAttribute("UserName").setValue(user.getUserName());
				taskBo.getAttribute("OrgID").setValue(user.getOrgID());
				taskBo.getAttribute("OrgName").setValue(user.getOrgName());
				taskBo.getAttribute("GroupID").setValue(processObject.getGroupID());
				taskBo.getAttribute("BeginTime").setValue(StringFunction.getTodayNow());
				taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);//״̬����Ϊδ�ύ
				taskBo.getAttribute("InfoArea").setValue(processObject.getInfoArea());//��Ϣ��
				taskBo.getAttribute("OperateArea").setValue(processObject.getOperateArea());//��ҵ��
				taskBo.getAttribute("ButtonArea").setValue(processObject.getButtonArea());//��ť��
				if(voteSerialNo!=null){
					taskBo.getAttribute("RelativeVoteNo").setValue(voteSerialNo);//���������
				}
				//�ж��Ƿ��Ǵ��������
				if("1".equals(processObject.getIsSecretary())){
					taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_SECRETARY);//���������״̬
					taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_SECRETARY);//���������״̬
					bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_SECRETARY);//���������״̬
				}
				if("1".equals(processObject.getIsPool())){
					taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_TASKPOOL);//�����״̬
					taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_POOL);//�����״̬
					bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_POOL);//�����״̬
				}
				if(user.getUserID().indexOf("@")>=0){
					taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);//δ���
					taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_VOTE);//�����״̬
					bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_VOTE);//�����״̬
				}
				//���Ϊ����׶�,�����ý���ʱ��
				if (processObject.getActivityID().startsWith("End")) {
					BizObject oldTaskBo = taskBom.createQuery("RelativeObjectNo =:RelativeObjectNo order by SerialNo desc")
							.setParameter("RelativeObjectNo", bizProcessObjectID).getSingleResult(true);
					taskBo.getAttribute("UserID").setValue(oldTaskBo.getAttribute("UserID"));
					taskBo.getAttribute("UserName").setValue(oldTaskBo.getAttribute("UserName"));
					taskBo.getAttribute("OrgID").setValue(oldTaskBo.getAttribute("OrgID"));
					taskBo.getAttribute("OrgName").setValue(oldTaskBo.getAttribute("OrgName"));
					taskBo.getAttribute("EndTime").setValue(StringFunction.getTodayNow());
					taskBo.getAttribute("PhaseOpinion").setValue("AutoFinish");
					taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_END);//״̬����Ϊ���ս�
					if("1000".equals(processObject.getMilestone())){
						taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_AGREE);
					}
					if("8000".equals(processObject.getMilestone())){
						taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_REJECT);
					}
				}
				taskBom.saveObject(taskBo);
				String taskSerialNo = taskBo.getAttribute("SerialNo").toString();
				
	            //��taskSerialNo������ҵ�����̶����
	            bo.getAttribute("RelativeTaskNo").setValue(taskSerialNo);
	            bom.saveObject(bo);
	
				//����ҵ�������
		        bom = factory.getManager(getBizProcessTaskClaz(processDefID));
		        getTx().join(bom);
		        BizObject bizOldTaskObject = bom.createQuery("SerialNo=:SerialNo")
		        				   				.setParameter("SerialNo", bizProcessTaskID)
		        				   				.getSingleResult(true);
	            //��ѯ����ͶƱ���û���Ϣ
	            String RelativeUser = bizOldTaskObject.getAttribute("RelativeUser").toString();
				if (RelativeUser == null) {
					RelativeUser = "@" + processObject.getUserVote() + "@";
				} else {
					RelativeUser = RelativeUser + processObject.getUserVote() + "@";
				}
				bizOldTaskObject.setAttributeValue("RelativeUser", RelativeUser);
		        bizOldTaskObject.getAttribute("EndTime").setValue(StringFunction.getTodayNow());//���ý���ʱ��
		        bizOldTaskObject.getAttribute("PhaseOpinion").setValue(taskParticipants);//�ύ����
		        bizOldTaskObject.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_FINISHED);//״̬����Ϊ���ύ
		        bom.saveObject(bizOldTaskObject);
		        
				//���¸��������
				mTaskBom = factory.getManager(getBizProcessMultiTaskClaz(processDefID));
				getTx().join(mTaskBom);
		        BizObject mTaskBo = mTaskBom.createQuery("RelativeTaskNo=:RelativeTaskNo and UserID=:UserID")
		        					.setParameter("RelativeTaskNo", bizProcessTaskID)
		        					.setParameter("UserID", userID).getSingleResult(true);
		        if(mTaskBo != null){
		        	mTaskBo.setAttributeValue("EndTime", StringFunction.getTodayNow());
		        	mTaskBo.setAttributeValue("VoteState", BusinessProcessConst.FINISHED);
		        	mTaskBo.setAttributeValue("VoteOpinion", voteOpinion);
		        	mTaskBom.saveObject(mTaskBo);
		        }
		        
		        //�����������������
				if(user.getUserID().indexOf("@")>=0){
		            // ����д��ҵ�����̸��������
    	            mTaskBom = factory.getManager(getBizProcessMultiTaskClaz(processDefID));
    	            getTx().join(mTaskBom);
    	            String users[] = user.getUserID().split("@");
	            	for(int i = 1 ; i < users.length ; i++){
	    	            BizObject mTaskbo = mTaskBom.newObject();
	    	            //��ȡ�û����ơ�������š���������
	    	            PSUserObject mUser = PSUserObject.getUser(users[i]);
	    	            mTaskbo.getAttribute("SerialNo").setNull();
	    	            mTaskbo.setAttributeValue("RelativeTaskNo", taskSerialNo);
	    	            mTaskbo.setAttributeValue("UserID", mUser.getUserID());
	    	            mTaskbo.setAttributeValue("UserName", mUser.getUserName());
	    	            mTaskbo.setAttributeValue("OrgID", mUser.getOrgID());
	    	            mTaskbo.setAttributeValue("OrgName", mUser.getOrgName());
	    	            mTaskbo.setAttributeValue("BeginTime", StringFunction.getTodayNow());
	    	            mTaskbo.setAttributeValue("VoteState", BusinessProcessConst.UNFINISHED);
	    	            mTaskBom.saveObject(mTaskbo);
	            	}
				}
			}
	        commitTx();
		} catch (JBOException e){
			rollbackTx();
			logger.debug("�ύ���̸����������", e);
			return FAILURE_MESSAGE;
		} catch (Exception e) {
			rollbackTx();
			logger.debug("�ύ���̵ĸ�������ʧ��,ʵ�����û��������", e);
			return FAILURE_MESSAGE;
		}
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * ����ػ�ȡ����ĸ�������.����Task��¼
	 * @param processDefID ���̶�����
	 * @param bizProcessTaskID ҵ��������(��Ӧ��ϵͳ�����Ŷ�Ӧ)
	 * @param userID ��ȡ�����û�
	 * @return
	 */
	public String takeTaskFromPoolAssistant(String processDefID, String bizProcessTaskID, String userID){
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		//��ѯ��TASK��¼�����û���Ϊ��ȡ�����˱�ţ�����relativeUser��Ϊ����ؽ�ɫ
		try {
			bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", bizProcessTaskID);
			bo = query.getSingleResult(true);
			PSUserObject user = PSUserObject.getUser(userID);
			bo.setAttributeValue("UserID", user.getUserID());
			bo.getAttribute("UserName").setValue(user.getUserName());
			bo.getAttribute("OrgID").setValue(user.getOrgID());
			bo.getAttribute("OrgName").setValue(user.getOrgName());
			//������״̬��Ϊδ�ύ
			bo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);
			bom.saveObject(bo);
			commitTx();
		} catch (Exception e) {
			rollbackTx();
			logger.debug("��ȡ������������", e);
			return FAILURE_MESSAGE;
		}
		
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * ������û������ĸ�������.����Task��¼
	 * @param processDefID ���̶�����
	 * @param bizProcessTaskID ҵ��������(��Ӧ��ϵͳ�����Ŷ�Ӧ)
	 * @param userID ��ȡ�����û�
	 * @return
	 */
	public String taskPoolAdjustAssistant(String processDefID, String bizProcessTaskID, String userID){
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		//��ѯ��TASK��¼�����û���Ϊ���������˱��
		try {
			bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", bizProcessTaskID);
			bo = query.getSingleResult(true);
			PSUserObject user = PSUserObject.getUser(userID);
			bo.setAttributeValue("UserID", user.getUserID());
			bo.setAttributeValue("UserName", user.getUserName());
			bo.getAttribute("OrgID").setValue(user.getOrgID());
			bo.getAttribute("OrgName").setValue(user.getOrgName());
			bo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);
			bom.saveObject(bo);
			commitTx();
		} catch (Exception e) {
			rollbackTx();
			logger.debug("������û���������", e);
			return FAILURE_MESSAGE;
		}
		
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * �����˻�����صĸ�������.����Task��¼
	 * @param processDefID ���̶�����
	 * @param bizProcessTaskID ҵ��������(��Ӧ��ϵͳ�����Ŷ�Ӧ)
	 * @return
	 */
	public String returnToPoolAssistant(String processDefID, String bizProcessTaskID){
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		//��ѯ��TASK��¼�����û��û�Ϊ�����״̬
		try {
			bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", bizProcessTaskID);
			bo = query.getSingleResult(true);
			
			bo.setAttributeValue("UserID","");
			bo.setAttributeValue("UserName", "");
			bo.setAttributeValue("OrgID", "");
			bo.setAttributeValue("OrgName", "");
			bo.setAttributeValue("TaskState",BusinessProcessConst.BUSINESS_PROCESS_TASKPOOL);
			bom.saveObject(bo);
			commitTx();
		} catch (Exception e) {
			rollbackTx();
			logger.debug("��ȡ������������", e);
			return FAILURE_MESSAGE;
		}
		
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * ��ȡ����ؽ�ɫ
	 * @param processDefID ���̶�����
	 * @param bizProcessTaskID ҵ��������(��Ӧ��ϵͳ�����Ŷ�Ӧ)
	 * @return
	 */
	public String getRole(String processDefID, String bizProcessTaskID){
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		//��ȡ����ؽ�ɫ
		String roles = "";
		try {
			bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", bizProcessTaskID);
			bo = query.getSingleResult(false);
			roles = bo.getAttribute("GroupID").toString();
		} catch (Exception e) {
			rollbackTx();
			logger.debug("��ȡ����ؽ�ɫ����", e);
			return FAILURE_MESSAGE;
		}
		return roles;
	}
	
	/**
	 * ����鵵�ĸ�������.����Task��¼
	 * @param processDefID ���̶�����
	 * @param bizProcessObjectID ���̶�����
	 * @return
	 */
	public String taskAchive(String processDefID, String bizProcessObjectID){
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		//��ѯ��TASK��¼�����鵵��ʶ��Ϊ1
		try {
			bom = factory.getManager(getBizProcessObjectClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("ObjectNo =:SerialNo")
						.setParameter("SerialNo", bizProcessObjectID);
			bo = query.getSingleResult(true);
			bo.getAttribute("ARCHIVE").setValue("1");
			bo.getAttribute("ARCHIVETIME").setValue(StringFunction.getTodayNow());
			bom.saveObject(bo);
			commitTx();
		} catch (Exception e) {
			rollbackTx();
			logger.debug("����鵵�����������", e);
			return FAILURE_MESSAGE;
		}
		
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * ȡ������鵵�ĸ�������.����Task��¼
	 * @param processDefID ���̶�����
	 * @param bizProcessObjectID ���̶�����
	 * @return
	 */
	public String cancelAchive(String processDefID, String bizProcessObjectID){
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		//��ѯ��TASK��¼�����鵵��ʶ��Ϊ0
		try {
			bom = factory.getManager(getBizProcessObjectClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("ObjectNo =:SerialNo")
						.setParameter("SerialNo", bizProcessObjectID);
			bo = query.getSingleResult(true);
			bo.getAttribute("ARCHIVE").setValue("0");
			bo.getAttribute("ARCHIVETIME").setValue(StringFunction.getTodayNow());
			bom.saveObject(bo);
			commitTx();
		} catch (Exception e) {
			rollbackTx();
			logger.debug("����鵵�����������", e);
			return FAILURE_MESSAGE;
		}
		
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * �����Ƿ���ջ��ж�,�ж�����:��һ���Ĵ������Ƿ��ǵ�ǰ������
	 * @param processDefID ���̶�����
	 * @param bizProcessTaskID ҵ������������
	 * @param userID ��ǰ�����˱��
	 * @return true/false
	 */
	public boolean canWithdraw(String processDefID, String bizProcessTaskID, String userID){
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		try {
			 //�ҳ������ˮ�ź���ض�����
			 bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			 String queryStr = "SerialNo=:SerialNo ";
			 query = bom.createQuery(queryStr).setParameter("SerialNo", bizProcessTaskID);
			 bo = query.getSingleResult(false);
			 String relativeSerialNo = bo.getAttribute("RelativeSerialNo").toString();
			 String relativeObjectNo = bo.getAttribute("RelativeObjectNo").toString();
			 
			 query = bom.createQuery("RelativeSerialNo=:RSerialNo and RelativeObjectNo=:RObjectNo")
			 							.setParameter("RSerialNo", relativeSerialNo)
			 							.setParameter("RObjectNo", relativeObjectNo);
			 List<BizObject> bos = query.getResultList(false);
			 for(int i = 0;i<bos.size();i++){
				 bo = bos.get(i);
				 String taskState = bo.getAttribute("TaskState").toString();
				 //�ҳ���һ��������
				 queryStr = "SerialNo=:SerialNo ";
				 query = bom.createQuery(queryStr).setParameter("SerialNo", relativeSerialNo);
				 bo = query.getSingleResult(false);
				 String lastUserID = bo.getAttribute("UserID").toString().replace("@", "");
				 if(!userID.equalsIgnoreCase(lastUserID) || "1".equals(taskState)){
					 return false;
				 }
			 }
		} catch (JBOException e){
			logger.debug("�ж������Ƿ���ջ�ʧ��", e);
			return false;
		}
		return true;
	}
	
	/**
	 * �ջ�����,���ش��ύ�����Ź������������
	 * @param processDefID ���̶�����
	 * @param bizProcessTaskID ҵ������������
	 * @return
	 */
	public String doWithdraw(String processDefID, String bizProcessTaskID){
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		String withdrawProp = "";
		try {
			 //ȡ����һ����bizProcessTaskID
			 bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			 getTx().join(bom);
			 query = bom.createQuery("SerialNo=:SerialNo")
			 			.setParameter("SerialNo", bizProcessTaskID);
			 bo = query.getSingleResult(true);
			 
			 String oldBizProcessTaskID = bo.getAttribute("RelativeSerialNo").toString();
			 String processTaskNo = bo.getAttribute("ProcessTaskNo").toString();
			 
			 query = bom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", oldBizProcessTaskID);
			 BizObject lastTaskBo = query.getSingleResult(false);

			 withdrawProp = processTaskNo + "@" + //�ջ�����������
	 		 				lastTaskBo.getAttribute("PhaseNo").getString() + "@" + //�ջؽ׶�
	 		 				lastTaskBo.getAttribute("UserID").getString().replace("@", "") + "@" + //�ջ���
	 		 				oldBizProcessTaskID + "@" +  //ǰһ������������ˮ��
	 		 				lastTaskBo.getAttribute("ProcessTaskNo").toString();
		} catch (JBOException e){
			rollbackTx();
			logger.debug("�����ջس���", e);
		}
		return withdrawProp;
	}
	
	/**
	 * �ջ���������ĺ�����:���µ�ǰ���������������
	 * @param processDefID ���̶�����
	 * @param bizProcessTaskID ҵ������������
	 * @param oldBizProcessTaskID �˻�����ҵ������������
	 * @param processObjects �������淵�ص����̶����б�
	 * @return
	 */
	public String postWithdraw(String processDefID, String bizProcessTaskID, String oldBizProcessTaskID, List<ProcessObject> processObjects) throws Exception {
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom,taskBom;
		BizObjectQuery query;
		BizObject bo,taskBo;
		try {
			
			if(processObjects == null){
				return FAILURE_MESSAGE;
			}
			
			// ����Task������״̬Ϊ�ر�
			taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
			getTx().join(taskBom);
			query = taskBom.createQuery("RelativeSerialNo=:RelativeSerialNo").setParameter("RelativeSerialNo", oldBizProcessTaskID);
			List taskBos = query.getResultList(true);
			// �Ƿ��Ƿ�֧����־λ
			Boolean forkFlag = true;
			for (int i = 0; i < taskBos.size(); i++) {
				taskBo = (BizObject) taskBos.get(i);
				//����֧��ʼ��־λ��Ϊ��
				if(taskBo.getAttribute("ForkState").toString()==null||!taskBo.getAttribute("ForkState").toString().startsWith("0")){
					forkFlag = false;
				}
				taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_CLOSE);
				taskBom.saveObject(taskBo);
			}
			 
			// ��ѯ���˻�����TASK�Ĳ���
			query = taskBom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", oldBizProcessTaskID);
			bo = query.getSingleResult(true);
			// Task��¼��������һ����¼
			taskBo = taskBom.newObject();
			taskBo.setAttributesValue(bo);
			taskBo.getAttribute("SerialNo").setNull(); // ��ˮ���������ÿգ�Ȼ������JBO����
			taskBo.getAttribute("RelativeSerialNo").setValue(bizProcessTaskID);
			//taskBo.getAttribute("ProcessTaskNo").setValue(processObjects.get(0).getTaskID());
			taskBo.getAttribute("BegInTime").setValue(StringFunction.getTodayNow());
			taskBo.getAttribute("EndTime").setNull();
			taskBo.getAttribute("PhaseOpinion").setNull();
			taskBo.getAttribute("PhaseAction").setNull();
			taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);
			taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_WITHDRAW);
			taskBom.saveObject(taskBo);
			
			// ���Task�����ˮ��
			String taskSerialNo = taskBo.getAttribute("SerialNo").toString();
			
			// ���Object�����ˮ��
			String bizProcessObjectID = taskBo.getAttribute("RelativeObjectNO").toString();
			
			// ��ѯ��ǰ�׶α��
			query = taskBom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", bizProcessTaskID);
			String phaseNo = query.getSingleResult(false).getAttribute("PhaseNo").toString();
			// Object��¼���и��¼�¼
			bom = factory.getManager(getBizProcessObjectClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("ObjectNo=:SerialNo and PhaseNo=:PhaseNo").setParameter("SerialNo", bizProcessObjectID)
										.setParameter("PhaseNo", phaseNo);
			bo = query.getSingleResult(true);
			bo.setAttributeValue("PhaseType", taskBo.getAttribute("PhaseType").toString());
			bo.setAttributeValue("PhaseNo", taskBo.getAttribute("PhaseNo").toString());
			bo.setAttributeValue("PhaseName", taskBo.getAttribute("PhaseName").toString());
			bo.setAttributeValue("ProcessTaskNo", taskBo.getAttribute("ProcessTaskNo").toString());
			bo.setAttributeValue("FlowState",BusinessProcessConst.FLOWSTATE_WITHDRAW);
			bo.getAttribute("RelativeTaskNo").setValue(taskSerialNo);
			bom.saveObject(bo);
			
			// ����Ƿ�֧�ĳ�ʼ�㣬��ɾ��Obejct���ж���ļ�¼��
			if (forkFlag == true){
				query = bom.createQuery("ObjectNo=:SerialNo and PhaseNo<>:PhaseNo").setParameter("SerialNo", bizProcessObjectID)
										.setParameter("PhaseNo", taskBo.getAttribute("PhaseNo").toString());
				List bos = query.getResultList(true);
				if (bos != null && bos.size() > 0) {
					for (int i = 0; i < bos.size(); i++) {
						bo = (BizObject)bos.get(i);
						bom.deleteObject(bo);
					}
				}
			}
			commitTx();
		} catch (JBOException e){
			rollbackTx();
			logger.debug("�����ջصĺ����������", e);
			throw new Exception("�����ջصĺ����������", e);
		}
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * ������Ա����������������ĸ���������
	 * @param processDefID ���̶�����
	 * @param bizProcessTaskID ����������
	 * @param userID �����������û����
	 * @throws Exception
	 */
	public void withdrawForVoteAssistant(String processDefID, String bizProcessTaskID, String userID) throws Exception{
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager taskBom,mTaskBom;
		//�������������
		taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
		getTx().join(taskBom);
		BizObject taskBo = taskBom.createQuery("SerialNo=:SerialNo")
							.setParameter("SerialNo", bizProcessTaskID)
							.getSingleResult(true);
		String relativeUser = taskBo.getAttribute("RelativeUser").toString();
		relativeUser = relativeUser.replace("@"+userID+"@", "@");
		taskBo.setAttributeValue("RelativeUser", relativeUser);
		taskBom.saveObject(taskBo);
		
		//���¸��������
		mTaskBom = factory.getManager(getBizProcessMultiTaskClaz(processDefID));
		getTx().join(mTaskBom);
		
        BizObject mTaskBo = mTaskBom.createQuery("RelativeTaskNo=:RelativeTaskNo and UserID=:UserID and VoteState=:VoteState")
        					.setParameter("RelativeTaskNo", bizProcessTaskID)
        					.setParameter("UserID", userID)
        					.setParameter("VoteState", "1").getSingleResult(true);
        if(mTaskBo != null){
        	mTaskBo.setAttributeValue("VoteState", BusinessProcessConst.BUSINESS_PROCESS_CLOSE);
        	mTaskBom.saveObject(mTaskBo);
        }
        
        //�²���һ����¼
        BizObject newBo =  mTaskBom.newObject();
        newBo.setAttributesValue(mTaskBo);
        newBo.getAttribute("SerialNo").setNull();
        newBo.getAttribute("BeginTime").setValue(StringFunction.getTodayNow());
        newBo.getAttribute("EndTime").setNull();
        newBo.getAttribute("VoteState").setValue("0");
        newBo.getAttribute("VoteOpinion").setNull();
        mTaskBom.saveObject(newBo);
	}
	
	/**
	 * �����˻ص�Ԥ����:��ȡ�˻ؽ׶Σ��˻ص�����
	 * @param processDefID ���̶�����
	 * @param bizProcessTaskID ҵ������������
	 * @return
	 */
	public String preTaskReturn(String processDefID, String bizProcessTaskID) throws Exception {
		String returnMessage = "";
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		try {
			//��ȡ�˻ؽ׶Σ��˻ص�����
			bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("SerialNo=:SerialNo")
			   .setParameter("SerialNo", bizProcessTaskID);
			bo = query.getSingleResult(false);
			if (bo == null) {
				logger.error("û���ҵ���Ҫ�˻ص�����");
			} else {
				returnMessage = bo.getAttribute("PhaseNo").toString() + "@"
						+ bo.getAttribute("UserID").toString().replace("@", "") + "@"
						+ bo.getAttribute("ProcessTaskNo").toString();
			}
		} catch (JBOException e){
			rollbackTx();
			logger.error("�����˻ص�Ԥ�������ʧ��"+e.getMessage(), e);
			throw new Exception("�����˻ص�Ԥ�������ʧ��"+e.getMessage(), e);
		}
		return returnMessage;
	}
	
	/**
	 * �����˻صĺ�����
	 * @param processDefID ���̶�����
	 * @param bizProcessTaskID ҵ������������
	 * @param bizAssignedTaskID ָ����һ�׶ε�����������
	 * @param processState ����״̬
	 * @param processObjects �������淵�ص����̶����б�
	 * @param userID ��ǰ�û����
	 * @return
	 */
	public String postTaskReturn(String processDefID, String bizProcessTaskID,
			String bizAssignedTaskID, String processState,
			List<ProcessObject> processObjects, String userID) {
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo,taskBo;
		try {
			if(processState==null||"".equals(processState)){
				processState = BusinessProcessConst.FLOWSTATE_RETURN;
			}
			// ��ѯ��Ҫ�˻ص�������
			bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", bizProcessTaskID);
			BizObject backBo = query.getSingleResult(false);
			
			// ��ȡ������������ţ���ѯ�����µ������TASK���
			String bizProcessObjectID = backBo.getAttribute("RelativeObjectNo").toString();
			String backForkState = backBo.getAttribute("ForkState").toString();
			
			// ��ȡ��ǰ����
			String q = "RelativeObjectNo =:RelativeObjectNo and userID = :UserID order by SerialNo desc";
			query = bom.createQuery(q).setParameter("RelativeObjectNo", bizProcessObjectID).setParameter("UserID",userID);
			bo = query.getSingleResult(true);
			String latestBizProcessTaskID = bo.getAttribute("SerialNo").toString();
	        String relativeSerialNo = bo.getAttribute("RelativeSerialNo").toString();
	        String forkState = bo.getAttribute("ForkState").toString();
	        String phaseNo = bo.getAttribute("PhaseNo").toString();
			
	        //�����˻����ɻ��֧�˻ط�֧
			if ((isNull(backForkState) && isNull(forkState))
					|| (!isNull(backForkState) && !isNull(forkState))){
				// ��������TASK��¼��״̬Ϊ�ر� 
				bo.setAttributeValue("EndTime",StringFunction.getTodayNow());
				bo.setAttributeValue("TaskState", BusinessProcessConst.BUSINESS_PROCESS_CLOSE);
				bom.saveObject(bo);
	
				// TASK��������һ����¼
				taskBo = bom.newObject();
				taskBo.setAttributesValue(backBo);
				taskBo.getAttribute("SerialNo").setNull(); // ��ˮ���������ÿգ�Ȼ������JBO����
				taskBo.getAttribute("RelativeObjectNo").setValue(bizProcessObjectID);
				taskBo.getAttribute("RelativeSerialNo").setValue(latestBizProcessTaskID);
				taskBo.getAttribute("ProcessTaskNo").setValue(backBo.getAttribute("ProcessTaskNo").toString());
				taskBo.getAttribute("BegInTime").setValue(StringFunction.getTodayNow());
				taskBo.getAttribute("EndTime").setNull();
				taskBo.getAttribute("PhaseOpinion").setNull();
				taskBo.getAttribute("PhaseAction").setNull();
				taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);
				taskBo.getAttribute("FlowState").setValue(processState);
				if(bizAssignedTaskID != null){
					taskBo.getAttribute("AssignedTaskNo").setValue(bizAssignedTaskID);
				}
				bom.saveObject(taskBo);
				String taskSerialNo = taskBo.getAttribute("SerialNo").toString();
	
				// ����OBJECT���¼
				bom = factory.getManager(getBizProcessObjectClaz(processDefID));
				getTx().join(bom);
				query = bom.createQuery("ObjectNo=:SerialNo and PhaseNo=:PhaseNo")
										.setParameter("SerialNo", bizProcessObjectID)
										.setParameter("PhaseNo", phaseNo);
				bo = query.getSingleResult(true);
				bo.setAttributeValue("PhaseType", taskBo.getAttribute("PhaseType").toString());
				bo.setAttributeValue("PhaseNo", taskBo.getAttribute("PhaseNo").toString());
				bo.setAttributeValue("PhaseName", taskBo.getAttribute("PhaseName").toString());
				bo.setAttributeValue("ProcessTaskNo", backBo.getAttribute("ProcessTaskNo").toString());
				bo.setAttributeValue("FlowState",processState);
				bo.getAttribute("RelativeTaskNo").setValue(taskSerialNo);
				bom.saveObject(bo);
				
		        //ɾ���������������¼
				BizObjectManager oldTaskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
				getTx().join(oldTaskBom);
				List deleteBos = oldTaskBom.createQuery("RelativeSerialNo=:RelativeSerialNo and TaskState = '0'")
						.setParameter("RelativeSerialNo", relativeSerialNo).getResultList(true);
				if (deleteBos != null) {
					for (int i = 0; i < deleteBos.size(); i++) {
						BizObject deleteBo = (BizObject) deleteBos.get(i);
						oldTaskBom.deleteObject(deleteBo);
					}
				}
			}
	        //��֧�˻�����
			if(!isNull(forkState) && isNull(backForkState)){
				//��ȡ��ǰ���з�֧
				query = bom.createQuery("TaskState = '0' and UserID =:UserID").setParameter("UserID", userID);
				List<BizObject> taskBos = query.getResultList(true);
				// ������������TASK��¼��״̬Ϊ�ر� 
				if(taskBos!=null){
					for(int i=0;i<taskBos.size();i++){
						taskBo = taskBos.get(i);
						taskBo.setAttributeValue("EndTime",StringFunction.getTodayNow());
						taskBo.setAttributeValue("TaskState", BusinessProcessConst.BUSINESS_PROCESS_CLOSE);
						bom.saveObject(taskBo);
					}
				}
				// TASK��������һ����¼
				taskBo = bom.newObject();
				taskBo.setAttributesValue(backBo);
				taskBo.getAttribute("SerialNo").setNull(); // ��ˮ���������ÿգ�Ȼ������JBO����
				taskBo.getAttribute("RelativeObjectNo").setValue(bizProcessObjectID);
				taskBo.getAttribute("RelativeSerialNo").setValue(latestBizProcessTaskID);
				taskBo.getAttribute("ProcessTaskNo").setValue(backBo.getAttribute("ProcessTaskNo").toString());
				taskBo.getAttribute("BegInTime").setValue(StringFunction.getTodayNow());
				taskBo.getAttribute("EndTime").setNull();
				taskBo.getAttribute("PhaseOpinion").setNull();
				taskBo.getAttribute("PhaseAction").setNull();
				taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);
				taskBo.getAttribute("FlowState").setValue(processState);
				if(bizAssignedTaskID != null){
					taskBo.getAttribute("AssignedTaskNo").setValue(bizAssignedTaskID);
				}
				bom.saveObject(taskBo);
				String taskSerialNo = taskBo.getAttribute("SerialNo").toString();
	
				// ɾ��OBJECT��������֧��¼
				bom = factory.getManager(getBizProcessObjectClaz(processDefID));
				getTx().join(bom);
				query = bom.createQuery("ObjectNo=:SerialNo and PhaseNo<>:PhaseNo")
										.setParameter("SerialNo", bizProcessObjectID)
										.setParameter("PhaseNo", phaseNo);
				List<BizObject> bos = query.getResultList(true);
				if (bos != null) {
					for (int i = 0; i < bos.size(); i++) {
						bo = bos.get(i);
						bom.deleteObject(bo);
					}
				}
				
				// ����OBJECT��ǰ��¼
				query = bom.createQuery("ObjectNo=:SerialNo and PhaseNo=:PhaseNo")
										.setParameter("SerialNo", bizProcessObjectID)
										.setParameter("PhaseNo", phaseNo);
				bo = query.getSingleResult(true);
				bo.setAttributeValue("PhaseType", taskBo.getAttribute("PhaseType").toString());
				bo.setAttributeValue("PhaseNo", taskBo.getAttribute("PhaseNo").toString());
				bo.setAttributeValue("PhaseName", taskBo.getAttribute("PhaseName").toString());
				bo.setAttributeValue("ProcessTaskNo", backBo.getAttribute("ProcessTaskNo").toString());
				bo.setAttributeValue("FlowState",processState);
				bo.getAttribute("RelativeTaskNo").setValue(taskSerialNo);
				bom.saveObject(bo);
				
		        //ɾ���������������¼
				BizObjectManager oldTaskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
				getTx().join(oldTaskBom);
				List deleteBos = oldTaskBom.createQuery("RelativeSerialNo=:RelativeSerialNo and TaskState = '0'")
						.setParameter("RelativeSerialNo", relativeSerialNo).getResultList(true);
				if (deleteBos != null) {
					for (int i = 0; i < deleteBos.size(); i++) {
						BizObject deleteBo = (BizObject) deleteBos.get(i);
						oldTaskBom.deleteObject(deleteBo);
					}
				}
			}
			commitTx();
		} catch (JBOException e) {
			rollbackTx();
			logger.debug("�����ջصĺ����������", e);
			return FAILURE_MESSAGE;
		}
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * �����˻�ǰ���жϣ��и����������ֵ�����
	 * @param processDefID ���̶�����
	 * @param bizProcessTaskID ҵ������������
	 * @return SUCCESS/FAILURE/��ǰ�������񲻴���,��˶�/���ύ���������˻�/�޸��������˻�/���׶λ��������а���,�����˻�
	 */
	public String canTakeback(String processDefID, String bizProcessTaskID){
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		try{
			bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			query = bom.createQuery("SerialNo=:SerialNo")
					   .setParameter("SerialNo", bizProcessTaskID);
			bo = query.getSingleResult(false);
			if(bo == null){
				return "��ǰ�������񲻴���,��˶�";
			} else {
				//�жϵ�ǰ�����Ƿ����ύ,���ύ�����˻�
				if(!bo.getAttribute("EndTime").isNull()){
					return "���ύ���������˻�";
				}
				//�жϵ�ǰ�����Ƿ��и�����,�и��������˻�
				String relativeSerialNo = bo.getAttribute("RelativeSerialNo").getString();
				if(relativeSerialNo == null || "".equals(relativeSerialNo)){
					return "�޸��������˻�";
				}
				//�жϱ��׶��Ƿ��������а���,�������˻�
				if(getChildTaskCount(processDefID, relativeSerialNo) > 1){
					return "���׶λ��������а���,�����˻�";
				}
			}
		} catch (JBOException e){
			logger.debug("�����˻�ǰ���жϳ���", e);
			return FAILURE_MESSAGE;
		}
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * �˻�����,�����˻��ύ�����ַ���,�������������
	 * @param processDefID ���̶�����
	 * @param bizProcessTaskID ҵ������������
	 * @return
	 */
	public String doTakeback(String processDefID, String bizProcessTaskID){
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		String takebackProp = "";
		try {
			 //���ݵ�ǰ������ˮ��ȡ�õ�ǰ������һ����Flow_Task��ˮ��
			 bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			 getTx().join(bom);
			 query = bom.createQuery("SerialNo=:SerialNo")
			 			.setParameter("SerialNo", bizProcessTaskID);
			 bo = query.getSingleResult(true);
			 String relativeObjectNo = bo.getAttribute("RelativeObjectNo").toString();
			 String curPhaseNo = bo.getAttribute("phaseNo").toString();
			 String forkState = bo.getAttribute("ForkState").toString();
			 if(!isNull(forkState)){
				 forkState = forkState.substring(1,3);
			 }
			 
			 //��ѯ��һ�������TaskState״̬������������ύ��1����Ϊ��Ҫ�˻ص����������Ϊ�ر�״̬��99���������ǰ׷�ݡ�
			 BizObject lastTaskBo = null;
			 if(isNull(forkState)){
				 query = bom.createQuery("RelativeObjectNo=:RelativeObjectNo order by serialNo desc")
				 							.setParameter("RelativeObjectNo", relativeObjectNo);
			 }else{
				 query = bom.createQuery("RelativeObjectNo=:RelativeObjectNo and (ForkState like :ForkState or ForkState is null) order by serialNo desc")
											.setParameter("RelativeObjectNo", relativeObjectNo)
											.setParameter("ForkState", "%"+forkState);
			 }
			 List<BizObject> boList = query.getResultList(false);
			 for(int i = 0;i<boList.size()-1;i++){
				 if(curPhaseNo.equals(boList.get(i).getAttribute("phaseNo").toString())){
					 if("1".equals(boList.get(i+1).getAttribute("taskState").toString())){
						 lastTaskBo = boList.get(i+1);
						 String lastForkState = lastTaskBo.getAttribute("ForkState").toString();
						 if(isNull(forkState)&& !isNull(lastForkState)){
							 String msg = "ǰһ�׶��Ƿ�֧���������˻�!";
							 return msg;
						 }
						 break;
					 }else{
						 continue;
					 }
				 }else{
					 if(i==boList.size()-2){
						 String msg = "�Ѿ��˵�������㣬�������˻�!";
						 return msg;
					 }
				 }
			 }

			 //���췵���ַ������������������@�˻ؽ׶�@�˻���@�˻�����������ˮ��
			 String userID = lastTaskBo.getAttribute("UserID").getString();//�˻���
			 if(userID!=null){userID = userID.replace("@", "");}
			 if ("".equals(userID) || "null".equalsIgnoreCase(userID) || userID == null) {
				 userID = lastTaskBo.getAttribute("GroupID").getString();//�˻���
				 userID = userID.replace("@", "");
			 }
			 takebackProp = bo.getAttribute("ProcessTaskNo").getString() + "@" + //�˻�����������
	 		 				lastTaskBo.getAttribute("PhaseNo").getString() + "@" + //�˻ؽ׶�
	 		 				userID + "@" + //�˻���
	 		 				lastTaskBo.getAttribute("SerialNo").getString()+ "@" + //ǰһ������������ˮ��
			 				lastTaskBo.getAttribute("ProcessTaskNo").toString(); //ǰһ������������
		} catch (JBOException e){
			rollbackTx();
			logger.debug("�����˻س���", e);
		}
		
		return takebackProp;
	}
	

	/**
	 * �˻صĺ������
	 * @param processDefID ���̶�����
	 * @param bizProcessTaskID ҵ������������
	 * @param oldBizProcessTaskID �˻�����ҵ������������
	 * @param processState ����״̬
	 * @param processObjects �������淵�ص����̶����б�
	 * @param userID ��ǰ�û����
	 * @return
	 */
	public String postTakeback(String processDefID, String bizProcessTaskID, String oldBizProcessTaskID, String processState, List<ProcessObject> processObjects, String userID) throws Exception {
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom,taskBom,mTaskBom;
		BizObjectQuery query;
		BizObject bo;
		try {
			
			if(isNull(processState)){
				processState = BusinessProcessConst.FLOWSTATE_RETURN;
			}
			
			if(processObjects == null){
				return FAILURE_MESSAGE;
			}
			
			// ��ѯ����ǰ����TASK�Ĳ���
			bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			query = bom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", bizProcessTaskID);
			BizObject curTaskBo = query.getSingleResult(true);
			String curForkState = curTaskBo.getAttribute("ForkState").toString();
			String curPhaseNo = curTaskBo.getAttribute("PhaseNo").toString();
			
			// ��ѯ���˻�����TASK�Ĳ���
			query = bom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", oldBizProcessTaskID);
			BizObject oldTaskBo = query.getSingleResult(true);
			
			// ���Object�����ˮ��
			String bizProcessObjectID = oldTaskBo.getAttribute("RelativeObjectNO").toString();
			// ��õ�ǰ��¼��relativeSerialNo
			String relativeSerialNo = oldTaskBo.getAttribute("SerialNo").toString();
			String lastForkState = oldTaskBo.getAttribute("ForkState").toString();
			
			//��֧�˻ص�����
			if (!isNull(curForkState) && isNull(lastForkState)) {
				//ɾ��������������ļ�¼
				taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
				getTx().join(taskBom);
				query = taskBom.createQuery("TaskState='0' and RelativeObjectNo=:RObejctNo and userID <> :UserID")
						.setParameter("RObejctNo",bizProcessObjectID)
						.setParameter("UserID", userID);
				List bos = query.getResultList(true);
				if (bos.size() != 0) {
					for(int i = 0 ; i< bos.size() ; i++ ){
						bo = (BizObject) bos.get(i);
						taskBom.deleteObject(bo);
					}
				}
				
				// ����Task������״̬Ϊ�ر�
				curTaskBo.getAttribute("EndTime").setValue(StringFunction.getTodayNow());
				curTaskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_CLOSE);
				bom.saveObject(curTaskBo);
				
				// Task��¼��������һ����¼
				getTx().join(bom);
				BizObject taskBo = bom.newObject();
				taskBo.setAttributesValue(oldTaskBo);
				taskBo.getAttribute("SerialNo").setNull(); // ��ˮ���������ÿգ�Ȼ������JBO����
				taskBo.getAttribute("RelativeObjectNo").setValue(bizProcessObjectID);
				taskBo.getAttribute("RelativeSerialNo").setValue(bizProcessTaskID);
				taskBo.getAttribute("ProcessTaskNo").setValue(oldTaskBo.getAttribute("ProcessTaskNo").toString());
				taskBo.getAttribute("BegInTime").setValue(StringFunction.getTodayNow());
				taskBo.getAttribute("EndTime").setNull();
				taskBo.getAttribute("PhaseOpinion").setNull();
				taskBo.getAttribute("PhaseAction").setNull();
				if("1".equals(processObjects.get(0).getIsPool())){
					taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_TASKPOOL);
				}else{
					taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);
				}
				taskBo.getAttribute("FlowState").setValue(processState);
				bom.saveObject(taskBo);
				String taskSerialNo = taskBo.getAttribute("SerialNo").toString();
				
				// Object��¼����ɾ����¼
				bom = factory.getManager(getBizProcessObjectClaz(processDefID));
				getTx().join(bom);
				query = bom.createQuery("ObjectNo=:SerialNo and PhaseNo<>:PhaseNo")
										.setParameter("SerialNo", bizProcessObjectID)
										.setParameter("PhaseNo", curPhaseNo);
				List<BizObject> bolist = query.getResultList(true);
				if (bolist.size() != 0) {
					for(int i = 0 ; i< bolist.size() ; i++ ){
						bo = (BizObject) bolist.get(i);
						bom.deleteObject(bo);
					}
				}
				
				// Object��¼���и��¼�¼
				query = bom.createQuery("ObjectNo=:SerialNo and PhaseNo=:PhaseNo")
										.setParameter("SerialNo", bizProcessObjectID)
										.setParameter("PhaseNo", curPhaseNo);
				bo = query.getSingleResult(true);
				bo.setAttributeValue("PhaseType", taskBo.getAttribute("PhaseType").toString());
				bo.setAttributeValue("PhaseNo", taskBo.getAttribute("PhaseNo").toString());
				bo.setAttributeValue("PhaseName", taskBo.getAttribute("PhaseName").toString());
				bo.setAttributeValue("ProcessTaskNo", oldTaskBo.getAttribute("ProcessTaskNo").toString());
				bo.setAttributeValue("FlowState",processState);
				bo.getAttribute("RelativeTaskNo").setValue(taskSerialNo);
				bom.saveObject(bo);
				
				//��ԭ����MultiTask������ݹ����������ɵ�Task��
				if(bo.getAttribute("PhaseNo").toString().startsWith("CounterSign")){
					mTaskBom = factory.getManager(getBizProcessMultiTaskClaz(processDefID));
					query = mTaskBom.createQuery("RelativeTaskNo=:RelativeTaskNo")
							.setParameter("RelativeTaskNo", oldBizProcessTaskID);
					List<BizObject> boList = query.getResultList(true);
					for (int i = 0; i < boList.size(); i++) {
						BizObject mTaskBo = boList.get(i);
						mTaskBo.setAttributeValue("RelativeTaskNo", taskSerialNo);
						mTaskBom.saveObject(mTaskBo);
					}
				}
			}
			//�����˻ص����ɻ��߷�֧�˻ص���֧
			else{
			
				// ����Task������״̬Ϊ�ر�
				curTaskBo.getAttribute("EndTime").setValue(StringFunction.getTodayNow());
				curTaskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_CLOSE);
				bom.saveObject(curTaskBo);

				// Task��¼��������һ����¼
				getTx().join(bom);
				BizObject taskBo = bom.newObject();
				taskBo.setAttributesValue(oldTaskBo);
				taskBo.getAttribute("SerialNo").setNull(); // ��ˮ���������ÿգ�Ȼ������JBO����
				taskBo.getAttribute("RelativeObjectNo").setValue(bizProcessObjectID);
				taskBo.getAttribute("RelativeSerialNo").setValue(bizProcessTaskID);
				taskBo.getAttribute("ProcessTaskNo").setValue(oldTaskBo.getAttribute("ProcessTaskNo").toString());
				taskBo.getAttribute("BegInTime").setValue(StringFunction.getTodayNow());
				taskBo.getAttribute("EndTime").setNull();
				taskBo.getAttribute("PhaseOpinion").setNull();
				taskBo.getAttribute("PhaseAction").setNull();
				if("1".equals(processObjects.get(0).getIsPool())){
					taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_TASKPOOL);
				}else{
					taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);
				}
				taskBo.getAttribute("FlowState").setValue(processState);
				bom.saveObject(taskBo);
				String taskSerialNo = taskBo.getAttribute("SerialNo").toString();
				
				// Object��¼���и��¼�¼
				bom = factory.getManager(getBizProcessObjectClaz(processDefID));
				getTx().join(bom);
				query = bom.createQuery("ObjectNo=:SerialNo and PhaseNo=:PhaseNo")
										.setParameter("SerialNo", bizProcessObjectID)
										.setParameter("PhaseNo", curPhaseNo);
				bo = query.getSingleResult(true);
				bo.setAttributeValue("PhaseType", taskBo.getAttribute("PhaseType").toString());
				bo.setAttributeValue("PhaseNo", taskBo.getAttribute("PhaseNo").toString());
				bo.setAttributeValue("PhaseName", taskBo.getAttribute("PhaseName").toString());
				bo.setAttributeValue("ProcessTaskNo", oldTaskBo.getAttribute("ProcessTaskNo").toString());
				bo.setAttributeValue("FlowState",processState);
				bo.getAttribute("RelativeTaskNo").setValue(taskSerialNo);
				bom.saveObject(bo);
				
				//��ԭ����MultiTask������ݹ����������ɵ�Task��
				if(bo.getAttribute("PhaseNo").toString().startsWith("CounterSign")){
					mTaskBom = factory.getManager(getBizProcessMultiTaskClaz(processDefID));
					query = mTaskBom.createQuery("RelativeTaskNo=:RelativeTaskNo")
							.setParameter("RelativeTaskNo", oldBizProcessTaskID);
					List<BizObject> boList = query.getResultList(true);
					for (int i = 0; i < boList.size(); i++) {
						BizObject mTaskBo = boList.get(i);
						mTaskBo.setAttributeValue("RelativeTaskNo", taskSerialNo);
						mTaskBom.saveObject(mTaskBo);
					}
				}
				
				//ɾ��������������ļ�¼
				taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
				getTx().join(taskBom);
				query = taskBom.createQuery("relativeSerialNo=:RelativeSerialNo and userID <> :UserID and PhaseNo=:PhaseNo")
						.setParameter("RelativeSerialNo", relativeSerialNo)
						.setParameter("UserID", userID)
						.setParameter("PhaseNo", curPhaseNo);
				List bos = query.getResultList(true);
				if (bos.size() != 0) {
					for(int i = 0 ; i< bos.size() ; i++ ){
						bo = (BizObject) bos.get(i);
						taskBom.deleteObject(bo);
					}
				}
			}
			commitTx();
		} catch (JBOException e){
			rollbackTx();
			logger.debug("�˻صĺ����������" + e.getMessage(), e);
			throw new Exception("�˻صĺ����������" + e.getMessage(), e);
		}
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * ��ȡ������ʷ������.(phaseNo���ظ�,����������ؽ׶�)
	 * <li>processDefID:���̶�����
	 * <li>bizProcessObjectID:ҵ�����̶�����
	 * <li>bizProcessTaskID:ҵ������������
	 * @return List<HistoryTaskObject> 
	 * @throws JBOException 
	 */
	public List<HistoryTaskObject> getProcessHistory(String processDefID, String bizProcessObjectID, String bizProcessTaskID) throws JBOException{
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom,taskBom;
		BizObjectQuery query;
		BizObject bo;
		List<HistoryTaskObject> historyTaskObjects = new ArrayList<HistoryTaskObject>();
		taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
		getTx().join(taskBom);
		if(bizProcessTaskID == null ||"null".equalsIgnoreCase(bizProcessTaskID)){
			query = taskBom.createQuery("O.RelativeObjectNo=:RelativeObjectNo and TaskState = '0' Order by O.SerialNo").setParameter("RelativeObjectNo", bizProcessObjectID);
		}else{
			query = taskBom.createQuery("O.SerialNo=:SerialNo").setParameter("SerialNo", bizProcessTaskID);
		}
		BizObject taskBo = query.getSingleResult(false);
		String taskNo = taskBo.getAttribute("ProcessTaskNo").toString();
		String forkState = taskBo.getAttribute("ForkState").toString();
		BusinessProcessAction BpAction = new BusinessProcessAction();
		BpAction.setProcessTaskID(taskNo);
		BpAction.setProcessDefID(processDefID);
		BpAction.setProperty("ISSPTASK");

		bom = factory.getManager(getBizProcessTaskClaz(processDefID));
		getTx().join(bom);
		if(isNull(forkState)){
			query = bom.createQuery("O.RelativeObjectNo=:RelativeObjectNo and TaskState <> '99' and ForkState is null Order by O.SerialNo")
										.setParameter("RelativeObjectNo", bizProcessObjectID);
		}else{
			query = bom.createQuery("O.RelativeObjectNo=:RelativeObjectNo and TaskState <> '99' and (ForkState like :ForkState or ForkState is null)Order by O.SerialNo")
										.setParameter("RelativeObjectNo", bizProcessObjectID)
										.setParameter("ForkState", "%"+forkState.substring(1,3));
		}
		List<BizObject> bos = query.getResultList(false);
		String curPhaseNo = bos.get(bos.size()-1).getAttribute("PhaseNo").toString();
		String allPhaseNo = "";
		for (int i = 0; i < bos.size(); i++) {
			bo = bos.get(i);
			BpAction.setPhaseNo(bo.getAttribute("PhaseNo").toString());
			String flag = BpAction.getPhaseProperty();
			if(allPhaseNo.contains(bo.getAttribute("PhaseNo").toString()) || "1".equals(flag)){
				continue;
			}else{
				if (i > 0 && bo.getAttribute("PhaseNo").toString().equals(curPhaseNo)){
					break;
				}else{
					String userID = bo.getAttribute("UserID").toString();
					if (("".equals(userID) || userID == null || "null".equalsIgnoreCase(userID)) && bo.getAttribute("GroupID")!=null) {
						historyTaskObjects.clear();
					} else {
						HistoryTaskObject hto = new HistoryTaskObject();
						hto.setBizProcessTaskID(bo.getAttribute("SerialNo").toString());
						hto.setPhaseAction(bo.getAttribute("PhaseNo").toString());
						hto.setUseID(bo.getAttribute("UserID").toString().replace("@", ""));
						historyTaskObjects.add(hto);
						allPhaseNo = allPhaseNo + bo.getAttribute("PhaseNo").toString() + ",";
					}
				}
			}
		}
		return historyTaskObjects;
	}
	
	/**
	 * ��ȡ������ʷ������.(���ͻ��������һ��)
	 * <li>processDefID:���̶�����
	 * <li>bizProcessObjectID:ҵ�����̶�����
	 * @return List<HistoryTaskObject> 
	 * @throws JBOException 
	 */
	public List<HistoryTaskObject> getPartProcessHistory(String processDefID, String bizProcessObjectID) throws JBOException{
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom,taskBom;
		BizObjectQuery query;
		BizObject bo;
		List<HistoryTaskObject> historyTaskObjects = new ArrayList<HistoryTaskObject>();
		//��ѯ������׶ε�������Ϣ
		taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
		getTx().join(taskBom);
		query = taskBom.createQuery("O.RelativeObjectNo=:RelativeObjectNo Order by O.SerialNo asc").setParameter("RelativeObjectNo", bizProcessObjectID);
		bo = query.getSingleResult(false);
		
		String phaseNo = bo.getAttribute("PhaseNo").toString();
			
		HistoryTaskObject hto = new HistoryTaskObject();
		hto.setBizProcessTaskID(bo.getAttribute("SerialNo").toString());
		hto.setPhaseAction(bo.getAttribute("PhaseNo").toString());
		hto.setUseID(bo.getAttribute("UserID").toString().replace("@", ""));
		historyTaskObjects.add(hto);
		
		//��ѯ����һ����������Ϣ
		bom = factory.getManager(getBizProcessObjectClaz(processDefID));
		getTx().join(bom);
		query = bom.createQuery("ObjectNo=:SerialNo").setParameter("SerialNo", bizProcessObjectID);
		bo = query.getSingleResult(false);
		String taskSerialNo = bo.getAttribute("RelativeTaskNo").toString();
		
		query = taskBom.createQuery("O.SerialNo=:SerialNo").setParameter("SerialNo", taskSerialNo);
		bo = query.getSingleResult(false);
		String relativeSerialNo = bo.getAttribute("RelativeSerialNo").toString();
		
		query = taskBom.createQuery("O.SerialNo=:SerialNo").setParameter("SerialNo", relativeSerialNo);
		bo = query.getSingleResult(false);
		
		if(!phaseNo.equals(bo.getAttribute("PhaseNo").toString())){
			hto = new HistoryTaskObject();
			hto.setBizProcessTaskID(bo.getAttribute("SerialNo").toString());
			hto.setPhaseAction(bo.getAttribute("PhaseNo").toString());
			hto.setUseID(bo.getAttribute("UserID").toString().replace("@", ""));
			historyTaskObjects.add(hto);
		}
		return historyTaskObjects;
	}
	
	/**
	 * ȡ���������
	 * @param processDefID ���̶�����
	 * @param bizProcessTaskID ��ǰ������
	 * @return
	 */
	public int getChildTaskCount(String processDefID, String bizProcessTaskID) throws JBOException {
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		int count = 0;
		bom = factory.getManager(getBizProcessTaskClaz(processDefID));
		query = bom.createQuery("RelativeSerialNo=:RelativeSerialNo")
				   .setParameter("RelativeSerialNo", bizProcessTaskID);
		List results = query.getResultList(false);
		if(results != null){
			count = results.size();
		}
		return count;
	}
	
	/**
	 * ת�츨������
	 * @param processDefID ���̶�����
	 * @param bizProcessTaskID ҵ������������
	 * @param userID ��Ҫ���������û�
	 * @return �ɹ������������������Ϣ��ʧ�ܷ��� ""
	 */
	public String changeUserAssistant(String processDefID, String bizProcessTaskID, String userID) throws Exception {
		String returnMessage = "";
		String oldUserID = "";
		String relativeUser = "";
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		try {
			//����ת���û�
			bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("SerialNo =:SerialNo").setParameter("SerialNo", bizProcessTaskID);
			bo = query.getSingleResult(true);
			if (bo != null) {
				oldUserID = bo.getAttribute("UserID").toString();
				relativeUser = bo.getAttribute("RelativeUser").toString();
			}
			PSUserObject curUser = PSUserObject.getUser(oldUserID.replace("@", "")); //�û�����
			if (relativeUser == null || "".equals(relativeUser)) {
				bo.setAttributeValue("RelativeUser", oldUserID);
				bo.setAttributeValue("UserID", curUser.getUserID());
				bo.setAttributeValue("UserName", curUser.getUserName());
				bo.setAttributeValue("OrgID", curUser.getOrgID());
				bo.setAttributeValue("OrgName", curUser.getOrgName());
			} else {
				bo.setAttributeValue("UserID", curUser.getUserID());
				bo.setAttributeValue("UserName", curUser.getUserName());
				bo.setAttributeValue("OrgID", curUser.getOrgID());
				bo.setAttributeValue("OrgName", curUser.getOrgName());
			}
			bom.saveObject(bo);
			commitTx();
		} catch (JBOException e){
			rollbackTx();
			logger.debug("����ת�츨������ʧ��"+e.getMessage(), e);
			throw new Exception("����ת�츨������ʧ��"+e.getMessage(), e);
		}
		return returnMessage;
	}
	
	private String initRelativeData(RelativeBusinessObject businessObject, String relativeData) throws Exception {
		StringBuffer newRelativeData = new StringBuffer();
		String objectNo = "";
		String applyType = "";
		if(businessObject != null){
			objectNo = (businessObject.getObjectNo() == null) ? "" : businessObject.getObjectNo();
			applyType = (businessObject.getApplyType() == null) ? "" : businessObject.getApplyType();
		}
		
		String bizObject = "\"S_BizObject\":{\"ObjectNo\":\"" + objectNo + "\",\"ApplyType\":\"" + applyType + "\"}";
		
		//����relativeDataΪJSON��ʽ:{},�������ϸ���
		if(relativeData == null || "".equals(relativeData)){//relativeDataΪ��
			newRelativeData.append("{" + bizObject + "}");
		} else if(relativeData.startsWith("{") && relativeData.endsWith("}")){//relativeData��"{"��ͷ����"}"��β
			newRelativeData.append(relativeData).insert(1, bizObject+",");
		} else {
			newRelativeData.append("{").append(bizObject).append(",").append(relativeData).append("}");
			logger.error(this.getClass().getName()+".initRelativeData: RelativeData format error." + relativeData);
			throw new Exception("RelativeData format error." + relativeData);
		}
		
		return newRelativeData.toString();
	}
	
	private Boolean isNull(String str) {
		if (str == null || "null".equalsIgnoreCase(str) || "".equals(str.trim())) {
			return true;
		} else {
			return false;
		}
	}
	

	
}
