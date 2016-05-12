package com.amarsoft.app.als.process;

import java.awt.image.BufferedImage;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.process.data.ProcessObject;
import com.amarsoft.app.als.process.data.TaskListCatalog;

/**
 * ���̷����ͳһ���Ƚӿڣ����������ṩ�ı�׼�����ڸýӿ��ж���
 * @author zszhang
 *
 */
public interface ProcessService extends Context, ExtendProcessService {
	
	/**
	 * ��������ʵ��
	 * @param processDefID ���̶�����
	 * @param userID ���̷�����/ProcessInst Owner/The first activity participant
	 * @param objects �����������(������ת��������Ҫ��ҵ������)
	 * @return List<ProcessObject> 
	 */
	public List<ProcessObject> startProcessInst(String processDefID, String userID, String objects) throws Exception ;
	
	/**
	 * ɾ������ʵ��
	 * @param processInstID ����ʵ�����
	 * @return processInstID or Success/Failure or other String
	 */
	public String deleteProcessInst(String processInstID) throws Exception ;
	
	/**
	 * ȡ�����������ύʱ�Ķ����б�,�������˻���һ�׶�\�ջ�\�˻�ǰһ������
	 * @param processDefID ���̶�����
	 * @param taskID ������
	 * @param userID �û����
	 * @return Map<actionName:String,action:String>
	 */
	public Map<String,String> getTaskActions(String processDefID, String taskID, String userID) throws Exception ;
	
	/**
	 * ȡ�����������ύʱ�ķ�֧�����б�
	 * @param processDefID ���̶�����
	 * @param taskID ������
	 * @param  ActivityNo ����
	 * @return Map<actionName:String,action:String>
	 */
	public Map<String,String> getForkActions(String processDefID, String taskID, String ActivityNo) throws Exception ;

	
	/**
	 * ȡ��������һ���ѡ�Ĳ������б�
	 * @param processDefID ���̶�����
	 * @param nextAction ��һ�
	 * @param taskID ������
	 * @param curUserID ��ǰ�û����
	 * @return
	 */
	public String[] getNextOptionalUsers(String processDefID, String nextAction, String taskID, String curUserID) throws Exception ;

	/**
	 * ȡ�����̵�ǰ���ѡ�Ĳ������б�
	 * @param processDefID ���̶�����
	 * @param nextAction ��ǰ����
	 * @param taskID ������
	 * @param curUserID ��ǰ�û����
	 * @return
	 */
	public String[] getCurOptionalUsers(String processDefID, String nextAction, String taskID, String curUserID) throws Exception ;

	/**
	 * ȡ��������
	 * @param processInstID ����ʵ�����
	 * @param processDefID ���̶�����
	 * @param activityID �������
	 * @param userID ���������
	 * @return
	 */
	public String getUnfinishedTaskNo(String processInstID, String processDefID, String activityID, String userID) throws Exception ;
		
	/**
	 * ����ǰ����ʵ�������ύ
	 * @param processDefID ���̶�����
	 * @param processInstID ����ʵ�����
	 * @param taskID ��ǰ������
	 * @param nextAction �ύ����
	 * @param nextOpinion �ύ��� 
	 * @param objects �����������(������ת��������Ҫ��ҵ������)
	 * @return List<ProcessObject>
	 */
	public List<ProcessObject> commitProcessInst(String processDefID, String processInstID, String taskID, String nextAction, String nextOpinion, String objects) throws Exception ;
	
	/**
	 * �ύ������Ա���
	 * @param processDefID ���̶�����
	 * @param processInstID ����ʵ�����
	 * @param taskID ������
	 * @param userID �û����
	 * @param voteOpinion ͶƱ���
	 * @param nextOpinion �ύ��� 
	 * @param objects �����������(������ת��������Ҫ��ҵ������)
	 * @return ProcessObject
	 * @throws Exception 
	 */
	public ProcessObject commitVote(String processDefID, String processInstID, String taskID, String userID, String voteOpinion ,String nextOpinion, String objects) throws Exception;
	
	/**
	 * ȡ����һ�����
	 * @param processDefID ���̶�����
	 * @param processInstID ����ʵ�����
	 * @param taskID ��ǰ������
	 * @param nextAction �ύ����
	 * @param nextOpinion �ύ���
	 * @return
	 */
	public String getNextActivityName(String processDefID, String processInstID, String taskID, String nextAction, String nextOpinion) throws Exception ;

	/**
	 * ȡ����һ�����
	 * @param processDefID ���̶�����
	 * @param processInstID ����ʵ�����
	 * @param taskID ��ǰ������
	 * @param nextAction �ύ����
	 * @return
	 */
	public String getNextState(String processDefID, String processInstID, String taskID, String nextAction) throws Exception ;
	
	/**
	 * ȡ���û������б�����,����������ͼչʾ
	 * @param userID �û����
	 * @param processDefID ���̶�����
	 * @return List<TaskListCatalog>
	 */
	public List<TaskListCatalog> getUserTaskListCatalog(String userID, String processDefID);
	
	/**
	 * ȡ���û���������ʵ���б�
	 * @param processDefID ���̶�����
	 * @param activityID �������
	 * @param milestone ��̱����׶����ͣ�
	 * @param userID �û����
	 * @return ����ʵ������
	 */
	public String[] getUserProcessInstList(String processDefID, String activityID, String milestone, String userID);
	
