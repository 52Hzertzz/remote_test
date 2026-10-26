// people.ets 会员中心页面
// 页面功能：展示用户头像昵称、积分卡片、活动福利、功能菜单与客服服务入口，底部挂载公共TabBar
import { TabBar } from '../../components/TabBar';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct PeoplePage {
  // 用户登录状态标记
  @State isLoggedIn: boolean = false
  // 用户昵称默认值
  @State userName: string = '茉莉奶白用户'

  aboutToAppear() {
    const params = router.getParams() as Record<string, Object>
    if (params?.loginSuccess === true) {
      this.isLoggedIn = true
      this.userName = params.nickName as string
    }
  }

  // 九宫格功能菜单数据集合
  menuItems: MenuItem[] = [
    { icon: 'coupon1', name: '抖音点评兑换', showBadge: false },
    { icon: 'coupon2', name: '优惠券兑换', showBadge: false },
    { icon: 'medal', name: '电子勋章', showBadge: false },
    { icon: 'sign', name: '签到有礼', showBadge: false },
    { icon: 'charge', name: '充值有礼', showBadge: false },
    { icon: 'card', name: '心意礼卡', showBadge: false },
    { icon: 'shop2', name: '周边商城', showBadge: false },
    { icon: 'women', name: '女性专属', showBadge: false }
  ]

  // 底部客服服务菜单数据
  serviceItems: ServiceItem[] = [
    { icon: 'bill', name: '发票助手' },
    { icon: 'service', name: '在线客服' },
    { icon: 'handshake', name: '加盟咨询' }
  ]

  build() {
    Column() {
      // 顶部用户信息头部区域
      this.UserHeader()

      // 中间可滚动主体内容
      Scroll() {
        Column() {
          // 用户积分信息卡片
          this.PointsCard()

          // 进群福利活动卡片
          this.WelfareCard()

          // 8宫格功能菜单区块
          this.FunctionMenu()

          // 在线客服服务列表区块
          this.ServiceMenu()

          // 底部会员协议文字说明
          this.AgreementText()
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
      }
      .layoutWeight(1)
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)

      TabBar({ currentPage: "people" })
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .width('100%')
    .height('100%')
    .backgroundColor('#f8f8f8')
  }

  // ========== 用户信息头部 ==========
  /**
   * @Builder 用户头像、昵称登录头部组件
   * 未登录显示登录入口，已登录展示用户昵称
   */
  @Builder
  UserHeader() {
    Column() {
      Row() {
        // 用户圆形头像
        Column() {
          Image($r('app.media.people'))
            .width(64)
            .height(64)
            .borderRadius(32)
            .backgroundColor('#e8e8e8')
            .fillColor('#999')
        }
        .margin({ right: 14 })

        // 右侧文字信息区域
        Column() {
          Text('MOLLYTEA')
            .fontSize(12)
            .fontColor('#D84A7C')
            .width('100%')
            .margin({ bottom: 4 })

          // 根据登录状态切换文字
          if (this.isLoggedIn) {
            Text(this.userName)
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333')
              .width('100%')
          } else {
            Row() {
              Text('登录/注册 >')
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333')
                .margin({ right: 8 })
            }
            .width('100%')
            // 点击跳转登录页面
            .onClick(() => {
              router.pushUrl({ url: "pages/people/login" })
            })
          }

          Text('为给您提供更好的服务请授权登录')
            .fontSize(12)
            .fontColor('#999')
            .width('100%')
            .margin({ top: 2 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
      }
      .width('100%')
      .padding({ top: 20, bottom: 16 })
    }
    .width('100%')
    .backgroundColor(Color.White)
    .padding({ left: 16, right: 16 })
  }

  // ========== 积分卡片 ==========
  /**
   * @Builder 用户积分卡片组件
   * 点击跳转到积分商城页面
   */
  @Builder
  PointsCard() {
    Row() {
      Column() {
        Text('100')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor('#D84A7C')
        Text('积分')
          .fontSize(12)
          .fontColor('#999')
          .margin({ top: 2 })
      }
      .padding({ left: 16, right: 20, top: 10, bottom: 10 })
      .backgroundColor('#fcf0f4')
      .borderRadius(10)

      Blank()

      Text('近7天内无积分过期')
        .fontSize(13)
        .fontColor('#666')

      Blank()

      Image($r('app.media.right'))
        .width(20)
        .height(20)
        .fillColor('#D84A7C')
    }
    .width('100%')
    .padding({ left: 12, right: 12, top: 10, bottom: 10 })
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ top: 12 })
    .onClick(() => {
      // 跳转到积分兑换商品页面
      router.pushUrl({ url: "pages/people/pointsShop" })
    })
  }

  // ========== 福利卡片 ==========
  /**
   * @Builder 社群新人福利卡片
   */
  @Builder
  WelfareCard() {
    Row() {
      Image($r('app.media.in_group'))
        .width(40)
        .height(40)
        .fillColor('#D84A7C')
        .margin({ right: 12 })

      Column() {
        Row() {
          Text('进群领「新人专属礼包」')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor('#333')
          Text('不定期免费抽周边')
            .fontSize(12)
            .fontColor('#999')
            .margin({ left: 8 ,top: 20})
        }
        .width('100%')
        Text('戳我立领 >')
          .fontSize(12)
          .fontColor('#D84A7C')
          .width('100%')
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .width('100%')
    .padding({ left: 12, right: 12, top: 10, bottom: 10 })
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ top: 12 })
    .onClick(() => {
      console.log('领取新人礼包')
    })
  }

  // ========== 功能菜单 ==========
  /**
   * @Builder 四列网格功能入口菜单
   * 根据菜单名称匹配对应页面路由，点击跳转各个二级页面
   */
  @Builder
  FunctionMenu() {
    Column() {
      Text('我的功能')
        .fontSize(15)
        .fontWeight(FontWeight.Medium)
        .fontColor('#333')
        .width('100%')
        .margin({ bottom: 12 })

      Grid() {
        ForEach(this.menuItems, (item: MenuItem, index: number) => {
          GridItem() {
            Column() {
              Image($r(`app.media.${item.icon}`))
                .width(32)
                .height(32)
                .fillColor('#D84A7C')
                .margin({ bottom: 6 })
              Text(item.name)
                .fontSize(12)
                .fontColor('#333')
            }
            .width('100%')
            .padding({ top: 8, bottom: 8 })
            .alignItems(HorizontalAlign.Center)
          }
          .onClick(() => {
            // 路由跳转匹配
            if (item.name === "抖音点评兑换") {
              router.pushUrl({ url: "pages/people/douyinExchange" })
            } else if (item.name === "优惠券兑换") {
              router.pushUrl({ url: "pages/people/couponExchange" })
            } else if (item.name === "电子勋章") {
              router.pushUrl({ url: "pages/people/medalPage" })
            } else if (item.name === "签到有礼") {
              router.pushUrl({ url: "pages/people/signPage" })
            }else if (item.name === "充值有礼") {
              router.pushUrl({ url: "pages/Index/storePage" })
            }else if (item.name === "心意礼卡") {
              router.pushUrl({ url: "pages/Index/giftCard" })
            }else if (item.name === "周边商城") {
              router.pushUrl({ url: "pages/people/shopPage" })
            } else if (item.name === "女性专属") {
              router.pushUrl({ url: "pages/people/womenPage" })
            }
          })
        })
      }
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .rowsGap(8)
      .columnsGap(0)
      .width('100%')
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ top: 12 })
  }

  // ========== 服务菜单 ==========
  /**
   * @Builder 在线服务列表（发票、客服、加盟咨询）
   */
  @Builder
  ServiceMenu() {
    Column() {
      Text('服务')
        .fontSize(15)
        .fontWeight(FontWeight.Medium)
        .fontColor('#333')
        .width('100%')
        .margin({ bottom: 12 })

      Column() {
        ForEach(this.serviceItems, (item: ServiceItem) => {
          Row() {
            Image($r(`app.media.${item.icon}`))
              .width(24)
              .height(24)
              .fillColor('#D84A7C')
              .margin({ right: 12 })
            Text(item.name)
              .fontSize(14)
              .fontColor('#333')
            Blank()
            Image($r('app.media.right'))
              .width(16)
              .height(16)
              .fillColor('#ccc')
          }
          .width('100%')
          .padding({ top: 10, bottom: 10 })
          .onClick(() => {
            console.log('点击:', item.name)
          })
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ top: 12 })
  }

  // ========== 会员协议 ==========
  /**
   * @Builder 底部协议与账号注销说明文字
   */
  @Builder
  AgreementText() {
    Column() {
      Text('会员协议')
        .fontSize(13)
        .fontColor('#666')
        .width('100%')
        .textAlign(TextAlign.Center)
        .padding({ top: 4, bottom: 4 })
        .onClick(() => {
          console.log('查看会员协议')
        })

      Text('*如您需要注销账户，请联系客服进行处理。')
        .fontSize(11)
        .fontColor('#999')
        .width('100%')
        .textAlign(TextAlign.Center)
        .padding({ top: 2, bottom: 2 })

      Text('客服联系途径："会员中心"-"在线客服"-输入"账号换绑手机号/注销"')
        .fontSize(11)
        .fontColor('#999')
        .width('100%')
        .textAlign(TextAlign.Center)
        .padding({ top: 2, bottom: 10 })
    }
    .width('100%')
    .padding({ top: 16, bottom: 10 })
  }
}

// 菜单项数据结构定义
interface MenuItem {
  icon: string        // 图标资源名称
  name: string        // 菜单文字
  showBadge: boolean  // 是否显示小红点标记
}

// 服务项数据结构定义
interface ServiceItem {
  icon: string // 图标资源名称
  name: string // 服务名称
}