# SelfAuthApp

## 概要

Rails(API) + Next.js による自作認証ミニアプリ

## 目的

- Deviseを使わない認証理解
- セッション管理の理解
- 権限制御の実装

## 技術スタック

- Backend: Rails 7.2 (API mode)
- Frontend: Next.js
- DB: PostgreSQL
- Auth: bcrypt + session

## 認証設計

### 対象

- Admin（管理者）
- Staff（スタッフ）

### 方針

- 認証は session を使用
- UIは共通
- 権限はAPIで制御

### セッション

- session[:admin_id]
- session[:staff_id]

### ログイン制御

- deleted = false
- account_locked = false
- effective_from <= today
- effective_to >= today or null

## ER図

### admins

### admins

| column          | type    | null | default |
| --------------- | ------- | ---- | ------- |
| name            | string  | NO   |         |
| password_digest | string  | NO   |         |
| effective_from  | date    | NO   |         |
| effective_to    | date    | YES  |         |
| account_locked  | boolean | NO   | false   |
| failed_attempts | integer | NO   | 0       |
| deleted         | boolean | NO   | false   |

### staffs

| column          | type    | null | default |
| --------------- | ------- | ---- | ------- |
| name            | string  | NO   |         |
| password_digest | string  | NO   |         |
| role            | integer | NO   | 0       |
| effective_from  | date    | NO   |         |
| effective_to    | date    | YES  |         |
| account_locked  | boolean | NO   | false   |
| failed_attempts | integer | NO   | 0       |
| deleted         | boolean | NO   | false   |

## 将来拡張

- SessionLog を追加予定
- Admin / Staff 両方に紐付くため polymorphic association を使用予定
