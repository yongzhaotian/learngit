<%
//���������Ϣ����Ч��
if(sObjectType.equals("CreditApply")) //�������
{
	//չ��
	if(sDisplayTemplet.equals("ApplyInfo0000")) 
	{
		//����չ�ڽ�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"չ�ڽ�������ڵ���0��\" ");
		//����չ������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"չ������(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//����չ��ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"չ��ִ��������(%)������ڵ���0��\" ");
	}
	
	//Э�鸶ϢƱ������
	if(sDisplayTemplet.equals("ApplyInfo0020"))
	{
		//����Ʊ������(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ʊ������(��)������ڵ���0��\" ");
		//����Ʊ���ܽ�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ʊ���ܽ�������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//������Ӧ��������Ϣ��Χ
		doTemp.appendHTMLStyle("PurchaserInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ӧ��������Ϣ������ڵ���0��\" ");
	}
	
	//��ҵ�жһ�Ʊ����
	if(sDisplayTemplet.equals("ApplyInfo0030"))
	{
		//���û�Ʊ����(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����(��)������ڵ���0��\" ");
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ó�ŵ�ѷ�Χ
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ�ѱ�����ڵ���0��\" ");
	}
	
	//����������Ŀ�������������Ŀ�����������Ŀ����
	if(sDisplayTemplet.equals("ApplyInfo0040"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//�����������(��)��Χ
		doTemp.appendHTMLStyle("DrawingPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������(��)������ڵ���0��\" ");
		//���ô��������(��)��Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������(��)������ڵ���0��\" ");
	}
	
	//���˹�������
	if(sDisplayTemplet.equals("ApplyInfo0050"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���÷������������Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������������ڵ���0��\" ");
		//���÷������������Χ
		doTemp.appendHTMLStyle("UseArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������������ڵ���0��\" ");
		//���ù�����ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������ͬ��������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//�������˰���
	if(sDisplayTemplet.equals("ApplyInfo0060"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ù�����ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������ͬ��������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//�豸���˰���
	if(sDisplayTemplet.equals("ApplyInfo0070"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ù�������豸��ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������豸��ͬ��������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//�������˰���
	if(sDisplayTemplet.equals("ApplyInfo0080"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ð����ʲ�ʹ�����޷�Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ʲ�ʹ�����ޱ�����ڵ���0��\" ");
		//���ð����ʲ���ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ʲ���ͬ��������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//���Ŵ���
	if(sDisplayTemplet.equals("ApplyInfo0090"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ÿ�����(��)��Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(��)������ڵ���0��\" ");
		//�������Ŵ����ܽ�Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ŵ����ܽ�������ڵ���0��\" ");
		//�����������(��)��Χ
		doTemp.appendHTMLStyle("DrawingPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������(��)������ڵ���0��\" ");
		//���ó�ŵ����(��)��Χ
    	doTemp.appendHTMLStyle("PromisesFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��ŵ����(��)�ķ�ΧΪ[0,1000]\" ");
    	//���ó�ŵ�Ѽ�����(��)��Χ
		doTemp.appendHTMLStyle("PromisesFeePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ�Ѽ�����(��)������ڵ���0��\" ");
		//���ó�ŵ�ѽ�Χ
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ�ѽ�������ڵ���0��\" ");
		//���ù������(��)��Χ
    	doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"�������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���ù���ѽ�Χ
		doTemp.appendHTMLStyle("MFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����ѽ�������ڵ���0��\" ");
		//���ô���ѷ�Χ
		doTemp.appendHTMLStyle("AgentFee"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����ѱ�����ڵ���0��\" ");
		//���ð��ŷѷ�Χ
		doTemp.appendHTMLStyle("DealFee"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ŷѱ�����ڵ���0��\" ");
		//�����ܳɱ���Χ
		doTemp.appendHTMLStyle("TotalCast"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�ܳɱ�������ڵ���0��\" ");
	}
	
	//ί�д���
	if(sDisplayTemplet.equals("ApplyInfo0100"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����ί�л���Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ί�л��������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//����ΥԼ������(%)��Χ
		doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ΥԼ������(%)������ڵ���0��\" ");
	}
	
	//�м�֤ȯ���е���
	if(sDisplayTemplet.equals("ApplyInfo0110"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
    	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//������㴢��ת����
	if(sDisplayTemplet.equals("ApplyInfo0140"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
	}
	
	//���ں�ͬ�������
	if(sDisplayTemplet.equals("ApplyInfo0190"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����ó�׺�ͬ�ܽ�Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ó�׺�ͬ�ܽ�������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//����֤���½���Ѻ��
	if(sDisplayTemplet.equals("ApplyInfo0240"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//��������֤��Χ
		doTemp.appendHTMLStyle("OldLCSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����֤��������ڵ���0��\" ");
		//���ö��⸶���Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���⸶���������ڵ���0��\" ");
		//���ÿ�֤��֤�����(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//���������ʽ����
	if(sDisplayTemplet.equals("ApplyInfo0360"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
	}
	
	//�����ʻ�͸֧
	if(sDisplayTemplet.equals("ApplyInfo0380"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//��������͸֧��(��)��Χ
		doTemp.appendHTMLStyle("OverDraftPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����͸֧��(��)������ڵ���0��\" ");
		//���ó�ŵ�ѷ�Χ
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ�ѱ�����ڵ���0��\" ");
	}
	
	//������˰�ʻ��йܴ���
	if(sDisplayTemplet.equals("ApplyInfo0390"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ý�ֹ����������Ӧ����˰��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ֹ����������Ӧ����˰��������ڵ���0��\" ");
	}
	
	//���гжһ�Ʊ����
	if(sDisplayTemplet.equals("ApplyInfo0410"))
	{
		//���û�Ʊ����(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����(��)������ڵ���0��\" ");
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");		
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���óжһ�Ʊ����ó�׺�ͬ��ͬ��ķ�Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�жһ�Ʊ����ó�׺�ͬ��ͬ��ı�����ڵ���0��\" ");
	}
	
	//��ҵ�жһ�Ʊ����
	if(sDisplayTemplet.equals("ApplyInfo0420"))
	{
		//���û�Ʊ����(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����(��)������ڵ���0��\" ");
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");		
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ÿۼ��˴��������ֽ����������Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�ۼ��˴��������ֽ����������������ڵ���0��\" ");
		//���óжһ�Ʊ����ó�׺�ͬ��ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�жһ�Ʊ����ó�׺�ͬ��ͬ��������ڵ���0��\" ");
	}
	
	//���ز���������
	if(sDisplayTemplet.equals("ApplyInfo0430"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����Ԥ�ƿ�����Ŀ�����п������˰��Ҵ���Ľ�Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ԥ�ƿ�����Ŀ�����п������˰��Ҵ���Ľ�������ڵ���0��\" ");
	}
	
	//���гжһ�Ʊ
	if(sDisplayTemplet.equals("ApplyInfo0530"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//����ó�ױ�����ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ó�ױ�����ͬ��������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//�����
	if(sDisplayTemplet.equals("ApplyInfo0533"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//���ô����Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//�����Ŵ�֤��
	if(sDisplayTemplet.equals("ApplyInfo0534"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//����������
	if(sDisplayTemplet.equals("ApplyInfo0535"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//�����ŵ��
	if(sDisplayTemplet.equals("ApplyInfo0536"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//������������𳥻�������͸֧�黹��������˰��������������ó�ױ���������������������Ա�����
	//Ͷ�걣������Լ������Ԥ��������а����̱���������ά�ޱ��������±���������ó�ױ��������ϱ�����
	//���ý𱣺����ӹ�װ��ҵ����ڱ����������������Ա���
	if(sDisplayTemplet.equals("ApplyInfo0541"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//������Ŀ��ͬ��ķ�Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ŀ��ͬ��ı�����ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//�ۺ����Ŷ��
	if(sDisplayTemplet.equals("ApplyInfo0570"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
	}
	
	//����ס������
	if(sDisplayTemplet.equals("ApplyInfo1010"))
	{
		//���������Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
	}
	
	//�����ٽ���ס������
	if(sDisplayTemplet.equals("ApplyInfo1050"))
	{
		//���������Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
	}
	
	//������ҵ�÷�������
	if(sDisplayTemplet.equals("ApplyInfo1060"))
	{
		//���������Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
	}
	
	//�����ٽ�����ҵ�÷�����
	if(sDisplayTemplet.equals("ApplyInfo1080"))
	{
		//���������Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
	}
	
	//���˱�֤����
	if(sDisplayTemplet.equals("ApplyInfo1130"))
	{
		//���������Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
	}
	
	//������Ѻ������˵�Ѻ����
	if(sDisplayTemplet.equals("ApplyInfo1140"))
	{
		//���������Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
	}
	
	//����ס��װ�޴���
	if(sDisplayTemplet.equals("ApplyInfo1160"))
	{
		//���������Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���÷����������/���������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������/���������ƽ�ף�������ڵ���0\" ");
	}
	
	//���˾�Ӫ����
	if(sDisplayTemplet.equals("ApplyInfo1170"))
	{
		//���������Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//����ί�д���
	if(sDisplayTemplet.equals("ApplyInfo1180"))
	{
		//���������Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
	}
	
	//���˸����
	if(sDisplayTemplet.equals("ApplyInfo1190"))
	{
		//���������Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
	}
	
	//���˷��ݴ��������Ŀ
	if(sDisplayTemplet.equals("ApplyInfo1200"))
	{
		//�������볨���ܶ�ȷ�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���볨���ܶ�ȱ�����ڵ���0��\" ");
		//���ö����Ч����(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����Ч����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
    	//������Ŀ�������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ŀ�������ƽ�ף�������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
	}
	
	//��������������
	if(sDisplayTemplet.equals("ApplyInfo1210"))
	{
		//�������볨���ܶ�ȷ�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���볨���ܶ�ȱ�����ڵ���0��\" ");
		//���ö����Ч����(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����Ч����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
	}
	
	//����ס�����������
	if(sDisplayTemplet.equals("ApplyInfo1220"))
	{
		//���������Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���÷����������/���������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������/���������ƽ�ף�������ڵ���0\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
	}
	
	//����Ӫ����������
	if(sDisplayTemplet.equals("ApplyInfo1240"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
	}
	
	//����������������
	if(sDisplayTemplet.equals("ApplyInfo1250"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
	}
	
	//�������Ѵ������������
	if(sDisplayTemplet.equals("ApplyInfo1260"))
	{
		//�������볨���ܶ�ȷ�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���볨���ܶ�ȱ�����ڵ���0��\" ");
		//���ö����Ч����(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����Ч����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
	}
	
	//���˾�Ӫѭ������
	if(sDisplayTemplet.equals("ApplyInfo1330"))
	{
		//���������Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
	}
	
	//���˵�Ѻѭ������
	if(sDisplayTemplet.equals("ApplyInfo1340"))
	{
		//���������Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
	}
	
	//����С�����ô���
	if(sDisplayTemplet.equals("ApplyInfo1350"))
	{
		//���������Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
	}
	
	//��ҵ��ѧ����
	if(sDisplayTemplet.equals("ApplyInfo1360"))
	{
		//���������Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//������ѧ����
	if(sDisplayTemplet.equals("ApplyInfo1370"))
	{
		//���������Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
	}
	
	//����������Ѻ����
	if(sDisplayTemplet.equals("ApplyInfo1390"))
	{
		//���������Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
	}
}
if(sObjectType.equals("ApproveApply")) //���������������
{
	//չ��
	if(sDisplayTemplet.equals("ApproveInfo0000")) 
	{
		//������׼չ�ڽ�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼չ�ڽ�������ڵ���0��\" ");
		//����չ������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"չ������(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//����չ��ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"չ��ִ��������(%)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//Э�鸶ϢƱ������
	if(sDisplayTemplet.equals("ApproveInfo0020"))
	{
		//����Ʊ������(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ʊ������(��)������ڵ���0��\" ");
		//������׼Ʊ���ܽ�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼Ʊ���ܽ�������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//������Ӧ��������Ϣ��Χ
		doTemp.appendHTMLStyle("PurchaserInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ӧ��������Ϣ������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��ҵ�жһ�Ʊ����
	if(sDisplayTemplet.equals("ApproveInfo0030"))
	{
		//���û�Ʊ����(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����(��)������ڵ���0��\" ");
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ó�ŵ�ѷ�Χ
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ�ѱ�����ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����������Ŀ�������������Ŀ�����������Ŀ����
	if(sDisplayTemplet.equals("ApproveInfo0040"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//�����������(��)��Χ
		doTemp.appendHTMLStyle("DrawingPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������(��)������ڵ���0��\" ");
		//���ô��������(��)��Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˹�������
	if(sDisplayTemplet.equals("ApproveInfo0050"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���÷������������Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������������ڵ���0��\" ");
		//���÷������������Χ
		doTemp.appendHTMLStyle("UseArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������������ڵ���0��\" ");
		//���ù�����ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������ͬ��������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�������˰���
	if(sDisplayTemplet.equals("ApproveInfo0060"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ù�����ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������ͬ��������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�豸���˰���
	if(sDisplayTemplet.equals("ApproveInfo0070"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ù�������豸��ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������豸��ͬ��������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�������˰���
	if(sDisplayTemplet.equals("ApproveInfo0080"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ð����ʲ�ʹ�����޷�Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ʲ�ʹ�����ޱ�����ڵ���0��\" ");
		//���ð����ʲ���ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ʲ���ͬ��������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���Ŵ���
	if(sDisplayTemplet.equals("ApproveInfo0090"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ÿ�����(��)��Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(��)������ڵ���0��\" ");
		//�������Ŵ����ܽ�Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ŵ����ܽ�������ڵ���0��\" ");
		//�����������(��)��Χ
		doTemp.appendHTMLStyle("DrawingPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������(��)������ڵ���0��\" ");
		//���ó�ŵ����(��)��Χ
    	doTemp.appendHTMLStyle("PromisesFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��ŵ����(��)�ķ�ΧΪ[0,1000]\" ");
    	//���ó�ŵ�Ѽ�����(��)��Χ
		doTemp.appendHTMLStyle("PromisesFeePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ�Ѽ�����(��)������ڵ���0��\" ");
		//���ó�ŵ�ѽ�Χ
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ�ѽ�������ڵ���0��\" ");
		//���ù������(��)��Χ
    	doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"�������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���ù���ѽ�Χ
		doTemp.appendHTMLStyle("MFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����ѽ�������ڵ���0��\" ");
		//���ô���ѷ�Χ
		doTemp.appendHTMLStyle("AgentFee"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����ѱ�����ڵ���0��\" ");
		//���ð��ŷѷ�Χ
		doTemp.appendHTMLStyle("DealFee"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ŷѱ�����ڵ���0��\" ");
		//�����ܳɱ���Χ
		doTemp.appendHTMLStyle("TotalCast"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�ܳɱ�������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//ί�д���
	if(sDisplayTemplet.equals("ApproveInfo0100"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����ί�л���Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ί�л��������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//����ΥԼ������(%)��Χ
		doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ΥԼ������(%)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�м�֤ȯ���е���
	if(sDisplayTemplet.equals("ApproveInfo0110"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
    	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
    	//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������㴢��ת����
	if(sDisplayTemplet.equals("ApproveInfo0140"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���ں�ͬ�������
	if(sDisplayTemplet.equals("ApproveInfo0190"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����ó�׺�ͬ�ܽ�Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ó�׺�ͬ�ܽ�������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����֤���½���Ѻ��
	if(sDisplayTemplet.equals("ApproveInfo0240"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//��������֤��Χ
		doTemp.appendHTMLStyle("OldLCSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����֤��������ڵ���0��\" ");
		//���ö��⸶���Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���⸶���������ڵ���0��\" ");
		//���ÿ�֤��֤�����(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���������ʽ����
	if(sDisplayTemplet.equals("ApproveInfo0360"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����ʻ�͸֧
	if(sDisplayTemplet.equals("ApproveInfo0380"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//��������͸֧��(��)��Χ
		doTemp.appendHTMLStyle("OverDraftPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����͸֧��(��)������ڵ���0��\" ");
		//���ó�ŵ�ѷ�Χ
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ�ѱ�����ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������˰�ʻ��йܴ���
	if(sDisplayTemplet.equals("ApproveInfo0390"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ý�ֹ����������Ӧ����˰��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ֹ����������Ӧ����˰��������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���гжһ�Ʊ����
	if(sDisplayTemplet.equals("ApproveInfo0410"))
	{
		//���û�Ʊ����(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����(��)������ڵ���0��\" ");
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");		
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���óжһ�Ʊ����ó�׺�ͬ��ͬ��ķ�Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�жһ�Ʊ����ó�׺�ͬ��ͬ��ı�����ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��ҵ�жһ�Ʊ����
	if(sDisplayTemplet.equals("ApproveInfo0420"))
	{
		//���û�Ʊ����(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����(��)������ڵ���0��\" ");
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");		
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ÿۼ��˴��������ֽ����������Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�ۼ��˴��������ֽ����������������ڵ���0��\" ");
		//���óжһ�Ʊ����ó�׺�ͬ��ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�жһ�Ʊ����ó�׺�ͬ��ͬ��������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���ز���������
	if(sDisplayTemplet.equals("ApproveInfo0430"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����Ԥ�ƿ�����Ŀ�����п������˰��Ҵ���Ľ�Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ԥ�ƿ�����Ŀ�����п������˰��Ҵ���Ľ�������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���гжһ�Ʊ
	if(sDisplayTemplet.equals("ApproveInfo0530"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//����ó�ױ�����ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ó�ױ�����ͬ��������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����
	if(sDisplayTemplet.equals("ApproveInfo0533"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//���ô����Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����Ŵ�֤��
	if(sDisplayTemplet.equals("ApproveInfo0534"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����������
	if(sDisplayTemplet.equals("ApproveInfo0535"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����ŵ��
	if(sDisplayTemplet.equals("ApproveInfo0536"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������������𳥻�������͸֧�黹��������˰��������������ó�ױ���������������������Ա�����
	//Ͷ�걣������Լ������Ԥ��������а����̱���������ά�ޱ��������±���������ó�ױ��������ϱ�����
	//���ý𱣺����ӹ�װ��ҵ����ڱ����������������Ա���
	if(sDisplayTemplet.equals("ApproveInfo0541"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//������Ŀ��ͬ��ķ�Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ŀ��ͬ��ı�����ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�ۺ����Ŷ��
	if(sDisplayTemplet.equals("ApproveInfo0570"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����ס������
	if(sDisplayTemplet.equals("ApproveInfo1010"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����ٽ���ס������
	if(sDisplayTemplet.equals("ApproveInfo1050"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������ҵ�÷�������
	if(sDisplayTemplet.equals("ApproveInfo1060"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����ٽ�����ҵ�÷�����
	if(sDisplayTemplet.equals("ApproveInfo1080"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼�����ʱ�����ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˱�֤����
	if(sDisplayTemplet.equals("ApproveInfo1130"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������Ѻ������˵�Ѻ����
	if(sDisplayTemplet.equals("ApproveInfo1140"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����ס��װ�޴���
	if(sDisplayTemplet.equals("ApproveInfo1160"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���÷����������/���������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������/���������ƽ�ף�������ڵ���0\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˾�Ӫ����
	if(sDisplayTemplet.equals("ApproveInfo1170"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����ί�д���
	if(sDisplayTemplet.equals("ApproveInfo1180"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˸����
	if(sDisplayTemplet.equals("ApproveInfo1190"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˷��ݴ��������Ŀ
	if(sDisplayTemplet.equals("ApproveInfo1200"))
	{
		//������׼�����ܶ�ȷ�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼�����ܶ�ȱ�����ڵ���0��\" ");
		//���ö����Ч����(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����Ч����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
    	//������Ŀ�������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ŀ�������ƽ�ף�������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��������������
	if(sDisplayTemplet.equals("ApproveInfo1210"))
	{
		//������׼�����ܶ�ȷ�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼�����ܶ�ȱ�����ڵ���0��\" ");
		//���ö����Ч����(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����Ч����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����ס�����������
	if(sDisplayTemplet.equals("ApproveInfo1220"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���÷����������/���������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������/���������ƽ�ף�������ڵ���0\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����Ӫ����������
	if(sDisplayTemplet.equals("ApproveInfo1240"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����������������
	if(sDisplayTemplet.equals("ApproveInfo1250"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�������Ѵ������������
	if(sDisplayTemplet.equals("ApproveInfo1260"))
	{
		//�������볨���ܶ�ȷ�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���볨���ܶ�ȱ�����ڵ���0��\" ");
		//���ö����Ч����(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����Ч����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˾�Ӫѭ������
	if(sDisplayTemplet.equals("ApproveInfo1330"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˵�Ѻѭ������
	if(sDisplayTemplet.equals("ApproveInfo1340"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����С�����ô���
	if(sDisplayTemplet.equals("ApproveInfo1350"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��ҵ��ѧ����
	if(sDisplayTemplet.equals("ApproveInfo1360"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������ѧ����
	if(sDisplayTemplet.equals("ApproveInfo1370"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����������Ѻ����
	if(sDisplayTemplet.equals("ApproveInfo1390"))
	{
		//������׼��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
}

if(sObjectType.equals("BusinessContract") || sObjectType.equals("AfterLoan") || sObjectType.equals("ReinforceContract")) //��ͬ����
{
	//չ��
	if(sDisplayTemplet.equals("ContractInfo0000")) 
	{
		//����չ�ڽ�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"չ�ڽ�������ڵ���0��\" ");
		//����չ������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"չ������(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//����չ��ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"չ��ִ��������(%)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//Э�鸶ϢƱ������
	if(sDisplayTemplet.equals("ContractInfo0020"))
	{
		//����Ʊ������(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ʊ������(��)������ڵ���0��\" ");
		//����Ʊ���ܽ�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ʊ���ܽ�������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//������Ӧ��������Ϣ��Χ
		doTemp.appendHTMLStyle("PurchaserInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ӧ��������Ϣ������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��ҵ�жһ�Ʊ����
	if(sDisplayTemplet.equals("ContractInfo0030"))
	{
		//���û�Ʊ����(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����(��)������ڵ���0��\" ");
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ó�ŵ�ѷ�Χ
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ�ѱ�����ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����������Ŀ�������������Ŀ�����������Ŀ����
	if(sDisplayTemplet.equals("ContractInfo0040"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//�����������(��)��Χ
		doTemp.appendHTMLStyle("DrawingPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������(��)������ڵ���0��\" ");
		//���ô��������(��)��Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˹�������
	if(sDisplayTemplet.equals("ContractInfo0050"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���÷������������Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������������ڵ���0��\" ");
		//���÷������������Χ
		doTemp.appendHTMLStyle("UseArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������������ڵ���0��\" ");
		//���ù�����ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������ͬ��������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�������˰���
	if(sDisplayTemplet.equals("ContractInfo0060"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ù�����ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������ͬ��������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�豸���˰���
	if(sDisplayTemplet.equals("ContractInfo0070"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ù�������豸��ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������豸��ͬ��������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�������˰���
	if(sDisplayTemplet.equals("ContractInfo0080"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ð����ʲ�ʹ�����޷�Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ʲ�ʹ�����ޱ�����ڵ���0��\" ");
		//���ð����ʲ���ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ʲ���ͬ��������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���Ŵ���
	if(sDisplayTemplet.equals("ContractInfo0090"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ÿ�����(��)��Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(��)������ڵ���0��\" ");
		//�������Ŵ����ܽ�Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ŵ����ܽ�������ڵ���0��\" ");
		//�����������(��)��Χ
		doTemp.appendHTMLStyle("DrawingPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������(��)������ڵ���0��\" ");
		//���ó�ŵ����(��)��Χ
    	doTemp.appendHTMLStyle("PromisesFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��ŵ����(��)�ķ�ΧΪ[0,1000]\" ");
    	//���ó�ŵ�Ѽ�����(��)��Χ
		doTemp.appendHTMLStyle("PromisesFeePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ�Ѽ�����(��)������ڵ���0��\" ");
		//���ó�ŵ�ѽ�Χ
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ�ѽ�������ڵ���0��\" ");
		//���ù������(��)��Χ
    	doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"�������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���ù���ѽ�Χ
		doTemp.appendHTMLStyle("MFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����ѽ�������ڵ���0��\" ");
		//���ô���ѷ�Χ
		doTemp.appendHTMLStyle("AgentFee"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����ѱ�����ڵ���0��\" ");
		//���ð��ŷѷ�Χ
		doTemp.appendHTMLStyle("DealFee"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ŷѱ�����ڵ���0��\" ");
		//�����ܳɱ���Χ
		doTemp.appendHTMLStyle("TotalCast"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�ܳɱ�������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//ί�д���
	if(sDisplayTemplet.equals("ContractInfo0100"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����ί�л���Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ί�л��������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//����ΥԼ������(%)��Χ
		doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ΥԼ������(%)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�м�֤ȯ���е���
	if(sDisplayTemplet.equals("ContractInfo0110"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
    	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
    	//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������㴢��ת����
	if(sDisplayTemplet.equals("ContractInfo0140"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���ں�ͬ�������
	if(sDisplayTemplet.equals("ContractInfo0190"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����ó�׺�ͬ�ܽ�Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ó�׺�ͬ�ܽ�������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����֤���½���Ѻ��
	if(sDisplayTemplet.equals("ContractInfo0240"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//��������֤��Χ
		doTemp.appendHTMLStyle("OldLCSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����֤��������ڵ���0��\" ");
		//���ö��⸶���Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���⸶���������ڵ���0��\" ");
		//���ÿ�֤��֤�����(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���������ʽ����
	if(sDisplayTemplet.equals("ContractInfo0360"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����ʻ�͸֧
	if(sDisplayTemplet.equals("ContractInfo0380"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//��������͸֧��(��)��Χ
		doTemp.appendHTMLStyle("OverDraftPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����͸֧��(��)������ڵ���0��\" ");
		//���ó�ŵ�ѷ�Χ
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ�ѱ�����ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������˰�ʻ��йܴ���
	if(sDisplayTemplet.equals("ContractInfo0390"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ý�ֹ����������Ӧ����˰��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ֹ����������Ӧ����˰��������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���гжһ�Ʊ����
	if(sDisplayTemplet.equals("ContractInfo0410"))
	{
		//���û�Ʊ����(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����(��)������ڵ���0��\" ");
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");		
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���óжһ�Ʊ����ó�׺�ͬ��ͬ��ķ�Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�жһ�Ʊ����ó�׺�ͬ��ͬ��ı�����ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��ҵ�жһ�Ʊ����
	if(sDisplayTemplet.equals("ContractInfo0420"))
	{
		//���û�Ʊ����(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����(��)������ڵ���0��\" ");
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");		
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ÿۼ��˴��������ֽ����������Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�ۼ��˴��������ֽ����������������ڵ���0��\" ");
		//���óжһ�Ʊ����ó�׺�ͬ��ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�жһ�Ʊ����ó�׺�ͬ��ͬ��������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���ز���������
	if(sDisplayTemplet.equals("ContractInfo0430"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����Ԥ�ƿ�����Ŀ�����п������˰��Ҵ���Ľ�Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ԥ�ƿ�����Ŀ�����п������˰��Ҵ���Ľ�������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���гжһ�Ʊ
	if(sDisplayTemplet.equals("ContractInfo0530"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//����ó�ױ�����ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ó�ױ�����ͬ��������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����
	if(sDisplayTemplet.equals("ContractInfo0533"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//���ô����Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����Ŵ�֤��
	if(sDisplayTemplet.equals("ContractInfo0534"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����������
	if(sDisplayTemplet.equals("ContractInfo0535"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����ŵ��
	if(sDisplayTemplet.equals("ContractInfo0536"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������������𳥻�������͸֧�黹��������˰��������������ó�ױ���������������������Ա�����
	//Ͷ�걣������Լ������Ԥ��������а����̱���������ά�ޱ��������±���������ó�ױ��������ϱ�����
	//���ý𱣺����ӹ�װ��ҵ����ڱ����������������Ա���
	if(sDisplayTemplet.equals("ContractInfo0541"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//������Ŀ��ͬ��ķ�Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ŀ��ͬ��ı�����ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�ۺ����Ŷ��
	if(sDisplayTemplet.equals("ContractInfo0570"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����ס������
	if(sDisplayTemplet.equals("ContractInfo1010"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����ٽ���ס������
	if(sDisplayTemplet.equals("ContractInfo1050"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������ҵ�÷�������
	if(sDisplayTemplet.equals("ContractInfo1060"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����ٽ�����ҵ�÷�����
	if(sDisplayTemplet.equals("ContractInfo1080"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˱�֤����
	if(sDisplayTemplet.equals("ContractInfo1130"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������Ѻ������˵�Ѻ����
	if(sDisplayTemplet.equals("ContractInfo1140"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����ס��װ�޴���
	if(sDisplayTemplet.equals("ContractInfo1160"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���÷����������/���������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������/���������ƽ�ף�������ڵ���0\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˾�Ӫ����
	if(sDisplayTemplet.equals("ContractInfo1170"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����ί�д���
	if(sDisplayTemplet.equals("ContractInfo1180"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˸����
	if(sDisplayTemplet.equals("ContractInfo1190"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˷��ݴ��������Ŀ
	if(sDisplayTemplet.equals("ContractInfo1200"))
	{
		//�������볨���ܶ�ȷ�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���볨���ܶ�ȱ�����ڵ���0��\" ");
		//���ö����Ч����(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����Ч����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
    	//������Ŀ�������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ŀ�������ƽ�ף�������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��������������
	if(sDisplayTemplet.equals("ContractInfo1210"))
	{
		//�������볨���ܶ�ȷ�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���볨���ܶ�ȱ�����ڵ���0��\" ");
		//���ö����Ч����(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����Ч����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����ס�����������
	if(sDisplayTemplet.equals("ContractInfo1220"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���÷����������/���������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������/���������ƽ�ף�������ڵ���0\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����Ӫ����������
	if(sDisplayTemplet.equals("ContractInfo1240"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����������������
	if(sDisplayTemplet.equals("ContractInfo1250"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�������Ѵ������������
	if(sDisplayTemplet.equals("ContractInfo1260"))
	{
		//�������볨���ܶ�ȷ�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���볨���ܶ�ȱ�����ڵ���0��\" ");
		//���ö����Ч����(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����Ч����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˾�Ӫѭ������
	if(sDisplayTemplet.equals("ContractInfo1330"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˵�Ѻѭ������
	if(sDisplayTemplet.equals("ContractInfo1340"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����С�����ô���
	if(sDisplayTemplet.equals("ContractInfo1350"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��ҵ��ѧ����
	if(sDisplayTemplet.equals("ContractInfo1360"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ñ�֤���Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤���������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������ѧ����
	if(sDisplayTemplet.equals("ContractInfo1370"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����������Ѻ����
	if(sDisplayTemplet.equals("ContractInfo1390"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
}

if(sObjectType.equals("PutOutApply")) //���ʶ���
{
	if(sDisplayTemplet.equals("PutOutInfo0"))
	{
		//����չ�ڽ�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"չ�ڽ�������ڵ���0��\" ");
		//����չ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"չ��������(%)������ڵ���0��\" ");
	}
	
	if(sDisplayTemplet.equals("PutOutInfo1"))
	{
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("ContractSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ù̶����ڷ�Χ
		doTemp.appendHTMLStyle("FixCyc"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�̶����ڱ�����ڵ���0��\" ");
		//���ô������ϵ����Χ
    	doTemp.appendHTMLStyle("RiskRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������ϵ��������ڵ���0\" ");
	}	
	
	if(sDisplayTemplet.equals("PutOutInfo2"))
	{
		//���÷��Ž�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ž�������ڵ���0��\" ");
		//���������ѽ�Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ�������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����ΥԼ������(%)��Χ
		doTemp.appendHTMLStyle("BackRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ΥԼ������(%)������ڵ���0��\" ");
		//���ù̶����ڷ�Χ
		doTemp.appendHTMLStyle("FixCyc"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�̶����ڱ�����ڵ���0��\" ");
		//���ô������ϵ����Χ
    	doTemp.appendHTMLStyle("RiskRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������ϵ��������ڵ���0\" ");
	}	
	
	if(sDisplayTemplet.equals("PutOutInfo3"))
	{
		//���÷��Ž�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ž�������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ù̶����ڷ�Χ
		doTemp.appendHTMLStyle("FixCyc"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�̶����ڱ�����ڵ���0��\" ");
	}	
	
	if(sDisplayTemplet.equals("PutOutInfo6"))
	{
		//����Ʊ���Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ʊ���������ڵ���0��\" ");
		//�����򷽸�Ϣ����(%)��Χ
		doTemp.appendHTMLStyle("BillRisk"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�򷽸�Ϣ����(%)�ķ�ΧΪ[0,100]\" ");
		//��������ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����ִ��������(��)������ڵ���0��\" ");
		//���õ���������Χ
		doTemp.appendHTMLStyle("FixCyc"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������������ڵ���0��\" ");
	}
	
	if(sDisplayTemplet.equals("PutOutInfo8"))
	{
		//���ý��׽�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���׽�������ڵ���0��\" ");
	}
		
	if(sDisplayTemplet.equals("PutOutInfo9"))
	{
		//���÷��Ž�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ž�������ڵ���0��\" ");
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("ContractSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//���÷�չ�̱�֤��Χ
		doTemp.appendHTMLStyle("FZGuaBalance"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��չ�̱�֤��������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���÷�չ�����ʾ��Χ
		doTemp.appendHTMLStyle("FZANBalance"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��չ�����ʾ��������ڵ���0��\" ");
		//���ù̶�������Χ
		doTemp.appendHTMLStyle("FixCyc"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�̶�����������ڵ���0��\" ");
		//���ô������ϵ����Χ
    	doTemp.appendHTMLStyle("RiskRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������ϵ��������ڵ���0\" ");
	}
		
	if(sDisplayTemplet.equals("PutOutInfo11"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//������������(��)��Χ
		doTemp.appendHTMLStyle("FZANBalance"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
		
	if(sDisplayTemplet.equals("PutOutInfo12"))
	{
		//���ý�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڵ���0��\" ");
		//������������(��)��Χ
		doTemp.appendHTMLStyle("FZANBalance"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
}
%>