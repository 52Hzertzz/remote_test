// 优惠券兑换页面
// 页面功能：查看当前可用积分、获取积分途径、使用积分兑换各类优惠券，附带兑换规则说明
import { router } from '@kit.ArkUI';

// 优惠券数据模型：单张优惠券信息
interface CouponItem {
  title: string        // 优惠券名称
  desc: string         // 优惠券使用说明
  needPoint: number    // 兑换所需积分
  coverImg: ResourceStr // 优惠券图片资源
}

// 积分获取渠道数据模型
interface PointSource {
  icon: ResourceStr  // 渠道图标
  title: string      // 渠道名称
  tip: string        // 渠道说明文案
}

// 兑换条款文本模型
interface RuleLine {
  text: string // 规则条文内容
}

@Entry
@ComponentV2
struct CouponExchangePage {
  // 用户当前可用积分，响应式变量
  @Local ownPoint: number = 120

  // 可兑换优惠券数组
  @Local couponList: CouponItem[] = [
    { title: "免费加料券", desc: "任意饮品免费添加一份珍珠/椰果/多肉", needPoint: 20, coverImg: $r("app.media.douying1") },
    { title: "饮品5元抵扣券", desc: "任意正价饮品下单立减5元，无门槛", needPoint: 40, coverImg: $r("app.media.douying2") },
    { title: "招牌奶茶半价券", desc: "招牌茉莉奶茶单人半价购买", needPoint: 60, coverImg: $r("app.media.douying3") },
    { title: "双人8折券", desc: "两杯饮品整单享八折优惠", needPoint: 100, coverImg: $r("app.media.douying4") },
    { title: "全品类8折周卡", desc: "7天内全场饮品通用八折", needPoint: 130, coverImg: $r("app.media.8discount") }
  ]

  // 赚取积分途径列表
  @Local sourceList: PointSource[] = [
    { icon: $r("app.media.coupon3"), title: "每日签到", tip: "每日签到领取5积分" },
    { icon: $r("app.media.coupon4"), title: "下单消费", tip: "每消费1元获得1积分" },
    { icon: $r("app.media.coupon5"), title: "邀请好友", tip: "好友首次下单双方得30积分" }
  ]

  // 积分兑换规则条文数组
  @Local ruleList: RuleLine[] = [
    { text: "1. 积分永久有效，不会自动过期" },
    { text: "2. 兑换后的优惠券自动存入「我的卡包」" },
    { text: "3. 每种优惠券每人每日最多兑换2张" },
    { text: "4. 优惠券有效期以卡包内展示为准，过期不予退回积分" }
  ]

  build() {
    Column() {
      this.TopNavBar()

      Scroll() {
        Column() {
          // 积分余额展示卡片
          this.PointBalanceCard()
          Blank().height(16)

          // 积分获取渠道标题文字
          Text("如何获取积分")
            .fontSize(17)
            .fontWeight(FontWeight.Medium)
            .width("100%")
            .padding({ left: 16 })
          Blank().height(10)
          // 积分渠道列表
          this.PointSourceArea()
          Blank().height(20)

          // 优惠券兑换板块标题
          Text("积分兑换优惠券")
            .fontSize(17)
            .fontWeight(FontWeight.Medium)
            .width("100%")
            .padding({ left: 16 })
          Blank().height(10)

          // 优惠券列表卡片容器
          this.CouponListArea()
          Blank().height(20)

          // 兑换须知标题
          Text("兑换须知")
            .fontSize(17)
            .fontWeight(FontWeight.Medium)
            .width("100%")
            .padding({ left: 16 })
          Blank().height(10)
          // 规则说明区块
          this.RuleBlock()

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
   * @Builder 顶部返回导航栏
   * 左侧返回箭头，中间页面标题，右侧空白占位保证文字居中
   */
  @Builder
  TopNavBar() {
    Row() {
      // 返回上一页按钮
      Image($r("app.media.left"))
        .width(24)
        .height(24)
        .onClick(() => router.back())
      Blank()
      Text("优惠券兑换")
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
   * @Builder 用户积分余额卡片
   * 显示当前积分，附带跳转签到页面的文字入口
   */
  @Builder
  PointBalanceCard() {
    Row() {
      Column() {
        Text("当前可用积分")
          .fontSize(13)
          .fontColor("#999")
        Text(`${this.ownPoint}`)
          .fontSize(34)
          .fontWeight(FontWeight.Bold)
          .fontColor("#D84A7C")
      }
      Blank()
      Text("去签到赚积分 >")
        .fontSize(13)
        .fontColor("#D84A7C")
    }
    .width("92%")
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ left: "4%", right: "4%" })
  }

  /**
   * @Builder 积分获取渠道列表
   * 循环渲染每一条途径，左侧图标，右侧标题+说明
   */
  @Builder
  PointSourceArea() {
    Column() {
      ForEach(this.sourceList, (item: PointSource) => {
        Row() {
          Image(item.icon)
            .width(36)
            .height(36)
            .margin({ right: 12 })
          Column() {
            Text(item.title)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
            Text(item.tip)
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
   * @Builder 优惠券列表容器
   * 每行一张优惠券，左侧图片，中间文字信息，右侧兑换按钮
   * 积分充足按钮高亮可扣减积分，积分不足按钮置灰无法点击
   */
  @Builder
  CouponListArea() {
    Column() {
      ForEach(this.couponList, (item: CouponItem) => {
        Row() {
          // 优惠券配图
          Image(item.coverImg)
            .width(80)
            .height(80)
            .borderRadius(8)
            .objectFit(ImageFit.Cover)
            .margin({ right: 12 })
          // 优惠券文字信息
          Column() {
            Text(item.title)
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
            Text(item.desc)
              .fontSize(12)
              .fontColor("#999")
              .margin({ top: 4 })
            Text(`所需积分：${item.needPoint}`)
              .fontSize(12)
              .fontColor("#D84A7C")
              .margin({ top: 6 })
          }
          .layoutWeight(1)
          Blank()
          // 兑换按钮与点击逻辑
          Text("立即兑换")
            .width(78)
            .height(34)
            .textAlign(TextAlign.Center)
            .fontSize(12)
            // 根据积分动态切换文字和背景色
            .fontColor(this.ownPoint >= item.needPoint ? Color.White : "#cccccc")
            .backgroundColor(this.ownPoint >= item.needPoint ? "#D84A7C" : "#eeeeee")
            .borderRadius(17)
            .onClick(() => {
              // 积分足够才执行扣减
              if (this.ownPoint >= item.needPoint) {
                this.ownPoint -= item.needPoint
                console.log("兑换成功：", item.title)
              }
            })
        }
        .width("92%")
        .padding({ top: 12, bottom: 12 })
      })
    }
    .width("100%")
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ left: "4%", right: "4%" })
    .padding({ left: 12, right: 12 })
  }

  /**
   * @Builder 底部兑换规则文字区块
   * 逐条展示兑换条款
   */
  @Builder
  RuleBlock() {
    Column() {
      ForEach(this.ruleList, (rule: RuleLine) => {
        Text(rule.text)
          .fontSize(12)
          .fontColor("#666")
          .lineHeight(22)
          .width("100%")
          .margin({ top: 4 })
      })
    }
    .width("92%")
    .padding(14)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ left: "4%", right: "4%" })
  }
}