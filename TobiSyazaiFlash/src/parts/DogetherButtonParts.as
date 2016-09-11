package parts 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * Be Dogether ボタンパーツ
	 * @author tobisako
	 */
	public class DogetherButtonParts extends Sprite
	{
		[Embed(source = "../img/doge_moji.png")] private var e_moji:Class;
		[Embed(source = "../img/doge_btn1.png")] private var e_btn1:Class;
		[Embed(source = "../img/doge_btn2.png")] private var e_btn2:Class;
		private var f:Function;		// ボタン押下時コールバック
		private var mode:int;
		private var img1:Bitmap;
		private var img2:Bitmap;
		private var imgmoji:Bitmap;
		private var timer:Timer;
		private var bIsAbeRight:Boolean;		// 阿倍は右だフラグ。

		public function DogetherButtonParts() 
		{
			img1 = new e_btn1() as Bitmap;
			img2 = new e_btn2() as Bitmap;
			imgmoji = new e_moji() as Bitmap;

			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		// addChild()された時に呼び出されるコールバック（起動時１回しか呼び出されない）
		private function addedToStage(event:Event):void 
		{
			// 背景マーカー設定
			var mm:Sprite = new Sprite();
			mm.graphics.beginFill(0xffffff);
			mm.graphics.drawRect(0, 0, 400, 200);
			mm.graphics.endFill();
//			addChild( mm );

			img1.x = 50;
			img1.y = 15;
			addChild( img1 );

			img2.x = 130;
			img2.y = 15;
			addChild( img2 );

			imgmoji.x = 20;
			imgmoji.y = 66;
			addChild( imgmoji );	// 阿倍文字

			// 阿倍アイコン表示
			bIsAbeRight = true;
			setAbe();		// 阿倍初期値は左。
		}

		// どっちのアイコン表示する？処理
		private function setAbe():void {
			if ( bIsAbeRight ) {	// 右だった
				// 左画像に切り替える
				//setChildIndex(img1, this.numChildren - 1);
				img1.visible = true;
				img2.visible = false;
				bIsAbeRight = false;	// 左
			} else {	// 阿倍は左だった
				// 右画像に切り替える
				//setChildIndex(img2, this.numChildren - 1);
				img1.visible = false;
				img2.visible = true;
				bIsAbeRight = true;		// 右にする
			}
		}

		// タイマー設定・再設定処理
		private function setTimeUpTimer():void {
			// 既存タイマーＣＢ解除
			if (timer != null) {
				timer.removeEventListener(TimerEvent.TIMER, onTimeTick);
				timer = null;
			}
			// ０．５秒タイマ設定
			timer = new Timer(500);	// タイマ生成（毎回作り直す）
			//timer.repeatCount = 1;		// ３０秒
			timer.addEventListener(TimerEvent.TIMER, onTimeTick);
			timer.start();
		}

		// ３０秒タイムアップＣＢ
		private function onTimeTick(te:TimerEvent):void {
			setAbe();
		}

		// フレーム・コールバック（メインループ）
		private function onEnterFrame(e:Event):void 
		{
			img1.x = img1.x + 1;
		}
		
		// タイマーアニメスタート
		public function start():void {
			// 阿倍タイマー稼働
			setTimeUpTimer();
		}
		
		// 右左チェック
		public function getAbePos():Boolean {
			return bIsAbeRight;
		}

		// ステージからＲＥＭＯＶＥされた時のイベント（後処理）
		private function onRemovedFromStage(e:Event):void {
			if (timer != null) {
				timer = null;
			}
		}
	}
}
