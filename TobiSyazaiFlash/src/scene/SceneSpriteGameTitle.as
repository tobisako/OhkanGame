package scene 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import parts.EffectButtonSprite;
	import parts.SoundParts;

	/**
	 * ...
	 * @author tobisako
	 */
	public class SceneSpriteGameTitle extends AqtorScreenTransSprite implements AqtorScreenTransSpriteInterface
	{
		private var st:AqtorScreenTransition;
		[Embed(source = "../img/bg_gametitle.png")] private var e_title:Class;
		[Embed(source = "../img/btn_gamestart.png")] private var e_btn_start:Class;
		private var btn_start:EffectButtonSprite;
		private var btn_modoru:EffectButtonSprite;
		private var s:SoundParts;
		private var backtimer:Timer;

		public function SceneSpriteGameTitle(st:AqtorScreenTransition)
		{
			this.st = st;
			addChild( new e_title() as Bitmap );

			//　スタートボタンを作る。
			btn_start = new EffectButtonSprite( onPushedStartButton );
			btn_start.x = 260;
			btn_start.y = 1680;
			
			// 戻るボタンを作る
			btn_modoru = new EffectButtonSprite( onPushedModoruButton, 1 );
			btn_modoru.x = 700;
			btn_modoru.y = 1680;
			
			// サウンド
			s = new SoundParts( 4 );		// 説明サウンド

			// デバッグ
		//	var n:Nyanko = new Nyanko();
		//	n.x = 50;
		//	n.y = 50;
		//	addChild( n );

			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		// addChild()された時に呼び出されるコールバック（起動時１回しか呼び出されない）
		private function addedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addChild( btn_start );
			addChild( btn_modoru );
		}
		
		// スタートボタン押下時のコールバック
		private function onPushedStartButton():void
		{
			st.goScreenTransition( 2 );
		}

		// もどるボタン押下時のコールバック
		private function onPushedModoruButton():void
		{
			// [201609]戻る処理コメントアウト
			// st.goScreenTransition( 0, 6 );
		}

		// タイマー設定・再設定処理
		private function setTimeUpTimer():void {
			// 既存タイマーＣＢ解除
			if (backtimer != null) {
				backtimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeUp);
				backtimer = null;
			}
			// ３０秒タイマ設定
			backtimer = new Timer(1000);	// タイマ生成（毎回作り直す）
			backtimer.repeatCount = 30;		// ３０秒
			backtimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeUp);
			backtimer.start();
		}

		// ３０秒タイムアップＣＢ
		private function onTimeUp(te:TimerEvent):void
		{
			// [201609]戻る処理コメントアウト
			// st.goScreenTransition( 0, 6 );
		}

		// 【画面遷移】　初期化処理
		public override function onInitScene(param:int = 0):void {
			s.play();
			setTimeUpTimer();
		}

		// 【画面遷移】　終了処理
		public override function onLeaveScene(param:int = 0):void {
			s.stop();
			if (backtimer != null) {
				backtimer.stop();
				backtimer = null;	// タイマ解放（ガベージコレクションさせる）
			}
		}
	}
}
