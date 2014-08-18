package flixel.addons.transition;

import flixel.FlxState;

/**
 * FlxTransitionStates adds the ability to perform visual transitions when the state begins and ends.
 * 
 * Usage:
 * 
 * First, extend FlxTransitionState as ie, FooState
 * 
 * Method 1: 
 *  
 *  var in:TransitionData = new TransitionData(...);		//add your data where "..." is
 *  var out:TransitionData = new TransitionData(...);
 * 
 *  FlxG.switchState(new FooState(in,out));
 * 
 * Method 2:
 * 
 *  FlxTransitionState.defaultTransIn = new TransitionData(...);
 *  FlxTransitionState.defaultTransOut = new TransitionData(...);
 *  
 *  FlxG.switchState(new FooState());
 * 
 * WHEN EXITING:
 *  
 *  USE transitionToState(NextState) 
 * 
 */

class FlxTransitionState extends FlxState
{
	//global default transitions for ALL states, used if _transIn/_transOut are null
	public static var defaultTransIn:TransitionData=null;
	public static var defaultTransOut:TransitionData=null;
	
	//beginning & ending transitions for THIS state:
	public var _transIn:TransitionData;
	public var _transOut:TransitionData;
	
	public var transOutFinished(default, null):Bool = false;
	
	/**
	 * Create a state with the ability to do visual transitions
	 * @param	TransIn		Plays when the state begins
	 * @param	TransOut	Plays when the state ends
	 */
	
	public function new(?TransIn:TransitionData,?TransOut:TransitionData)
	{
		_transIn = TransIn;
		_transOut = TransOut;
		if (_transIn == null && defaultTransIn != null)
		{
			_transIn = defaultTransIn;
		}
		if (_transOut == null && defaultTransOut != null)
		{
			_transOut = defaultTransOut;
		}
		super();
	}
	
	override public function destroy():Void
	{
		_transIn = null;
		_transOut = null;
		_onExit = null;
	}
	
	override public function create():Void 
	{
		super.create();
		
		if (_transIn != null && _transIn.type != NONE)
		{
			var _trans = getTransition(_transIn);
		
			_trans.setStatus(FULL);
			openSubState(_trans);
			
			_trans.finishCallback = finishTransIn;
			_trans.start(OUT);
		}
	}
	
	public function transitionToState(Next:FlxState):Void
	{
		exitTransition(
			function():Void
			{
				FlxG.switchState(Next);
			}
		);
	}
	
	private var _onExit:Void->Void;
	
	private function getTransition(data:TransitionData):Transition
	{
		switch(data.type)
		{
			case TILES:	return new TileTransition(data);
			case FADE:	return new FadeTransition(data);
			default:
		}
		
		return null;
	}
	
	private function finishTransIn()
	{
		closeSubState();
	}
	
	private function finishTransOut()
	{
		transOutFinished = true;
		if (_onExit != null)
		{
			_onExit();
		}
		//closeSubState();
	}
	
	private function exitTransition(?OnExit:Void->Void):Void
	{
		_onExit = OnExit;
		if (_transOut != null && _transOut.type != NONE)
		{
			var _trans = getTransition(_transOut);
			
			_trans.setStatus(EMPTY);
			openSubState(_trans);
			
			_trans.finishCallback = finishTransOut;
			_trans.start(IN);
		}
		else
		{
			_onExit();
		}
	}
}