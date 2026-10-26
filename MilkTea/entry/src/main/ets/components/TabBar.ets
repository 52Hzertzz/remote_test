// 组件功能：全局底部五栏导航，首页/点单/会员活动/我的订单/会员中心
// 参数说明：currentPage - 当前所在页面标识，用于切换图标激活状态
import router from '@ohos.router';

@ComponentV2
export struct TabBar {
  // 传入必填参数：当前页面标识，用来区分tab选中状态
  @Param @Require currentPage: string

  build() {
    Row() {
      // Tab1 首页入口
      Column() {
        // 根据当前页面判断使用激活/未激活图标
        Image(this.currentPage === "home" ? $r("app.media.home_open") : $r("app.media.home_close"))
          .width(28).height(28)
        Text("首页").fontSize(12).margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Center)
      .onClick(() => {
        if (this.currentPage !== "home") {
          router.pushUrl({ url: "pages/Index/Index" })
        }
      })

      // Tab2 点单入口
      Column() {
        Image(this.currentPage === "tea" ? $r("app.media.tea_open") : $r("app.media.tea_close"))
          .width(28).height(28)
        Text("点单").fontSize(12).margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Center)
      .onClick(() => {
        if (this.currentPage !== "tea") {
          router.pushUrl({ url: "pages/tea/tea" })
        }
      })

      // Tab3 会员活动入口
      Column() {
        Image(this.currentPage === "activity" ? $r("app.media.activity_open") : $r("app.media.activity_close"))
          .width(28).height(28)
        Text("会员活动").fontSize(12).margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Center)
      .onClick(() => {
        if (this.currentPage !== "activity") {
          router.pushUrl({ url: "pages/activity/activity" })
        }
      })

      // Tab4 我的订单入口
      Column() {
        Image(this.currentPage === "order" ? $r("app.media.order_open") : $r("app.media.order_close"))
          .width(28).height(28)
        Text("我的订单").fontSize(12).margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Center)
      .onClick(() => {
        if (this.currentPage !== "order") {
          router.pushUrl({ url: "pages/order/order" })
        }
      })

      // Tab5 会员中心入口
      Column() {
        Image(this.currentPage === "people" ? $r("app.media.people_open") : $r("app.media.people_close"))
          .width(28).height(28)
        Text("会员中心").fontSize(12).margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Center)
      .onClick(() => {
        if (this.currentPage !== "people") {
          router.pushUrl({ url: "pages/people/people" })
        }
      })
    }
    .width("100%")
    .padding({ top: 8, bottom: 12 })
    .backgroundColor("#ffffff")
    .border({ width: { top: 1 }, color: "#eeeeee" })
  }
}