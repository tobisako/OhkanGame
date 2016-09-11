package game 
{
	import flash.display.Bitmap;
	import flash.display3D.textures.RectangleTexture;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * 主人公（阿倍サダオ）パーツスプライト
	 * @author tobisako
	 */
	public class PartsSpriteAbe extends PartsSpriteBase
	{
		[Embed(source = "img/g_abe.png")] private var e_abe:Class;
		private var img_abe:Bitmap;
		private var bPlayer:Boolean;	// 主人公フラグ

		public function PartsSpriteAbe(w:int, h:int, b:Boolean = false) 
		{
			super(w, h, b);			// 阿倍は基本、地面の上に最初から立っている。
									// しかし、「阿倍も降ってくる」実装が出来る様に、[b]を加えた。
			bPlayer = true;			// まだダミー。

			// 画像設定
			img_abe = new e_abe() as Bitmap;
			img_abe.x = 0 - img_abe.width / 2;
			//img_abe.y = img_abe.height / 2 * -1;
			addChild( img_abe );
		}

		// 自分の上のマウントエリアを返す
		public override function getMountRect():Rectangle {
			// 当たり判定用矩形オブジェクト
		//	mountedRect.x = this.x - (this.width / 4) + 3 - 6;
			mountedRect.x = this.x - (this.width >> 2) + 3 - 6;
		//	mountedRect.width = this.width / 2　+ 3;
			mountedRect.width = (this.width >> 1)　+ 3;
			mountedRect.y = this.y + 10;
			mountedRect.height = 7;		// 6;
			//trace("ABE RECT! x=" + mountedRect.x + ", y=" + mountedRect.y + ", w=" + mountedRect.width + ", h=" + mountedRect.height );
			return mountedRect;
		}

		// 自分の足元のヒットエリアを返す
		public override function getMountingPoint():Point {
			// 当たり判定（下）用の座標オブジェクト
			mountingPoint.x = this.x + 5;	// 阿倍補正（阿倍は中心より少し右に寄っている）
			mountingPoint.y = this.y + (this.height / 2) - 4;
			//trace("ABE POINT!");
			return mountingPoint;
		}

		// 自分の頭上中央点を返す（重ねる時の中心点ゲット用）
		protected override function getCenterTopPoint():Point {
			var tmp:Point = super.getCenterTopPoint();
			tmp.y = this.y + 9;		// 少し深くかぶる
			tmp.x = tmp.x + 8;		// 少し右に寄っている。
			return tmp;
		}

		// 阿倍サダオ・移動処理
		public override function doMove(dx:int = 0):void {
			if ( bPlayer ) {
				this.x += dx;	// 主人公の移動処理
				if ( this.x < this.width / 2 ) {
					this.x = this.width / 2;
				}
				if ( this.x > f_width - (this.width / 2) ) {
					this.x = f_width - (this.width / 2);
				}
			} else {
				super.doMove(dx);
			}
			// 自分の上に王冠とか乗っている場合は、そいつにも移動指示してやる
			if (onMountObj != null) onMountObj.doTrackingMove( getMountingPoint().x );	// 移動を連携させる
		}
	}
}
