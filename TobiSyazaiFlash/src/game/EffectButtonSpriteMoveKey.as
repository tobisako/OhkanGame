package game {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * ...
	 * @author tobisako
	 */
	public class EffectButtonSpriteMoveKey  extends Sprite
	{
		[Embed(source = "img/btn_left.png")] private var e_btn_left:Class;
		[Embed(source = "img/btn_right.png")] private var e_btn_right:Class;
		[Embed(source = "img/btn_retry.png")] private var e_btn_retry:Class;
		private var callback:Function;
		private var btn:Sprite;
		private var bDoAnime:Boolean;
		private var cnt:int;

		public function EffectButtonSpriteMoveKey(muki:int, cb:Function) 
		{
			var img:Bitmap;
			callback = cb;
			bDoAnime = false;
			
			// ボタン画像
			switch( muki ) {
			case 0:		img = new e_btn_left() as Bitmap;		break;
			case 1:		img = new e_btn_right() as Bitmap;		break;
			case 2:		img = new e_btn_retry() as Bitmap;		break;
			}
			img.x = img.width / 2 * -1;
			img.y = img.height / 2 * -1;
			addChild( img );
			
			// マウスボタン用リスナー登録
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseClick);
			// フレーム用リスナー登録
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		// ボタンが押されたらエフェクトする。
		private function onMouseClick(e:Event):void
		{	// エフェクト開始
		
			if ( !bDoAnime ) {
				bDoAnime = true;
				cnt = 0;
				this.scaleZ = 1;
			}
			// コールバックでボタン押下を通知する
			callback();
		}

		// フレーム・コールバック
		private function onEnterFrame(e:Event):void 
		{
			cnt++;
			if ( cnt < 3 ) {
				this.scaleX -= 0.2;
				this.scaleY -= 0.2;
			} else if ( cnt < 6 ) {
				this.scaleX += 0.2;
				this.scaleY += 0.2;
			} else {
				this.scaleX = 1;
				this.scaleY = 1;
				bDoAnime = false;
			}
		}
	}
}
