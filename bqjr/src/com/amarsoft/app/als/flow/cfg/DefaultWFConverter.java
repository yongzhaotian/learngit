package com.amarsoft.app.als.flow.cfg;

import java.util.ArrayList;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;

import com.amarsoft.app.als.flow.cfg.model.Activity;
import com.amarsoft.app.als.flow.cfg.model.BusinessProcess;
import com.amarsoft.app.als.flow.cfg.model.BusinessProcessConst;
import com.amarsoft.app.als.flow.cfg.model.Transition;

public class DefaultWFConverter implements WFConverter {

	public Document convertProcessToXML(BusinessProcess bp) {
		//建立XML文档内容
		//建立根元素
		Document doc = new Document();
		Element root = new Element(BusinessProcessConst.NODE_ROOT);
		root.setAttribute(BusinessProcessConst.ATTR_ROOT_ID, bp.getProcessID());
		root.setAttribute(BusinessProcessConst.ATTR_ROOT_NAME, bp.getProcessName());
		doc.setRootElement(root);
		
		//建立Activities元素
		List activities = bp.getActivities();
		if(activities != null && activities.size() > 0){
			Element activitiesNode = new Element(BusinessProcessConst.NODE_ACTIVITIES);
			root.addContent(activitiesNode);
			for(int i = 0; i < activities.size(); i++){
				Activity activity = (Activity)activities.get(i);
				Element activityNode = new Element(BusinessProcessConst.NODE_ACTIVITIE);
				activityNode.setAttribute(BusinessProcessConst.ATTR_ACTIVITIE_ID, activity.getId());
				activityNode.setAttribute(BusinessProcessConst.ATTR_ACTIVITIE_TYPE, activity.getType());
				activityNode.setAttribute(BusinessProcessConst.ATTR_ACTIVITIE_NAME, activity.getName());
				activityNode.setAttribute(BusinessProcessConst.ATTR_ACTIVITIE_X_COORD, activity.getxCoordinate()==null?"":activity.getxCoordinate());
				activityNode.setAttribute(BusinessProcessConst.ATTR_ACTIVITIE_Y_COORD, activity.getyCoordinate()==null?"":activity.getyCoordinate());
				activityNode.setAttribute(BusinessProcessConst.ATTR_ACTIVITIE_WIDTH, activity.getWidth()==null?"":activity.getWidth());
				activityNode.setAttribute(BusinessProcessConst.ATTR_ACTIVITIE_HEIGHT, activity.getHeight()==null?"":activity.getHeight());
				activityNode.setAttribute(BusinessProcessConst.ATTR_ACTIVITIE_BELONGPROCESS, activity.getBelongProcess()==null?"":activity.getBelongProcess());
				activityNode.setAttribute(BusinessProcessConst.ATTR_ACTIVITIE_PHASENO,activity.getPhaseNo()==null?"":activity.getPhaseNo());
				activityNode.setAttribute(BusinessProcessConst.ATTR_ACTIVITIE_PHASENAME,activity.getPhaseName()==null?"":activity.getPhaseName());
				activityNode.setAttribute(BusinessProcessConst.ATTR_ACTIVITIE_ISINUSE, (activity.getIsInuse()==null || "".equals(activity.getIsInuse()))?"1":activity.getIsInuse());
				activityNode.setAttribute(BusinessProcessConst.ATTR_ACTIVITIE_EDITSTATUS, (activity.getEditStatus()==null || "".equals(activity.getEditStatus()))?"00":activity.getEditStatus());
				activityNode.setAttribute(BusinessProcessConst.ATTR_ACTIVITIE_TRANPHASENAMES, (activity.getTranPhaseNames()==null)?"":activity.getTranPhaseNames());
				activitiesNode.addContent(activityNode);
			}
		}
		
		//建立Transition元素
		List transitions = bp.getTransitions();
		if(transitions !=null && transitions.size() > 0){
			Element transitionsNode = new Element(BusinessProcessConst.NODE_TRANSITIONS);
			root.addContent(transitionsNode);
			for(int i = 0; i < transitions.size(); i++){
				Transition transition = (Transition)transitions.get(i);
				Element transitionNode = new Element(BusinessProcessConst.NODE_TRANSITION);
				transitionNode.setAttribute(BusinessProcessConst.ATTR_TRANSITION_ID, transition.getId());
				transitionNode.setAttribute(BusinessProcessConst.ATTR_TRANSITION_NAME, transition.getName()==null?"":transition.getName());
				transitionNode.setAttribute(BusinessProcessConst.ATTR_TRANSITION_FROM, transition.getFromActivity().getId());
				transitionNode.setAttribute(BusinessProcessConst.ATTR_TRANSITION_TO, transition.getToActivity().getId());
				transitionsNode.addContent(transitionNode);
			}
		}
		
		return doc;
	}
	
	/**
	 * 将流程的XML表示转换为实际的流程模型.<br>
	 * 完全的逆向生成在本场景中是没有意义的,此处转换的目的是保存流程的图形信息,因此该转换是不完全的转换,请不要使用此处
	 * 生成的流程模型进行保存流程节点坐标以外的操作.
	 */
	public BusinessProcess convertXMLToProcess(Document doc){
		BusinessProcess bp = new BusinessProcess();
		Element activitiesElement = doc.getRootElement().getChild(BusinessProcessConst.NODE_ACTIVITIES);
		List activityElements = activitiesElement.getChildren();
		if(activityElements == null) return null;
		List activities = new ArrayList();
		for(int i = 0; i < activityElements.size(); i++){
			Element activityElement = (Element)activityElements.get(i);
			Activity activity = new Activity();
			activity.setPhaseNo(activityElement.getAttributeValue(BusinessProcessConst.ATTR_ACTIVITIE_PHASENO));
			activity.setBelongProcess(activityElement.getAttributeValue(BusinessProcessConst.ATTR_ACTIVITIE_BELONGPROCESS));
			activity.setId(activityElement.getAttributeValue(BusinessProcessConst.ATTR_ACTIVITIE_ID));
			activity.setName(activityElement.getAttributeValue(BusinessProcessConst.ATTR_ACTIVITIE_NAME));
			activity.setType(activityElement.getAttributeValue(BusinessProcessConst.ATTR_ACTIVITIE_TYPE));
			activity.setxCoordinate(activityElement.getAttributeValue(BusinessProcessConst.ATTR_ACTIVITIE_X_COORD));
			activity.setyCoordinate(activityElement.getAttributeValue(BusinessProcessConst.ATTR_ACTIVITIE_Y_COORD));
			activity.setWidth(activityElement.getAttributeValue(BusinessProcessConst.ATTR_ACTIVITIE_WIDTH));
			activity.setHeight(activityElement.getAttributeValue(BusinessProcessConst.ATTR_ACTIVITIE_HEIGHT));
			activities.add(activity);
		}
		bp.setActivities(activities);
		return bp;
	}
}
