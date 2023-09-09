var FunFacts = {
	ID : "mod_fun_facts"
};

FunFacts.WorldObituaryScreen_createDiv = WorldObituaryScreen.prototype.createDIV;
WorldObituaryScreen.prototype.createDIV = function (_parentDiv)
{
	FunFacts.WorldObituaryScreen_createDiv.call(this, _parentDiv);
	var empty = this.mListScrollContainer.empty;
	this.mListScrollContainer.empty = function()
	{
		this.children('.l-row').each(function()
		{
			$(this).unbindTooltip();
		});
		empty.call(this);
	}
}

FunFacts.WorldObituaryScreen_addListEntry = WorldObituaryScreen.prototype.addListEntry;
WorldObituaryScreen.prototype.addListEntry = function (_data)
{
	FunFacts.WorldObituaryScreen_addListEntry.call(this, _data);
	var result = this.mListScrollContainer.children('.l-row:last');
	result.bindTooltip({
		contentType: 'msu-generic',
		modId: FunFacts.ID,
		elementId: "Fallen",
		FunFacts_Idx: _data.FunFacts_Idx
	});
}
