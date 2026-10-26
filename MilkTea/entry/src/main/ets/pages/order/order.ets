// 我的订单页面 OrderPage
// 页面功能：按订单状态筛选展示历史订单，区分待付款/待制作/待取餐/已完成，底部挂载公共TabBar导航
import { TabBar } from '../../components/TabBar';

// 订单数据模型：单条订单完整信息结构
interface OrderItem {
  orderId: string      // 订单编号
  status: number        // 订单状态码 0全部 1待付款 2待制作 3待取餐 4已完成
  goodsName: string     // 商品名称
  specText: string      // 规格文案（杯型/冰度/甜度/茶底）
  addonText: string     // 加料信息
  count: number         // 购买份数
  singlePrice: number   // 单品单价
  totalPrice: number    // 订单总价
  createTime: string    // 下单时间
}

@Entry
@Component
struct OrderPage {
  // 当前选中筛选状态，默认0=全部订单
  @State selectStatus: number = 0
  // 模拟全部订单列表测试数据
  @State orderList: OrderItem[] = [
    // 待付款 (2个)
    {
      orderId: "DD20260623001",
      status: 1,
      goodsName: "针王蜜瓜",
      specText: "大杯/正常冰/默认糖/五分甜/茉莉茶底",
      addonText: "加料：椰果、珍珠",
      count: 2,
      singlePrice: 21,
      totalPrice: 42,
      createTime: "2026-06-23 19:23"
    },
    {
      orderId: "DD20260623002",
      status: 1,
      goodsName: "奶茶果茶双拼",
      specText: "中杯/少冰/默认糖/七分甜/茉莉茶底",
      addonText: "无加料",
      count: 1,
      singlePrice: 37,
      totalPrice: 37,
      createTime: "2026-06-23 19:30"
    },
    // 待制作 (2个)
    {
      orderId: "DD20260623003",
      status: 2,
      goodsName: "双杯招牌芝士",
      specText: "大杯/温/默认糖/三分甜/茉莉茶底",
      addonText: "加料：多肉、西米",
      count: 1,
      singlePrice: 27,
      totalPrice: 27,
      createTime: "2026-06-23 18:45"
    },
    {
      orderId: "DD20260623004",
      status: 2,
      goodsName: "多杯果奶团购",
      specText: "大杯/正常冰/默认糖/十分甜/茉莉茶底",
      addonText: "加料：西柚粒",
      count: 3,
      singlePrice: 30,
      totalPrice: 90,
      createTime: "2026-06-23 18:50"
    },
    // 待取餐 (2个)
    {
      orderId: "DD20260623005",
      status: 3,
      goodsName: "茉莉零食套餐",
      specText: "中杯/热/默认糖/五分甜/茉莉茶底",
      addonText: "无加料",
      count: 1,
      singlePrice: 16,
      totalPrice: 16,
      createTime: "2026-06-23 17:12"
    },
    {
      orderId: "DD20260623006",
      status: 3,
      goodsName: "茉莉柠檬茶",
      specText: "大杯/正常冰/三分甜/四季春茶底",
      addonText: "加料：珍珠",
      count: 2,
      singlePrice: 17,
      totalPrice: 34,
      createTime: "2026-06-23 17:20"
    },
    // 已完成 (2个)
    {
      orderId: "DD20260622007",
      status: 4,
      goodsName: "招牌茉莉奶茶",
      specText: "大杯/温/五分甜/茉莉茶底",
      addonText: "无加料",
      count: 1,
      singlePrice: 18,
      totalPrice: 18,
      createTime: "2026-06-22 12:30"
    },
    {
      orderId: "DD20260622008",
      status: 4,
      goodsName: "百香果果奶",
      specText: "中杯/少冰/七分甜",
      addonText: "加料：西柚粒",
      count: 1,
      singlePrice: 18,
      totalPrice: 18,
      createTime: "2026-06-22 12:35"
    }
  ]

