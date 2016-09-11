package scene 
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import parts.EffectButtonSprite;
	import parts.SoundParts;
	/**
	 * ...
	 * @author tobisako
	 */
	public class SceneSpriteGameClear extends AqtorScreenTransSprite
	{
		private var st:AqtorScreenTransition;
		[Embed(source = "../img/bg_gameclear.png")] private var e_gameclear:Class;
		private var btn_modoru:EffectButtonSprite;
		private var s:SoundParts;
		private var backtimer:Timer;

		public function SceneSpriteGameClear(st:AqtorScreenTransition) 
		{
			this.st = st;

			// 一覧に戻るボタン
			btn_modoru = new EffectButtonSprite(onBtnBack, 2);
			btn_modoru.x = 480;
			btn_modoru.y = 1600;
			
			// サウンド
			s = new SoundParts( 3 );		// ゲームクリアサウンド

			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		// addChild()された時に呼び出されるコールバック（起動時１回しか呼び出されない）
		private function addedToStage(event:Event):void 
		{
			// クリア画面表示
			addChild( new e_gameclear() as Bitmap );
			addChild( btn_modoru );
		}

		// 戻るボタン押下→リストへ戻る
		private function onBtnBack():void
		{
			////////////////////////////////////////
			// [201609]戻る処理コメントアウト
			
			// Ａ：オープニングデモに戻る。
			// st.goScreenTransition( 0, 6 );
			
			// Ｂ：ゲームタイトルに戻る。
			st.goScreenTransition( 1 );		// ゲームタイトル画面へジャンプ

			////////////////////////////////////////
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
			//st.goScreenTransition( 0, 6 );
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