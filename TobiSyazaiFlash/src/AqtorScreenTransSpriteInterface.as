package  
{
	import flash.display.Sprite;
	
	/**
	 * 画面遷移制御用スプライト
	 * @author tobisako
	 */
	public interface AqtorScreenTransSpriteInterface
	{
		function onInitScene(param:int = 0):void;
		function onLeaveScene(param:int = 0):void;
	}
}