// TeaPage.ets 点单首页 左右联动分类菜单
import { TabBar } from '../../components/TabBar';
import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { CartManager, CartItem } from '../CartManager';

// 左侧分类条目结构
interface CategoryItem {
  name: string
  tag: string
  iconRes: string
}
// 右侧商品条目结构
interface GoodsItem {
  name: string
  tags: string[]
  price: string
  imgRes: string
}

@Entry
@Component
struct TeaPage {
  // 当前左侧选中分类下标
  @State selectCatIndex: number = 0
  // 标记：是否为手动点击左侧分类，防止滚动联动互相覆盖造成闪烁
  @State isManualClick: boolean = false
  // 右侧滚动控制器
  private rightScroller: Scroller = new Scroller()
  // 存储每一个分类标题的Y轴坐标，用于滚动定位
  private sectionPositions: number[] = []

  // 购物车数据
  @State cartItems: CartItem[] = []
  @State totalPrice: number = 0
  @State totalCount: number = 0
  @State showCartDialog: boolean = false

  // 订单类型：自取 / 外卖
  @State selectedOrderType: string = '自取'

  // 左侧菜单数组
  catList: CategoryItem[] = [
    { name: "好茶上新", tag: "NEW", iconRes: "new" },
    { name: "周边套餐", tag: "", iconRes: "package" },
    { name: "茉莉小零嘴", tag: "", iconRes: "snack" },
    { name: "摩登茶咖", tag: "可选热饮", iconRes: "coffee1" },
    { name: "必喝推荐", tag: "", iconRes: "coffee2" },
    { name: "摩登果奶", tag: "", iconRes: "juice" }
  ]

  // 各个分类下的商品数据
  teaNewList: GoodsItem[] = [
    { name: "针王蜜瓜", tags: ["上新款", "漂亮水", "蜜瓜系列"], price: "19起", imgRes: "MilkTea1" },
    { name: "针王蜜瓜雪球", tags: ["联名款", "漂亮水", "蜜瓜系列"], price: "22起", imgRes: "MilkTea2" },
    { name: "茉莉杨枝甘露", tags: ["经典回归", "芒果沙冰", "果肉丰富"], price: "21起", imgRes: "MilkTea3" },
    { name: "浓抹观音", tags: ["浓抹系列", "三重茶韵", "自研咸乳酪"], price: "21起", imgRes: "MilkTea4" }
  ]

  packageList: GoodsItem[] = [
    { name: "奶茶果茶双拼", tags: ["果茶", "奶茶"], price: "39起", imgRes: "MilkTea7" },
    { name: "双杯招牌芝士", tags: ["芝士奶盖", "人气爆款"], price: "25起", imgRes: "MilkTea6" },
    { name: "多杯果奶团购", tags: ["新鲜果肉", "酸甜可口"], price: "29起", imgRes: "MilkTea5" },
    { name: "茉莉零食套餐", tags: ["手工制作", "花香浓郁"], price: "16起", imgRes: "MilkTea8" }
  ]

  snackList: GoodsItem[] = [
    { name: "茉莉花茶饼干", tags: ["酥脆", "茶香浓郁"], price: "12起", imgRes: "MilkTea9" },
    { name: "茉莉味软糖", tags: ["Q弹", "花香四溢"], price: "8起", imgRes: "MilkTea10" },
    { name: "茉莉花茶冻", tags: ["清爽", "手工制作"], price: "10起", imgRes: "MilkTea11" },
    { name: "茉莉薄脆", tags: ["薄脆", "低糖"], price: "15起", imgRes: "MilkTea12" }
  ]

  coffeeList: GoodsItem[] = [
    { name: "茉莉拿铁", tags: ["可选热饮", "花香浓郁"], price: "22起", imgRes: "MilkTea13" },
    { name: "抹茶拿铁", tags: ["可选热饮", "日式风味"], price: "20起", imgRes: "MilkTea14" },
    { name: "桂花拿铁", tags: ["可选热饮", "桂花飘香"], price: "21起", imgRes: "MilkTea15" },
    { name: "红茶拿铁", tags: ["可选热饮", "经典搭配"], price: "19起", imgRes: "MilkTea16" }
  ]

