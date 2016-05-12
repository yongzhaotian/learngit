package com.amarsoft.app.als.flow.cfg;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import com.amarsoft.app.als.flow.cfg.model.Activity;
import com.amarsoft.app.als.flow.cfg.model.BusinessProcess;
import com.amarsoft.app.als.flow.cfg.model.BusinessProcessConst;
import com.amarsoft.app.als.flow.cfg.model.Transition;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.log.Log;

public class DefaultWFLoader implements WFLoader {

	private JBOFactory factory = JBOFactory.getFactory();
	private BizObjectManager bom;
	private BizObjectQuery query;
	
	private Log logger = ARE.getLog();
	
	public BusinessProcess loadWorkFlow(String flowNo) throws JBOException {
		BusinessProcess bp = null;
		BizObject flowCatalogBo = loadWorkFlowCatalog(flowNo);//�������̶�����Ϣ
		if(flowCatalogBo == null || flowCatalogBo.getAttribute("FlowName").isNull()){
			logger.debug("�������̺�[" + flowNo + "]�Ҳ�����������̶�����Ϣ��");
			return null;
		}
		bp = new BusinessProcess(flowNo, flowCatalogBo.getAttribute("FlowName").getString());
		List activities = loadActivities(flowNo);//��������̵����нڵ�
		bp.setActivities(activities);
		List transitions = loadTransitions(activities);//����ת����Ϣ
		bp.setTransitions(transitions);
		
		resetActivities(activities); //���ýڵ��������Ϣ
		
		persistActivities(activities); //���ڵ��ͼ����Ϣд�����ݿ�
		
		return bp;
	}
	
	/**
	 * ��ȡ��ǰ���������̿��еĶ���
	 * @param flowNo ���̱��
	 * @return true/false
	 * @throws JBOException
	 */
	private BizObject loadWorkFlowCatalog(String flowNo) throws JBOException {
		String boClass = "jbo.sys.FLOW_CATALOG";
		String sql = "FlowNo=:FlowNo";
		bom = factory.getManager(boClass);
		query = bom.createQuery(sql).setParameter("FlowNo", flowNo);
		BizObject flowCatalogBo = query.getSingleResult(false);
		return flowCatalogBo;
	}
	
	/**
	 * ��FLOW_MODEL�е����̽׶�ת��ΪActivity
	 * @param flowNo
	 * @return
	 * @throws JBOException
	 */
	private List loadActivities(String flowNo) throws JBOException {
		List activities = new ArrayList();
		String boClass = "jbo.sys.FLOW_MODEL";
		String sql = "FlowNo=:FlowNo order by PhaseNo";
		bom = factory.getManager(boClass);
		query = bom.createQuery(sql).setParameter("FlowNo", flowNo);
		List workFlowModels = query.getResultList(false);
		
		if(workFlowModels == null || workFlowModels.size() == 0){
			return null;
		}
		
		for(int i = 0; i < workFlowModels.size(); i++){
			BizObject bo = (BizObject)workFlowModels.get(i);
			Activity activity = new Activity();
			activity.setId(String.valueOf(i + 1));  //���
			String phaseNo = bo.getAttribute("PhaseNo").getString();
			if("0010".equals(phaseNo)){//��ʼ�ڵ�
				activity.setType(BusinessProcessConst.ACTIVITY_TYPE_START_NODE);
			} else if ("3000".equals(phaseNo)){//�˻ز�������Ϊ��۽ڵ�
				activity.setType(BusinessProcessConst.ACTIVITY_TYPE_JOIN_NODE);
			} else if("1000".equals(phaseNo) || "8000".equals(phaseNo)){//��׼�����ڵ�Ϊ�����ڵ�
				activity.setType(BusinessProcessConst.ACTIVITY_TYPE_END_NODE);
			} else{
				//Ĭ�������ڵ��������ʱΪ����ڵ�
				activity.setType(BusinessProcessConst.ACTIVITY_TYPE_NODE);
			}
			
			if(bo.getAttribute("Name").isNull()){
				activity.setName(bo.getAttribute("PhaseName").getString());
			} else {
				activity.setName(bo.getAttribute("Name").getString());
			}
			activity.setBelongProcess(bo.getAttribute("FlowNo").getString());
			activity.setPhaseNo(bo.getAttribute("PhaseNo").getString());
			activity.setPhaseName(bo.getAttribute("PhaseName").getString());
			activity.setPhaseType(bo.getAttribute("PhaseType").getString());
			activity.setInitScript(bo.getAttribute("InitScript").getString());
			activity.setChoiceScript(bo.getAttribute("ChoiceScript").getString());
			activity.setActionScript(bo.getAttribute("ActionScript").getString());
			activity.setPostScript(bo.getAttribute("PostScript").getString());
			activity.setEditStatus(bo.getAttribute("Attribute7").getString());
			activity.setIsInuse(bo.getAttribute("Attribute8").getString());
			activity.setRealPostScript(bo.getAttribute("Attribute10").getString());
			activity.setxCoordinate(bo.getAttribute("XCOORDINATE").getString());
			activity.setyCoordinate(bo.getAttribute("YCOORDINATE").getString());
			activity.setWidth(bo.getAttribute("Width").getString());
			activity.setHeight(bo.getAttribute("Height").getString());
			
			//��Ĭ��ֵ
			if(activity.getIsInuse() == null) activity.setIsInuse("1");
			if(activity.getEditStatus() == null) activity.setEditStatus("00");
			activities.add(activity);
		}
		return activities;
	}
	
