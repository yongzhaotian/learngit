<%@page import="com.amarsoft.app.accounting.config.loader.DateFunctions"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		还款说明书
		Author:   xiongtao  2005.02.18
		Tester:
		Content: 报告的第0页
		Input Param:
			必须传入的参数：
				DocID:	  文档template
				ObjectNo：业务号
				SerialNo: 调查报告流水号
			可选的参数：
				Method:   其中 1:display;2:save;3:preview;4:export
				FirstSection: 判断是否为报告的第一页
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 30;	//这个是页面需要输入的个数，必须写对：客户化1
	int iCount = 1;
	int iCountNew = 20 ;
	String sReplaceAccount = ""; // 代扣帐号
	String sReplaceName = ""; // 代扣帐户名
	String sOpenBankName = ""; // 代扣帐户开户行
	String sRepaymentNo="";//还款账号
	String sRepaymentBank="";//还款银行
	String sRepaymentName="";//还款户名
	String sRepaymentWay = ""; // 还款方式
%>

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>
<%
//获得调查报告数据
String sSql = "select bc.CustomerID,bc.CustomerName,bc.stores,bc.inputuserid,bc.inputdate,bc.BusinessType,bc.BusinessSum,bc.InteriorCode,getstorename(bc.Stores) as StoresName, "+
				" bc.TotalPrice,bc.PdgRatio,bc.ReplaceAccount,getitemname('BankCode',bc.OpenBank) as OpenBank,bc.ReplaceName,"+
				" bc.TotalSum,bc.MonthRepayMent,bc.Periods,bc.RepaymentNo,getitemname('BankCode',bc.RepaymentBank) as RepaymentBank,bc.RepaymentName, "+
				"(select typename from business_type where typeno = bc.BusinessType) as ApplyType1,getitemname('BusinessType',bc.productid) as ApplyType,"+
				" PutOutDate,PERIODS,REPAYMENTWAY,getitemname('RepaymentWay',REPAYMENTWAY) as REPAYMENTWAY,getitemname('YesNo',falg6) as falg6, "+
				" bc.BrandType1,bc.Price1,bc.BrandType2,bc.Price2,getTypeName(bc.BusinessRange1,bc.BusinessType1) as BusinessType1,getTypeName(bc.BusinessRange2,bc.BusinessType2) as BusinessType2,bc.Manufacturer1,bc.Manufacturer2, "+
				" getusername(bc.Inputuserid) as UserName " + 
				" from Business_Contract bc where SerialNo = '"+sObjectNo+"'";

ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()){
		
		sReplaceAccount = rs2.getString("ReplaceAccount");
		sReplaceName = rs2.getString("ReplaceName");
		sOpenBankName=rs2.getString("OpenBank");
		sRepaymentNo=rs2.getString("RepaymentNo");
		sRepaymentBank=rs2.getString("RepaymentBank");
		sRepaymentName=rs2.getString("RepaymentName");
		sRepaymentWay = rs2.getString("REPAYMENTWAY");
		
		if(sReplaceAccount == null) sReplaceAccount = "&nbsp;";
		if(sReplaceName == null) sReplaceName = "&nbsp;";
		if(sOpenBankName == null) sOpenBankName = "&nbsp;";
		if(sRepaymentNo == null) sRepaymentNo ="&nbsp;";
		if(sRepaymentBank == null) sRepaymentBank ="&nbsp;";
		if(sRepaymentName == null) sRepaymentName ="&nbsp;";
		
		if ("2".equals(sRepaymentWay)) {
			sReplaceAccount = "-";
			sOpenBankName = "-";
			sReplaceName = "-";
		}

	}
	rs2.getStatement().close();
	
