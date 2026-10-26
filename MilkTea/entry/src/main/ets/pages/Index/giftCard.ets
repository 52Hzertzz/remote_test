// 心意礼卡页面 GiftCardPage
// 页面功能：展示礼卡宣传横幅、送礼适用场景、多档位面值礼品卡，支持横向滑动选购不同面值礼卡
import { router } from '@kit.ArkUI';

// 礼品卡面值套餐数据模型
interface GiftCardItem {
  value: string       // 礼卡面值金额
  giftPoints: string  // 购买附赠积分文案
  tagText: string     // 礼卡标签描述
}

// 送礼推荐场景条目模型
interface GiftTip {
  icon: ResourceStr  // 场景图标资源
  title: string      // 场景标题
  desc: string       // 场景适用说明
}

@Entry
@ComponentV2
struct GiftCardPage {
  // 礼卡面值数组，存储四档面值套餐数据
  @Local cardList: GiftCardItem[] = [
    { value: "50", giftPoints: "赠20积分", tagText: "小额送礼" },
    { value: "100", giftPoints: "赠60积分", tagText: "人气爆款" },
    { value: "200", giftPoints: "赠150积分", tagText: "亲友优选" },
    { value: "500", giftPoints: "赠400积分", tagText: "大额礼遇" }
  ]

  // 送礼适用场景数组，展示不同送礼场景推荐
  @Local tipList: GiftTip[] = [
    { icon: $r("app.media.afternoon_tea"), title: "闺蜜下午茶", desc: "送闺蜜，一起打卡新品奶茶" },
    { icon: $r("app.media.company"), title: "同事福利", desc: "办公室下午茶集体采购超合适" },
    { icon: $r("app.media.lovers"), title: "情侣约会", desc: "甜蜜饮品，日常小惊喜" },
    { icon: $r("app.media.gift"), title: "生日赠礼", desc: "代替礼物，好喝不踩雷" }
  ]

  build() {
    Column() {
      this.TopBackBar()

      Scroll() {
        Column() {
          // 顶部心意礼卡宣传横幅
          this.CardBanner()
          Blank().height(16)

          // 送礼推荐场景模块标题
          Text("送礼推荐场景")
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .width("100%")
            .padding({ left: 16 })
          Blank().height(10)

          // 循环渲染送礼场景列表
          this.TipListArea()
          Blank().height(20)

          // 面值选购模块标题
          Text("选择礼卡面值")
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .width("100%")
            .padding({ left: 16 })
          Blank().height(10)

          // 横向滑动面值礼卡卡片区域
          this.CardPackageScroll()
          Blank().height(40)
        }
        .width("100%")
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width("100%")
    .height("100%")
    .backgroundColor("#f8f8f8")
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }

  /**
   * @Builder 页面顶部返回导航栏组件
   * 左侧返回箭头按钮，中间页面标题，右侧空白占位保证标题居中
   */
  @Builder
  TopBackBar() {
    Row() {
      // 返回上一页按钮
      Image($r("app.media.left"))
        .width(24)
        .height(24)
        .onClick(() => router.back())
      Blank()
      Text("心意礼卡")
        .fontSize(19)
        .fontWeight(FontWeight.Medium)
      Blank()
      Row().width(24)
    }
    .width("100%")
    .height(48)
    .padding({ left: 16, right: 16 })
    .backgroundColor(Color.White)
  }

  /**
   * @Builder 顶部心意礼卡宣传横幅组件
   * 全屏圆角海报图展示礼卡宣传图
   */
  @Builder
  CardBanner() {
    Stack() {
      Image($r("app.media.giftCard"))
        .width("92%")
        .height(160)
        .borderRadius(16)
        .objectFit(ImageFit.Cover)
    }
    .width("100%")
  }

  /**
   * @Builder 送礼推荐场景列表组件
   * 循环渲染每个送礼场景，左侧图标、右侧场景标题+说明
   */
  @Builder
  TipListArea() {
    Column() {
      ForEach(this.tipList, (item: GiftTip) => {
        Row() {
          // 场景图标
          Image(item.icon)
            .width(36)
            .height(36)
            .margin({ right: 12 })
          // 场景文字信息容器
          Column() {
            Text(item.title)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
            Text(item.desc)
              .fontSize(12)
              .fontColor("#999")
              .margin({ top: 2 })
          }
          .layoutWeight(1)
        }
        .width("92%")
        .padding({ top: 10, bottom: 10 })
      })
    }
    .width("100%")
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ left: "4%", right: "4%" })
    .padding({ left: 12, right: 12 })
  }

  /**
   * @Builder 面值礼卡横向滚动容器组件
   * 水平滑动切换不同面值礼品卡，每张卡片包含标签、面值、赠送积分、购买按钮
   */
  @Builder
  CardPackageScroll() {
    Scroll() {
      Row() {
        ForEach(this.cardList, (card: GiftCardItem) => {
          Column() {
            // 礼卡特色标签
            Text(card.tagText)
              .fontSize(11)
              .fontColor(Color.White)
              .padding({ left: 8, right: 8, top: 2, bottom: 2 })
              .backgroundColor("#D84A7C")
              .borderRadius(99)
              .margin({ bottom: 10 })
            Text("面值")
              .fontSize(13)
              .fontColor("#666")
            // 面值金额展示行
            Row() {
              Text("¥")
                .fontSize(14)
                .fontColor("#D84A7C")
              Text(card.value)
                .fontSize(26)
                .fontWeight(FontWeight.Bold)
                .fontColor("#D84A7C")
            }
            .margin({ top: 6, bottom: 8 })
            // 购买附赠积分文案
            Text(card.giftPoints)
              .fontSize(12)
              .fontColor("#666")
            Blank().layoutWeight(1)
            // 购买按钮
            Text("立即购买")
              .width("100%")
              .height(36)
              .textAlign(TextAlign.Center)
              .fontSize(13)
              .fontColor(Color.White)
              .backgroundColor("#D84A7C")
              .borderRadius(18)
              .margin({ top: 12 })
          }
          .width(140)
          .height(200)
          .padding(14)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .margin({ left: 10, right: 6 })
        })
      }
    }
    .width("100%")
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
    .padding({ left: 16 })
  }
}