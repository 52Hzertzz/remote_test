// 积分兑换商城页面 PointsShopPage
// 页面功能：以双列网格展示所有积分可兑换商品，显示商品图片、名称与所需积分
import { router } from '@kit.ArkUI';

// 积分兑换商品数据模型
interface PointsGoods {
  goodsName: string    // 商品名称
  needPoints: number   // 兑换所需积分
  imgRes: ResourceStr  // 商品图片资源
}

@Entry
@ComponentV2
struct PointsShopPage {
  // 所有可兑换商品数组数据
  @Local goodsList: PointsGoods[] = [
    { goodsName: "招牌茉莉奶茶一杯", needPoints: 80, imgRes: $r("app.media.MilkTea17") },
    { goodsName: "椰果加料券", needPoints: 30, imgRes: $r("app.media.yeguo") },
    { goodsName: "茉莉奶白帆布袋", needPoints: 120, imgRes: $r("app.media.fanbudai") },
    { goodsName: "芝士奶盖兑换券", needPoints: 60, imgRes: $r("app.media.naigai") },
    { goodsName: "定制吸管套装", needPoints: 90, imgRes: $r("app.media.xiguan") },
    { goodsName: "全品类8折优惠券", needPoints: 150, imgRes: $r("app.media.8discount") },
    { goodsName: "多肉加料券", needPoints: 35, imgRes: $r("app.media.duorou") },
    { goodsName: "茉莉周边钥匙扣", needPoints: 100, imgRes: $r("app.media.yaoshikou") }
  ]

  build() {
    Column() {
      this.TopBackBar()

      // 可滚动商品列表区域
      Scroll() {
        Column() {
          // 标题行：左侧文字，右侧当前积分
          Row() {
            Text('积分兑换商城')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
            Blank()
            Text('当前可用积分：100')
              .fontSize(13)
              .fontColor("#D84A7C")
          }
          .width("100%")
          .padding({ left: 16, right: 16, top: 12, bottom: 12 })

          // 两列均等网格布局渲染商品卡片
          Grid() {
            ForEach(this.goodsList, (item: PointsGoods) => {
              GridItem() {
                this.GoodsCard(item)
              }
            })
          }
          .columnsTemplate("1fr 1fr")
          .columnsGap(12)
          .rowsGap(12)
          .width("100%")
          .padding({ left: 16, right: 16 })

          // 底部空白间距
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
   * 左侧返回箭头，中间页面标题，右侧空白占位保证标题居中
   */
  @Builder
  TopBackBar() {
    Row() {
      Image($r("app.media.left"))
        .width(24)
        .height(24)
        .onClick(() => router.back())
      Blank()
      Text("积分兑换")
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
   * @Builder 单个商品卡片组件
   * 结构：商品图片 + 商品名称 + 兑换积分文字
   * @param item 单条商品数据对象
   */
  @Builder
  GoodsCard(item: PointsGoods) {
    Column() {
      // 商品封面图
      Image(item.imgRes)
        .width("100%")
        .height(120)
        .borderRadius(10)
        .objectFit(ImageFit.Cover)
      Blank().height(8)
      // 商品名称
      Text(item.goodsName)
        .fontSize(13)
        .fontColor("#333")
        .width("100%")
      Blank().height(6)
      // 兑换所需积分
      Text(`${item.needPoints}积分兑换`)
        .fontSize(12)
        .fontColor("#D84A7C")
        .width("100%")
    }
    .width("100%")
    .padding(10)
    .backgroundColor(Color.White)
    .borderRadius(12)
  }
}