# flutter_geoloc_map_web_console

最終更新日：2025-12-17

## 概要

**ジオロケーション（位置情報）データを地図上に可視化する Flutter Web コンソールアプリ**です。

`flutter_map` + OpenStreetMap タイルで東京都の市区町村ポリゴンを表示し、日付ごとに記録された位置情報データをマーカーとして地図上に重ね描きします。年・日付の選択により、複数日分の行動記録を色分けして比較できます。

---

## 主な機能

- **東京都市区町村ポリゴン表示**：GeoJSON データから各市区町村の境界を読み込み、カラフルに塗り分けて表示（離島は自動除外）
- **ジオロケーションデータのマーカー表示**：日付ごとの位置情報をピンで地図上にプロット
- **年選択**：2023 年以降の年をヘッダーで切り替え
- **日付タイル一覧**：選択年の記録のある日付を横スクロールのタイルで表示（平日・土曜・日曜・祝日で色分け）
- **複数日選択**：複数の日付を同時選択し、それぞれ異なる色のマーカーで地図上に重ねて表示
- **地図の自動フィット**：ポリゴン全体が収まるよう `CameraFit.bounds` で初期表示を自動調整
- **タイルキャッシュ**：`CachedTileProvider` + `flutter_cache_manager` でタイル画像をキャッシュ
- **アプリ再起動機能**：`AppRoot` の `restartApp()` で状態をリセット

---

## ファイル構成

```
lib/
├── main.dart                         # エントリーポイント（ProviderScope・アプリ再起動）
├── const/                            # 定数（初期表示位置など）
├── controllers/
│   ├── controllers_mixin.dart        # 全 Controller への統合アクセス Mixin
│   ├── app_param/                    # 選択年・選択日・現在ズームなどの UI 状態
│   ├── geoloc/                       # ジオロケーションデータの取得・管理
│   ├── holiday/                      # 祝日データの取得・管理
│   └── tokyo_municipal/              # 東京都市区町村データの取得・管理
├── data/                             # データソース・API 定義
├── extensions/                       # Dart 拡張メソッド
├── models/
│   ├── geoloc_model.dart             # 位置情報モデル（id, year, month, day, time, lat, lng）
│   ├── municipal_model.dart          # 市区町村モデル（name, polygons）
│   └── bounding_box_info_model.dart  # バウンディングボックスモデル
├── screens/
│   └── home_screen.dart              # メイン画面（地図 + 年選択 + 日付タイル）
└── utility/
    ├── map_functions.dart            # ポリゴン生成などの地図ユーティリティ
    ├── tile_provider.dart            # キャッシュ対応タイルプロバイダー
    └── utility.dart                  # 日付色分け・面積計算などの汎用ユーティリティ

assets/
└── json/
    └── tokyo_municipal.geojson       # 東京都市区町村ポリゴンデータ
```

---

## 主要モデル

### `GeolocModel`

| フィールド    | 型       | 説明         |
|-------------|----------|------------|
| `id`        | `int`    | レコード ID  |
| `year`      | `String` | 年          |
| `month`     | `String` | 月          |
| `day`       | `String` | 日          |
| `time`      | `String` | 時刻        |
| `latitude`  | `String` | 緯度        |
| `longitude` | `String` | 経度        |

---

## 状態管理

Riverpod（`hooks_riverpod` + `riverpod_annotation`）と Freezed を採用しています。

| Controller         | 役割                                   |
|-------------------|--------------------------------------|
| `AppParam`        | 選択年・選択日リスト・現在ズーム・UI 状態  |
| `Geoloc`          | 日付ごとの位置情報データ（`Map<String, List<GeolocModel>>`）|
| `Holiday`         | 祝日リスト                             |
| `TokyoMunicipal`  | 東京都市区町村ポリゴンデータ             |

`ControllersMixin` を使うと、各画面の `ConsumerState` から上記 Controller の state / notifier に簡潔にアクセスできます。

---

## 依存パッケージ

### dependencies

| パッケージ                    | バージョン   | 用途                              |
|-----------------------------|-------------|----------------------------------|
| `flutter_map`               | `^7.0.2`    | 地図表示（OpenStreetMap）          |
| `latlong2`                  | `^0.9.1`    | 緯度経度の型・計算                  |
| `flutter_riverpod`          | `^2.5.1`    | 状態管理                           |
| `hooks_riverpod`            | `^2.5.1`    | Riverpod + Hooks                 |
| `riverpod_annotation`       | `^2.3.5`    | Riverpod アノテーション             |
| `freezed_annotation`        | `^2.4.1`    | 不変オブジェクト定義                 |
| `json_annotation`           | `^4.9.0`    | JSON シリアライズ                   |
| `cached_network_image`      | `^3.4.1`    | 画像キャッシュ                      |
| `flutter_cache_manager`     | `^3.4.1`    | ファイルキャッシュ（タイル含む）       |
| `scroll_to_index`           | `^3.0.1`    | 日付リストの自動スクロール            |
| `scrollable_positioned_list`| `^0.3.8`    | 位置指定スクロール                  |
| `font_awesome_flutter`      | `^10.7.0`   | アイコン                           |
| `http`                      | `^1.2.1`    | HTTP 通信                         |
| `intl`                      | `^0.20.2`   | 国際化・日付フォーマット             |
| `url_launcher`              | `^6.3.2`    | URL 起動                          |
| `equatable`                 | `^2.0.7`    | 値オブジェクトの等価比較             |
| `flutter_launcher_icons`    | `^0.13.1`   | アプリアイコン生成                  |
| `flutter_native_splash`     | `^2.4.0`    | スプラッシュ画面                    |

### dev_dependencies

| パッケージ            | バージョン   | 用途                         |
|----------------------|-------------|------------------------------|
| `build_runner`       | `^2.4.9`    | コード生成実行                |
| `freezed`            | `^2.5.2`    | Freezed コード生成            |
| `json_serializable`  | `^6.8.0`    | JSON コード生成               |
| `riverpod_generator` | `^2.4.0`    | Riverpod コード生成           |
| `riverpod_lint`      | `^2.3.10`   | Riverpod Lint ルール          |
| `custom_lint`        | `^0.6.4`    | カスタム Lint                 |

---

## 環境

| 項目         | バージョン  |
|-------------|-----------|
| Dart SDK    | `^3.8.1`  |

---

## セットアップ

```bash
# リポジトリのクローン
git clone https://github.com/toyotarou/flutter_geoloc_map_web_console.git
cd flutter_geoloc_map_web_console

# パッケージの取得
flutter pub get

# コード生成（freezed / riverpod_generator）
dart run build_runner build --delete-conflicting-outputs

# アプリの実行（Web を推奨）
flutter run -d chrome
```

---

## 対応プラットフォーム

- Web（主要ターゲット）
- Android
- iOS
- macOS
- Linux
- Windows
