package game 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import caurina.transitions.Tweener;
	import parts.SoundParts;

	/**
	 * ...
	 * @author tobisako
	 */
	public class PartsSpriteBigKokeshi extends PartsSpriteBase
	{
		[Embed(source="img/g_big_kokeshi.png")] private var e_bkoke:Class
		private var img_bkoke:Bitmap;
		private var bActive:Boolean;			// 攻撃行動中かをチェック
		private var s1:SoundParts;

		public function PartsSpriteBigKokeshi()
		{
			super();

			// こけし画像を「中心部」に添える。
			img_bkoke = new e_bkoke() as Bitmap;
			img_bkoke.x = 0 - (img_bkoke.width / 2);
			img_bkoke.y = 0 - (img_bkoke.height / 2);
			addChild( img_bkoke );
			
			// きしみ音サウンド取り込み
			s1 = new SoundParts( 6 );
		}

		// ファーストポジション（隠れている）
		public function initPosition():void 
		{
			lfx = this.x = 1080 + 665;
			lfy = this.y = 1100;
		}

		// Tweenerをフレーム追従させる工夫
		private var lfx:int = 0;
		private var lfy:int = 0;
		private var lfrotation:Number = 0.0;

		public function get fx():int {
			return lfx;
		}
		public function set fx(x:int):void {
			lfx = x;
		}
		public function get fy():int {
			return lfy;
		}
		public function set fy(y:int):void {
			lfy = y;
		}
		public function get frotation():Number {
			return lfrotation;
		}
		public function set frotation(rr:Number):void {
			lfrotation = rr;
		}

		// Twinner実行
		public function playTwinner():void
		{
			bActive = true;

			initPosition();		// 初期位置

		// ver1	Tweener.addTween(this, {  transition:'easeOutBack', x:0, y: -578, time:5 } );

			Tweener.addTween(this, {  transition:'easeOutBack', fx:-100, fy: -578, time:5, onComplete:onCompleteHandler } );
			
			//Tweener.addTween(this, {  transition:'easeInQuint', rotation:46, time:1.2, delay:0.5 } );
			//Tweener.addTween(this, {  transition:'easeOutBounce', rotation:45, time:2.0, delay:0.5 } );
			//Tweener.addTween(this, {  transition:'easeInQuad', rotation:0, time:1.8, delay:2.5 } );
			//Tweener.addTween(this, {  transition:'easeInExpo', x:this.x, y:this.y, time:0.5, delay:4.3 } );
			s1.play();
		}
		
		// Tweener終了コールバック
		private function onCompleteHandler():void {
			bActive = false;
		}

		// ヒットチェック準備（１フレームに１回だけ実行して速度向上を狙う）
		public override function createHitBitmapData(base:DisplayObject):void {
			if (bActive) bdTargetObj = createBitmapData2(base, this);
		}

		// ヒットチェック（Ｐｏｉｎｔ）
		public override function onHitCheckPoint(paredisp:DisplayObject, x:int, y:int):Boolean {
			if (bActive) return super.onHitCheckPoint(paredisp, x, y);
			return false;	// 高速化・攻撃体制以外は当たり判定処理しない
		}

		// アクティブ状態チェック
		public function get isActive():Boolean {
			return bActive;
		}

		// 移動処理（ベース）
		public override function doMove(centerx:int = 0):void {
			// １フレームに１回だけ、ローテーション情報を反映させる。
			this.rotation = lfrotation;		// 反映。
			this.x = lfx;
			this.y = lfy;
		}
	}
}