  recommendList: GoodsItem[] = [
    { name: "招牌茉莉奶茶", tags: ["招牌必点", "销量冠军"], price: "18起", imgRes: "MilkTea17" },
    { name: "芝士茉莉", tags: ["芝士奶盖", "人气爆款"], price: "23起", imgRes: "MilkTea18" },
    { name: "茉莉柠檬茶", tags: ["清爽", "夏日必备"], price: "16起", imgRes: "MilkTea19" },
    { name: "茉莉蜜桃", tags: ["果茶系列", "季节限定"], price: "20起", imgRes: "MilkTea21" }
  ]

  fruitMilkList: GoodsItem[] = [
    { name: "芒果果奶", tags: ["芒果沙冰", "果肉丰富"], price: "22起", imgRes: "MilkTea20" },
    { name: "草莓果奶", tags: ["草莓季", "新鲜果肉"], price: "21起", imgRes: "MilkTea22" },
    { name: "葡萄果奶", tags: ["葡萄系列", "清爽解腻"], price: "20起", imgRes: "MilkTea23" },
    { name: "百香果果奶", tags: ["百香果", "酸甜可口"], price: "19起", imgRes: "MilkTea24" }
  ]

  aboutToAppear() {
    // 订阅购物车数据变化，实时刷新总价与商品
    CartManager.subscribe(() => {
      this.cartItems = CartManager.getItems()
      this.totalPrice = CartManager.getTotalPrice()
      this.totalCount = CartManager.getTotalCount()
    })
    // 接收首页传过来的自取/外卖参数
    const params = router.getParams() as Record<string, string>
    if (params) {
      const orderType = params['orderType']
      if (orderType === '自取' || orderType === '外卖') {
        this.selectedOrderType = orderType
        console.log('从首页切换到:', this.selectedOrderType)
      }
    }
  }

  aboutToDisappear() {
  }