	/**
	 * �ջ�����
	 * @param processDefID ���̶�����
	 * @param processInstID ����ʵ�����
	 * @param currentTaskID ��ǰ������
	 * @param arriveTaskID Ŀ��������
	 * @param nextAction �ύ����
	 * @param nextOpinion �ύ���
	 * @param objects �����������(������ת��������Ҫ��ҵ������)
	 * @param userID �û����
	 * @return List<ProcessObject>
	 */
	public List<ProcessObject> withdrawProcessInst(String processDefID, String processInstID, String currentTaskID, String arriveTaskID,
										String nextAction, String nextOpinion, String objects, String userID) throws Exception;
	
	/**
	 * 
	 * �˻�����
	 * @param processDefID ���̶�����
	 * @param processInstID ����ʵ�����
	 * @param currentTaskID ��ǰ������
	 * @param arriveTaskID Ŀ��������
	 * @param nextAction �ύ����
	 * @param nextOpinion �ύ���
	 * @param objects �����������(������ת��������Ҫ��ҵ������)
	 * @param userID �û����
	 * @return List<ProcessObject>
	 */
	public List<ProcessObject> returnProcessInst(String processDefID, String processInstID, String currentTaskID, String arriveTaskID,
										String nextAction, String nextOpinion, String objects, String userID) throws Exception;

	/**
	 * ȡ�����̶�����ĳ�������
	 * @param processDefID ���̶�����
	 * @param taskID ������,���������ֲ�ͬ�����̷����汾
	 * @param activityID �������
	 * @param property ���Ա��
	 * @return String ����ֵ
	 */
	public String getActivityProperty(String processDefID, String taskID, String activityID, String property);
	
	/**
	 * ��ȡ����ͼ
	 * @param processDefID ���̶�����
	 * @param taskID ����������
	 * @return BufferedImage
	 * @throws Exception
	 */
	public BufferedImage getFlowGraph(String processDefID, String taskID) throws Exception;
	
	/**
	 * ���Ӵ�����Ա
	 * @param processDefID ���̶�����
	 * @param taskID ����������
	 * @param users �����ӵĳ�Ա�б� user1,user2,user3
	 * @return
	 * @throws Exception 
	 */
	public String addVote(String processDefID, String taskID, String users) throws Exception;
	
	/**
	 * �Ƴ�������Ա
	 * @param processDefID ���̶�����
	 * @param taskID ����������
	 * @param users ���Ƴ��ĳ�Ա�б� user1,user2,user3
	 * @return
	 * @throws Exception 
	 */
	public String removeVote(String processDefID, String taskID, String users) throws Exception;
	
	/**
	 * ȡ������ָ������������
	 * @param processDefID ���̶�����
	 * @param taskID ������
	 * @return String ��ѯ���
	 */
	public String getTask(String processDefID,String taskID);
	
	
	/**
	 * ��������л�ȡ����
	 * @param processDefID ���̶�����
	 * @param taskID ������
	 * @param userID �û����
	 * @return
	 * @throws Exception
	 */
	public String takeTaskFromPool(String processDefID, String taskID, String userID) throws Exception;
	
	/**
	 * �������̶���
	 * @param taskID ����������
	 * @param ObjectName �����ţ�eg:UserInfo.UserID
	 * @param ObjectValue ����ֵ
	 * @return String
	 * @throws Exception
	 */
	public String setProcessObject(String taskID, String ObjectName, String ObjectValue) throws Exception;
	
	/**
	 * ȡ��������һ�׶ν�ɫ
	 * @param processDefID ���̶�����
	 * @param nextAction ��һ�
	 * @param taskID ������
	 * @param curUserID ��ǰ�û����
	 * @return
	 */
	public String getNextOptionalRole(String processDefID, String nextAction, String taskID) throws Exception;
	
	/**
	 * ȡ�����̽ڵ����һ���ڵ�
	 * @param processDefID ���̶�����
	 * @param taskID ������
	 * @param activityID ָ���ڵ��ţ�Ϊ��Ϊ��ǰ����ڵ�
	 * @return String 
	 */
	public String getPreActivity(String processDefID, String taskID, String activityID) throws Exception;
	
	/**
	 * �������̶���ȡ�û���꣬������������ͼ
	 * @param processDefID ���̶�����
	 * @param taskID ������
	 * @return String[] ����ֵ����
	 * @throws Exception
	 */
	public String[] getCoordinatesByDef(String processDefID, String taskID) throws Exception;
	
	/**
	 * ��ȡ����ͼ
	 * @param processDefID ���̶�����
	 * @param taskID ������
	 * @return String
	 * @throws Exception
	 */
	public String getFlowImage(String processDefID, String taskID) throws Exception;
	
	/**
	 * �����������񣺽���ǰ��������ͬ����ָ������״̬
	 * @param processDefID ���̶�����
	 * @param taskID ����������
	 * @return
	 * @throws Exception
	 */
	public String restoreTask(String processDefID, String taskID) throws Exception;
	
	/**
	 * ���̽�����ָ�������ǰ�Ľ׶�
	 * @param processDefID ���̶�����
	 * @param processInstID ����ʵ�����
	 * @return
	 * @throws Exception
	 */
	public String restoreInstance(String processDefID, String processInstID) throws Exception;

}
