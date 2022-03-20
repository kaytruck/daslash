# Daslash
2D action game made with PICO-8

# スプライトのフラグ
| フラグ    | 意味              |
| --------- | ----------------- |
| 0000 0001 | 右突き抜け禁止    |
| 0000 0010 | 左突き抜け禁止    |
| 0000 0100 | 下突き抜け禁止    |
| 0000 1000 | 上突き抜け禁止    |
| 0001 0001 | ゴール            |
| 0001 0100 | はしご            |
| 0010 0000 | アイテム(一度のみ)|
| 0010 0001 | HP回復            |
| 0010 0010 | HP最大up          |

# TODO
* [x] hidingに時間制限を設ける
* [x] 次のステージに移動する。
* [x] 時間内に次のドアに進む。
* [x] ハシゴの端の方では上り下りができない問題を改善する。
* [x] ゲーム画面上部を情報エリアにする。
* [x] ゲームオーバー画面にスコア？(各ステージの残時間の合計？)を表示する。
* [x] はしごの色を改善する(もう少し暗くする)
* [x] 時間制限の追加
* [x] プレイヤー死亡後、突然ゲームオーバー画面になるのを避ける
* [x] 時間制限カウンタで、残り時間が少なくなった場合に色を変える
* [x] 敵生成処理のコードを改善する
* [x] スコアは各ステージ値を加算するように改善する
* [ ] 効果音を追加する
* [ ] BGMを追加する
## プレイヤー
* [x] ダッシュ直後、一定時間はダメージを受けない。(シビアな判定の緩和)
* [x] 攻撃ヒット時のダメージ表現(爆発)を追加する。
* [x] プレイヤーキャラクタに剣を持たせる。
* [x] ダウンタイム中の敵に接触してもダメージを受けない。
* [x] ダメージを受けたときに画面をわずかに揺らす。
## 敵
* [x] ダッシュアタックを受けた敵は一定時間ダウンタイムになる。
* [x] ダウンタイム中は移動を停止する。
* [ ] 敵の遠隔攻撃(弾)を追加する
* [ ] 犬型の的にジャンプを加える
* [ ] 上位敵を追加する
## ステージ
* [x] ステージ管理を行う(マップ、敵の配置)
* [x] ステージ番号を表示する
* [ ] ステージを追加する
## アイテム
* [x] 回復アイテムを追加する。