  build() {
    Stack() {
      Column() {
        // 顶部门店信息、切换栏（固定不跟随滚动）
        this.TopFixedArea()

        // 主体左右双栏布局
        Row() {
          // 左侧分类菜单
          Scroll() {
            Column() {
              ForEach(this.catList, (item: CategoryItem, index: number) => {
                Column() {
                  Column() {
                    Image($r(`app.media.${item.iconRes}`))
                      .width(28)
                      .height(28)
                    Text(item.name)
                      .fontSize(12)
                      .fontColor(this.selectCatIndex === index ? "#D84A7C" : "#333")
                    if (item.tag !== "" && item.tag !== "NEW") {
                      Text(item.tag)
                        .fontSize(10)
                        .fontColor("#D84A7C")
                    }
                  }
                  .width("100%")
                  .padding({ top: 16, bottom: 16 })
                  .alignItems(HorizontalAlign.Center)
                  // 选中项粉色背景高亮
                  .backgroundColor(this.selectCatIndex === index ? "#fcf0f4" : "#f8f8f8")
                }
                .width("100%")
                .onClick(() => {
                  // 点击立刻高亮当前分类
                  this.selectCatIndex = index
                  this.isManualClick = true
                  // 等待DOM坐标采集完成再执行滚动
                  setTimeout(() => {
                    this.scrollToSection(index)
                  }, 60)
                })
              })
            }
          }
          .width("24%")
          .scrollable(ScrollDirection.Vertical)
          .scrollBar(BarState.Off)

          Blank().width(1)

          // 右侧商品列表滚动区域
          Scroll(this.rightScroller) {
            Column() {
              // 分类标题区块，绑定ID与坐标监听，保存Y位置
              // 0 好茶上新
              Column() {
                Text("好茶上新")
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .width("100%")
                  .margin({ top: 12, bottom: 12, left: 10 })
              }
              .id('section_0')
              .onAreaChange((oldArea: Area, newArea: Area) => {
                this.sectionPositions[0] = Number(newArea.position.y)
              })
              ForEach(this.teaNewList, (goods: GoodsItem) => {
                this.GoodsItemBuilder(goods)
              })

              // 1 周边套餐
              Column() {
                Text("周边套餐")
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .width("100%")
                  .margin({ top: 20, bottom: 12, left: 10 })
              }
              .id('section_1')
              .onAreaChange((oldArea: Area, newArea: Area) => {
                this.sectionPositions[1] = Number(newArea.position.y)
              })
              ForEach(this.packageList, (goods: GoodsItem) => {
                this.GoodsItemBuilder(goods)
              })

              // 2 茉莉小零嘴
              Column() {
                Text("茉莉小零嘴")
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .width("100%")
                  .margin({ top: 20, bottom: 12, left: 10 })
              }
              .id('section_2')
              .onAreaChange((oldArea: Area, newArea: Area) => {
                this.sectionPositions[2] = Number(newArea.position.y)
              })
              ForEach(this.snackList, (goods: GoodsItem) => {
                this.GoodsItemBuilder(goods)
              })

              // 3 摩登茶咖
              Column() {
                Text("摩登茶咖")
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .width("100%")
                  .margin({ top: 20, bottom: 12, left: 10 })
              }
              .id('section_3')
              .onAreaChange((oldArea: Area, newArea: Area) => {
                this.sectionPositions[3] = Number(newArea.position.y)
              })
              ForEach(this.coffeeList, (goods: GoodsItem) => {
                this.GoodsItemBuilder(goods)
              })

              // 4 必喝推荐
              Column() {
                Text("必喝推荐")
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .width("100%")
                  .margin({ top: 20, bottom: 12, left: 10 })
              }
              .id('section_4')
              .onAreaChange((oldArea: Area, newArea: Area) => {
                this.sectionPositions[4] = Number(newArea.position.y)
              })
              ForEach(this.recommendList, (goods: GoodsItem) => {
                this.GoodsItemBuilder(goods)
              })

              // 5 摩登果奶
              Column() {
                Text("摩登果奶")
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .width("100%")
                  .margin({ top: 20, bottom: 12, left: 10 })
              }
              .id('section_5')
              .onAreaChange((oldArea: Area, newArea: Area) => {
                this.sectionPositions[5] = Number(newArea.position.y)
              })
              ForEach(this.fruitMilkList, (goods: GoodsItem) => {
                this.GoodsItemBuilder(goods)
              })

              // 底部空白占位
              Column()
                .height(20)
                .width('100%')
            }
          }
          .layoutWeight(1)
          .scrollable(ScrollDirection.Vertical)
          .scrollBar(BarState.Off)
          // 右侧滚动监听，自动同步左侧分类高亮
          .onScroll((xOffset: number, yOffset: number) => {
            // 手动点击触发滚动时，暂时屏蔽自动联动，防止闪烁冲突
            if (this.isManualClick) return
            this.updateSelectedIndex(yOffset)
          })
        }
        .layoutWeight(1)

        // 底部购物车栏
        this.BottomCartBar()

        // 底部Tab导航栏
        TabBar({ currentPage: "tea" })
      }
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .width("100%")
      .height("100%")
      .backgroundColor("#ffffff")

      // 购物车弹窗
      if (this.showCartDialog) {
        this.CartDialog()
      }
    }
  }

