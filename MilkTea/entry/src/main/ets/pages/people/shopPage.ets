// 周边商城页面 ShopPage
// 页面功能：展示用户积分、横向商品分类、双列网格周边商品，点击兑换自动扣减积分
import { router } from '@kit.ArkUI';

// 周边商品数据模型
interface ShopGoods {
  name: string          // 商品名称
  needPoint: number     // 兑换所需积分
  coverImg: ResourceStr // 商品图片资源
  desc: string          // 商品简短描述
}

// 商品分类标签模型
interface CategoryItem {
  title: string // 分类名称
}

@Entry
@ComponentV2
struct ShopPage {
  // 用户当前可用积分，响应式变量，兑换成功自动扣减
  @Local userPoint: number = 220

  // 横向分类标签数组
  @Local categoryList: CategoryItem[] = [
    { title: "全部周边" },
    { title: "杯具水杯" },
    { title: "帆布袋" },
    { title: "钥匙扣挂件" },
    { title: "文具周边" }
  ]

  // 所有周边商品数据集合
  @Local goodsList: ShopGoods[] = [
    { name: "MOLLYTEA 奶茶玻璃杯", needPoint: 110, coverImg: $r("app.media.shopPage1"), desc: "透明ins风饮品玻璃杯" },
    { name: "品牌印花帆布袋", needPoint: 130, coverImg: $r("app.media.shopPage2"), desc: "大容量通勤手提布袋" },
    { name: "奶茶造型钥匙扣", needPoint: 85, coverImg: $r("app.media.shopPage3"), desc: "迷你立体挂件挂饰" },
    { name: "定制吸管套装", needPoint: 90, coverImg: $r("app.media.shopPage4"), desc: "玻璃吸管+收纳盒" },
    { name: "联名笔记本", needPoint: 100, coverImg: $r("app.media.shopPage5"), desc: "横线内页便携记事本" },
    { name: "渐变马克水杯", needPoint: 120, coverImg: $r("app.media.shopPage6"), desc: "家用办公喝水马克杯" }
  ]

  build() {
    Column() {
      // 顶部返回导航栏
      this.TopBackBar()

      Scroll() {
        Column() {
          // 用户积分信息卡片
          this.PointCard()
          Blank().height(16)

          // 横向滑动分类标签栏
          this.CategoryScroll()
          Blank().height(16)

          // 双列网格商品列表
          this.GoodsGrid()
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
   * 左侧返回箭头，中间页面标题，右侧空白占位保持文字居中
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
      Text("周边商城")
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
   * 展示当前可用积分，附带攒积分引导文字
   */
  @Builder
  PointCard() {
    Row() {
      Column() {
        Text("我的可用积分")
          .fontSize(13)
          .fontColor("#999")
        Text(`${this.userPoint}`)
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor("#D84A7C")
      }
      Blank()
      Text("做任务攒更多积分 >")
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
   * @Builder 横向滚动分类标签栏
   * 标签可左右滑动浏览所有分类
   */
  @Builder
  CategoryScroll() {
    Scroll() {
      Row() {
        ForEach(this.categoryList, (cate: CategoryItem) => {
          Text(cate.title)
            .fontSize(13)
            .padding({ left: 14, right: 14, top: 6, bottom: 6 })
            .backgroundColor(Color.White)
            .borderRadius(99)
            .margin({ left: 8 })
        })
      }
    }
    .width("100%")
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
    .padding({ left: 16 })
  }

  /**
   * @Builder 双列网格商品布局
   * 每一项包含商品图片、名称、描述、积分与兑换按钮
   * 积分充足才可扣减积分完成兑换
   */
  @Builder
  GoodsGrid() {
    Grid() {
      ForEach(this.goodsList, (item: ShopGoods) => {
        GridItem() {
          Column() {
            // 商品封面图
            Image(item.coverImg)
              .width("100%")
              .height(130)
              .borderRadius(10)
              .objectFit(ImageFit.Cover)
            Blank().height(8)

            // 商品名称，文字超长自动省略
            Text(item.name)
              .fontSize(13)
              .fontWeight(FontWeight.Medium)
              .width("100%")
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
            Blank().height(4)

            // 商品简短描述
            Text(item.desc)
              .fontSize(11)
              .fontColor("#999")
              .width("100%")
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
            Blank().layoutWeight(1)

            // 积分文字 + 兑换按钮行
            Row() {
              Text(`${item.needPoint}积分兑换`)
                .fontSize(12)
                .fontColor("#D84A7C")
              Blank().layoutWeight(1)
              Text("兑换")
                .fontSize(11)
                .fontColor(Color.White)
                .padding({ left: 10, right: 10, top: 3, bottom: 3 })
                .backgroundColor("#D84A7C")
                .borderRadius(12)
                .onClick(() => {
                  // 判断积分是否充足，充足再扣减积分
                  if(this.userPoint >= item.needPoint){
                    this.userPoint -= item.needPoint
                    console.log("兑换成功", item.name)
                  }
                })
            }
            .width("100%")
            .margin({ top: 8 })
          }
          .width("100%")
          .height(220)
          .padding(10)
          .backgroundColor(Color.White)
          .borderRadius(12)
        }
      })
    }
    .columnsTemplate("1fr 1fr")
    .columnsGap(12)
    .rowsGap(12)
    .width("92%")
  }
}