# JSON Viewer 가이드

[English](guide_en.md) | [简体中文](guide_cn.md) | [Deutsch](guide_de.md) | [Português](guide_pt.md) | [日本語](guide_jp.md) | 한국어

## 소개

JSON Viewer는 JSON 데이터를 포맷팅하고 표시하는 Flutter 위젯으로, JSON 노드의 확장 및 축소를 지원합니다. 주로 애플리케이션에서 API 응답 데이터를 표시하는 데 사용됩니다.

![데모](json_shrink_widget/pics/show.gif)

## 설치

pubspec.yaml에 의존성을 추가합니다:

```yaml
dependencies:
  json_shrink_widget: ^1.2.0
```

## 기본 사용법

가장 간단한 사용 방법:

```dart
JsonShrinkWidget(
  json: jsonString  // String, Map, List 유형 지원
)
```

## 고급 설정

JsonShrinkWidget은 다음과 같은 설정 옵션을 지원합니다:

- `shrink`: bool - 기본적으로 축소할지 여부, 기본값은 false
- `deep`: int - JSON 순회 깊이 레벨
- `indentation`: String - 들여쓰기 문자
- `style`: JsonShrinkStyle - 스타일 설정
- `deepShrink`: int - 기본 축소 레벨
- `showNumber`: bool - 배열/객체의 요소 수를 표시할지 여부
- `urlSpanBuilder`: Function - 사용자 정의 URL 링크 표시 스타일

스타일 설정 예시:

```dart
JsonShrinkWidget(
  json: jsonString,
  shrink: true,  // 기본적으로 축소
  deep: 3,       // 3레벨 순회
  indentation: "  ",  // 2칸 들여쓰기
  style: JsonShrinkStyle(
    // 사용자 정의 스타일
    keyStyle: TextStyle(color: Colors.blue),
    valueStyle: TextStyle(color: Colors.black),
    symbolStyle: TextStyle(color: Colors.grey)
  ),
  showNumber: true  // 요소 수 표시
)
```

## 기능

1. 다양한 데이터 유형 지원
- JSON 문자열
- Map
- List

2. 유연한 표시 제어
- 클릭으로 JSON 노드 축소/확장
- 기본 축소 레벨 설정
- 사용자 정의 들여쓰기 스타일

3. 사용자 친화적인 시각 효과
- 구문 강조
- 포맷된 정렬
- 선택적 요소 수 표시

4. 사용자 정의 설정
- 스타일 사용자 정의
- URL 링크 처리
- 들여쓰기 제어

## 예시

1. 기본 JSON 표시:

```dart
String jsonStr = '''
{
  "name": "JSON Viewer",
  "version": "1.2.0",
  "author": "infinity"
}
''';

JsonShrinkWidget(
  json: jsonStr
)
```

2. 스타일이 적용된 설정:

```dart
JsonShrinkWidget(
  json: jsonData,
  style: JsonShrinkStyle(
    keyStyle: TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold
    ),
    valueStyle: TextStyle(
      color: Colors.black87
    )
  )
)
```

3. 배열 요소 수 표시:

```dart
JsonShrinkWidget(
  json: listData,
  showNumber: true,  // 배열 길이 표시
  shrink: true      // 기본적으로 축소
)
```

## 중요 참고 사항

1. 입력 JSON 문자열은 유효한 JSON 형식이어야 합니다
2. 데이터 크기에 따라 적절한 순회 깊이(deep 매개변수)를 설정하는 것이 좋습니다
3. 큰 JSON 데이터의 경우 기본적으로 축소 모드를 사용하는 것이 좋습니다
4. 스타일 설정은 애플리케이션 테마에 따라 완전히 사용자 정의할 수 있습니다

## 일반적인 문제

1. JSON 파싱 실패
- JSON 문자열 형식이 올바른지 확인하세요
- 문자열 인코딩이 UTF-8인지 확인하세요

2. 성능 문제
- deep 매개변수를 적절히 제어하세요
- 큰 데이터 세트에는 축소 모드를 사용하세요

3. 스타일 문제
- 스타일 설정이 올바른지 확인하세요
- TextStyle 매개변수를 확인하세요 