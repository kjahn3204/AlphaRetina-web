
<p align='center'>
Mocking up web app with <b>Vital</b><sup><em>(speed)</em></sup><br>
</p>

<br>

<p align='center'>
<a href="https://vital.josepvidal.dev">Live Demo</a>
</p>

<br>

## 의료기기 사이버보안 기능 (웹 프론트엔드)

본 프로젝트는 의료기기 사이버보안 요구사항에 따라 API 서버와 연계하여 다음 보안 기능이 구현되어 있습니다.

### 로그인 / 인증 (`src/pages/login-page.tsx`)

- **시스템 알림 메시지**: 로그인 화면에 관리자가 발송한 시스템 알림 배너 표시
- **중복 로그인 안내 다이얼로그**: 409 응답 시 "이미 로그인된 사용자입니다" 확인 팝업
- **강제 로그인**: `?force=true` 파라미터로 기존 세션 무효화 후 로그인
- **비밀번호 변경 다이얼로그**: 403 응답 시 사유별 안내
  - 초기 비밀번호 사용 → "초기 비밀번호를 사용중입니다. 보안을 위해 비밀번호를 변경해주세요."
  - 30일 경과 → "비밀번호가 만료되었습니다. 보안을 위해 30일마다 비밀번호를 변경해야 합니다."
- **비밀번호 정책 실시간 검증**: 8~20자, 대소문자+숫자+특수문자 체크리스트
- **로그인 실패 박스**: 횟수/남은 기회 표시, 5회 초과 시 계정 잠금 안내
- **인증 피드백 최소화**: 아이디/비밀번호 구분 없이 동일한 실패 메시지

### 계정 관리 페이지 (`src/pages/account-management-page.tsx`)

**접근 제어**: `SUPER_ADMIN`, `ADMIN` 역할만 프로필 드롭다운의 "계정 관리" 버튼 표시

#### 계정 관리 탭
- **계정 목록**: 이름, 이메일, 소속, 직책, 역할, 상태(활성/비활성), 잠금, 로그인 실패 횟수
- **계정 추가 모달**:
  - 아이디 입력 후 blur 시 실시간 중복 체크
  - 초기 비밀번호는 아이디와 동일 (최초 로그인 시 강제 변경)
  - 자동으로 기본 역할(DOCTOR) 할당
- **계정 수정 모달**: 이름/이메일/소속/직책
- **활성화 / 비활성화**: 선택된 계정의 상태 토글
- **삭제**: 선택된 계정 일괄 삭제
- **역할 변경 (RoleChanger)**: 다중 역할 토글 (SUPER_ADMIN, ADMIN, DOCTOR, NURSE, USER)
- **비밀번호 초기화**: 실패 횟수 리셋 + 잠금 해제 + 초기 비밀번호(ID와 동일)

#### 감사 로그 탭
- **조회**: 시간, 유형, 심각도, 카테고리, 사용자, 설명, IP, 응답코드, 이벤트 ID
- **필터**: 사용자 ID, 이벤트 유형, 날짜 범위
- **페이징**: 50건씩 이전/다음 네비게이션
- **관리자 전용 읽기 접근**, 수정/삭제 기능 없음

#### 시스템 알림 발송 (NoticeModal)
- **대상 선택**: 전체 사용자 / 최고관리자 / 관리자 / 개별 사용자
- **메시지 발송**: 대상에게 맞는 알림 저장
- **활성 알림 목록**: 현재 발송 중인 알림 조회 및 개별 삭제

### 헤더 레이아웃 (`src/layouts/header-layout/`)

- **시스템 알림 팝업**: 10초마다 `/system/notice` 폴링 → 새 알림 팝업 표시
  - 다중 알림 지원, 확인한 알림은 재표시 안 함
- **사용자 프로필 드롭다운**: 관리자 전용 "계정 관리" 메뉴

### 환자 데이터 비식별화 (`src/pages/main-page/main-page.tsx`)

- **환자 목록**: `name_masked` (홍**), `birth_dt_masked` (1990****) 필드 사용

### 세션 관리 (`src/hooks/api/use-request.ts`)

- **자동 로그아웃**: 토큰 만료 시 "자동 로그아웃 / 장시간 활동이 없어 자동으로 로그아웃 되었습니다" 토스트 표시
- **사용자 확인 후 로그인 페이지 이동**: 토스트 닫기 시 자동 리다이렉트
- **401/403 에러 처리**: 로그인 요청은 refresh 시도 없이 즉시 에러 전파
- **시스템 오류 박스**: "SYS-001 시스템 오류 - 관리자에게 문의하시길 바랍니다" 형식

## Features

- ⚡️ [React 18](https://beta.reactjs.org/)
- 🦾 TypeScript, of course
- 🫀 [Vitest](https://vitest.dev/) - unitary testing made easy
- 👑 [Atomic Design organization](https://bradfrost.com/blog/post/atomic-web-design/)
- 🗂 [Absolute imports](https://github.com/vitejs/vite/issues/88#issuecomment-762415200)
- 😃 [Hero icons](https://heroicons.com/)
- ☁️ Deploy on Netlify, zero-config

### Dependencies

- react-dom
- react-router
- react-router-dom
- @chakra-ui/react
- react-query

### Coding Style

- [ESLint](https://eslint.org/) - configured for React/Hooks & TypeScript
- [Prettier](https://prettier.io/)

### Dev tools

- [TypeScript](https://www.typescriptlang.org/)
- [Commit lint](https://github.com/conventional-changelog/commitlint) - helps your team adhering to a commit convention
- [Netlify](https://www.netlify.com/) - zero-config deployment

## Try it now!

### GitHub Template

[Create a repo from this template on GitHub](https://github.com/jvidalv/vital/generate).

### Clone to local

If you prefer to do it manually with the cleaner git history

```bash
npx degit jvidalv/vital my-vital-app
cd my-vital-app
yarn # If you don't have yarn installed, run: npm install -g yarn
```

## Checklist

When you use this template, try follow the checklist to update your info properly

- [ ] Rename `name` and `author` fields in `package.json`
- [ ] Change the author name in `LICENSE`
- [ ] Change the title in `index.html`
- [ ] Change the favicon in `public`
- [ ] Modify the manifest in `public`
- [ ] Clean up the README's

And, enjoy :)

## Usage

### Development

Just run and visit http://127.0.0.1:3000/

```bash
yarn dev
```

### Build

To build the App, run

```bash
yarn build
```

And you will see the generated file in `dist` that ready to be served.

### Deploy on Netlify

Go to [Netlify](https://app.netlify.com/start) and select your repository, `OK` along the way, and your App will be live in a minute.

### Issues

#### Husky

If pre-commit hooks are not working be sure that you have installed husky: `husky install`.

By default this command should be triggered after yarn/npm deps are installed.

## Why

I have created several React apps recently. Setting the configs up is kinda the bottleneck for me to make the ideas simply come true within a very short time.

So I made this starter template for myself to create apps more easily, along with some good practices that I have learned from making those apps. Feel free to tweak it or even maintains your own forks.
