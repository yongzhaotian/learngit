var AWEButton = {
	StatChange: function(iButtonID,pos,state,style){
	    $('#'+iButtonID+'_'+pos).removeClass();
	    $('#'+iButtonID+'_'+pos).addClass('btn_bg_'+pos+state+style);
	},

	over: function(iButtonID,style){
	    this.StatChange(iButtonID, "left","_over",style);
	    this.StatChange(iButtonID, "mid","_over",style);
	    this.StatChange(iButtonID, "right","_over",style);
	},

	normal: function(iButtonID,style){
		this.StatChange(iButtonID, "left","",style);
		this.StatChange(iButtonID, "mid","",style);
		this.StatChange(iButtonID, "right","",style);
	},

	down: function (iButtonID,style){
		this.StatChange(iButtonID, "left","_down",style);
		this.StatChange(iButtonID, "mid","_down",style);
		this.StatChange(iButtonID, "right","_down",style);
	}
};