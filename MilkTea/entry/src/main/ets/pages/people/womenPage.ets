// 女性专属页面 WomenPage
// 页面功能：展示女生专属活动横幅、会员福利，双列网格展示少女系列饮品
import { router } from '@kit.ArkUI';

// 女性特调饮品数据模型
interface WomenDrink {
  name: string        // 饮品名称
  desc: string        // 饮品简短介绍
  img: ResourceStr    // 饮品图片资源
  tag: string         // 商品标签文案
}

// 女生专属权益福利模型
interface WomenBenefit {
  icon: ResourceStr  // 福利图标
  title: string      // 福利标题
  tip: string        // 福利说明文案
}

@Entry
@ComponentV2
struct WomenPage {
  // 少女款饮品列表数据
  @Local drinkList: WomenDrink[] = [
    { name: "桃桃茉莉", desc: "水蜜桃果肉搭配清新茉莉茶底，清甜低卡", img: $r("app.media.womenPage1"), tag: "人气少女款" },
    { name: "玫瑰奶白", desc: "重瓣玫瑰+顺滑奶底，花香温柔不腻口", img: $r("app.media.womenPage2"), tag: "养颜推荐" },
    { name: "荔枝玉露", desc: "新鲜荔枝果肉，清甜水润无负担", img: $r("app.media.womenPage3"), tag: "夏日限定" },
    { name: "樱花小奶绿", desc: "樱花风味绿茶，颜值超高适合拍照", img: $r("app.media.womenPage4"), tag: "颜值爆款" },
    { name: "芋泥牛乳", desc: "手工厚切芋泥，软糯绵密女生最爱", img: $r("app.media.womenPage5"), tag: "暖心热饮" },
    { name: "西柚茉莉气泡", desc: "西柚鲜果气泡水，清爽解腻减脂友好", img: $r("app.media.womenPage6"), tag: "低卡轻饮" }
  ]

  // 女生专属权益列表
  @Local benefitList: WomenBenefit[] = [
    { icon: $r("app.media.half_discount"), title: "每月女生日半价", tip: "生日当月任意饮品半价购买" },
    { icon: $r("app.media.pink_couple"), title: "粉色周边优先兑", tip: "限定少女周边优先开放兑换" },
    { icon: $r("app.media.jialiao"), title: "小料免费加一份", tip: "点女性系列饮品免费加一份小料" }
  ]

  build() {
    Column() {
      // 顶部返回导航栏组件
      this.TopBackBar()

      Scroll() {
        Column() {
          // 顶部粉色宣传横幅海报
          this.BannerCard()
          Blank().height(16)

          // 专属福利板块标题
          Text("女生专属福利")
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .width("100%")
            .padding({ left: 16 })
          Blank().height(10)
          // 福利条目列表
          this.BenefitArea()
          Blank().height(20)

          // 饮品菜单板块标题
          Text("少女感特调饮品")
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .width("100%")
            .padding({ left: 16 })
          Blank().height(10)

          // 双列网格展示所有饮品卡片
          this.DrinkGrid()
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
   * 左侧返回箭头，中间页面标题，右侧空白占位保证标题居中
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
      Text("女性专属")
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
   * @Builder 顶部粉色横幅海报组件
   */
  @Builder
  BannerCard() {
    Stack() {
      Image($r("app.media.womenPage_big"))
        .width("92%")
        .height(160)
        .borderRadius(16)
        .objectFit(ImageFit.Cover)
    }
    .width("100%")
  }

  /**
   * @Builder 女生专属福利列表
   * 左侧图标，右侧福利标题+说明文字
   */
  @Builder
  BenefitArea() {
    Column() {
      ForEach(this.benefitList, (item: WomenBenefit) => {
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
   * @Builder 双列饮品网格布局
   * 每张卡片包含标签、饮品图片、名称与简介，文字超长自动截断
   */
  @Builder
  DrinkGrid() {
    Grid() {
      ForEach(this.drinkList, (item: WomenDrink) => {
        GridItem() {
          Column() {
            // 商品特色标签
            Text(item.tag)
              .fontSize(11)
              .fontColor(Color.White)
              .backgroundColor("#D84A7C")
              .borderRadius(99)
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .width("50%")
              .textAlign(TextAlign.Center)
            Blank().height(6)
            // 饮品实拍图
            Image(item.img)
              .width("100%")
              .height(110)
              .borderRadius(10)
              .objectFit(ImageFit.Cover)
            Blank().height(8)
            // 饮品名称，单行超出省略
            Text(item.name)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .width("100%")
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
            Blank().height(4)
            // 饮品介绍，最多两行文字
            Text(item.desc)
              .fontSize(11)
              .fontColor("#999")
              .width("100%")
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .width("100%")
          .height(190)
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