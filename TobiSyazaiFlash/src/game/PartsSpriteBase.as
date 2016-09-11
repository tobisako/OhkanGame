package game 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ゲーム用スプライト・パーツのベースクラス（Vector格納用）…このクラスを継承してパーツを作ることにする。
	 * オブジェクトで「積み重なる」・「動いた時に追従する」機能を、ベースクラスで実装する。
	 * @author tobisako
	 */
	public class PartsSpriteBase extends Sprite
	{
		protected var f_width:int;		// フィールドの幅
		private var f_height:int;		// フィールドの高さ
		protected var onMountObj:PartsSpriteBase;	// 自分の上にのっかってるオブジェクト
		protected var underMountObj:PartsSpriteBase;	// 自分の足元のオブジェクト（地面の場合はnull）
		protected var bIsMounting:Boolean;		// 自分がだれかの上にのっかっているかフラグ
		protected var mountedRect:Rectangle;
		protected var mountingPoint:Point;
		private var targetPoint:Point;			// 当たり判定用
		private var chkPoint:Point;				// 当たり判定用
		protected var topCenterPoint:Point;		// 中央値

		// コンストラクタ
		public function PartsSpriteBase(w:int = 0, h:int = 0, b:Boolean = false) 
		{
			f_width = w;
			f_height = h;
			bIsMounting = b;
			onMountObj = null;
			underMountObj = null;
 			mountedRect = new Rectangle();
			mountingPoint = new Point();
			targetPoint = new Point();
			chkPoint = new Point();
			topCenterPoint = new Point( this.x - (this.width / 2), this.y - 5 );

			// Event.REMOVED_FROM_STAGE
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		// オブジェクトが画面外に消えたかをチェック
		public function checkOutOfScreen():Boolean {

			// 上方部に消えたかチェック（少し余裕を持たせる）
			if ( this.y < 0 - this.height - 20 ) return true;

			// 左側に消えたかチェック
			if ( this.x < 0 - this.width ) return true;
			
			// 右側に消えたかチェック
			if ( this.x > f_width + this.width) return true;

			// 下方部に消えたかチェック（少し余裕を持たせる）
		//	if ( this.y - (this.height/2) > f_height ) return true;
			if ( this.y - (this.height>>1) > f_height ) return true;

			return false;
		}

		// 「俺の頭の上に何かのっているか？」チェック＆合体処理
		public function onMountCheck(target:PartsSpriteBase):Boolean
		{
			// もし自分の上に既に物体が乗っていたら、判定はそっちに任せる
			if (onMountObj != null) {
				return onMountObj.onMountCheck(target);
			}

			var r:Rectangle = this.getMountRect();
			var p:Point = target.getMountingPoint();
			if ( r.contains( p.x, p.y ) ) {
				//trace("TRUE!!!!! r.x=", r.x + ", r.y=" + r.y + ", r.w=" + r.width + ", r.h=" + r.height + ", p.x=" + p.x + ", p.y=" + p.y );
				this.setMountObject(target);	// 自分の上にターゲットを載せる。
				return true;
			}
			return false;
		}

		// 自分の上に何かが乗っかる。
		public function setMountObject(target:PartsSpriteBase):void {
			if (onMountObj != null) {
				// 既にオブジェクトが乗っていた：今回は異常系
				trace("FATAL: mount object is duplicate, hoge.");
				onMountObj = null;	// 異常系：そのまま継続する。奴は捨てる。
			}
			onMountObj = target;
			onMountObj.setMounting(this);	// 頭上のターゲットに「お前は着地した」と通知する。
		}

		// 自分が何かの上に乗った・自分の足元に何かがいる（自分は停止した）事を設定する
		protected function setMounting(ob:PartsSpriteBase):void {
			bIsMounting = true;		// 俺の足元に何かがいるフラグＯＮ
			underMountObj = ob;		// 足元の奴が誰なのか覚えておく。
		}

		// 自分の上のマウントエリアを取得
		public function getMountRect():Rectangle {
			trace("err!");
			return mountedRect;
		}
		
		// 自分の下のヒットエリアを取得
		public function getMountingPoint():Point {
			trace("err!");
			return mountingPoint;
		}
		
		// 自分の頭上中央点を返す（重ねる時の中心点ゲット用）
		protected function getCenterTopPoint():Point {
			topCenterPoint.x = this.x;	//  - (this.width / 2);
			//topCenterPoint.y = this.y - (this.height / 2) + 2;
			topCenterPoint.y = this.y - (this.height >> 1) + 2;
			return topCenterPoint;
		}

		// 自分がはじけ飛んだ（マウント解除された）・・・足元のオブジェクトに通知し、頭上オブジェクトにも通知する。
		public function dropOutMe():void {
			// もし自分の下に物体がいたら、そいつに解除を通知する
			if ( underMountObj != null ) {
				underMountObj.removeOnMountObject();	// 下の奴に「お前の上が消えたぞ」と知らせてやる
				underMountObj = null;					// リンク解除
			}
			// もし自分の上に既に物体が乗っていたら、そいつもはじけ飛ばせる
			if (onMountObj != null) {
				onMountObj.dropOutMe();
				onMountObj = null;		// 接続解除
			}
			bIsMounting = false;		// マウントフラグ解除
		}

		//　自分の頭上オブジェクトが消えた処理
		private function removeOnMountObject():void {
			onMountObj = null;		// 頭上をクリアする
		}

		// ヒットチェック準備（１フレームに１回だけ実行して速度向上を狙う）
		public function createHitBitmapData(base:DisplayObject):void {
			bdTargetObj = createBitmapData2(base, this);
		}
		
		protected var bdTargetObj:Object;

		// ヒットチェック（Ｐｏｉｎｔ）
		public function onHitCheckPoint(paredisp:DisplayObject, x:int, y:int):Boolean {
			// 事前確認：範囲外チェック（負荷削減の為）
			//if ( this.hitTestPoint( x, y ) == false ) return false;
			
			// 回転画像
			//var bdTargetObj:Object = createBitmapData2( paredisp, this );	// 女神ターゲット
			//var bdTargetObj:Object = createBitmapData2( paredisp, this );	// 女神ターゲット
			if ( bdTargetObj == null) return false;	
			
			var bdTarget:BitmapData = bdTargetObj.bd;

			targetPoint.x = bdTargetObj.rect.x;
			targetPoint.y = bdTargetObj.rect.y;

			chkPoint.x = x;
			chkPoint.y = y;

			return bdTarget.hitTest( targetPoint, 0xFF, chkPoint );			
		}

		// 回転した画像のヒットチェックを行うための「BitmapData」を取得する
		protected function createBitmapData2(base:DisplayObject, src:DisplayObject):Object
		{
			var rect:Rectangle = src.getBounds( base );
			var matrix:Matrix = src.transform.matrix;
			matrix.tx = src.x - rect.x;
			matrix.ty = src.y - rect.y;
 
			var bd:BitmapData = new BitmapData(rect.width, rect.height, true, 0x0);

		//	bd.width = rect.width;
		//	bd.height = rect.height;

			//trace("w=" + rect.width + ", h=" + rect.height);
			bd.draw(src, matrix);
			return {"bd":bd, "rect":rect};
		}

		// 積み上げ数チェック（自分より上に何匹のっているか？）
		public function checkOnMountObjectNum():int {
			if (onMountObj != null) {
				return 1 + onMountObj.checkOnMountObjectNum();
			} else {
				return 1;
			}
		}

		// ステージからＲＥＭＯＶＥされた時のイベント（後処理）
		private function onRemovedFromStage(e:Event):void {
			trace("RemovedFromStage!(BASE)");
		}

		// 追従移動
		public function doTrackingMove(centerx:int = 0):void {
			// 誰かの上に載っているなら、下の奴の位置に合わせてやる処理
			this.x = (underMountObj.getCenterTopPoint()).x;
			this.y = (underMountObj.getCenterTopPoint()).y - (this.height >> 1);
			// 自分の上に王冠とか乗っている場合は、そいつにも移動指示してやる
			if (onMountObj != null) onMountObj.doTrackingMove( getMountingPoint().x );	// 移動を連携させる
		}

		// 移動処理（ベース）
		public function doMove(centerx:int = 0):void {
		//	if (bIsMounting) {
		//		// 下の奴に場所を聞く。
		//		this.x = (underMountObj.getCenterTopPoint()).x;
		//	//	this.y = (underMountObj.getCenterTopPoint()).y - (this.height / 2);
		//		this.y = (underMountObj.getCenterTopPoint()).y - (this.height >> 1);
		//	}
			// 移動判断処理
			//if ( this.x > centerx ) this.x --;
			//else if ( this.x < centerx ) this.x ++;

			// まずは純粋に追従する.
		//	this.x = centerx;

			// 自分の上に王冠とか乗っている場合は、そいつにも移動指示してやる
		//	if (onMountObj != null) onMountObj.doMove(this.x);	// 移動を連携させる
		}
	}
}