	/**
	 * ����Activity����ת�ƣ����ߣ�
	 * @param activities
	 * @return
	 */
	private List loadTransitions(List activities){
		List transitions = new ArrayList();
		if(activities != null && activities.size() > 0){
			int len = activities.size();
			for(int i = 0; i < activities.size(); i++){
				Activity activity = (Activity)activities.get(i);
				if(activity.getIsInuse().equals("0")) continue;//����ڵ㱻���Σ���Ϊ����������
				String postScript = activity.getPostScript();
				if(postScript == null) continue;
				String[] phaseNos = postScript.split("'");
				String tranPhaseNames = "";
				int count = 0; //��¼��֧��Ŀ
				for(int j = 0; j < phaseNos.length; j++){
					String phaseNo = phaseNos[j];
					Activity tmpActivity = new Activity(phaseNo); //Activity��PhaseNo��ʶ
					// �ж��Ƿ�Ϊ4���ַ������̽׶κţ������������̽׶��д��ڣ�������ת��
					if (Pattern.matches("\\d{4}", phaseNo) && activities.contains(tmpActivity)) {
						Activity desActivity = (Activity)activities.get(activities.indexOf(tmpActivity));
						Activity realDesActivity = findRealDesActivity(activities, desActivity);
						tranPhaseNames += "," + realDesActivity.getPhaseName();
						Transition transition = new Transition(activity, realDesActivity);
						transition.setId(String.valueOf(++len));
						transitions.add(transition);
						count++;
					}
				}
				if(!"".equals(tranPhaseNames)) activity.setTranPhaseNames(tranPhaseNames.substring(1));
				//����Ľڵ�ĺ����׶ζ���1�������øýڵ������Ϊ��֧�ڵ�
				if(count > 1) activity.setType(BusinessProcessConst.ACTIVITY_TYPE_FORK_NODE);
			}
		}
		return transitions;
	}
	
	/**
	 * Ѱ�������ĺ�̽ڵ�
	 * @param activities
	 * @param curActivity
	 * @return
	 */
	private Activity findRealDesActivity(List activities, Activity curActivity){
		if(activities == null || activities.size() == 0 || curActivity == null) return null;
		Activity realDesActivity = null;
		Activity nextActivity = null;
		if("1".equals(curActivity.getIsInuse())){//�ڵ�δ������
			realDesActivity = curActivity;
		} else {//�ڵ㱻����
			if(curActivity.getRealPostScript() == null || "".equals(curActivity.getRealPostScript().trim())){//��ǰ�ڵ�δ����ֱ����ת�ڵ�
				realDesActivity = curActivity;
			} else {//��ǰ�ڵ����ֱ�Ӻ����ת�ڵ�
				Activity tmpActivity = new Activity(curActivity.getRealPostScript()); //Activity��PhaseNo��ʶ
				if(activities.indexOf(tmpActivity) > -1){
					nextActivity = (Activity)activities.get(activities.indexOf(tmpActivity));
					realDesActivity = findRealDesActivity(activities, nextActivity);
				} else {
					logger.error("[�׶�" + curActivity.getPhaseName() + "(" + curActivity.getPhaseNo() + ")�Ҳ�����Ч��ֱ����ת:"+ curActivity.getRealPostScript() +"]");	
				}
			}
		}
		
		return realDesActivity;
	}
	
