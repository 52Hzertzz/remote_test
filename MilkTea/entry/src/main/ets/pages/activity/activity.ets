// 会员活动页面
// 页面功能：展示首页轮播Banner、各类优惠活动卡片列表，底部挂载公共TabBar导航
import { TabBar } from '../../components/TabBar';

// 活动卡片数据模型：定义单条活动所需全部字段
interface ActivityItem {
  title: string        // 活动标题
  desc: string         // 活动描述
  tagText: string      // 活动标签文字
  imgRes: ResourceStr  // 活动配图资源
  endTime: string      // 活动截止时间
}

@Entry
@ComponentV2
struct ActivityPage {
  // 顶部轮播图资源数组，存放多张Banner图片
  bannerImgList: ResourceStr[] = [
    $r("app.media.picture1"),
    $r("app.media.picture2"),
    $r("app.media.picture3")
  ]

  // 活动模拟数据数组，存储所有展示活动
  @Local activityList: ActivityItem[] = [
    {
      title: "开业全场8折优惠",
      desc: "到店任意饮品享八折，不限杯数",
      tagText: "限时活动",
      imgRes: $r("app.media.picture4"),
      endTime: "2026-06-30"
    },
    {
      title: "买二送一小料活动",
      desc: "任意两杯饮品免费赠送加料一份",
      tagText: "长期活动",
      imgRes: $r("app.media.picture5"),
      endTime: "长期有效"
    },
    {
      title: "会员积分兑换奶茶",
      desc: "100积分兑换大杯招牌茉莉奶白",
      tagText: "会员专享",
      imgRes: $r("app.media.picture6"),
      endTime: "2026-07-15"
    },
    {
      title: "周二免配送费",
      desc: "每周二外卖订单全部免除配送费用",
      tagText: "每周福利",
      imgRes: $r("app.media.picture7"),
      endTime: "长期有效"
    }
  ]

  build() {
    Column() {
      // 1. 顶部标题栏
      this.TopTitleBar()

      // 2. 可滚动主体内容区
      Scroll() {
        Column() {
          this.ActivitySwiperBanner()
          Blank().height(16)

          // 活动列表标题行：左侧全部活动，右侧更多活动入口文字
          Row() {
            Text("全部活动")
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
            Blank()
            Text("更多活动 >")
              .fontSize(13)
              .fontColor("#999")
          }
          .width("100%")
          .padding({ left: 12, right: 12 })
          Blank().height(10)

          // 循环渲染所有活动卡片
          ForEach(this.activityList, (item: ActivityItem) => {
            this.ActivityCard(item)
          })

          Blank().height(40)
        }
        .width("100%")
        .padding({ left: 0, right: 0 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)

      TabBar({ currentPage: "activity" })
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .width("100%")
    .height("100%")
    .backgroundColor("#f8f8f8")
  }

  /**
   * @Builder 页面顶部标题栏组件
   * 左侧居中页面标题，右侧图标
   */
  @Builder
  TopTitleBar() {
    Row() {
      Text("会员活动")
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
      Image($r("app.media.checked"))
        .width(24)
        .height(24)
    }
    .width("100%")
    .height(50)
    .padding({ left: 16, right: 16 })
    .backgroundColor(Color.White)
  }

  /**
   * @Builder 顶部Swiper自动轮播Banner组件
   * 替换原有横向Scroll，支持自动播放、循环、指示器
   */
  @Builder
  ActivitySwiperBanner() {
    Swiper() {
      ForEach(this.bannerImgList, (img: ResourceStr) => {
        Image(img)
          .width("100%")
          .height("100%")
          .objectFit(ImageFit.Contain)
          .backgroundColor("#f8f8f8")
      })
    }
    .width("96%")
    .height(160) // 固定轮播高度，适配奶茶横幅比例
    .autoPlay(true) // 开启自动轮播
    .interval(3000) // 轮播切换间隔3秒
    .loop(true) // 循环轮播
    .indicator(true) // 显示底部小圆点指示器
    .borderRadius(12)
    .padding(4) // 图片与圆角边框内边距
    .margin({ left: "2%", right: "2%" })
  }

  /**
   * @Builder 单条活动卡片组件
   * @param item 单条活动数据对象
   * 布局：左侧活动图 + 右侧文字信息区域
   */
  @Builder
  ActivityCard(item: ActivityItem) {
    Row() {
      // 左侧活动配图
      Image(item.imgRes)
        .width(90)
        .height(90)
        .borderRadius(8)
        .objectFit(ImageFit.Cover)

      // 右侧文字信息容器
      Column() {
        // 标题+标签行
        Row() {
          Text(item.title)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
          Blank()
          Text(item.tagText)
            .fontSize(11)
            .fontColor("#D84A7C")
            .padding({ left: 6, right: 6, top: 2, bottom: 2 })
            .backgroundColor("#fcf0f4")
            .borderRadius(99)
        }
        .width("100%")
        .margin({ bottom: 6 })

        // 活动描述文字
        Text(item.desc)
          .fontSize(12)
          .fontColor("#666")
          .width("100%")
          .margin({ bottom: 8 })

        // 活动截止时间
        Text(`活动截止：${item.endTime}`)
          .fontSize(11)
          .fontColor("#999")
          .width("100%")
      }
      .layoutWeight(1)
      .margin({ left: 12 })
    }
    .width("100%")
    .padding(14)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ left: 12, right: 12, bottom: 10 })
  }
}