%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='04.jsp' name='reportInfo'>");
	sTemp.append("<div>");
	sTemp.append("<table class=table1 align=center  border=0 cellspacing=0 cellpadding=1  width='880'>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 class=td1 style='border: none;'><font style=' font-size: 8pt;' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;现金分期贷款三方协议<br>"
			+"	一、贷款申请1．中信信托有限责任公司（以下简称“贷款人”）为依法成立并有效存续的信托公司，根据中国银行业监督管理委员会颁布的《信托公司管理办法》第十九条的规定，可以发放信托贷款。2．在本合同下方签名的自然人借款人（以下简称“借款人”）拟向贷款人申请一笔《个人现金贷款申请表》（以下简称“《申请表》”，样本请见附件一）中所列明的贷款。3．借款人愿意聘请深圳市佰仟金融服务有限公司（以下简称“佰仟金融”）向借款人提供与本协议项下贷款相关的财务管理服务和客户服务，其服务内容包括但不限于代借款人接收贷款人发放的贷款。4．贷款人依据其与佰仟金融签署的《消费信贷合作协议》的约定，聘请佰仟金融为其提供推荐借款人、代为向借款人划付贷款本金、代为收取贷款本金及利息等款项、根据本协议约定通知还款、催收欠款等服务。5．若贷款人同意向借款人发放贷款的，借款人同意并确认如下：（1）授权佰仟金融代其接收贷款人发放的贷款本金，并且贷款人向佰仟金融指定的贷款接收账户划付贷款本金即视为贷款发放成功，借款人应承担偿还贷款的责任；（2）授权佰仟金融用其代为接收的贷款向借款人发放。6．借款人、佰仟金融、贷款人在此确认，贷款人向佰仟金融指定的贷款接收账户划付贷款本金，即视为贷款人已履行完毕本合同项下的放款义务。7．借款人同意按期足额支付贷款本金、利息、财务管理费、客户服务费、增值服务费、滞纳金（如有）及其他应付款项。贷款人授权佰仟金融代为收取借款人支付的贷款本息等款项（包括贷款本金、利息、滞纳金（如有））并向贷款人划付。借款人在此确认知晓上述事宜，并同意按本合同约定向佰仟金融指定的账户偿还前述贷款本息等还款项，并委托佰仟金融向贷款人支付贷款本息等款项。借款人应向佰仟金融支付财务管理费、客户服务费、增值服务费等款项。贷款人、佰仟金融、借款人进一步共同确认以下条款：<br>"
			+"	二、基本贷款条款与定义1．贷款本金：即《申请表》所列“贷款本金”。为免歧义，该贷款本金不含根据本合同约定借款人应支付的利息、借款人应向佰仟金融支付的财务管理费、客户服务费、增值服务费。2．贷款利率：即贷款期间适用的贷款利率（符合人民银行有关利率的规定），以《申请表》所列“月贷款利率”为准。3．分期期数、每月还款额：即《申请表》所列“分期期数”和“每月还款额”。本贷款以按月等额本息还款的方式偿还，全额偿还本贷款（以及借款人履行本合同项下其他的支付义务，滞纳金等除外）所需的分期期数以及每期应支付的期款以《申请表》所列为准。4．贷款期间：即从借款人《申请表》所列之申请日期开始至最后一笔期款的到期日为止。贷款期间结束后，如借款人仍拖欠本合同项下的任何款项，其还款义务并不因此而解除。5．期款：即借款人每个月应向贷款人及佰仟金融支付的款项，对应《申请表》项下的“每月还款额”。期款金额以本协议第五条第1款约定为准。6．还款到期日：即《申请表》所列第一期期款的还款日——“首次还款日”；与其后的每一期期款还款日——“每月还款日”，为每一日历月的同一天（为方便借款人还款，若申请日期为某月的29日、30日、31日，则首次还款日为协议签订月后第二个月的2日、3日、4日，之后的每月还款日亦为相应月份的2日、3日、4日），前两者统称“还款到期日”。7．本合同：即本《现金分期贷款三方协议》及附件，以及前述协议的任何后续补充约定或修改的合称，本合同的附件包括《个人现金贷款申请表》。8．指定还款账户：即佰仟金融开立的借款人还款资金接收账户，贷款人委托佰仟金融用该账户代为收取借款人偿还的贷款本息等款项，借款人向该账户偿还贷款本息并委托佰仟金融进一步向贷款人划付。具体账户信息以《申请表》的记载为准。<br>"
			+"	三、保险1．若借款人在申请表上选择申请参加保险，即表明借款人同意佰仟金融作为投保人为借款人本人投保《申请表》上列明的保险，并认可佰仟金融为本人所投保的保险金额（保险金额见《申请表》）。在该保单项下，受益人及/或第一受益人为佰仟金融，借款人为被保险人；保险人名称、保险金额、受益金额见《申请表》。2．借款人选择申请参加保险后，佰仟金融有权自行决定是否为借款人投保《申请表》上列明的保险。3．若佰仟金融同意为借款人投保《申请表》上列明的保险，则借款人应向佰仟金融支付因此而产生的管理成本（即“增值服务费”），该费用在贷款期间内按月收取并包含在每一期期款中，具体金额以本协议第五条第1款的相关约定为准。4．佰仟金融将借款人加入保单之后，佰仟金融依然有权根据借款人的申请或者任何其他原因使借款人丧失被保险人资格，如保险公司与佰仟金融之间保单的终止等。在上述情况下，佰仟金融应停止向借款人收取增值服务费。<br>"
			+"	四、佰仟金融服务1．就本合同，佰仟金融向借款人提供服务内容包括财务管理服务和客户服务：●财务管理服务（1）贷款咨询服务；（2）将借款人推荐给贷款人；（3）客户理财服务；（4）代收代付服务，包括代借款人接收贷款人发放的贷款，并且向借款人发放。●客户服务（1）客户纸质文档、电子文档保管、调阅服务；（2）客户还款渠道维护服务；（3）客户还款信息查询服务；（4）客户还款提醒服务。2．就上述服务，佰仟金融向借款人收取财务管理费、客户服务费，佰仟金融有权自主决定财务管理费和客户服务费的金额和收取方式，前述费用在贷款期间内按月收取并包含在每一期期款中。为免歧义，前述费用仅指借款人针对上述服务应向佰仟金融支付的费用。<br>"
			+"	五、还款与费用1．借款人知悉并同意，每期应支付的期款是以下（1）至（4）项之和，期款以元为最小单位：（1）借款人应以按月等额本息还款的方式偿还向贷款人偿还的（佰仟金融代为收取）每月贷款本金和利息（每月偿还的利息为剩余贷款本金乘以月利率），以及借款人应向贷款人支付的其他款项；（2）借款人应向佰仟金融支付的每月财务管理费，为初始贷款本金乘以《申请表》所列之“月财务管理费率”的金额；（3）借款人应向佰仟金融支付的每月客户服务费，为初始贷款本金乘以《申请表》所列之“月客户服务费率”的金额。（4）借款人应向佰仟金融支付的每月增值服务费，为初始贷款本金乘以《申请表》所列之“月增值服务费率”的金额。2．若借款人在《申请表》上不选择银行代扣，则适用第五条第3款和第4款的约定。若借款人在《申请表》上选择银行代扣，则适用第五条第5款和第6款的约定。3．借款人应将每一期期款在还款到期日之前支付至《申请表》上所列的佰仟金融指定还款账户。4．还款时间以指定还款账户实际收到借款人支付款项的到账时间为准，建议借款人提前将期款转入指定还款账户，以确保期款准时足额到账。5．借款人授权佰仟金融从借款人的银行账户划扣到期的期款及所有本合同项下到期应付的其他款项，而无需进一步通知借款人或者得到其同意。银行代扣不得早于还款到期日。借款人在此确认其授权佰仟金融划扣期款的银行账户信息如下：<b><i><u>开户行："+sOpenBankName+"；账户名："+sReplaceName+"；账号："+sReplaceAccount +"</b></i></u>。6．如果任何本合同项下的银行代扣失败，无论何种原因所致，借款人在本合同项下的还款义务不得因此而减免，借款人应采用其它合理方式继续清偿债务。7．若借款人在签订本合同时仍有其他未还清的贷款，且该贷款合同的金融服务公司为深圳市佰仟金融服务有限公司：●如果借款人在《申请表》上选择银行代扣，则借款人对所有未还清的贷款在此授权银行代扣，银行代扣的账户将以借款人最新授权的账户为准。●如果借款人在《申请表》上不选择银行代扣，则借款人对所有未还清的贷款在此同意取消所有之前授权的银行代扣。8．到达指定还款账户的款项，按照如下顺序清偿各项债务（包括借款人签订了其他由深圳市佰仟金融服务有限公司作为金融服务公司的贷款合同的情形）：●各期债务包含的各款项按照以下顺序依次清偿：其他应付款项（如有）、滞纳金（如有）、财务管理费、客户服务费、增值服务费、利息、贷款本金。●无论合同签订先后，先到期的债务先偿还。●多笔贷款的期款同时到期，先签署的贷款先偿还。●同时到期的多笔贷款中，借款人申请了提前还款的贷款先偿还。●若多笔贷款于同日签署，且借款人支付的款项不足以同时支付全部应付未付款项的，则各笔贷款按比例偿还。9．借款人应妥善保管本合同项下已还款项的付款证明。因借款人的还款引起争议的，由借款人对其还款情况承担举证责任。10. 如发生溢缴款情况，即借款人实际还款额大于应还款额，借款人有权向佰仟金融申请退还多支付的金额，但借款人应提供相应证明并承担退款时发生的银行汇款手续费。11．本合同第五条之任何规定不可被视为免除借款人对本合同项下任何款项的偿还义务，如滞纳金。<br>"
			+"	六、提前还款1．借款人有权按照本协议约定提前偿还本合同项下的贷款。提前还款指于某月份（“提前还款月份”）的还款到期日当天或之前一次性支付以下款项（“提前还款金额”）：●截至提前还款月份的应付利息、滞纳金（如有）、增值服务费、财务管理费和客户服务费；●本合同项下所有尚未偿还的贷款本金及其他应付款项；●<font style=' font-size: 10pt;' ><b><i><u>提前还款费人民币二百元</b></i></u><font style=' font-size: 8pt;' >。2．借款人提前还款，应在提前还款月份还款到期日的十五个自然日之前致电佰仟金融申请提前还款并授权其向贷款人办理提前还款手续。佰仟金融的客服人员将告知借款人具体的提前还款金额。3．借款人提前还款，其还款方式与第五条约定的偿还期款方式相同，但提前还款时，银行代扣可以在还款到期日之前发生。4．犹豫期：如借款人《申请表》所列之申请日起的十五个自然日内（包含借款人签署《申请表》当天）向佰仟金融申请提前还款并且在上述十五个自然日内将贷款本金全额付至指定还款账户，贷款人、佰仟金融不收取任何利息和费用。5．除本合同第六条第4款以外，只有借款人在本合同以及任何其他由深圳市佰仟金融服务有限公司作为其金融服务公司的合同项下没有任何逾期款项时，才可申请提前还款。若借款人在前述合同条款项下发生逾期，任何提前还款将自动取消。<br>"
			+"	七、逾期还款1．如果借款人未履行本合同项下的付款义务，其应立即偿还拖欠款项并应当按照本合同第七条的规定向贷款人支付滞纳金。滞纳金按照逾期天数计算，逾期天数是指单笔贷款中最早一笔未全额支付的期款已逾期的天数。2．单笔贷款逾期天数第10天，产生30元人民币的滞纳金；逾期天数第30天，在已产生的滞纳金基础上再额外产生80元人民币的滞纳金；逾期天数第60天，再额外产生100元人民币的滞纳金；逾期天数第90天，再额外产生160元人民币的滞纳金。3．借款人逾期后，其支付的款项将优先用于清偿已经拖欠的期款和滞纳金，故其逾期天数可能因此而减少。但是，如若拖欠的期款并未全额清偿，其逾期天数将会继续累加计算并且当达到上述时间段时，将会产生更多的滞纳金。4、借款人同意承担因借款人逾期产生的催收及诉讼费用。<br>"
			+"	八、强制提前还款1．以下任何事件发生，贷款人授权佰仟金融可代表贷款人要求借款人立即一次性偿还本合同项下的全部款项：（1）借款人违反本协议项下的任何约定，包括其在本协议项下的陈述与保证不真实；（2）借款人在其与佰仟金融、贷款人签署的其他贷款合同项下发生重大违约；（3）按照佰仟金融的合理判断，借款人自贷款申请日起就贷款、财务管理费、客户服务费、增值服务费可能从事过任何欺诈行为或借款人可能无能力根据本合同付款，借款人在此同意并确认本条款的适用以佰仟金融的自主判断为准；（4）若按照佰仟金融的合理判断，借款人发生可能对贷款人或佰仟金融的权利或利益造成负面影响的任何其他情形，借款人在此同意并确认本条款的适用以佰仟金融的自主判断为准。2．如果第八条第1款的情形发生在贷款人发放贷款之前，贷款人可以解除本合同，并且贷款人无需发放贷款或者承担任何其他责任。3．若借款人在某一笔期款的还款到期日90天之后仍未完全偿还该笔期款，则贷款人授权佰仟金融可代表贷款人通知借款人本合同提前终止，终止日为该笔未还期款的还款到期日起第90天，借款人应立即一次性偿还本合同下全部款项（包括截止合同提前终止日的应付利息、滞纳金、合同项下全部的财务管理费、合同项下全部的客户服务费、合同项下全部增值服务费以及所有尚未偿还的贷款本金及逾期产生的催收及诉讼费用等其他应付款项），如果借款人未于合同提前终止日支付上述任何费用，则从合同提前终止日起直至借款人实际还款之日止，按照本合同约定的利率计算所有逾期未付款项的违约金，直至借款人实际结清所有费用及违约金之日止。4．若借款人尚有其他未还清的贷款，且该贷款合同的金融服务公司为深圳市佰仟金融服务有限公司，则其他贷款合同的提前终止也将导致本合同的提前终止。<br>"
			+"	九、陈述与保证1．借款人陈述并保证：●借款人为贷款目的提供的所有信息（包括《申请表》上填写的信息）完整、真实、准确并不存在误导性。●不存在任何可能影响借款人信用的情况，如借款人存在正在进行或将来有可能发生的诉讼、仲裁、行政程序等。因以上任何陈述不真实、不准确而导致的贷款人、佰仟金融的任何损失，均应由借款人足额赔偿。2．借款人应积极配合贷款人和佰仟金融对借款人的信用、贷款使用情况、贷款偿还情况进行监督。<font style=' font-size: 10pt;' ><b><i><u>3．借款人授权佰仟金融及贷款人为信用评估、数据处理、风险控制、逾期账款催收等任何目的从任何数据库（包括不限于中国人民银行个人信用信息基础数据库）查询借款人的资产、资信及个人信用信息等情况，或者向上述系统报送其个人信息（如果发生债权转让或其他情况借款人在此确认并同意授权任何第三方债权人以自己的名义向上述系统报送其个人征信信息），以及佰仟金融为向借款人提供服务等目的通过任何方式使用其个人信息联系借款人或者授权第三方联系借款人。</b></i></u><font style=' font-size: 8pt;' >4．如果借款人违约，借款人同意佰仟金融直接或者经由第三方，通过当面拜访、电话、邮寄、网络等合法形式提醒借款人或者督促借款人对违约行为进行改正，并且同意佰仟金融向该第三方披露此违约事件。5．《申请表》上的借款人信息发生任何变化、借款人个人资产或者财务状况发生重大变化、或者发生了可能影响借款人履行本合同项下义务的任何其他情况时，借款人均应在五个自然日内通知佰仟金融。6.  贷款人、佰仟金融按照借款人签署本合同时在《申请表》上预留的现居住地址和通信方式（或者借款人另行书面或通过佰仟金融服务热线通知佰仟金融、贷款人变更的地址或通信方式）发出与本合同有关的通知。贷款人、佰仟金融以挂号信发出通知的，在挂号信回执所示日为有效送达；以邮件或短信方式发出的通知，以邮件或短信发送成功之日视为有效送达。<br>"
			+"	</tr><tr><td colspan=10 class=td1 style='border: none;'><font style=' font-size: 10pt;' ><b><i><u>十、争议解决1．凡因本合同引起的或与本合同有关的任何争议，应通过协商解决，若协商仍无法解决，任何一方应向合同签署地人民法院提起诉讼。败诉方应承担为解决本争议而产生的所有费用，包括但不限于诉讼费、律师费、公证费、交通费等。2．若争议正在解决过程之中，合同各方应继续履行其在本合同项下的所有义务。</b></i></u><br></td>"
			+"  </tr><tr><td colspan=10 class=td1 style='border: none;'><font style=' font-size: 8pt;' >十一、其他约定1．如本协议任何条款之一被司法机关或者其他有权部门认定为无效，该条款将不影响其余条款的有效性。2. 借款人同意，本协议以包括但不限于电子方式签署和保存，即除正常纸质签署方式外借款人也可以通过佰仟金融提供的设备在本协议上以电子方式签名，贷款人和佰仟金融在本协议上加盖电子章。本合同的生效日期与《申请表》上“申请日期”相同。3. 借款人授权佰仟金融保存借款人的本协议原件，借款人可要求佰仟金融提供本协议复印件，借款人同意佰仟金融在借款人付清本协议项下的全部款项之后销毁该原件。4. 贷款人授权佰仟金融可不时地向借款人提供关于本协议履行的优惠条款。与本协议的约定相比，该优惠条款如对借款人更有利，经借款人确认后，该优惠条款即生效。5. 贷款人与借款人双方同意，贷款人可将其在本协议项下享有的债权转让给商业银行或任意第三方，当商业银行或任意第三方同意受让时即视为商业银行或任意第三方与借款人重新签订了贷款协议，协议内容除更换贷款人外与本协议完全一致，并确认了变更后的债权债务关系。发生债权转让时，本合同项下贷款人将债权转让通知以书面形式送达佰仟金融，并委托佰仟金融将通知发放给债务人，债务人应于每半年向佰仟金融索取相关通知，如果债务人没有按期领取该通知，则债务人承诺同意视该债权转让通知已送达债务人，债务人无其他异议。6. 借款人确认已经认真阅读并完全理解本协议中的各项条款，且对协议中免除和限制其责任的条款已收到贷款人和佰仟金融的提醒注意和特别说明。<br><br><br></td></tr>");
	sTemp.append("<tr style='height:50px;border: none;'>");
	sTemp.append("<td colspan=3 width='30%' class=td1 style='border: none;'><font style=' font-size: 8pt; text-align: left;margin: auto; ' >贷款人：中信信托有限责任公司</td>");
	sTemp.append("<td colspan=4 width='40%' class=td1 style='border: none;'><font style=' font-size: 8pt; text-align: center;margin: auto;' >借款人：</td></tr>");
	sTemp.append("<tr style='height:50px; border: none;'>");
	sTemp.append("<td colspan=3 width='30%' class=td1 style='border: none;'><font style=' font-size: 8pt; text-align: right;margin: auto;' >佰仟金融：深圳市佰仟金融服务有限公司</td>");
	
	//sTemp.append("<td colspan=3 width='30%' class=td1 style='border: none;'><font style=' font-size: 8pt; text-align: left;margin: auto;' >合同签署日："+DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")+"</td>");
	sTemp.append("<td colspan=7 width='70%' class=td1 style='border: none;'><font style=' font-size: 8pt; text-align: center;margin: auto;' >合同签订地：广东省深圳市前海深港合作区</td>");
	sTemp.append("<td colspan=3 width='30%' class=td1 style='border: none;'><font style=' font-size: 8pt; text-align: right;margin: auto;' ></td></tr><br><br>");
		
	sTemp.append("</tr>");
	
	sTemp.append("</table>");	
	sTemp.append("</div>");
	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='111'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='111'>");
	sTemp.append("<input type='hidden' name='ObjectType' value='111'>");
	sTemp.append("<input type='hidden' name='Rand' value=''>");
	sTemp.append("<input type='hidden' name='CompClientID' value='111'>");
	sTemp.append("<input type='hidden' name='PageClientID' value='111'>");
	sTemp.append("</form>");	

	String sReportInfo = sTemp.toString();
	String sPreviewContent = "pvw"+java.lang.Math.random();
%>
<%/*~END~*/%>

<%@include file="/FormatDoc/IncludeFDFooter.jsp"%>

<script type="text/javascript">
<%	
	if(sMethod.equals("1"))  //1:display
	{
%>
	//客户化3
	var config = new Object();  
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>