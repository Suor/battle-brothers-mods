TooltipModule.prototype.setupUITooltip = function(_targetDIV, _data)
{
	if(_targetDIV === undefined)
		return;

	var offsetY = ('yOffset' in _data) ? _data.yOffset : this.mDefaultYOffset;
	if (offsetY !== null)
	{
		if (typeof(offsetY) === 'string')
		{
			offsetY = parseInt(offsetY, 10);
		}
		else if (typeof(offsetY) !== 'number')
		{
			offsetY = 0;
		}
	}

	var wnd = this.mParent; // $(window);
	
	// calculate tooltip position
	var targetOffset    = _targetDIV.offset();
	var elementWidth    = _targetDIV.outerWidth(true);
	var elementHeight   = _targetDIV.outerHeight(true);
	var containerWidth  = this.mContainer.outerWidth(true);
	var containerHeight = this.mContainer.outerHeight(true);
	
	var posLeft = (targetOffset.left + (elementWidth / 2)) - (containerWidth / 2);
	var posTop  = targetOffset.top - containerHeight - offsetY;

	if (posLeft < 0)
	{
		posLeft = targetOffset.left;
	}
	
	if (posLeft + containerWidth > wnd.width())
	{
		posLeft = targetOffset.left + elementWidth - containerWidth;
	}
			
	if (posTop < 0)
	{
		posTop = targetOffset.top + elementHeight + offsetY;
	}

	// make sure long tooltips stay within the window
	if (posTop + containerHeight > wnd.height())
	{
		posTop = wnd.height() - containerHeight;
	}

	// show & position tooltip & animate
	this.mContainer.removeClass('display-none').addClass('display-block');
	this.mContainer.css({ left: posLeft, top: posTop });
	this.mContainer.velocity("finish", true).velocity({ opacity: 0.99 }, { duration: this.mFadeInTime }); // Anti Alias Fix
};