  // 商品条目模板
  @Builder
  GoodsItemBuilder(goods: GoodsItem) {
    Row() {
      Image($r(`app.media.${goods.imgRes}`))
        .width(90)
        .height(90)
        .borderRadius(8)

      Column() {
        Text(goods.name)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .width("100%")
          .margin({ bottom: 6 })
        Flex({ alignItems: ItemAlign.Center, wrap: FlexWrap.Wrap }) {
          ForEach(goods.tags, (tag: string) => {
            Text(tag)
              .fontSize(10)
              .fontColor("#f29c68")
              .backgroundColor("#fff3e8")
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .borderRadius(4)
              .margin({ right: 6, bottom: 6 })
          })
        }
        .width("100%")
        .margin({ bottom: 8 })

        Row() {
          Text(`¥${goods.price}`)
            .fontSize(16)
            .fontColor("#d63333")
            .margin({ top: 5 })
          Blank()
          Button("选规格", { stateEffect: true })
            .fontSize(12)
            .fontColor("#fff")
            .backgroundColor("#222")
            .padding({ left: 12, right: 12, top: 1, bottom: 1 })
            .borderRadius(99)
            .height(25)
            .margin({ top: 5 })
            .onClick(() => {
              // 去掉价格文字中的“起”，只传递数字
              const priceNum = goods.price.replace('起', '').trim()
              router.pushUrl({
                url: 'pages/spec/GoodsDetailPage',
                params: {
                  goodsName: goods.name,
                  goodsImg: goods.imgRes,
                  price: priceNum
                }
              })
            })
        }
        .width("100%")
      }
      .layoutWeight(1)
      .margin({ left: 10 })
    }
    .width("100%")
    .padding({ left: 10, right: 10, bottom: 20 })
  }

