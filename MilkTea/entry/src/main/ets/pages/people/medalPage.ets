// 电子勋章页面 MedalPage
// 页面功能：展示用户所有成就勋章，区分已解锁与未解锁，双列网格布局，显示解锁进度与获取条件
import { router } from '@kit.ArkUI';

// 勋章信息数据模型
interface MedalItem {
  medalName: string    // 勋章名称
  desc: string         // 勋章描述文案
  iconImg: ResourceStr // 勋章图标资源
  isGet: boolean       // 解锁状态：true已解锁，false未解锁
  getTip: string        // 解锁条件说明
}

@Entry
@ComponentV2
struct MedalPage {
  // 全部勋章数据集合
  @Local medalList: MedalItem[] = [
    {
      medalName: "初来乍到",
      desc: "首次注册茉莉奶白账号",
      iconImg: $r("app.media.medal1"),
      isGet: true,
      getTip: "注册账号自动解锁"
    },
    {
      medalName: "奶茶爱好者",
      desc: "累计下单10杯饮品",
      iconImg: $r("app.media.medal2"),
      isGet: true,
      getTip: "累计下单满10杯解锁"
    },
    {
      medalName: "签到达人",
      desc: "连续签到7天",
      iconImg: $r("app.media.medal3"),
      isGet: false,
      getTip: "连续7天每日签到解锁"
    },
    {
      medalName: "储值大佬",
      desc: "单次储值200元及以上",
      iconImg: $r("app.media.medal4"),
      isGet: false,
      getTip: "充值200元档位解锁"
    },
    {
      medalName: "分享达人",
      desc: "邀请3位好友注册下单",
      iconImg: $r("app.media.medal5"),
      isGet: false,
      getTip: "成功邀请3位新用户解锁"
    },
    {
      medalName: "周边收藏家",
      desc: "积分兑换任意3款周边",
      iconImg: $r("app.media.medal6"),
      isGet: false,
      getTip: "积分商城兑换3次周边解锁"
    }
  ]

  build() {
    Column() {
      this.TopBackBar()

      Scroll() {
        Column() {
          // 已解锁勋章进度统计卡片
          this.MedalCountCard()
          Blank().height(16)

          // 勋章列表标题文字
          Text("我的全部勋章")
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .width("100%")
            .padding({ left: 16 })
          Blank().height(10)

          // 双列网格展示所有勋章
          this.MedalGridArea()
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
   * 左侧返回箭头，中间页面标题，右侧空白占位保持文字居中
   */
  @Builder
  TopBackBar() {
    Row() {
      Image($r("app.media.left"))
        .width(24)
        .height(24)
        .onClick(() => router.back())
      Blank()
      Text("电子勋章")
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
   * @Builder 勋章解锁进度卡片
   * 展示已解锁数量 / 总数量，附带前往做任务的引导文字
   */
  @Builder
  MedalCountCard() {
    Row() {
      Column() {
        Text("已解锁勋章")
          .fontSize(13)
          .fontColor("#999")
        Text("2 / 6")
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor("#D84A7C")
      }
      Blank()
      Text("完成任务解锁更多专属勋章 >")
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
   * @Builder 双列网格勋章布局
   * 已解锁勋章正常显示，未解锁勋章图标与文字置灰
   */
  @Builder
  MedalGridArea() {
    Grid() {
      ForEach(this.medalList, (item: MedalItem) => {
        GridItem() {
          Column() {
            // 勋章图标：未解锁降低透明度置灰
            Image(item.iconImg)
              .width(80)
              .height(80)
              .objectFit(ImageFit.Contain)
              .opacity(item.isGet ? 1 : 0.4)
            Blank().height(10)
            // 勋章名称：未解锁文字变灰色
            Text(item.medalName)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor(item.isGet ? "#333" : "#999")
            Blank().height(4)
            // 解锁条件说明小字
            Text(item.getTip)
              .fontSize(11)
              .fontColor("#aaa")
              .textAlign(TextAlign.Center)
              .width("100%")
          }
          .width("100%")
          .height(160)
          .padding(12)
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