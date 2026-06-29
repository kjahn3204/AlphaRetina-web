# Chakra UI React 19 호환성 업그레이드 계획

## 현재 상황

### 문제점
- **React**: 19.2.3 (업그레이드 완료)
- **Chakra UI**: 2.8.2 (React 19 공식 지원 없음)
- **타입 에러**: `ComponentWithAs` 타입이 React 19의 JSX 요소 타입과 호환되지 않음

### 사용 중인 Chakra UI 컴포넌트
프로젝트에서 사용하는 주요 컴포넌트:
- `Box`, `Flex`, `VStack`, `HStack`, `Center`
- `Button`, `IconButton`, `Input`, `Select`, `Textarea`
- `Grid`, `GridItem`, `Icon`, `Img`
- `ChakraProvider`, `extendTheme`, `createStandaloneToast`, `useModal`

## 업그레이드 전략

### 옵션 1: Chakra UI 최신 버전으로 업그레이드 (권장)

#### 1단계: 최신 버전 확인 및 업그레이드
```bash
# 현재 최신 버전 확인
yarn info @chakra-ui/react versions --json

# 최신 버전으로 업그레이드
yarn upgrade @chakra-ui/react@latest
yarn upgrade @emotion/react@latest
yarn upgrade @emotion/styled@latest
```

**예상 버전:**
- `@chakra-ui/react`: ^2.8.2 → ^2.8.x (최신 v2)
- `@emotion/react`: ^11.13.3 → ^11.13.x (최신)
- `@emotion/styled`: ^11.13.0 → ^11.13.x (최신)

#### 2단계: 타입 호환성 확인
- TypeScript 컴파일 에러 확인
- 타입 정의 파일 업데이트 여부 확인

#### 3단계: Breaking Changes 확인
- Chakra UI v2.8.x 변경사항 확인
- `extendTheme` API 변경사항 확인
- 컴포넌트 props 변경사항 확인

### 옵션 2: 타입 호환성 임시 해결 (단기)

#### TypeScript 설정 조정
`tsconfig.json`에 다음 옵션 추가:
```json
{
  "compilerOptions": {
    "skipLibCheck": true,  // 이미 설정됨
    "types": ["vite-plugin-svgr/client"]
  }
}
```

#### 타입 단언 사용 (임시)
```typescript
// 타입 에러가 발생하는 컴포넌트에만 적용
const FlexComponent = Flex as any;
```

**단점:**
- 타입 안정성 저하
- IDE 자동완성 기능 제한
- 장기적으로 유지보수 어려움

### 옵션 3: Chakra UI v3 마이그레이션 (장기, 복잡)

**주의**: Chakra UI v3는 완전히 다른 아키텍처를 사용하므로 대규모 리팩토링 필요

**v3 주요 변경사항:**
- 새로운 컴포넌트 API
- 다른 스타일링 시스템
- 테마 구성 방식 변경

**예상 작업량**: 프로젝트 전체 리팩토링 필요

## 권장 업그레이드 계획

### Phase 1: 즉시 적용 (타입 에러 해결)

1. **Chakra UI 최신 v2 버전으로 업그레이드**
   ```bash
   yarn upgrade @chakra-ui/react@^2.8.10
   yarn upgrade @emotion/react@^11.13.5
   yarn upgrade @emotion/styled@^11.13.5
   ```

2. **타입 호환성 테스트**
   - 빌드 실행: `yarn build`
   - 타입 체크: `yarn tsc --noEmit`
   - 개발 서버 실행: `yarn start`

3. **타입 에러가 지속되는 경우**
   - `tsconfig.json`에 타입 오버라이드 추가
   - 또는 타입 단언 사용 (임시)

### Phase 2: 호환성 확인 및 테스트

1. **기능 테스트**
   - 모든 페이지 렌더링 확인
   - 폼 컴포넌트 동작 확인
   - 모달, 토스트 등 UI 컴포넌트 확인

2. **스타일 확인**
   - 커스텀 테마 (`chakra-config.ts`) 적용 확인
   - 색상, 브레이크포인트 확인

3. **성능 확인**
   - 빌드 시간 확인
   - 번들 크기 확인

### Phase 3: 장기 계획

1. **Chakra UI 공식 React 19 지원 대기**
   - GitHub 이슈 모니터링: https://github.com/chakra-ui/chakra-ui/issues/8519
   - 공식 발표 대기

2. **대안 검토 (필요시)**
   - Mantine UI (React 19 지원)
   - Material-UI (MUI) v6 (React 19 지원)

## 실행 계획

### 즉시 실행 가능한 작업

1. **Chakra UI 최신 버전 확인**
   ```bash
   yarn info @chakra-ui/react versions --json | tail -20
   ```

2. **의존성 업그레이드**
   ```bash
   yarn upgrade @chakra-ui/react@latest
   yarn upgrade @emotion/react@latest  
   yarn upgrade @emotion/styled@latest
   ```

3. **타입 에러 재확인**
   - IDE에서 타입 에러 확인
   - 빌드 실행하여 컴파일 에러 확인

### 예상 결과

**최선의 경우:**
- 최신 버전에서 React 19 타입 호환성 개선
- 타입 에러 자동 해결

**타입 에러 지속 시:**
- `tsconfig.json` 타입 오버라이드 적용
- 또는 타입 단언으로 임시 해결
- Chakra UI 공식 지원 대기

## 참고 자료

- [Chakra UI GitHub Issues - React 19](https://github.com/chakra-ui/chakra-ui/issues/8519)
- [Chakra UI v2 Documentation](https://v2.chakra-ui.com/)
- [React 19 Upgrade Guide](https://ko.react.dev/blog/2024/04/25/react-19-upgrade-guide)

## 다음 단계

1. Chakra UI 최신 버전 확인 및 업그레이드 실행
2. 타입 에러 재확인
3. 필요시 추가 조치 적용
