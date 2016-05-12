<div id="CoverTipDiv" style="position:absolute; left:1px; top:1px; width:100%; height:35px; z-index:2; display:none"> 
 <table width="100%" height="100%" align=center border="0" cellspacing="0" cellpadding="1" bgcolor="#333333">
    <tr> 
      <td>
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
		<tr> 
		  <td width=1><img class=clockimg src=<%=sResourcesPath%>/1x1.gif width="1" height="1"></td>
		  <td id="CoverTipTD" style="background-color: #FFFFFF;"></td>
		</tr>
		</table>
	</td>
	</tr>
</table>
</div>
<script type="text/javascript">
	function showCoverTip(sTipText){
		oDiv = document.getElementById("CoverTipDiv");
		oTD = document.getElementById("CoverTipTD");
		oDiv.style.display="";
		oTD.innerHTML=sTipText;
	}
	function hideCoverTip(){
		oDiv = document.getElementById("CoverTipDiv");
		oTD = document.getElementById("CoverTipTD");
		oDiv.style.display="none";
		oTD.innerHTML="";
	}
</script>