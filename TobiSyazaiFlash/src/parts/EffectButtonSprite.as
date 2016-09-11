package parts 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * エフェクト付きボタン制御クラス
	 * @author tobisako
	 */
	public class EffectButtonSprite extends Sprite
	{
		[Embed(source = "../img/btn_gamestart.png")] private var e_btn_start:Class;
		[Embed(source = "../img/btn_back.png")] private var e_btn_back:Class;
		[Embed(source = "../img/btn_back2.png")] private var e_btn_back2:Class;
		private var callback:Function;
		private var btn_start:Sprite;
		private var bPushed:Boolean;
		private var cnt:int;

		// コンストラクタ
		public function EffectButtonSprite(cb:Function, picnum:int = 0) 
		{
			callback = cb;
			bPushed = false;

			// ボタン画像を登録
			//var img:Bitmap = (picnum == 0) ? new e_btn_start() as Bitmap : new e_btn_back() as Bitmap;
			var img:Bitmap;
			switch( picnum ) {
			case 0:	img	= new e_btn_start() as Bitmap;		break;
			case 1:	img = new e_btn_back() as Bitmap;		break;
			case 2:	img = new e_btn_back2() as Bitmap;		break;
			}
			img.x = img.width / 2 * -1;
			img.y = img.height / 2 * -1;
			addChild( img );

			// マウスボタン用リスナー登録
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}

		// ボタンが押されたらエフェクトして、しばらく待つ。
		private function onMouseClick(e:Event):void
		{
			this.callback();		// コールバック呼び出し

		//	if ( bPushed ) return;
		//	bPushed = true;
		//	cnt = 0;
			// エフェクトの不具合を修正すること。
			
			// エフェクト開始
		//	this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		// フレーム・コールバック
		private function onEnterFrame(event:Event):void 
		{
			cnt++;
			if (cnt < 5) {	// まず小さくなる
				this.scaleX -= 0.1;
				this.scaleY -= 0.06;
			} else if (cnt < 10) {
				this.scaleX += 0.2;
				this.scaleY += 0.12;
			} else if (cnt < 15) {
				this.scaleX -= 0.1;
				this.scaleY -= 0.06;
			} else if (cnt < 20) {
				bPushed = false;
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				this.callback();		// コールバック呼び出し
			}
		}
	}
}
