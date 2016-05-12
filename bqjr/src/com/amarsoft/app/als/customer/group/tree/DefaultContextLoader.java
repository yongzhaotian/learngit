package com.amarsoft.app.als.customer.group.tree;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.customer.group.tree.component.FacesContext;
import com.amarsoft.app.als.customer.group.tree.component.FacesException;
import com.amarsoft.app.als.customer.group.tree.component.FamilyTreeNode;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.context.ASUser;


/**
 * @author syang
 * @date 2011-7-27
 * @describe ���ſͻ����������ݼ�����������
 */
public class DefaultContextLoader {
	private FacesContext context = null;
	private ASUser curUser ;
	private String groupId;
	private String versionSeq;
	public DefaultContextLoader(ASUser curUser,String groupId,String versionSeq){
		this.curUser = curUser;
		this.groupId = groupId;
		this.versionSeq = versionSeq;
	}
	/**
	 * ��ȡһ������������
	 * @return
	 */
	public FacesContext getContext() {
		if(context==null)init();
		return context;
	}
	/**
	 * ִ�г�ʼ��
	 */
	private void init(){
		context = new FacesContext();
		context.addListener(new GroupCustomerContextListener(curUser,groupId,versionSeq));
		try {
			genFamilyTreeNode();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}	
	/**
	 * ������ͼ�ڵ�
	 * @param context
	 * @return
	 * @throws Exception 
	 */
	private FamilyTreeNode genFamilyTreeNode() throws Exception{
		//���ڵ�
		List<BizObject> jList = getMemberList();
		BizObject rootBizObject = findRootMember(jList);
		
		FamilyTreeNode root = createTreeNode(rootBizObject);//���ɸ��ڵ����
		//���б����Ƴ����ڵ�
		jList.remove(rootBizObject);
		genChildNode(root,jList);
		context.setRootComponent(root);
		return root;
	}
	/**
	 * �ݹ�������ͼģ��
	 * @param node ��ǰ�ڵ�
	 * @param jList �ڵ��б�
	 * @throws FacesException
	 * @throws JBOException
	 */
	private void genChildNode(FamilyTreeNode node,List<BizObject> jList) throws FacesException, JBOException{
		String id = node.getId();
		//�ҵ��ӽڵ�
		List<BizObject> fList = new ArrayList<BizObject>();
		for(int i=0;i<jList.size();i++){
			BizObject bo = jList.get(i);
			String parentId = bo.getAttribute("PARENTMEMBERID").getString();
			if(id.equals(parentId)){
				fList.add(bo);
			}
		}
		if(fList.size()==0)return;	//���û�еģ��򷵻�
		for(int i=0;i<fList.size();i++){
			FamilyTreeNode childNode = createTreeNode(fList.get(i));
			genChildNode(childNode,jList);					//�ݹ��ӽڵ�
			context.appendChildComponent(node, childNode,false);//��Ϊnode���ӽڵ����,�����������������
		}
	}

	/**
	 * ��ȡ���ڵ��Ӧ�ļ�¼
	 * @param jList
	 * @return
	 * @throws JBOException 
	 */
	private BizObject findRootMember(List<BizObject> jList) throws Exception{
		int count = 0;
		BizObject rootObject = null;
		for(BizObject bo: jList){
			DataElement element = bo.getAttribute("PARENTMEMBERID");
			if(element.isNull()||element.getString().length()==0||"None".equals(element.getString())){
				count ++;
				rootObject = bo;
			}
		}
		if(count>1)throw new Exception("�����쳣�����ſͻ�[���:"+this.groupId+",�汾��:"+this.versionSeq+"���ڶ�����ڵ�");
		if(count==0)throw new Exception("�����쳣�����ſͻ�[���:"+this.groupId+",�汾��:"+this.versionSeq+"û�и��ڵ�");
		return rootObject;
	}
	/**
	 * ��ȡ���ſͻ�ָ���汾�¼��ų�Ա�б�
	 * @param groupId ���ſͻ���
	 * @param versionSeq �汾��
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<BizObject> getMemberList(){
        BizObjectManager mamager;
        List<BizObject> jList = null;
		try {
			mamager = JBOFactory.getFactory().getManager("jbo.app.GROUP_FAMILY_MEMBER");
			BizObjectQuery query = mamager.createQuery("GroupID=:GroupID and VersionSeq=:VersionSeq and REVISEFLAG <> 'REMOVED' order by MemberID asc");
			query.setParameter("GroupID", groupId);
			query.setParameter("VersionSeq", versionSeq);
			jList = query.getResultList();
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return jList;
	}
	/**
	 * ��JBO����������һ����ͼ�ڵ����
	 * @param bo
	 * @return
	 * @throws JBOException
	 * @throws FacesException
	 */
	public FamilyTreeNode createTreeNode(BizObject bo) throws JBOException, FacesException{
		//��ȡJBO����
		String id = bo.getAttribute("MEMBERCUSTOMERID").getString();
		String memberName = bo.getAttribute("MEMBERNAME").getString();
		String parentId = bo.getAttribute("PARENTMEMBERID").getString();
		String parentRelationType = bo.getAttribute("PARENTRELATIONTYPE").getString();
		String memberType = bo.getAttribute("MEMBERTYPE").getString();
		String addReason = bo.getAttribute("ATT01").getString();
		String state = bo.getAttribute("REVISEFLAG").getString();
		DataElement shareValue = bo.getAttribute("SHAREVALUE");
		//����bean
		FamilyTreeNode node = (FamilyTreeNode)context.createComponent(id, FamilyTreeNode.class);
		node.setMemberName(memberName);
		node.setParentId(parentId);
		node.setAddReason(addReason);
		node.setParentRelationType(parentRelationType);
		node.setMemberType(memberType);
		node.setState(state);
		if(shareValue !=null && !shareValue.isNull())node.setShareValue(shareValue.toString());
		return node;
	}
}

