package  
{
	/**
	 * 画面遷移制御クラス
	 * @author tobisako
	 */
	public class AqtorScreenTransition // extends Event
	{
		public const SCENE_NOTHING:int = 0;
		// 画面遷移コールバック指定
		private var callBackFunc:Function;
		private var scene_cur:int;
		private var scene_old:int;

		public function AqtorScreenTransition(f:Function) 
		{
			
			
			
			
			// コールバックを登録する
			callBackFunc = f;
			scene_old = -1;
			scene_cur = -1;
		}

		// コールバックを呼び出す
		public function goScreenTransition(i:int = 0,para:int = 0):void
		{
			scene_old = scene_cur;	// 現時点のシーン番号を保存
			scene_cur　 = i;			// 新しいシーン番号を登録
			callBackFunc(scene_old, scene_cur, para);	// コールバック実行
		}
	}
}
