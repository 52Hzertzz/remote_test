// 页面功能：小程序首页，包含顶部轮播Banner、自取/外送点单入口、四大功能快捷入口、底部Tab导航栏
import { TabBar } from '../../components/TabBar';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  build() {
    Column() {
      Scroll() {
        Column() {
          // 1. 顶部通栏粉色Banner区域（全屏覆盖）
          this.TopBanner()

          // 2. 自取+外送双卡片模块
          this.TakeCardGroup()

          Blank().height(20)

          // 3. 底部四大功能入口
          this.FunctionGrid()

          // 预留空白高度，方便后续新增更多商品/活动板块
          Blank().height(40)
        }
        .width("100%")
        .padding({ left: 0, right: 0, bottom: 20 })
      }
      .layoutWeight(1)
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)

      TabBar({ currentPage: "home" })
    }
    .width("100%")
    .height("100%")
    .backgroundColor("#ffffff")
  }

  /**
   * @Builder 顶部全屏Banner组件
   * 结构：底层背景图 + 顶部悬浮门店信息标签
   * 点击Banner跳转权益卡页面
   */
  @Builder
  TopBanner() {
    Stack({ alignContent: Alignment.Top }) {
      Image($r('app.media.tea_background'))
        .width("100%")
        .height(400)
        .objectFit(ImageFit.Cover)
        .onClick(()=>{
          router.pushUrl({url:"pages/Index/cardVip"})
        })
      // 顶部悬浮门店信息行容器
      Row() {
        Image($r("app.media.mollytea"))
          .width(16)
          .height(16)
        Text("茉莉奶白小程序提供服务")
          .fontSize(14)
          .fontColor("#333333")
          .padding({ right: 18 })
        Image($r("app.media.star"))
          .width(16)
          .height(16)
          .padding({ right: 2 })
        Text("3.4")
          .fontSize(14)
          .fontColor("#333333")
          .padding({ right: 10 })
        Image($r("app.media.checked"))
          .width(20)
          .height(20)
      }
      .width("75%")
      .padding(7)
      .backgroundColor("#ffffff")
      .borderRadius(99)
      .margin({ top: 10 ,left: 80})
    }
    .width("100%")
    .height(400)
  }

  /**
   * @Builder 自取、外送双卡片组件
   * 布局：左右均分两栏卡片
   * 点击分别跳转点单页，传递对应订单类型参数
   */
  @Builder
  TakeCardGroup() {
    Row() {
      // 左侧自取卡片
      Column() {
        Text("自    取")
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
        Text("提前下单免排队")
          .fontSize(14)
          .fontColor("#666666")
          .margin({ top: 6, bottom: 12 })
        Image($r("app.media.dog1"))
          .width(60)
          .height(60)
      }
      .width("48%")
      .padding(20)
      .backgroundColor("#ffffff")
      .borderRadius(12)
      .alignItems(HorizontalAlign.Center)
      .onClick(() => {
        // 跳转到点单页，传递 "自取" 参数
        router.pushUrl({
          url: 'pages/tea/tea',
          params: {
            orderType: '自取'
          }
        })
      })

      Blank().width("4%")
      // 右侧外送卡片
      Column() {
        Text("外    送")
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
        Text("每周二免配送费")
          .fontSize(14)
          .fontColor("#666666")
          .margin({ top: 6, bottom: 12 })
        Image($r("app.media.dog2"))
          .width(60)
          .height(60)
      }
      .width("48%")
      .padding(10)
      .backgroundColor("#ffffff")
      .borderRadius(12)
      .alignItems(HorizontalAlign.Center)
      .onClick(() => {
        // 跳转到点单页，传递 "外卖" 参数
        router.pushUrl({
          url: 'pages/tea/tea',
          params: {
            orderType: '外卖'
          }
        })
      })
    }
    .width("80%")
  }

  /**
   * @Builder 首页四大功能横向网格入口
   * 从左至右：茉莉权益卡、心意礼卡、积分商城、储值有礼
   * 每个入口点击跳转对应二级页面
   */
  @Builder
  FunctionGrid() {
    Row() {
      // 入口1：茉莉权益卡
      Column() {
        Text("享专属权益")
          .fontSize(12)
          .fontColor("#D84A7C")
          .border({ width: 1 })
          .borderColor("#D84A7C")
          .borderRadius(99)
          .padding({ left: 6, right: 6, top: 1, bottom: 1 })
        Image($r("app.media.card1"))
          .width(30)
          .height(30)
          .margin({ top: 8 })
        Text("茉莉权益卡")
          .fontSize(13)
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Center)
      .onClick(()=>{
        router.pushUrl({url:"pages/Index/cardVip"})
      })

      // 入口2：心意礼卡
      Column() {
        Row() {
          Text("520限定")
            .fontSize(12)
            .fontColor("#666")
            .border({ width: 1 })
            .borderColor("#666")
            .borderRadius(99)
            .padding({ left: 6, right: 6, top: 1, bottom: 1 })
        }
        Image($r("app.media.card2"))
          .width(30)
          .height(30)
          .margin({ top: 8 })
        Text("心意礼卡")
          .fontSize(13)
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Center)
      .onClick(()=>{
        router.pushUrl({url:"pages/Index/giftCard"})
      })

      // 入口3：积分商城
      Column() {
        Text("联名周边")
          .fontSize(12)
          .fontColor("#ffbe9004")
          .border({ width: 1 })
          .borderColor("#ffbe9004")
          .borderRadius(99)
          .padding({ left: 6, right: 6, top: 1, bottom: 1 })
        Image($r("app.media.shop"))
          .width(30)
          .height(30)
          .margin({ top: 8 })
        Text("积分商城")
          .fontSize(13)
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Center)
      .onClick(()=>{
        router.pushUrl({url:"pages/people/pointsShop"})
      })

      // 入口4：储值有礼
      Column() {
        Text("赠免单")
          .fontSize(12)
          .fontColor("#ffbe9004")
          .border({ width: 1 })
          .borderColor("#ffbe9004")
          .borderRadius(99)
          .padding({ left: 6, right: 6, top: 1, bottom: 1 })
        Image($r("app.media.money"))
          .width(30)
          .height(30)
          .margin({ top: 8 })
        Text("储值有")
          .fontSize(13)
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Center)
      .onClick(() => {
        router.pushUrl({ url: "pages/Index/storePage" })
      })
    }
    .width("96%").padding(2)
  }
}