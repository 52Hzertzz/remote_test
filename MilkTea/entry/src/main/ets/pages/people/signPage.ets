// 签到有礼页面 SignPage
// 页面功能：完成每日签到、累计连续签到天数、领取阶梯积分奖励，展示长期签到额外福利
import { router } from '@kit.ArkUI';

// 连续签到阶梯奖励数据模型
interface SignReward {
  day: number        // 签到第几天
  point: number       // 奖励积分数量
  isSigned: boolean  // 是否已经完成签到
}

// 签到额外权益条目模型
interface ExtraBenefit {
  icon: ResourceStr  // 福利图标
  title: string      // 福利标题
  desc: string       // 福利说明文案
}

@Entry
@ComponentV2
struct SignPage {
  // 连续签到天数，响应式变量
  @Local continueDay: number = 3
  // 今日签到状态标记
  @Local todaySigned: boolean = false

  // 7天连续签到奖励列表
  @Local weekReward: SignReward[] = [
    { day: 1, point: 5, isSigned: true },
    { day: 2, point: 5, isSigned: true },
    { day: 3, point: 10, isSigned: true },
    { day: 4, point: 10, isSigned: false },
    { day: 5, point: 15, isSigned: false },
    { day: 6, point: 15, isSigned: false },
    { day: 7, point: 30, isSigned: false }
  ]

  // 长期签到额外福利列表
  @Local benefitList: ExtraBenefit[] = [
    { icon: $r("app.media.sign_double"), title: "积分翻倍", desc: "连续7天签到后每日积分双倍" },
    { icon: $r("app.media.sign_coupon"), title: "免费加料券", desc: "满15天连续签到赠送加料券一张" },
    { icon: $r("app.media.sign_medal"), title: "限定勋章", desc: "连续签到30天解锁专属签到达人勋章" }
  ]

  /**
   * 签到点击处理方法
   * 未签到时，更新签到状态、连续天数与奖励条目
   */
  signHandle() {
    if (!this.todaySigned) {
      this.todaySigned = true
      this.continueDay += 1
      // 把对应天数标记为已签到
      this.weekReward[this.continueDay - 1].isSigned = true
      console.log("签到成功")
    }
  }

  build() {
    Column() {
      // 顶部返回导航栏
      this.TopBackBar()

      Scroll() {
        Column() {
          // 顶部粉色签到主卡片
          this.SignMainCard()
          Blank().height(16)

          // 连续签到奖励标题
          Text("连续签到奖励")
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .width("100%")
            .padding({ left: 16 })
          Blank().height(10)
          // 横向滑动7天奖励卡片
          this.WeekRewardArea()
          Blank().height(20)

          // 签到额外福利标题
          Text("签到额外福利")
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .width("100%")
            .padding({ left: 16 })
          Blank().height(10)
          // 福利条目列表
          this.BenefitArea()
          Blank().height(30)
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
   * @Builder 页面顶部返回导航栏
   * 左侧返回箭头，中间页面标题，右侧空白保持标题居中
   */
  @Builder
  TopBackBar() {
    Row() {
      Image($r("app.media.left"))
        .width(24)
        .height(24)
        .onClick(() => router.back())
      Blank()
      Text("签到有礼")
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
   * @Builder 顶部签到主卡片
   * 展示连续签到天数，按钮区分未签到/已签到两种状态
   */
  @Builder
  SignMainCard() {
    Column() {
      Text(`已连续签到 ${this.continueDay} 天`)
        .fontSize(14)
        .fontColor("#fff")
      Blank().height(12)
      Text("今日签到")
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor("#fff")
      Blank().height(20)
      // 签到按钮，动态切换文字与背景样式
      Text(this.todaySigned ? "今日已完成签到" : "点击领取今日积分")
        .width(140)
        .height(40)
        .textAlign(TextAlign.Center)
        .fontSize(14)
        .fontColor(this.todaySigned ? "#D84A7C" : Color.White)
        .backgroundColor(this.todaySigned ? "#fff" : "#ff7ea0")
        .borderRadius(20)
        .onClick(() => this.signHandle())
    }
    .width("92%")
    .height(180)
    .padding(20)
    .backgroundColor("#D84A7C")
    .borderRadius(16)
    .margin({ left: "4%", right: "4%" })
  }

  /**
   * @Builder 横向滚动7天签到奖励区域
   * 已签到显示星星图标，未签到显示文字
   */
  @Builder
  WeekRewardArea() {
    Scroll() {
      Row() {
        ForEach(this.weekReward, (item: SignReward) => {
          Column() {
            Text(`第${item.day}天`)
              .fontSize(12)
              .fontColor("#666")
            Blank().height(8)
            Text(`${item.point}积分`)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor(item.isSigned ? "#D84A7C" : "#999")
            Blank().height(8)
            // 已签到展示星星图标，未签到展示文字
            if (item.isSigned) {
              Image($r("app.media.star_full"))
                .width(22)
                .height(22)
                .fillColor('#fffdc701')
            } else {
              Text("待签到")
                .fontSize(10)
                .fontColor("#ccc")
            }
          }
          .width(70)
          .height(100)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor(Color.White)
          .borderRadius(10)
          .margin({ left: 6, right: 6 })
        })
      }
    }
    .width("100%")
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
    .padding({ left: 16 })
  }

  /**
   * @Builder 签到长期福利列表
   * 左侧图标，右侧标题+说明文字
   */
  @Builder
  BenefitArea() {
    Column() {
      ForEach(this.benefitList, (item: ExtraBenefit) => {
        Row() {
          Image(item.icon)
            .width(36)
            .height(36)
            .margin({ right: 12 })
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
}