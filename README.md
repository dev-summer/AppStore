## 목차
1. [프로젝트 소개](프로젝트-소개)
2. [고민한 점](고민한-점)

## 프로젝트 소개
- 애플 앱스토어의 `Today` 탭과 `Search` 탭을 클론코딩한 앱

### 개발 환경
[![Xcode](https://img.shields.io/badge/Xcode-14.2-orange)]() [![iOS](https://img.shields.io/badge/iOS-14.0-blue)]()

<!-- ### 기능 -->


---

## 고민한 점

### 1️⃣ DiffableDataSource의 ItemIdentifier 타입 정의
앱 상세화면은 다음과 같이 여러 종류의 section과 item으로 구성되어 있습니다.
<img src=https://hackmd.io/_uploads/B11g1UMc3.png width="300">

각 section별로 item의 타입이 다르기 때문에(`TopItem`, `SummaryItem`, `ScreenshotItem`) `DiffableDatasource`의 `ItemIdentifier` 타입으로 Hashable한 특정 구체 타입(예: `TopItem`)을 지정할 수가 없습니다. 이 문제를 해결하기 위해 고려한 방법은 다음의 네 가지입니다.

1. **<u>`ItemIdentifer`에 들어갈 타입을 열거형으로 정의⭐️ 선택한 방법</u>**
2. `ItemIdentifier`에 들어갈 타입을 `AnyHashable`로 정의
3. `ItemIdentifier`에 들어갈 타입으로 커스텀 `AnyHashable` 타입을 구현
4. `DiffableDatasource`를 사용하지 않기

**4번**은 `indexPath` 기반의 접근 방식을 사용하기 때문에 item의 삽입/삭제가 일어날 때 고려해야 할 점이 많아 휴먼 에러가 발생하기 쉽습니다. 위 화면에서는 앱 정보를 단순히 보여주기만 하기 때문에 item의 삽입/삭제가 일어나지 않아 4번을 채택하면 쉽게 해결할 수 있습니다. 하지만 `DiffableDataSource`를 활용해 해당 문제를 해결하는 경험을 쌓고자 4번 방법은 배제하였습니다.

**1번**을 선택한 이유는 `DataSource`에 들어갈 객체의 타입을 가장 strict하게 통제할 수 있기 때문입니다.

1~4번의 구현 방법 및 고려한 내용은 다음과 같습니다.

#### 1. `ItemIdentifer`에 들어갈 타입을 `enum`으로 정의
열거형과 연관값을 활용해 `ItemIdentifier`의 타입을 정의할 수 있습니다.
- 장점: `DataSource`에 들어갈 객체의 타입을 열거형 `case`와 `연관값`을 활용해서 통제할 수 있다.
- 단점: 열거형이기 때문에 case의 추가/삭제 시 해당 열거형과 관련된 모든 `switch`문을 수정해야 할 수 있다.

``` swift
// DetailItem.swift
enum DetailItem: Hashable {
    case top(TopItem)
    case summary(SummaryItem)
    ...
}

struct TopItem {
    let appName: String
    let appIconURL: String
    ...
}

struct SummaryItem {
    let screenshotURL: String
    ...
}

// DetailViewController.swift
final class DetailViewController: UIViewController {
    let dataSource = UICollectionViewDiffableDataSource<DetailSection, DetailItem>()
    ...
    func configureDatasource() {
        let topCellRegistration = UICollectionView.CellRegistration<DetailTopCell, DetailItem> { cell, _, item in
            switch item {
                case .top(let topItem):
                    cell.bind(with: topItem)
                default:
                    return
            }
        }
        ...
    }
    ...
}
```

#### 2. `ItemIdentifier`에 들어갈 타입을 `AnyHashable`로 정의
- 장점: 구현 코드가 비교적 단순하다.
- 단점: `Hashable`한 객체라면 무엇이든 `DataSource`에 삽입할 수 있다.

```swift
// DetailItem.swift
struct TopItem: Hashable {
    let appName: String
    let appIconURL: String
    ...
}

// DetailViewController.swift
final class DetailViewController: UIViewController {
    let dataSource = UICollectionViewDiffableDataSource<DetailSection, AnyHashable>()
    ...
    func configureDatasource() {
        let topCellRegistration = UICollectionView.CellRegistration<DetailTopCell, AnyHashable> { cell, _, item in
            if let item = item as? TopItem {
                cell.bind(with: item)
            }
        }
        ...
    }
    ...
}
```

#### 3. `ItemIdentifier`에 들어갈 타입으로 커스텀 `AnyHashable` 타입을 구현
- 장점: `AnyHashable` 보다 `DataSource`에 들어갈 수 있는 객체의 타입을 더 좁은 범위로 한정지을 수 있다.
  - 아래 예시의 경우 `DetailItemType`을 채택한 객체로 타입을 한정할 수 있다.
- 단점: 구현이 필요 이상으로 복잡해질 수 있다.

```swift
// DetailItem.swift
protocol DetailItemType: Hashable { }

struct DetailBasicItem: Hashable {
    let base: any DetailItemType
    
    init(base: any DetailItemType) {
        self.base = base
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(base)
    }
    
    static func == (lhs: DetailBasicItem, rhs: DetailBasicItem) -> Bool {
        if let lhsItem = lhs.base as? TopItem,
           let rhsItem = rhs.base as? TopItem {
            return lhsItem == rhsItem
        } else if let lhsItem = lhs.base as? SummaryItem,
                  let rhsItem = rhs.base as? SummaryItem {
            return lhsItem == rhsItem
        } else {
            return false
        }
    }
}

struct TopItem: DetailItemType { }
struct SummaryItem: DetailItemType { }

// DetailViewController.swift
final class DetailViewController: UIViewController {
    let dataSource = UICollectionViewDiffableDataSource<DetailSection, DetailBasicItem>()
    ...
    func configureDatasource() {
        let topCellRegistration = UICollectionView.CellRegistration<DetailTopCell, DetailBasicItem> { cell, _, item in
            let topItem = item.base as? TopItem
            cell.bind(with: topItem)
        }
        ...
    }
    ...
}
```
