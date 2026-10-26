// 茉莉权益卡开通页面 CardVipPage
// 页面功能：展示会员卡宣传横幅、会员全部专属权益、三种档位开通套餐，支持横向滑动切换套餐
import { router } from '@kit.ArkUI';

// 权益套餐数据模型：开通套餐相关信息
interface VipPackage {
  title: string    // 套餐名称
  price: string     // 套餐价格
  giftText: string  // 开通赠送福利文案
  tag: string       // 套餐标签（性价比首选/热销推荐等）
}

// 会员专属权益条目模型
interface VipBenefit {
  icon: ResourceStr // 权益图标资源
  title: string     // 权益标题
  desc: string      // 权益详细说明
}

@Entry
@ComponentV2
struct CardVipPage {
  // 会员开通套餐数组，存储月度/季度/年度三种套餐
  @Local packageList: VipPackage[] = [
    { title: "月度权益卡", price: "12.9", giftText: "赠加料券2张", tag: "性价比首选" },
    { title: "季度权益卡", price: "29.9", giftText: "赠招牌奶茶一杯", tag: "热销推荐" },
    { title: "年度权益卡", price: "88", giftText: "全年8折+每月免费加料", tag: "最划算" }
  ]

  // 会员专属权益数组，展示全部会员福利
  @Local benefitList: VipBenefit[] = [
    { icon: $r("app.media.discount"), title: "全场饮品折扣", desc: "会员专享常年9折，年卡低至8折" },
    { icon: $r("app.media.jialiao"), title: "每月免费加料", desc: "每月可领取2份免费小料" },
    { icon: $r("app.media.birthday"), title: "生日专属福利", desc: "生日当天免费兑换大杯奶茶" },
    { icon: $r("app.media.new2"), title: "新品优先尝鲜", desc: "上新会员提前体验限定饮品" },
    { icon: $r("app.media.jifen"), title: "积分加速翻倍", desc: "消费积分双倍累计，兑换更快" }
  ]

  build() {
    Column() {
      this.TopBackBar()

      Scroll() {
        Column() {
          // 顶部会员卡宣传大图横幅
          this.CardBanner()
          Blank().height(16)

          // 会员专属权益模块标题行
          Row() {
            Text("会员专属权益")
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
            Blank()
          }
          .width("100%")
          .padding({ left: 16 })
          Blank().height(10)

          // 权益列表容器，循环渲染所有权益条目
          this.BenefitList()
          Blank().height(20)

          // 开通套餐模块标题行
          Row() {
            Text("立即开通权益卡")
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
          }
          .width("100%")
          .padding({ left: 16 })
          Blank().height(10)

          // 横向滚动套餐卡片区域
          this.PackageScroll()
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
   * @Builder 顶部返回导航栏组件
   * 左侧返回箭头，中间页面标题，右侧占位空白保持居中对齐
   */
  @Builder
  TopBackBar() {
    Row() {
      // 返回按钮，点击回到上一页
      Image($r("app.media.left"))
        .width(24)
        .height(24)
        .onClick(() => router.back())
      Blank()
      Text("茉莉权益卡")
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
   * @Builder 顶部会员卡宣传横幅组件
   * 单张全屏卡片背景图展示VIP视觉海报
   */
  @Builder
  CardBanner() {
    Stack() {
      Image($r("app.media.VIPcard"))
        .width("92%")
        .height(160)
        .borderRadius(16)
        .objectFit(ImageFit.Cover)
    }
    .width("100%")
  }

  /**
   * @Builder 会员权益列表组件
   * 循环渲染每条权益，左侧图标、右侧权益标题+说明
   */
  @Builder
  BenefitList() {
    Column() {
      ForEach(this.benefitList, (item: VipBenefit) => {
        Row() {
          // 权益图标
          Image(item.icon)
            .width(36)
            .height(36)
            .margin({ right: 12 })
          // 权益文字信息
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
   * @Builder 套餐横向滚动容器
   * 水平滑动展示三种开通档位卡片，每张卡片包含标签、价格、福利、开通按钮
   */
  @Builder
  PackageScroll() {
    Scroll() {
      Row() {
        ForEach(this.packageList, (pkg: VipPackage) => {
          Column() {
            // 套餐特色标签
            Text(pkg.tag)
              .fontSize(11)
              .fontColor(Color.White)
              .padding({ left: 8, right: 8, top: 2, bottom: 2 })
              .backgroundColor("#D84A7C")
              .borderRadius(99)
              .margin({ bottom: 10 })
            // 套餐名称
            Text(pkg.title)
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
            // 价格展示行
            Row() {
              Text("¥")
                .fontSize(12)
                .fontColor("#D84A7C")
              Text(pkg.price)
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .fontColor("#D84A7C")
            }
            .margin({ top: 8, bottom: 8 })
            // 开通赠送福利文案
            Text(pkg.giftText)
              .fontSize(12)
              .fontColor("#666")

            // 开通按钮
            Text("立即开通")
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