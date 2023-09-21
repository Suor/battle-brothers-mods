this.turn_sequence_bar <- this.inherit("scripts/ui/screens/ui_module", {
	m = {
		CurrentEntities = [],
		AllEntities = [],
		TurnPosition = 0,
		MaxVisibleEntities = 7,
		CurrentRound = 0,
		LastRemoveTime = 0,
		JumpToFirstEntity = false,
		IsLocked = false,
		IsBattleEnded = false,
    CancelPending = false,
		IsSkippingRound = false,
    IsWaitingRound = false,
		IsInitNextRound = false,
		CheckEnemyRetreat = false,
		IsLastEntityPlayerControlled = false,
		IsBusy = false,
		ActiveEntityMouseHover = null,
		ActiveEntityCostsPreview = null,
		InShutdown = null,
		OnNextTurnListener = null,
		OnNextRoundListener = null,
		OnEntitySkillClickedListener = null,
		OnEntitySkillCancelClickedListener = null,
		OnEntityEnteredFirstSlotListener = null,
		OnEntityEnteredFirstSlotFullyListener = null,
		OnEntityMouseEnterListener = null,
		OnEntityMouseLeaveListener = null,
		OnBattleEndedListener = null,
		OnOpenInventoryButtonPressed = null,
		OnCheckEnemyRetreatListener = null
	},
	function setOnNextTurnListener( _listener )
	{
		this.m.OnNextTurnListener = _listener;
	}

	function setOnNextRoundListener( _listener )
	{
		this.m.OnNextRoundListener = _listener;
	}

	function setOnEntitySkillClickedListener( _listener )
	{
		this.m.OnEntitySkillClickedListener = _listener;
	}

	function setOnEntitySkillCancelClickedListener( _listener )
	{
		this.m.OnEntitySkillCancelClickedListener = _listener;
	}

	function setOnEntityEnteredFirstSlotListener( _listener )
	{
		this.m.OnEntityEnteredFirstSlotListener = _listener;
	}

	function setOnEntityEnteredFirstSlotFullyListener( _listener )
	{
		this.m.OnEntityEnteredFirstSlotFullyListener = _listener;
	}

	function setOnEntityMouseEnterListener( _listener )
	{
		this.m.OnEntityMouseEnterListener = _listener;
	}

	function setOnEntityMouseLeaveListener( _listener )
	{
		this.m.OnEntityMouseLeaveListener = _listener;
	}

	function setOnBattleEndedListener( _listener )
	{
		this.m.OnBattleEndedListener = _listener;
	}

	function setOnOpenInventoryButtonPressed( _listener )
	{
		this.m.OnOpenInventoryButtonPressed = _listener;
	}

	function setCheckEnemyRetreatListener( _listener )
	{
		this.m.OnCheckEnemyRetreatListener = _listener;
	}

	function clearEventListeners()
	{
		this.m.OnNextTurnListener = null;
		this.m.OnNextRoundListener = null;
		this.m.OnEntitySkillClickedListener = null;
		this.m.OnEntitySkillCancelClickedListener = null;
		this.m.OnEntityEnteredFirstSlotListener = null;
		this.m.OnEntityEnteredFirstSlotFullyListener = null;
		this.m.OnEntityMouseEnterListener = null;
		this.m.OnEntityMouseLeaveListener = null;
		this.m.OnBattleEndedListener = null;
		this.m.OnOpenInventoryButtonPressed = null;
	}

	function isLastEntityPlayerControlled()
	{
		return this.m.IsLastEntityPlayerControlled;
	}

	function getCurrentRound()
	{
		return this.m.CurrentRound;
	}

	function getActiveEntity()
	{
		if (!this.m.IsLocked && this.m.CurrentEntities.len() != 0)
		{
			return this.m.CurrentEntities[0];
		}
		else
		{
			return null;
		}
	}

	function isHumanControlled(entity = null)
	{
		if(entity == null) entity = getActiveEntity();
		return entity != null && entity.isPlayerControlled() && (entity.getAIAgent() == null || entity.getAIAgent().ClassName == "player_agent");
	}

	function getCurrentEntities()
	{
		return this.m.CurrentEntities;
	}

	function getAllEntities()
	{
		return this.m.AllEntities;
	}

	function isLastEntityActive()
	{
		return this.m.CurrentEntities.len() == 1;
	}

	function isRemovingEntity()
	{
		return this.m.LastRemoveTime + 2.0 >= this.Time.getRealTimeF();
	}

	function getTurnPosition()
	{
		return this.m.TurnPosition;
	}

	function setBusy( _b )
	{
		this.m.IsBusy = _b;
	}

	function create()
	{
		this.m.ID = "TurnSequenceBarModule";
		this.ui_module.create();
	}

	function destroy()
	{
		this.m.InShutdown = true;
		this.clearEventListeners();
		this.removeEntities();
		this.ui_module.destroy();
	}

	function hasEnemiesLeftToAct( _ofFaction )
	{
		for( local i = 0; i < this.m.CurrentEntities.len(); i = ++i )
		{
			if (this.Tactical.State.isScenarioMode())
			{
				if (this.Const.FactionAlliance[_ofFaction].find(this.m.CurrentEntities[i].getFaction()) == null)
				{
					return true;
				}
			}
			else if (this.World.FactionManager.getAlliedFactions(_ofFaction).find(this.m.CurrentEntities[i].getFaction()) == null)
			{
				return true;
			}
		}

		return false;
	}

	function insertEntity( _entity )
	{
		if (this.m.InShutdown == true)
		{
			return false;
		}

		if (!this.isRemovingEntity() && this.m.CurrentEntities.len() >= 1)
		{
			this.m.AllEntities.push(_entity);
			this.m.CurrentEntities.insert(1, _entity);
			this.m.JSHandle.call("insertEntity", {
				id = _entity.getID(),
				index = 1
			});

			if (this.m.CurrentEntities.len() > this.m.MaxVisibleEntities)
			{
				local indexToRemove = this.Math.min(this.m.CurrentEntities.len(), this.m.MaxVisibleEntities);
				this.m.JSHandle.asyncCall("removeEntity", this.m.CurrentEntities[indexToRemove].getID());
				this.m.LastRemoveTime = this.Time.getRealTimeF();
			}

			_entity.onRoundStart();
		}
		else
		{
			this.addEntity(_entity);
		}
	}

	function addEntity( _entity )
	{
		if (this.m.InShutdown == true)
		{
			return false;
		}

		local entityId = _entity.getID();

		if (this.findEntityByID(this.m.AllEntities, entityId) != null)
		{
			this.logDebug("TurnSequenceBar::addEntity(" + _entity.getName() + " already exists.)");
			return false;
		}

		this.m.AllEntities.push(_entity);
		return true;
	}

	function removeEntity( _entity )
	{
		if (this.m.InShutdown)
		{
			return;
		}

		if (this.m.ActiveEntityMouseHover != null && this.m.ActiveEntityMouseHover.getID() == _entity.getID())
		{
			if (this.m.OnEntityMouseLeaveListener != null)
			{
				this.m.OnEntityMouseLeaveListener(this.m.ActiveEntityMouseHover);
			}

			this.m.ActiveEntityMouseHover = null;
		}

		local allIndex = this.m.AllEntities.find(_entity);

		if (allIndex != null)
		{
			this.m.AllEntities.remove(allIndex);
		}

		local currentIndex = this.m.CurrentEntities.find(_entity);

		if (currentIndex != null)
		{
			if (currentIndex == 0)
			{
				this.initNextTurn(true);
			}
			else
			{
				if (this.m.CurrentEntities[currentIndex].isAlive())
				{
					this.m.CurrentEntities[currentIndex].onTurnEnd();
				}

				this.m.CurrentEntities.remove(currentIndex);

				if (currentIndex < this.m.MaxVisibleEntities)
				{
					this.m.JSHandle.asyncCall("removeEntity", _entity.getID());

					if (this.m.CurrentEntities.len() >= this.m.MaxVisibleEntities)
					{
						local entityToAddIndex = this.Math.min(this.m.CurrentEntities.len() - 1, this.m.MaxVisibleEntities - 1);
						this.m.JSHandle.asyncCall("addEntity", this.convertEntityToUIData(this.m.CurrentEntities[entityToAddIndex], entityToAddIndex == this.m.CurrentEntities.len() - 1));
					}
				}
			}

			this.m.LastRemoveTime = this.Time.getRealTimeF();
		}

		this.m.ActiveEntityMouseHover = null;
		this.checkBattleEndedCondition();
	}

	function removeEntities()
	{
		this.m.AllEntities = [];
		this.m.CurrentEntities = [];
		this.m.JSHandle.call("clear", null);
	}

	function checkEnemyRetreat()
	{
		if (this.m.OnCheckEnemyRetreatListener != null)
		{
			this.m.IsBusy = true;
			this.m.OnCheckEnemyRetreatListener();
		}
	}

	function initNextRound()
	{
		if (this.m.IsBattleEnded)
		{
			this.logDebug("Info: Battle ended after " + this.m.CurrentRound + " Round(s).");
			return;
		}

		this.m.IsLocked = true;
		this.m.JSHandle.call("clear", null);

		foreach( entity in this.m.CurrentEntities )
		{
			entity.onTurnEnd();
		}

		foreach( entity in this.m.AllEntities )
		{
			entity.onRoundEnd();
		}

		this.m.CurrentEntities = [];
		this.m.ActiveEntityMouseHover = null;

		if (this.m.AllEntities.len() > 0)
		{
			++this.m.CurrentRound;

			if (this.m.OnNextRoundListener != null)
			{
				this.m.OnNextRoundListener(this.m.CurrentRound);
			}

			local temp = clone this.m.AllEntities;

			foreach( entity in temp )
			{
				entity.onRoundStart();
			}

			if (this.m.AllEntities.len() == 0)
			{
				return;
			}

			this.m.CurrentEntities = clone this.m.AllEntities;
			this.m.CurrentEntities.sort(this.compareEntitiesByInitiative);

			foreach( entity in this.m.CurrentEntities )
			{
				entity.setWaitActionSpent(false);
			}

			this.m.CurrentEntities[0].onBeforeActivation();
			this.m.TurnPosition = 0;
			local entitiesToAdd = this.Math.min(this.m.CurrentEntities.len(), this.m.MaxVisibleEntities);

			for( local i = 0; i < entitiesToAdd; i = ++i )
			{
				this.m.JSHandle.call("addEntity", this.convertEntityToUIData(this.m.CurrentEntities[i], i == this.m.CurrentEntities.len() - 1));
			}

			this.m.IsSkippingRound = false;
			this.m.IsWaitingRound = false;
			this.m.JSHandle.call("setEndTurnAllButtonVisible", true);
			this.m.JSHandle.call("setWaitTurnAllButtonVisible", true);
		}
	}

	function initNextTurn( _force = false )
	{
		if (this.m.IsBattleEnded)
		{
			return;
		}

		if (this.m.IsLocked)
		{
			return;
		}

		if (!_force && (this.Time.hasEventScheduled(this.TimeUnit.Virtual) || this.Tactical.State.isPaused()))
		{
			return;
		}

		if (this.m.OnNextTurnListener != null)
		{
			if (!this.m.OnNextTurnListener())
			{
				return;
			}
		}

		if (this.m.CurrentEntities.len() <= 1)
		{
			if (!this.m.IsInitNextRound)
			{
				this.m.IsInitNextRound = true;
				this.m.CheckEnemyRetreat = true;
			}

			return;
		}

		local activeEntity = this.m.CurrentEntities[0];

		if (this.m.CurrentEntities.len() > 1)
		{
			this.m.CurrentEntities[1].onBeforeActivation();
		}

		this.m.IsLocked = true;
		this.m.JSHandle.asyncCall("removeEntity", activeEntity.getID());
		activeEntity.onTurnEnd();
		this.m.CurrentEntities.remove(0);
		++this.m.TurnPosition;
		this.m.IsLastEntityPlayerControlled = activeEntity.isPlayerControlled() || "isUnderAIControl" in activeEntity && activeEntity.isUnderAIControl();

		if (this.m.CurrentEntities.len() >= this.m.MaxVisibleEntities)
		{
			local entityToAddIndex = this.Math.min(this.m.CurrentEntities.len() - 1, this.m.MaxVisibleEntities - 1);
			this.m.JSHandle.asyncCall("addEntity", this.convertEntityToUIData(this.m.CurrentEntities[entityToAddIndex], entityToAddIndex == this.m.CurrentEntities.len() - 1));
		}
	}

	function initNextTurnBecauseOfWait()
	{
		if (this.m.IsBattleEnded)
		{
			return;
		}

		if (this.m.IsLocked)
		{
			return;
		}

		if (this.Time.hasEventScheduled(this.TimeUnit.Virtual) || this.Tactical.State.isPaused())
		{
			return;
		}

		if (this.m.OnNextTurnListener != null)
		{
			if (!this.m.OnNextTurnListener())
			{
				return;
			}
		}

		if (this.m.CurrentEntities.len() == 1)
		{
			if (!this.m.IsInitNextRound)
			{
				this.m.IsInitNextRound = true;
				this.m.CheckEnemyRetreat = true;
			}

			return;
		}

		local activeEntity = this.m.CurrentEntities[0];

		if (this.m.CurrentEntities.len() > 1)
		{
			this.m.CurrentEntities[1].onBeforeActivation();
		}

		this.m.IsLocked = true;
		this.m.JSHandle.call("removeEntity", activeEntity.getID());
		this.m.CurrentEntities.remove(0);
		this.m.CurrentEntities.push(activeEntity);
		activeEntity.wait();
		++this.m.TurnPosition;
		local entityToAddIndex = this.Math.min(this.m.CurrentEntities.len() - 1, this.m.MaxVisibleEntities - 1);
		this.m.JSHandle.asyncCall("addEntity", this.convertEntityToUIData(this.m.CurrentEntities[entityToAddIndex], entityToAddIndex == this.m.CurrentEntities.len() - 1));
	}

	function pushEntityBack( _entityId )
	{
		if (this.m.IsBattleEnded)
		{
			return;
		}

		if (this.m.IsLocked)
		{
			return;
		}

		if (this.m.CurrentEntities.len() <= 2)
		{
			return;
		}

		local idx = 0;
		local entity;

		foreach( i, e in this.m.CurrentEntities )
		{
			if (e.getID() == _entityId)
			{
				idx = i;
				entity = e;
				break;
			}
		}

		if (entity == null || idx == this.m.CurrentEntities.len() - 1)
		{
			return;
		}

		this.m.CurrentEntities.remove(idx);
		this.m.CurrentEntities.push(entity);

		if (idx < this.m.MaxVisibleEntities)
		{
			this.m.JSHandle.call("removeEntity", _entityId);
			local entityToAddIndex = this.Math.min(this.m.CurrentEntities.len() - 1, this.m.MaxVisibleEntities - 1);
			this.m.JSHandle.asyncCall("addEntity", this.convertEntityToUIData(this.m.CurrentEntities[entityToAddIndex], entityToAddIndex == this.m.CurrentEntities.len() - 1));
		}
	}

	function moveEntityToFront( _entityId )
	{
		if (this.m.IsBattleEnded)
		{
			return;
		}

		if (this.m.IsLocked)
		{
			return;
		}

		if (this.m.CurrentEntities.len() <= 2)
		{
			return;
		}

		local idx = 0;
		local entity;

		foreach( i, e in this.m.CurrentEntities )
		{
			if (e.getID() == _entityId)
			{
				idx = i;
				entity = e;
				break;
			}
		}

		if (entity == null || entity.isTurnDone() || idx == 1)
		{
			return;
		}

		this.m.CurrentEntities.remove(idx);
		this.m.CurrentEntities.insert(1, entity);
		this.m.JSHandle.call("removeEntity", _entityId);
		this.m.JSHandle.call("insertEntity", {
			id = _entityId,
			index = 1
		});
	}

	function updateEntity( _entityId )
	{
		if (this.m.CurrentEntities.len() == 0)
		{
			return;
		}

		local entity = this.findEntityByID(this.m.AllEntities, _entityId);

		if (entity != null && entity.entity.isAlive() && entity.entity.isPlacedOnMap())
		{
			this.Tooltip.reloadDataIfEqual(_entityId);
			entity = this.findEntityByID(this.m.CurrentEntities, _entityId);

			if (entity != null && entity.index < this.m.MaxVisibleEntities)
			{
				this.m.JSHandle.asyncCall("updateEntity", this.convertEntityToUIData(entity.entity));
			}
		}
	}

	function findEntityById( _entityID )
	{
		if (this._entityId == null)
		{
			return null;
		}

		local entity = this.findEntityByID(this.m.AllEntities, _entityID);

		if (entity != null)
		{
			return entity.entity;
		}

		return null;
	}

	function getTurnsUntilActive( _entityID )
	{
		for( local i = 0; i < this.m.CurrentEntities.len(); i = ++i )
		{
			if (this.m.CurrentEntities[i].getID() == _entityID)
			{
				return i;
			}
		}

		return null;
	}

	function setActiveEntityCostsPreview( _costsPreview )
	{
		local activeEntity = this.getActiveEntity();

		if (activeEntity != null)
		{
			local update = false;

			if (this.m.ActiveEntityCostsPreview != null)
			{
				this.m.ActiveEntityCostsPreview.id <- activeEntity.getID();
			}
			else
			{
				this.m.ActiveEntityCostsPreview = {
					id = activeEntity.getID()
				};
			}

			if ("ActionPoints" in _costsPreview)
			{
				this.m.ActiveEntityCostsPreview.actionPointsPreview <- activeEntity.getActionPoints() - _costsPreview.ActionPoints;

				if (this.m.ActiveEntityCostsPreview.actionPointsPreview < 0)
				{
					this.m.ActiveEntityCostsPreview.actionPointsPreview = activeEntity.getActionPoints();
				}

				this.m.ActiveEntityCostsPreview.actionPointsMaxPreview <- activeEntity.getActionPointsMax();
				update = true;
			}

			if ("Fatigue" in _costsPreview)
			{
				this.m.ActiveEntityCostsPreview.fatiguePreview <- activeEntity.getFatigue() + _costsPreview.Fatigue;

				if (this.m.ActiveEntityCostsPreview.fatiguePreview > activeEntity.getFatigueMax())
				{
					this.m.ActiveEntityCostsPreview.fatiguePreview = activeEntity.getFatigueMax();
				}

				this.m.ActiveEntityCostsPreview.fatigueMaxPreview <- activeEntity.getFatigueMax();
				update = true;
			}

			if (update)
			{
				activeEntity.setPreviewActionPoints(this.m.ActiveEntityCostsPreview.actionPointsPreview);
				activeEntity.setPreviewFatigue(this.m.ActiveEntityCostsPreview.fatiguePreview);

				if ("SkillID" in _costsPreview)
				{
					activeEntity.setPreviewSkillID(_costsPreview.SkillID);
				}
				else
				{
					activeEntity.setPreviewSkillID("");
				}

				this.m.JSHandle.asyncCall("updateCostsPreview", this.m.ActiveEntityCostsPreview);
			}
		}
	}

	function resetActiveEntityCostsPreview()
	{
		local activeEntity = this.getActiveEntity();

		if (activeEntity != null && this.m.ActiveEntityCostsPreview != null)
		{
			this.m.JSHandle.asyncCall("updateCostsPreview", {
				actionPointsPreview = activeEntity.getActionPoints(),
				actionPointsMaxPreview = activeEntity.getActionPointsMax(),
				fatiguePreview = activeEntity.getFatigue(),
				fatigueMaxPreview = activeEntity.getFatigueMax()
			});
			activeEntity.setPreviewActionPoints(activeEntity.getActionPoints());
			activeEntity.setPreviewFatigue(activeEntity.getFatigue());
			activeEntity.setPreviewSkillID("");
			this.m.ActiveEntityCostsPreview = null;
		}
	}

	function flashProgressbars( _flashActionPointsProgressbar, _flashFatigueProgressbar )
	{
		local activeEntity = this.getActiveEntity();

		if (activeEntity != null)
		{
			local flashBars;

			if (_flashActionPointsProgressbar)
			{
				flashBars = {
					attackPoints = true
				};
				this.Tactical.EventLog.log("[color=" + this.Const.UI.Color.NegativeValue + "]Not enough Action Points![/color]");
			}

			if (_flashFatigueProgressbar)
			{
				if (flashBars == null)
				{
					flashBars = {
						fatigue = true
					};
				}
				else
				{
					flashBars.fatigue <- true;
				}

				this.Tactical.EventLog.log("[color=" + this.Const.UI.Color.NegativeValue + "]Too much fatigue![/color]");
			}

			if (flashBars != null)
			{
				this.m.JSHandle.asyncCall("flashProgressbars", flashBars);
			}
		}
	}

	function focusActiveEntity( _force )
	{
		local activeEntity = this.getActiveEntity();

		if (activeEntity != null)
		{
			this.moveToEntity(activeEntity, false, _force);
		}
	}

	function focusEntityById( _entityId )
	{
		local entity = this.findEntityByID(this.m.CurrentEntities, _entityId);

		if (entity != null)
		{
			this.moveToEntity(entity.entity);
		}
	}

	function selectSkillById( _skillID, _select )
	{
		local activeEntity = this.getActiveEntity();

		if (activeEntity != null)
		{
			local activeSkill = activeEntity.getSkills().getSkillByID(_skillID);

			if (activeSkill && activeSkill.isUsable() && activeSkill.isAffordable())
			{
				this.m.JSHandle.asyncCall("selectSkill", {
					id = _skillID,
					select = _select
				});
			}
		}
	}

	function deselectActiveSkill()
	{
		local activeEntity = this.getActiveEntity();

		if (activeEntity != null)
		{
			this.m.JSHandle.asyncCall("unselectSkills", null);
		}
	}

	function selectEntity( _entity )
	{
		if (_entity != null)
		{
			this.deselectEntity();
			this.m.ActiveEntityMouseHover = _entity;
			this.m.JSHandle.asyncCall("selectEntity", {
				id = this.m.ActiveEntityMouseHover.getID(),
				select = true
			});
		}
	}

	function deselectEntity()
	{
		if (this.m.ActiveEntityMouseHover != null)
		{
			this.m.JSHandle.asyncCall("selectEntity", {
				id = this.m.ActiveEntityMouseHover.getID(),
				select = false
			});
			this.m.ActiveEntityMouseHover = null;
		}
	}

	function isAllyStillToAct( _entity )
	{
		foreach( e in this.m.CurrentEntities )
		{
			if (e.getID() != _entity.getID() && e.isAlliedWith(_entity) && !e.getCurrentProperties().IsStunned && e.getMoraleState() != this.Const.MoraleState.Fleeing)
			{
				return true;
			}
		}

		return false;
	}

	function isOpponentStillToAct( _entity )
	{
		foreach( e in this.m.CurrentEntities )
		{
			if (e.getID() != _entity.getID() && !e.isAlliedWith(_entity) && !e.getCurrentProperties().IsStunned && e.getMoraleState() != this.Const.MoraleState.Fleeing)
			{
				return true;
			}
		}

		return false;
	}

	function canEntityWait( _entity )
	{
		return !_entity.isWaitActionSpent() && this.m.CurrentEntities[this.m.CurrentEntities.len() - 1].getID() != _entity.getID();
	}

	function entityWaitTurn( _entity )
	{
		if (this.Time.hasEventScheduled(this.TimeUnit.Virtual) || this.Tactical.State.isPaused())
		{
			return;
		}

		local entity = this.findEntityByID(this.m.CurrentEntities, _entity.getID());

		if (entity)
		{
			if (!entity.entity.isWaitActionSpent() && _entity.getID() != this.m.CurrentEntities[this.m.CurrentEntities.len() - 1].getID())
			{
				this.initNextTurnBecauseOfWait();
				return true;
			}
		}
		else
		{
		}

		return false;
	}

	function onNextTurnButtonPressed()
	{
		if (!isHumanControlled())
		{
			return;
		}

		this.initNextTurn();
	}

	function onWaitTurnButtonPressed()
	{
		if (!isHumanControlled())
		{
			return;
		}

		this.entityWaitTurn(this.getActiveEntity());
	}

	function onEndTurnAllButtonPressed()
	{
		if (this.m.IsSkippingRound || !isHumanControlled())
		{
			return;
		}

		this.Tactical.State.showDialogPopup("End Round", "Have all your characters skip their turn until the next round starts?", function ()
		{
			this.m.IsSkippingRound = true;
			this.m.JSHandle.call("setEndTurnAllButtonVisible", false);
			this.m.JSHandle.call("setWaitTurnAllButtonVisible", false);

			foreach( e in this.m.CurrentEntities )
			{
				if (e.isPlayerControlled())
				{
					e.setSkipTurn(true);
				}
			}

			this.initNextTurn();
		}.bindenv(this), null);
	}

	function onWaitTurnAllButtonPressed()
	{
		if(this.m.IsSkippingRound || this.m.IsWaitingRound || !isHumanControlled())
		{
			return;
		}

		this.Tactical.State.showDialogPopup("Wait", "Have all your characters wait until the second phase?", function ()
		{
			this.m.IsWaitingRound = true;
			this.m.JSHandle.call("setWaitTurnAllButtonVisible", false);
			this.initNextTurnBecauseOfWait();
		}.bindenv(this), null);
	}

	function onShieldWallButtonPressed()
	{
		if(this.m.IsSkippingRound || !isHumanControlled())
		{
			return;
		}

		this.Tactical.State.showDialogPopup("Shield Wall", "Have all your characters shieldwall this turn if they can?", function ()
		{
			foreach( e in this.m.CurrentEntities )
			{
				if (e.isPlayerControlled() && !e.m.IsTurnDone) e.addAutoSkill("actives.shieldwall");
			}

			this.getActiveEntity().processAutoSkills();
		}.bindenv(this), null);
	}

	function onIgnoreButtonPressed()
	{
		if(this.m.IsSkippingRound || !isHumanControlled())
		{
			return;
		}

		this.getActiveEntity().m._isIgnored <- true;
		this.initNextTurn();
	}

	function onCancelButtonPressed()
	{
		if(m.IsLocked || !isHumanControlled()) m.CancelPending = true;
		else cancelAutoActions();
	}

	function cancelAutoActions(cancelIgnorance = true)
	{
		m.IsSkippingRound = false;
		m.IsWaitingRound = false;
		Tactical.State.m.IsEnemyRetreatDialogShown = true; // show the "enemy retreating" popup again

		foreach(e in m.AllEntities)
		{
			if(e.isPlayerControlled() || "isUnderAIControl" in e && e.isUnderAIControl())
			{
				e.clearAutoSkills();
				if(cancelIgnorance) e.m._isIgnored <- false;
				e.setSkipTurn(false);
				e.cancelAIControl();
			}
		}

		m.JSHandle.call("setEndTurnAllButtonVisible", true);
		m.JSHandle.call("setWaitTurnAllButtonVisible", true);
		m.JSHandle.call("setAIButtonVisible", true);
		m.CancelPending = false;
	}

	function onAIButtonPressed()
	{
		if(m.IsSkippingRound || !isHumanControlled())
		{
			return;
		}

		Tactical.State.showDialogPopup("AI Control", "Turn control over to the AI? (The current unit's turn will be skipped.)", function ()
		{
			cancelAutoActions(false); // reset changes we may have made (except ignoring bros)
			m.JSHandle.call("setEndTurnAllButtonVisible", false);
			m.JSHandle.call("setWaitTurnAllButtonVisible", false);
			m.JSHandle.call("setAIButtonVisible", false);
			Tactical.State.m.IsEnemyRetreatDialogShown = true; // don't show the "enemy retreating" popup
			foreach(e in m.AllEntities)
			{
				if (e.isPlayerControlled() && e.getAIAgent().ClassName == "player_agent" && !e.isGuest() &&
				    (!("_isIgnored" in e.m) || !e.m._isIgnored))
				{
					e.enableAIControl();
					e.getAIAgent().onTurnStarted();
					// agent.onTurnStarted(); // seems to cause intermittent crashes...
					//initNextTurn();
				}
			}
		}.bindenv(this), null);
	}

	function onOpenInventoryButtonPressed()
	{
		if (this.m.OnOpenInventoryButtonPressed != null)
		{
			this.m.OnOpenInventoryButtonPressed();
		}
	}

	function onSkilltreeButtonPressed()
	{
	}

	function onInventoryButtonPressed()
	{
	}

	function onQueryEntity( _entityId )
	{
		local entity = this.findEntityByID(this.m.CurrentEntities, _entityId);

		if (entity != null)
		{
			return this.convertEntityToUIData(entity.entity, entity.index == this.m.CurrentEntities.len() - 1);
		}

		return null;
	}

	function onQueryEntitySkills( _entityId )
	{
		local entity = this.findEntityByID(this.m.CurrentEntities, _entityId);

		if (entity != null)
		{
			return this.convertEntitySkillsToUIData(entity.entity);
		}

		return null;
	}

	function onQueryEntityStatusEffects( _entityId )
	{
		local entity = this.findEntityByID(this.m.CurrentEntities, _entityId);

		if (entity != null)
		{
			return this.convertEntityStatusEffectsToUIData(entity.entity);
		}

		return null;
	}

	function onEntityEntersFirstSlot( _entityId )
	{
		if(m.CancelPending) cancelAutoActions();
		local entity = this.findEntityByID(this.m.AllEntities, _entityId);

		if (entity)
		{
			if (!entity.entity.isWaitActionSpent() && !entity.entity.isTurnStarted())
			{
				entity.entity.onTurnStart();
			}
			else
			{
				entity.entity.onTurnResumed();
			}

			if (!entity.entity.isAlive())
			{
				return null;
			}

			this.moveToEntity(entity.entity, this.m.JumpToFirstEntity);
			this.m.JumpToFirstEntity = false;
			return this.convertEntityToUIData(entity.entity, entity.index == this.m.CurrentEntities.len() - 1);
		}

		return null;
	}

	function onEntityEnteredFirstSlot( _entityId )
	{
		local entity = this.findEntityByID(this.m.CurrentEntities, _entityId);

		if (entity)
		{
			if (this.m.OnEntityEnteredFirstSlotListener != null)
			{
				this.m.OnEntityEnteredFirstSlotListener(entity.entity);
			}
		}
	}

	function onEntityEnteredFirstSlotFully( _entityId )
	{
		local entity = this.findEntityByID(this.m.CurrentEntities, _entityId);

		if (entity)
		{
			if (this.m.OnEntityEnteredFirstSlotFullyListener != null)
			{
				this.m.OnEntityEnteredFirstSlotFullyListener(entity.entity);
			}

			this.m.IsLocked = false;
			local e = entity.entity;
			if(e.isPlayerControlled())
			{
				if("_isIgnored" in e.m && e.m._isIgnored) initNextTurn();
				else if(m.IsWaitingRound) onWaitTurnButtonPressed();
			}
		}
	}

	function onEntityClicked( _entityId )
	{
		if (!this.Tactical.CameraDirector.isInputAllowed())
		{
			return;
		}

		local entity = this.findEntityByID(this.m.CurrentEntities, _entityId);

		if (entity)
		{
			this.moveToEntity(entity.entity, false, true);
		}
	}

	function onEntityMouseEnter( _entityId )
	{
		local entity = this.findEntityByID(this.m.CurrentEntities, _entityId);

		if (entity)
		{
			this.m.ActiveEntityMouseHover = entity.entity;

			if (this.m.OnEntityMouseEnterListener != null)
			{
				this.m.OnEntityMouseEnterListener(this.m.ActiveEntityMouseHover);
			}
		}
	}

	function onEntityMouseLeave( _entityId )
	{
		local entity = this.findEntityByID(this.m.CurrentEntities, _entityId);

		if (entity)
		{
			if (this.m.OnEntityMouseLeaveListener != null)
			{
				this.m.OnEntityMouseLeaveListener(entity.entity);
			}

			this.m.ActiveEntityMouseHover = null;
		}
	}

	function onEntitySkillClicked( _data )
	{
		if (this.m.OnEntitySkillClickedListener == null)
		{
			return;
		}

		local activeEntity = this.getActiveEntity();

		if (activeEntity != null && activeEntity.getID() == _data.entityId)
		{
			this.m.OnEntitySkillClickedListener(_data.skillId);
		}
		else
		{
			this.logDebug("ERROR: Skill was clicked for an unknown entity!");
		}
	}

	function onEntitySkillCancelClicked( _data )
	{
		if (this.m.OnEntitySkillCancelClickedListener == null)
		{
			return;
		}

		local activeEntity = this.getActiveEntity();

		if (activeEntity != null && activeEntity.getID() == _data.entityId)
		{
			this.m.OnEntitySkillCancelClickedListener(_data.skillId);
		}
		else
		{
			this.logDebug("ERROR: Skill cancel was clicked for an unknown entity!");
		}
	}

	function checkBattleEndedCondition()
	{
		this.Time.scheduleEvent(this.TimeUnit.Real, 50, function ( _d )
		{
			this.Tactical.Entities.checkCombatFinished();
			_d.m.IsBattleEnded = this.Tactical.Entities.isCombatFinished();
		}.bindenv(this), this);
	}

	function moveToEntity( _entity, _jumpToEntity = false, _force = false )
	{
		if (!_entity.isHiddenToPlayer())
		{
			local camera = this.Tactical.getCamera();

			if (!_jumpToEntity)
			{
				local entityTile = _entity.getTile();

				if (_force || !camera.isInsideScreen(_entity.getPos()))
				{
					if (this.Tactical.CameraDirector.isIdle())
					{
						camera.moveTo(_entity, 200.0);
					}
					else
					{
						this.Tactical.CameraDirector.addMoveToTileEvent(0, _entity.getTile());
					}
				}
				else if (this.Tactical.CameraDirector.isIdle())
				{
					camera.Level = camera.getBestLevelForTile(entityTile);
				}
				else
				{
					this.Tactical.CameraDirector.addMoveToTileEventIfNotVisible(0, _entity.getTile());
				}
			}
			else if (this.Tactical.CameraDirector.isIdle())
			{
				camera.jumpTo(_entity);
			}
			else
			{
				this.Tactical.CameraDirector.addMoveToTileEventIfNotVisible(0, _entity.getTile());
			}
		}
	}

	function convertEntityToUIData( _entity, isLastEntity = false )
	{
    // if it is or will be human controlled
		local humanControlled = _entity.isPlayerControlled() && (_entity.getAIAgent() == null || _entity.getAIAgent().ClassName == "player_agent" || m.CancelPending);
		local result = {
			id = _entity.getID(),
			name = _entity.getName(),
			nameOnly = _entity.getNameOnly(),
			levelImagePath = _entity.getLevelImagePath(),
			imageOffsetX = _entity.isDiscovered() ? _entity.getImageOffsetX() : 0,
			imageOffsetY = _entity.isDiscovered() ? _entity.getImageOffsetY() : 0,
			actionPoints = _entity.getActionPoints(),
			actionPointsMax = _entity.getActionPointsMax(),
			hitpoints = _entity.getHitpoints(),
			hitpointsMax = _entity.getHitpointsMax(),
			morale = _entity.getMoraleState(),
			moraleMax = this.Const.MoraleState.COUNT - 1,
			moraleLabel = this.Const.MoraleStateName[_entity.getMoraleState()],
			fatigue = _entity.getFatigue(),
			fatigueMax = _entity.getFatigueMax(),
			armorHead = _entity.getArmor(this.Const.BodyPart.Head),
			armorHeadMax = _entity.getArmorMax(this.Const.BodyPart.Head),
			armorBody = _entity.getArmor(this.Const.BodyPart.Body),
			armorBodyMax = _entity.getArmorMax(this.Const.BodyPart.Body),
			isEnemy = !humanControlled || this.Tactical.State.isAutoRetreat(),
			isHiddenToPlayer = _entity.isHiddenToPlayer() || _entity.getFaction() != 1 && this.Settings.getGameplaySettings().FasterAIMovement || this.Tactical.State.isAutoRetreat(),
			isWaitActionSpent = !this.canEntityWait(_entity)
		};

		if (_entity.isDiscovered())
		{
			result.imagePath <- _entity.getImagePath();
		}
		else
		{
			result.imagePathFoW <- _entity.getImagePath();
		}

		return result;
	}

	function convertEntitySkillsToUIData( _entity )
	{
		if (_entity.isPlayerControlled())
		{
			local result = [];
			local activeSkills = _entity.getSkills().queryActives();

			foreach( skill in activeSkills )
			{
				if (skill.isHidden())
				{
					continue;
				}

				local isSkillAffordable = skill.isAffordable();

				if (this.m.ActiveEntityCostsPreview != null && this.m.ActiveEntityCostsPreview.id == _entity.getID())
				{
					isSkillAffordable = skill.isAffordablePreview();
				}

				result.push({
					id = skill.getID(),
					imagePath = skill.getIcon(),
					isUsable = skill.isUsable() && skill.isAffordable(),
					isAffordable = isSkillAffordable
				});
			}

			foreach(item in _entity.querySwitchableItems())
				result.push({ id = item.getInstanceID(), imagePath = "ui/items/" + item.getIcon(), isUsable = true, isAffordable = true });

			return result;
		}

		return null;
	}

	function convertEntityStatusEffectsToUIData( _entity )
	{
		if (_entity.isPlayerControlled())
		{
			local result = [];
			local statusEffects = _entity.getSkills().query(this.Const.SkillType.StatusEffect);

			foreach( statusEffect in statusEffects )
			{
				if (statusEffect.isHidden())
				{
					continue;
				}

				result.push({
					id = statusEffect.getID(),
					imagePath = statusEffect.getIcon()
				});
			}

			return result;
		}

		return null;
	}

	function findEntityByID( _array, _entityId )
	{
		if (_array == null || _array.len() == 0 || _entityId == null)
		{
			return null;
		}

		for( local i = 0; i < _array.len(); i = ++i )
		{
			if (_array[i] != null && _entityId == _array[i].getID())
			{
				return {
					entity = _array[i],
					index = i
				};
			}
		}

		return null;
	}

	function compareEntitiesByInitiative( _entity1, _entity2 )
	{
		local initiative1 = _entity1.getTurnOrderInitiative();
		local initiative2 = _entity2.getTurnOrderInitiative();

		if (initiative1 > initiative2)
		{
			return -1;
		}
		else if (initiative1 < initiative2)
		{
			return 1;
		}

		return 0;
	}

	function reloadVisibleEntities()
	{
		local maxVisibleIndex = this.Math.min(this.m.CurrentEntities.len(), this.m.MaxVisibleEntities);

		for( local i = 0; i < maxVisibleIndex; i = ++i )
		{
			this.m.JSHandle.asyncCall("addEntity", this.convertEntityToUIData(this.m.CurrentEntities[i], i == maxVisibleIndex - 1));
		}
	}

	function update()
	{
		if (this.m.IsInitNextRound)
		{
			if (this.m.CheckEnemyRetreat)
			{
				this.m.CheckEnemyRetreat = false;
				this.checkEnemyRetreat();
			}
			else if (!this.m.IsBusy)
			{
				this.m.IsInitNextRound = false;
				this.initNextRound();
			}
		}
	}

});