	/**
	 * ���ýڵ��������Ϣ
	 * @param activities
	 */
	private void resetActivities(List activities){
		if(activities == null || activities.size() == 0)
			return;
		
		int count = activities.size();//�ڵ���Ŀ
		
		for(int i = 0; i < count; i++){
			Activity activity = (Activity)activities.get(i);
			int x = Math.abs(i/LINE_NODE_COUNT);
			int y = Math.abs((x%2)*(LINE_NODE_COUNT-1) - (i - x*LINE_NODE_COUNT)%LINE_NODE_COUNT);
			
			if(activity.getxCoordinate() == null || "".equals(activity.getxCoordinate()))
				activity.setxCoordinate(String.valueOf(ACTIVITY_NODE_FIRST_XCOORDINATE + y*(ACTIVITY_NODE_INCREAMENT + ACTIVITY_NODE_WIDTH)));
			if(activity.getyCoordinate() == null || "".equals(activity.getyCoordinate()))
				activity.setyCoordinate(String.valueOf(ACTIVITY_NODE_FIRST_YCOORDINATE + x*(ACTIVITY_LINE_INCREAMENT + ACTIVITY_NODE_HEIGHT)));
			if(activity.getWidth() == null || "".equals(activity.getWidth()))
				activity.setWidth(String.valueOf(ACTIVITY_NODE_WIDTH));
			if(activity.getHeight() == null || "".equals(activity.getHeight()))
				activity.setHeight(String.valueOf(ACTIVITY_NODE_HEIGHT));
		}
	}
	
	/**
	 * �����̵�ͼ����Ϣд�����ݿ�
	 */
	public void persistWorkFlow(BusinessProcess bp) throws JBOException{
		persistActivities(bp.getActivities());
	}
	
	/**
	 * ���ڵ��ͼ����Ϣд�����ݿ�
	 * @param activities
	 */
	private void persistActivities(List activities) throws JBOException {
		if(activities == null || activities.size() == 0) return;
		String boClass = "jbo.sys.FLOW_MODEL";
		String sql = "FlowNo=:FlowNo and PhaseNo=:PhaseNo";
		bom = factory.getManager(boClass);
		for(int i = 0; i < activities.size(); i++){
			Activity activity = (Activity)activities.get(i);
			query = bom.createQuery(sql)
					   .setParameter("FlowNo", activity.getBelongProcess())
					   .setParameter("PhaseNo", activity.getPhaseNo());
			BizObject activityBo = query.getSingleResult(true);
			if(activityBo == null) continue;
			activityBo.setAttributeValue("ID", activity.getId());
			activityBo.setAttributeValue("Name", activity.getName());
			activityBo.setAttributeValue("Type", activity.getType());
			activityBo.setAttributeValue("XCoordinate", activity.getxCoordinate());
			activityBo.setAttributeValue("YCoordinate", activity.getyCoordinate());
			activityBo.setAttributeValue("Width", activity.getWidth());
			activityBo.setAttributeValue("Height", activity.getHeight());
			bom.saveObject(activityBo);
		}
	}
	
	private static final int LINE_NODE_COUNT = 4;//����ÿ����ʾ�Ľڵ���,���ڳ�ʼ������ͼʱ�򵥶�λ
	private static final int ACTIVITY_NODE_WIDTH = 100;//Ĭ�Ͻڵ����ʾ���
	private static final int ACTIVITY_NODE_HEIGHT = 30;//Ĭ�Ͻڵ����ʾ�߶�
	private static final int ACTIVITY_NODE_FIRST_XCOORDINATE = 20;//��һ���ڵ��Ĭ��λ��x����
	private static final int ACTIVITY_NODE_FIRST_YCOORDINATE = 60;//��һ���ڵ��Ĭ��λ��y����
	private static final int ACTIVITY_NODE_INCREAMENT = 100;//�ڵ�֮��ļ��
	private static final int ACTIVITY_LINE_INCREAMENT = 100;//�ڵ�֮����о�

}
