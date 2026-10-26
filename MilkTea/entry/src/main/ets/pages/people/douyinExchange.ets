// 抖音点评兑换页面 DouyinExchangePage
// 页面功能：展示用户抖音点评积分，使用积分兑换优惠券，查看完整活动规则
import { router } from '@kit.ArkUI';

// 优惠券数据模型
interface ExchangeCoupon {
  title: string        // 优惠券名称
  desc: string         // 优惠券使用说明
  needPoint: number    // 兑换所需积分数量
  img: ResourceStr     // 优惠券图片资源
}

// 活动条款数据模型
interface RuleItem {
  content: string     // 单条规则文字内容
}

@Entry
@ComponentV2
struct DouyinExchangePage {
  // 用户当前可用点评积分，响应式变量
  @Local userPoint: number = 60

  // 可兑换优惠券数组数据
  @Local couponList: ExchangeCoupon[] = [
    {
      title: "免费加料券",
      desc: "任意饮品免费添加一份小料",
      needPoint: 20,
      img: $r("app.media.douying1")
    },
    {
      title: "饮品5元抵扣券",
      desc: "全场饮品下单立减5元",
      needPoint: 40,
      img: $r("app.media.douying2")
    },
    {
      title: "招牌奶茶半价券",
      desc: "招牌茉莉奶茶半价购买",
      needPoint: 60,
      img: $r("app.media.douying3")
    },
    {
      title: "双人8折券",
      desc: "两杯饮品享8折优惠",
      needPoint: 100,
      img: $r("app.media.douying4")
    }
  ]

  // 抖音点评活动规则列表
  @Local ruleList: RuleItem[] = [
    { content: "1. 抖音发布茉莉奶白带图点评，审核通过即可获得20点评积分" },
    { content: "2. 每条点评仅可领取一次积分，重复发布不计入积分" },
    { content: "3. 积分永久有效，可在本页面兑换各类饮品优惠券" },
    { content: "4. 兑换后优惠券自动发放至卡包，有效期7天" },
    { content: "5. 活动仅限抖音平台参与，其他平台不参与本次兑换活动" }
  ]

  build() {
    Column() {
      this.TopBackBar()

      Scroll() {
        Column() {
          // 用户积分信息卡片
          this.PointInfoCard()
          Blank().height(16)

          // 优惠券板块标题文字
          Text("可兑换优惠券")
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .width("100%")
            .padding({ left: 16 })
          Blank().height(10)

          // 优惠券列表容器
          this.CouponListArea()
          Blank().height(20)

          // 活动规则板块标题文字
          Text("活动规则")
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .width("100%")
            .padding({ left: 16 })
          Blank().height(10)

          // 规则文字展示区域
          this.RuleArea()
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
   * @Builder 顶部返回导航栏组件
   * 左侧返回箭头，中间页面标题，右侧空白占位保证标题居中对齐
   */
  @Builder
  TopBackBar() {
    Row() {
      Image($r("app.media.left"))
        .width(24)
        .height(24)
        .onClick(() => router.back())
      Blank()
      Text("抖音点评兑换")
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
   * @Builder 用户积分卡片组件
   * 展示当前积分，附带跳转获取积分的文字入口
   */
  @Builder
  PointInfoCard() {
    Row() {
      Column() {
        Text("我的点评积分")
          .fontSize(13)
          .fontColor("#666")
        Text(`${this.userPoint}`)
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor("#D84A7C")
      }
      Blank()
      Text("去抖音发布点评赚积分 >")
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
   * @Builder 优惠券列表组件
   * 循环渲染每一张优惠券条目
   * 积分充足时按钮高亮可兑换，积分不足按钮置灰无法扣减积分
   */
  @Builder
  CouponListArea() {
    Column() {
      ForEach(this.couponList, (item: ExchangeCoupon) => {
        Row() {
          // 优惠券图片
          Image(item.img)
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
            .width(72)
            .height(32)
            .textAlign(TextAlign.Center)
            .fontSize(12)
            // 根据积分动态切换按钮样式
            .fontColor(this.userPoint >= item.needPoint ? Color.White : "#ccc")
            .backgroundColor(this.userPoint >= item.needPoint ? "#D84A7C" : "#eee")
            .borderRadius(16)
            .onClick(() => {
              // 积分足够才执行扣减操作
              if (this.userPoint >= item.needPoint) {
                this.userPoint -= item.needPoint
                console.log("兑换成功", item.title)
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
   * @Builder 活动规则文字区块
   * 逐条渲染活动条款
   */
  @Builder
  RuleArea() {
    Column() {
      ForEach(this.ruleList, (rule: RuleItem) => {
        Text(rule.content)
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