  // 底部购物车栏UI
  @Builder
  BottomCartBar() {
    Row() {
      // 左侧优惠券入口
      Column() {
        Text("尊享商品券")
          .fontSize(14)
          .fontColor(Color.White)
        Text("登录后查询")
          .fontSize(12)
          .fontColor(Color.White)
      }
      .width("35%")
      .padding({ left: 2, right: 0, top: 10, bottom: 10 })
      .backgroundColor(Color.Black)
      .borderRadius({ topLeft: 99, bottomLeft: 99, topRight: 20, bottomRight: 20 })
      .justifyContent(FlexAlign.Center)
      .margin({ left: 20, right: 2, bottom: 8 })
      .onClick(()=>{
        router.pushUrl({url:"pages/people/login"})
      })

      // 右侧购物车按钮
      Row() {
        Row() {
          // 购物车图标+角标
          Stack() {
            Image($r("app.media.bag"))
              .width(24)
              .height(24)
              .fillColor(Color.White)

            if (this.totalCount > 0) {
              Text(`${this.totalCount}`)
                .fontSize(10)
                .fontColor('#fff')
                .backgroundColor('#D84A7C')
                .borderRadius(99)
                .padding({ left: 4, right: 4, top: 1, bottom: 1 })
                .position({ x: 16, y: -4 })
            }
          }
          .margin({ right: 8 })

          // 总价文字
          if (this.totalCount > 0) {
            Text(`¥${this.totalPrice}`)
              .fontSize(18)
              .height(34)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
              .margin({ right: 8 ,left: 20})

            Image($r("app.media.right"))
              .width(16)
              .height(16)
              .fillColor(Color.White)
              .margin({left: 20})
          } else {
            Text("暂无商品，请先选购")
              .fontSize(14)
              .height(26)
              .fontColor(Color.White)
              .margin({ left: 4 ,top: 4,bottom: 4})
          }
        }
        .padding({ left: 12, right: 16, top: 8, bottom: 8 })
        .backgroundColor(this.totalCount > 0 ? "#D84A7C" : "rgba(143, 140, 140, 0.65)")
        .borderRadius({ topRight: 99, bottomRight: 99, topLeft: 20, bottomLeft: 20 })
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          if (this.totalCount > 0) {
            this.showCartDialog = true
          }
        })
      }
      .width("90%")
      .margin({ left: 10, right: 2, bottom: 8 })
    }
  }

  // 购物车弹窗
  @Builder
  CartDialog() {
    // 遮罩层
    Column()
      .width('100%')
      .height('100%')
      .backgroundColor('rgba(0,0,0,0.5)')
      .position({ x: 0, y: 0 })
      .zIndex(100)
      .onClick(() => {
        this.showCartDialog = false
      })

    // 弹窗主体
    Column() {
      // 标题行
      Row() {
        Text('购物车')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
        Blank()
        Text('清空')
          .fontSize(14)
          .fontColor('#D84A7C')
          .onClick(() => {
            CartManager.clearCart()
            this.showCartDialog = false
          })
        Text('✕')
          .fontSize(20)
          .fontColor('#999')
          .margin({ left: 16 })
          .onClick(() => {
            this.showCartDialog = false
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 12 })

      Divider()
        .margin(0)

      // 购物车商品列表
      if (this.cartItems.length > 0) {
        Scroll() {
          Column() {
            ForEach(this.cartItems, (item: CartItem, index: number) => {
              this.CartItemRow(item, index)
            })
          }
          .width('100%')
          .padding({ bottom: 400 })
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      } else {
        Column() {
          Text('购物车是空的')
            .fontSize(16)
            .fontColor('#999')
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      }

      // 底部结算栏
      Row() {
        Column() {
          Text(`合计: ¥${this.totalPrice}`)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#d63333')
          Text(`共 ${this.totalCount} 件商品`)
            .fontSize(12)
            .fontColor('#999')
        }
        .alignItems(HorizontalAlign.Start)

        Blank()

        Button(`去结算 ¥${this.totalPrice}`)
          .fontSize(16)
          .fontColor('#fff')
          .backgroundColor('#D84A7C')
          .padding({ left: 24, right: 24, top: 10, bottom: 10 })
          .borderRadius(20)
          .onClick(() => {
            promptAction.showToast({
              message: '正在跳转到结算页面...',
              duration: 1500
            })
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 16 })
      .backgroundColor(Color.White)
      .border({ width: 1, color: '#eee' })
    }
    .width('90%')
    .height('80%')
    .backgroundColor(Color.White)
    .borderRadius(16)
    .position({ x: '5%', y: '10%' })
    .zIndex(101)
  }

  // 购物车单行商品模板
  @Builder
  CartItemRow(item: CartItem, index: number) {
    Row() {
      Column() {
        Text(item.name)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .width('100%')
        Text(`${item.size}/${item.temp}/${item.sugar}/${item.sweet}/${item.tea}`)
          .fontSize(11)
          .fontColor('#999')
          .width('100%')
        if (item.addons.length > 0) {
          Text(`+ ${item.addons.join('、')}`)
            .fontSize(11)
            .fontColor('#666')
            .width('100%')
        }
        if (item.remove.length > 0) {
          Text(`- ${item.remove.join('、')}`)
            .fontSize(11)
            .fontColor('#999')
            .width('100%')
        }
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Column() {
        Text(`¥${item.singlePrice}`)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#d63333')

        Row() {
          Button() {
            Text('-')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333')
          }
          .width(28)
          .height(28)
          .backgroundColor('#f0f0f0')
          .borderRadius(14)
          .onClick(() => {
            CartManager.updateCount(item.id, -1)
          })

          Text(`${item.count}`)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .margin({ left: 8, right: 8 })
            .width(16)
            .textAlign(TextAlign.Center)

          Button() {
            Text('+')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#fff')
          }
          .width(28)
          .height(28)
          .backgroundColor('#D84A7C')
          .borderRadius(14)
          .onClick(() => {
            CartManager.updateCount(item.id, 1)
          })
        }
        .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.End)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor(index % 2 === 0 ? '#fafafa' : Color.White)
  }

  // 滚动右侧商品区到对应分类标题位置
  private scrollToSection(index: number) {
    const position = this.sectionPositions[index]
    if (position !== undefined) {
      this.rightScroller.scrollTo({
        xOffset: 0,
        yOffset: position,
        animation: { duration: 300, curve: Curve.EaseInOut }
      })
    }
    // 延时解除手动点击锁定，恢复滚动自动联动
    setTimeout(() => {
      this.isManualClick = false
    }, 400)
  }

  // 根据右侧滚动Y值，自动切换左侧分类高亮下标
  private updateSelectedIndex(yOffset: number) {
    let selectedIndex = 0
    // 倒序匹配区块坐标
    for (let i = this.sectionPositions.length - 1; i >= 0; i--) {
      // 预留30像素容错，优化切换时机
      if (this.sectionPositions[i] <= yOffset + 30) {
        selectedIndex = i
        break
      }
    }
    if (this.selectCatIndex !== selectedIndex) {
      this.selectCatIndex = selectedIndex
    }
  }

  // 顶部门店、自取外卖切换栏
  @Builder
  TopFixedArea() {
    Column() {
      // 第一行：拼单、搜索
      Row() {
        Row() {
          Image($r("app.media.tea_open"))
            .width(24)
            .height(24)
          Text("一起拼")
            .fontSize(15)
            .margin({ left: 4 })
        }
        .padding({ left: 12, right: 12, top: 6, bottom: 6 })
        .backgroundColor("#f3f3f3")
        .borderRadius(99)

        Blank().layoutWeight(1)

        Row() {
          Image($r("app.media.search")).width(24).height(24)
            .margin({ right: 16 })
          Image($r("app.media.dot")).width(24).height(24)
            .margin({ right: 16 })
          Image($r("app.media.checked")).width(24).height(24)
        }
      }
      .width("94%")
      .margin({ top: 10, bottom: 12 })

      // 第二行：门店 + 自取/外卖切换
      Row() {
        Row() {
          Image($r("app.media.star"))
            .width(20)
            .height(20)
            .fillColor(Color.Gray)
            .margin({ right: 4 })
          Text("深圳宝安大仟里店")
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
          Image($r("app.media.right"))
            .width(16)
            .height(16)
        }
        Blank().layoutWeight(1)
        Row() {
          Text("自取")
            .fontSize(14)
            .fontColor(this.selectedOrderType === '自取' ? "#fff" : "#333")
            .backgroundColor(this.selectedOrderType === '自取' ? "#222" : "transparent")
            .padding({ left: 14, right: 14, top: 6, bottom: 6 })
            .borderRadius(99)
            .border({ width: this.selectedOrderType === '自取' ? 0 : 1, color: "#ddd" })
            .onClick(() => {
              this.selectedOrderType = '自取'
              console.log('切换到:', this.selectedOrderType)
            })

          Text("外卖")
            .fontSize(14)
            .fontColor(this.selectedOrderType === '外卖' ? "#fff" : "#333")
            .backgroundColor(this.selectedOrderType === '外卖' ? "#222" : "transparent")
            .padding({ left: 14, right: 14, top: 6, bottom: 6 })
            .borderRadius(99)
            .border({ width: this.selectedOrderType === '外卖' ? 0 : 1, color: "#ddd" })
            .margin({ left: 8 })
            .onClick(() => {
              this.selectedOrderType = '外卖'
              console.log('切换到:', this.selectedOrderType)
            })
        }
      }
      .width("94%")
      .margin({ bottom: 8 })

      // 距离、出餐进度
      Row() {
        Image($r("app.media.location"))
          .width(18)
          .height(18)
        Text("距您928m")
          .fontSize(13)
          .fontColor("#666")
        Text("前方24杯制作中")
          .fontSize(13)
          .fontColor("#2b7cd3")
          .backgroundColor("#e8f2fc")
          .padding({ left: 8, right: 8, top: 2, bottom: 2 })
          .borderRadius(6)
          .margin({ left: 8 })
      }
      .width("94%")
      .alignItems(VerticalAlign.Top)
      .margin({ bottom: 12 })

      // 活动标签
      Row() {
        Text("限时8折")
          .fontSize(9)
          .border({ width: 1, color: "#333" })
          .padding({ left: 5, right: 5, top: 2, bottom: 2 })
          .borderRadius(4)
          .margin({ right: 2 })
        Text("限时买一送一")
          .fontSize(9)
          .border({ width: 1, color: "#333" })
          .padding({ left: 5, right: 5, top: 2, bottom: 2 })
          .borderRadius(4)
          .margin({ right: 2 })
        Text("购活动饮品1杯加赠滴胶贴纸1张")
          .fontSize(9)
          .border({ width: 1, color: "#333" })
          .padding({ left: 5, right: 5, top: 2, bottom: 2 })
          .borderRadius(4)
          .margin({ right: 2 })
        Text('...')
          .fontSize(9)
        Blank()
          .layoutWeight(1)
        Text("点击查看 >")
          .fontSize(12)
          .fontColor("#666")
      }
      .width("94%")
      .margin({ bottom: 10 })
    }
    .width("100%")
    .backgroundColor("#ffffff")
  }
}