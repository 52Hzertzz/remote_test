// 储值有礼页面 StorePage
// 页面功能：展示用户当前储值余额、双列网格储值档位卡片、底部储值规则说明
import { router } from '@kit.ArkUI';

// 储值档位数据模型
interface StoreItem {
  payMoney: number  // 用户实际支付金额
  giveMoney: number // 充值赠送余额
  tag: string       // 档位标签文案
  hot: boolean      // 是否热门档位标识
}

@Entry
@ComponentV2
struct StorePage {
  // 模拟当前余额
  @Local balance: number = 28.6
  // 两列宫格充值数据
  @Local storeList: StoreItem[] = [
    { payMoney: 50, giveMoney: 5, tag: "小额尝鲜", hot: false },
    { payMoney: 100, giveMoney: 15, tag: "人气优选", hot: true },
    { payMoney: 200, giveMoney: 40, tag: "性价比高", hot: false },
    { payMoney: 500, giveMoney: 120, tag: "超值囤货", hot: true }
  ]

  build() {
    Column() {
      this.NavBar()
      Scroll() {
        Column() {
          // 1. 个人余额卡片
          this.BalanceCard()

          // 2. 充值档位标题
          Text("选择充值金额")
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .width('100%')
            .padding({ left: 16, top: 20, bottom: 10 })

          // 3. 两列网格充值卡片（替换之前横向滑动，全新结构）
          this.StoreGrid()

          // 4. 储值说明规则
          this.RuleBlock()

          Blank().height(30)
        }
        .width('100%')
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f8f8f8')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }

  /**
   * @Builder 页面顶部导航栏组件
   * 左侧返回箭头，中间页面标题，右侧空白占位保证标题居中
   */
  @Builder
  NavBar() {
    Row() {
      Image($r("app.media.left"))
        .width(24)
        .height(24)
        .onClick(() => router.back())
      Blank()
      Text("储值有礼")
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
      Blank()
      Row().width(24)
    }
    .width('100%')
    .height(48)
    .backgroundColor(Color.White)
    .padding({ left: 16, right: 16 })
  }

  /**
   * @Builder 用户余额卡片组件
   * 粉色背景卡片，展示当前余额与余额使用说明
   */
  @Builder
  BalanceCard() {
    Column() {
      Text("我的储值余额")
        .fontSize(13)
        .fontColor('#fff')

      // 余额金额展示行
      Row() {
        Text("¥")
          .fontSize(16)
          .fontColor('#fff')
          .margin({ top: 6 })
        Text(`${this.balance.toFixed(2)}`)
          .fontSize(36)
          .fontWeight(FontWeight.Bold)
          .fontColor('#fff')
      }
      .margin({ top: 8 })

      // 余额补充说明文字
      Text("储值余额永久有效 · 全场饮品通用")
        .fontSize(12)
        .fontColor('#ffffffaa')
        .margin({ top: 12 })

    }
    .width('92%')
    .padding(20)
    .backgroundColor('#D84A7C')
    .borderRadius(16)
    .margin({ top: 16 })
  }

  /**
   * @Builder 双列网格储值档位组件
   * Grid两列均分布局，循环渲染所有充值档位卡片
   * 热门档位自动展示右上角「热门」标签
   */
  @Builder
  StoreGrid() {
    Grid() {
      ForEach(this.storeList, (item: StoreItem) => {
        GridItem() {
          Column() {
            // 热门标签
            if (item.hot) {
              Text("热门")
                .fontSize(11)
                .fontColor(Color.White)
                .backgroundColor('#D84A7C')
                .borderRadius(99)
                .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                .width('26%')
                .textAlign(TextAlign.End)
            }

            // 根据是否有热门标签调整上方间距
            Blank().height(item.hot ? 4 : 12)

            // 支付金额展示行
            Row() {
              Text("¥")
                .fontSize(12)
                .fontColor('#D84A7C')
              Text(`${item.payMoney}`)
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333')
            }

            // 赠送金额
            Text(`赠¥${item.giveMoney}`)
              .fontSize(13)
              .fontColor('#D84A7C')
              .margin({ top: 4 })

            Blank().layoutWeight(1)

            // 标签
            Text(item.tag)
              .fontSize(12)
              .fontColor('#999')
              .margin({ bottom: 10 })

            // 充值按钮
            Text("立即充值")
              .width('100%')
              .height(34)
              .textAlign(TextAlign.Center)
              .fontSize(12)
              .fontColor(Color.White)
              .backgroundColor('#D84A7C')
              .borderRadius(17)

          }
          .width('100%')
          .height(160)
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(12)
        }
      })
    }
    .columnsTemplate('1fr 1fr')
    .columnsGap(12)
    .rowsGap(12)
    .width('92%')
  }

  /**
   * @Builder 底部储值规则说明区块
   * 文字罗列储值相关四条规则
   */
  @Builder
  RuleBlock() {
    Column() {
      Text("储值说明")
        .fontSize(15)
        .fontWeight(FontWeight.Medium)
        .width('100%')
        .margin({ bottom: 10 })

      Text("1. 储值余额永久有效，无使用期限；\n2. 充值赠送金额不支持退款；\n3. 所有饮品、小料、周边均可使用余额抵扣；\n4. 储值用户可享受每月专属优惠活动。")
        .fontSize(12)
        .fontColor('#666')
        .lineHeight(20)
    }
    .width('92%')
    .margin({ top: 20 })
    .padding(14)
    .backgroundColor(Color.White)
    .borderRadius(12)
  }
}
