package parts 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 * ビデオ再生窓パーツ：マスクをかけて高速描画出来る事にする。
	 * @author tobisako
	 */
	public class VideoPlayWindowParts extends Sprite
	{
		private var vs:VideoStreamParts;	// ビデオストリームパーツ
		private var cb_start:Function;		// 再生開始コールバック
		//private var cb_cuepoint:Function;	// キューポイントコールバック
		private var cb_comp:Function;		// 再生終了コールバック
		private var time_expire:Number;		// 再生後一定時間経過で画面非表示タイム
		private var timer:Timer;
		private var modenum:int;

		public function VideoPlayWindowParts(m:int = 0)
		{
			modenum = m;
			time_expire = 0.0;
			vs = new VideoStreamParts();
			//this.addChild( vs );
		}

		// 画面表示モード設定
		public function set mode(m:int):void {
			modenum = m;
		}

		// ビデオ再生開始
		public function playVideo(s:String):void {

			// ビデオ再生
			if(modenum != 0) {
				// 背景マスキングする
				var mask_sp:Sprite = new Sprite();
				var r_sp:Sprite = new Sprite();

				// ビデオ再生サイズがWidth=1080だと、これでちょうど良い。
				//r_sp.graphics.drawRect( 0, 32, 400, 177 );
				//r_sp.graphics.drawRect( 0, 0, 100, 100 );

				if (modenum == 1) {
					vs.x = 0;
					vs.y = 0;
					vs.width = 1024;
					vs.height = 580;
				} else {
					vs.x = 128;	// 191;
					vs.y = 72;	// 108;
					vs.width = 769;		// 642;
					vs.height = 436;	// 364;
					//r_sp.graphics.beginFill( 0x000000 );
					//r_sp.graphics.drawRect(0, 72, 1024, 488);	// 508);				// MODE2
					//r_sp.graphics.endFill();
				}
					r_sp.graphics.beginFill( 0x000000 );
					r_sp.graphics.drawRect(0, 72, 1024, 436);				// MODE１
					r_sp.graphics.endFill();
				
				mask_sp.addChild( r_sp );
				this.addChild( mask_sp );
				this.mask = mask_sp;
			}

			// 再生開始を知るコールバック設定
			vs.setPlayStartCallBack( onVideoPlayStartCallBack );
			// 再生終了を知るコールバック設定
			vs.setPlayCompleteCallBack( onVideoPlayCompleteCallBack );
			// 再生
			vs.playVideo( s );
			this.addChild( vs );
		}

		// ビデオ再生開始コールバック
		private function onVideoPlayStartCallBack():void {
			// 再生開始コールバック呼び出し
			if (cb_start != null) cb_start();

			// キューポイント到達までタイマー開始
			if ( time_expire != 0.0 ) {
				timer = new Timer(100);
				timer.repeatCount = time_expire * 10;
				timer.start();
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeExpiredCallBack);
			}
		}

		// ビデオ再生終了コールバック
		private function onVideoPlayCompleteCallBack():void {
			// 再生終了コールバック呼び出し
			if (cb_comp != null) cb_comp();
		}

		// 再生後、指定時間まで経過した際のコールバック
		private function onTimeExpiredCallBack(te:TimerEvent):void {
			//if (cb_cuepoint != null) cb_cuepoint();		// 呼び出し。
			// 自ら隠す
			this.visible = false;		// 隠す
		}
		
		/////////////////////////////////////////////////////
		// プロパティで「VideoStreamParts」を返す
		public function get videoStreamParts():VideoStreamParts {
			return vs;
		}
		/////////////////////////////////////////////////////
		
		// 再生開始直後コールバック（安定再生を取って完全に同期する事が出来る)
		public function setPlayStartCallBack(f:Function):void {
			cb_start = f;
		}

		// 再生終了コールバック（安定再生を取って完全に同期する事が出来る)
		public function setPlayCompleteCallBack(f:Function):void {
			cb_comp = f;
		}

		// 一定時間で映像を隠すコールバック登録
		public function setAutoHidden(c:Number):void {
			time_expire = c;
		}

		// ビューエリア指定
		public function setViewArea(w:int, h:int):void {
			vs.width = w;
			vs.height = h;
		}

	//	// 「setVolume()」関数（中継）
	//	public function setVolume(v:Number):void {
	//		vs.setVolume( v );
	//	}
	}
}