  // 订单状态码对应文字数组
  statusTextArr: string[] = ["全部", "待付款", "待制作", "待取餐", "已完成"]

  // 商品名称与饮品图片资源映射表，根据商品名匹配对应配图
  private goodsImageMap: Record<string, ResourceStr> = {
    "针王蜜瓜": $r("app.media.MilkTea1"),
    "奶茶果茶双拼": $r("app.media.MilkTea5"),
    "双杯招牌芝士": $r("app.media.MilkTea6"),
    "多杯果奶团购": $r("app.media.MilkTea7"),
    "茉莉零食套餐": $r("app.media.MilkTea8"),
    "茉莉柠檬茶": $r("app.media.MilkTea19"),
    "招牌茉莉奶茶": $r("app.media.MilkTea17"),
    "百香果果奶": $r("app.media.MilkTea24")
  }

  build() {
    Column() {

      this.TopTitleBar()

      this.StatusTabBar()

      Scroll() {
        Column() {
          // 渲染筛选后的订单列表
          ForEach(this.getFilterOrderList(), (item: OrderItem, index: number) => {
            this.OrderCard(item, index)
          })
          // 筛选后无订单，展示空订单提示
          if (this.getFilterOrderList().length === 0) {
            this.EmptyOrderTip()
          }
        }
        .width('100%')
        .padding({ left: 12, right: 12, top: 8, bottom: 12 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)

      TabBar({ currentPage: "order" })
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .width("100%")
    .height("100%")
    .backgroundColor("#f8f8f8")
  }

  /**
   * 根据选中状态过滤订单，返回对应状态订单数组
   * @returns 筛选后的订单列表
   */
  getFilterOrderList(): OrderItem[] {
    if (this.selectStatus === 0) return this.orderList
    return this.orderList.filter(item => item.status === this.selectStatus)
  }

  /**
   * 根据商品名称获取对应饮品图片，无匹配则返回默认占位图
   * @param goodsName 商品名称
   * @returns 图片资源对象
   */
  getGoodsImage(goodsName: string): ResourceStr {
    return this.goodsImageMap[goodsName] || $r("app.media.startIcon")
  }

  // ---------------------- 顶部标题栏 ----------------------
  /**
   * @Builder 页面顶部标题组件
   * 居中展示页面标题「我的订单」
   */
  @Builder
  TopTitleBar() {
    Row() {
      Text("我的订单")
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
      Image($r('app.media.checked'))
        .width(24)
        .height(24)
    }
    .width('100%')
    .height(50)
    .padding({ left: 16, right: 16 })
    .backgroundColor(Color.White)
  }

  // ---------------------- 状态标签栏（左对齐置顶）--------------------
  /**
   * @Builder 横向订单状态筛选标签组件
   * 可左右滑动切换订单状态筛选，选中项粉色高亮
   */
  @Builder
  StatusTabBar() {
    Scroll() {
      Row() {
        ForEach(this.statusTextArr, (text: string, index: number) => {
          Text(text)
            .fontSize(14)
            // 当前选中标签粉色文字+浅粉背景，未选中灰色文字透明背景
            .fontColor(this.selectStatus === index ? "#D84A7C" : "#666")
            .padding({ left: 14, right: 14, top: 8, bottom: 8 })
            .borderRadius(16)
            .backgroundColor(this.selectStatus === index ? "#fcf0f4" : Color.Transparent)
            .margin({ right: 8 })
            .onClick(() => {
              // 切换筛选状态，触发列表重新渲染
              this.selectStatus = index
            })
        })
      }
      .width('100%')
      .padding({ left: 12, right: 12, top: 10, bottom: 10 })
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .backgroundColor(Color.White)
    .margin({ bottom: 8 })
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
  }

  // ---------------------- 单个订单卡片 ----------------------
  /**
   * @Builder 单条订单卡片组件
   * @param item 单条订单数据
   * @param index 循环下标
   * 结构：订单号+状态头部 | 商品图文详情 | 分割线 | 下单时间+总价 | 底部操作按钮
   */
  @Builder
  OrderCard(item: OrderItem, index: number) {
    Column() {
      // 订单头部：订单号 + 订单状态文字
      Row() {
        Text(`订单号：${item.orderId}`)
          .fontSize(13)
          .fontColor("#999")
        Blank()
        Text(this.statusTextArr[item.status])
          .fontSize(13)
          .fontColor("#D84A7C")
      }
      .width('100%')
      .margin({ bottom: 10 })

      // 商品主体行：左侧饮品图 + 中间规格加料文字 + 右侧份数单价
      Row() {
        Image(this.getGoodsImage(item.goodsName))
          .width(70)
          .height(70)
          .borderRadius(8)
          .objectFit(ImageFit.Cover)

        Column() {
          Text(item.goodsName)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .margin({ bottom: 4 })
          Text(item.specText)
            .fontSize(11)
            .fontColor("#999")
            .margin({ bottom: 2 })
          Text(item.addonText)
            .fontSize(11)
            .fontColor("#999")
        }
        .layoutWeight(1)
        .margin({ left: 10 })

        Column() {
          Text(`x${item.count}`)
            .fontSize(13)
            .fontColor("#666")
            .margin({ bottom: 4 })
          Text(`¥${item.singlePrice}`)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor("#333")
        }
      }
      .width('100%')
      .margin({ bottom: 10 })

      // 分割线
      Divider()
        .width('100%')
        .color("#eee")
        .margin({ bottom: 10 })

      // 底部信息行：下单时间 + 订单总价
      Row() {
        Text(`下单时间：${item.createTime}`)
          .fontSize(11)
          .fontColor("#999")
        Blank()
        Text(`合计：¥${item.totalPrice}`)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor("#d63333")
      }
      .width('100%')
      .margin({ bottom: 10 })

      // 根据订单状态渲染不同操作按钮
      Row() {
        Blank()
        // 1待付款：取消订单 / 去支付
        if (item.status === 1) {
          Text("取消订单")
            .fontSize(13)
            .fontColor("#666")
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .borderRadius(16)
            .border({ width: 1, color: "#ccc" })
            .margin({ right: 8 })
          Text("去支付")
            .fontSize(13)
            .fontColor(Color.White)
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .borderRadius(16)
            .backgroundColor("#D84A7C")
        }
        // 2待制作：仅可取消订单
        else if (item.status === 2) {
          Text("取消订单")
            .fontSize(13)
            .fontColor("#666")
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .borderRadius(16)
            .border({ width: 1, color: "#ccc" })
        }
        // 3待取餐：查看取餐码
        else if (item.status === 3) {
          Text("查看取餐码")
            .fontSize(13)
            .fontColor(Color.White)
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .borderRadius(16)
            .backgroundColor("#D84A7C")
        }
        // 4已完成：再来一单 / 去评价
        else if (item.status === 4) {
          Text("再来一单")
            .fontSize(13)
            .fontColor("#666")
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .borderRadius(16)
            .border({ width: 1, color: "#ccc" })
            .margin({ right: 8 })
          Text("去评价")
            .fontSize(13)
            .fontColor(Color.White)
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .borderRadius(16)
            .backgroundColor("#D84A7C")
        }
      }
      .width('100%')
    }
    .width('100%')
    .padding(34)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ bottom: 10 })
  }

  // ---------------------- 空订单占位 ----------------------
  /**
   * @Builder 筛选后无订单时空白提示组件
   */
  @Builder
  EmptyOrderTip() {
    Column() {
      Image($r('app.media.startIcon'))
        .width(80)
        .height(80)
        .margin({ bottom: 12 })
      Text("暂无相关订单")
        .fontSize(15)
        .fontColor("#999")
    }
    .width('100%')
    .padding({ top: 80 })
  }
}