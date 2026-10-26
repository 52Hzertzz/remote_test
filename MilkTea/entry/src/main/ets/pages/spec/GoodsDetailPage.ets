// GoodsDetailPage.ets 商品规格选择详情页
// 功能：选择杯型、温度、甜度、茶底、加料去料，实时计算价格，将商品组装后加入购物车
import { router } from '@kit.ArkUI';
import { CartManager, CartItem as CartItemType } from '../CartManager';  // 根据实际路径调整

// 购物车条目类型，杜绝对象字段undefined
interface CartItem {
  name: string
  size: string
  temp: string
  sugar: string
  sweet: string
  tea: string
  addons: string[]
  remove: string[]
  singlePrice: number
  count: number
  totalPrice: number
}

// 页面接收的跳转参数
interface DetailParams {
  goodsName: string
  goodsImg: string
  price: string  // 传入的价格，如 "19"
}

@Entry
@Component
struct GoodsDetailPage {
  // 商品基础信息
  @State goodsName: string = ''
  @State goodsImg: string = ''
  @State basePrice: number = 19  // 基础价格（大杯价格）
  @State isFavorited: boolean = false
  // 杯型价格映射（动态计算）
  private getSizePrice(size: string): number {
    if (size === '大') {
      return this.basePrice
    } else {
      // 中杯 = 大杯 - 2
      return Math.max(this.basePrice - 2, 1) // 最低1元
    }
  }

  // 切换收藏状态
  private toggleFavorite() {
    this.isFavorited = !this.isFavorited
    console.log(`${this.goodsName} 收藏状态: ${this.isFavorited}`)
  }
  // 获取显示价格

  private getSizeDisplayPrice(size: string): string {
    return `￥${this.getSizePrice(size)}`
  }

  // ========== 单选规格（互斥选择）==========
  @State selectedSize: string = '大'
  @State selectedTemp: string = '正常冰'
  @State selectedSugar: string = '默认糖'
  @State selectedSweetness: string = '五分甜'
  @State selectedTea: string = '茉莉'

  // ========== 多选规格（可多选）==========
  @State addons: Map<string, boolean> = new Map([
    ['椰果', false],
    ['芦荟·单日限1份', false],
    ['粉宝石', false],
    ['多肉', false],
    ['珍珠', false],
    ['西米', false],
    ['西柚粒', false]
  ])
  @State removals: Map<string, boolean> = new Map([
    ['去珍珠', false],
    ['去椰果', false]
  ])

  // 购买数量
  @State quantity: number = 1

  // 底部实时总价
  @State displayPrice: number = 0

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>
    if (params) {
      this.goodsName = params['goodsName'] ?? ''
      this.goodsImg = params['goodsImg'] ?? ''
      const priceStr = params['price'] ?? '19'
      const parsedPrice = parseFloat(priceStr)
      this.basePrice = isNaN(parsedPrice) ? 19 : parsedPrice
    }
    this.updatePrice()
  }

  // 更新价格
  private updatePrice() {
    this.displayPrice = this.calculateTotalPrice()
  }

  // 计算单品单价：当前杯型价格 + 选中加料数量*1
  private calculateSinglePrice(): number {
    const base = this.getSizePrice(this.selectedSize)
    let addonCount = 0
    const valuesArr = Array.from(this.addons.values())
    for (let i = 0; i < valuesArr.length; i++) {
      if (valuesArr[i]) addonCount++
    }
    return base + addonCount
  }

  // 计算最终总价
  private calculateTotalPrice(): number {
    return this.calculateSinglePrice() * this.quantity
  }

  // 多选切换 - 加料
  private toggleAddon(key: string) {
    const current = this.addons.get(key) ?? false
    this.addons.set(key, !current)
    this.addons = new Map(this.addons)
    this.updatePrice()
  }

  // 多选切换 - 去料
  private toggleRemoval(key: string) {
    const current = this.removals.get(key) ?? false
    this.removals.set(key, !current)
    this.removals = new Map(this.removals)
    this.updatePrice()
  }

  build() {
    Column() {
      this.TopNavBar()
      Scroll() {
        Column() {
          this.GoodsImage()
          this.GoodsInfoSection()
          this.SizeSection()
          this.AddonSection()
          this.RemovalSection()
          this.TemperatureSection()
          this.SugarSection()
          this.SweetnessSection()
          this.TipsSection()
          this.TeaSection()
          this.DescriptionSection()
          Column().height(80).width('100%')
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
      }
      .layoutWeight(1)
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      this.BottomBar()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f8f8f8')
  }

  /**
   * @Builder 顶部返回导航栏
   */
  @Builder
  TopNavBar() {
    Row() {
      Row() {
        Image($r('app.media.left')).width('60%')
      }
      .width(40).height(40).borderRadius(20).justifyContent(FlexAlign.Center)
      .onClick(() => router.back())
      Blank()
      Text('商品详情').fontSize(17).fontWeight(FontWeight.Medium).fontColor('#333')
      Blank()
      Row().width(40).height(40)
    }
    .width('100%').height(50).padding({ left: 12, right: 12 })
    .backgroundColor(Color.White).border({ width: 1, color: '#f0f0f0' })
  }

  /**
   * @Builder 商品大图
   */
  @Builder
  GoodsImage() {
    Column() {
      Image($r(`app.media.${this.goodsImg}`))
        .width('100%').height(280).objectFit(ImageFit.Cover).borderRadius(12)
    }
    .width('100%').backgroundColor(Color.White).borderRadius(12).padding(12).margin({ top: 12 })
  }

  /**
   * @Builder 商品标题+收藏按钮
   */
  @Builder
  GoodsInfoSection() {
    Column() {
      Row() {
        Column() {
          Text(this.goodsName)
            .fontSize(22).fontWeight(FontWeight.Bold).margin({ bottom: 8 }).width('100%')
          Text('新鲜水果|珍珠椰果|广西横州茉莉').fontSize(14).fontColor('#666')
        }
        .layoutWeight(1)
        // 口味收藏按钮 - 点击切换星星填充状态
        Row() {
          Image(this.isFavorited ? $r('app.media.star_full') : $r('app.media.star'))
            .width(18)
            .height(18)
            .fillColor(this.isFavorited ? '#D84A7C' : '#D84A7C')
            .margin({ right: 4 })
          Text('口味收藏')
            .fontSize(12)
            .fontColor('#D84A7C')
        }
        .padding({ left: 12, right: 16, top: 6, bottom: 6 })
        .backgroundColor('#fcf0f4')
        .borderRadius(16)
        .onClick(() => {
          this.toggleFavorite()
        })
      }
      .width('100%').alignItems(VerticalAlign.Top)
    }
    .width('100%').padding(12).backgroundColor(Color.White).borderRadius(12).margin({ top: 12 })
  }

  /**
   * @Builder 杯型规格单选区域
   */
  @Builder
  SizeSection() {
    Column() {
      Text('规格*').fontSize(15).fontWeight(FontWeight.Medium).width('100%').margin({ bottom: 10 })
      Row() {
        this.SizeButton('中', this.getSizeDisplayPrice('中'))
        this.SizeButton('大', this.getSizeDisplayPrice('大'))
      }
      .width('100%')
    }
    .width('100%').padding(12).backgroundColor(Color.White).borderRadius(12).margin({ top: 12 })
  }

  @Builder
  SizeButton(label: string, price: string) {
    Column() {
      Text(label).fontSize(16).fontWeight(FontWeight.Medium)
      Text(price).fontSize(12).fontColor('#999')
    }
    .padding({ left: 24, right: 24, top: 10, bottom: 10 })
    .borderRadius(8)
    .backgroundColor(this.selectedSize === label ? '#fcf0f4' : '#f5f5f5')
    .border({ width: this.selectedSize === label ? 2 : 0, color: '#D84A7C' })
    .margin({ right: 10 })
    .onClick(() => {
      this.selectedSize = label
      this.updatePrice()
    })
  }

  /**
   * @Builder 加料多选区域
   */
  @Builder
  AddonSection() {
    Column() {
      Text('加料（每项+￥1）').fontSize(15).fontWeight(FontWeight.Medium).width('100%').margin({ bottom: 10 })
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(Array.from(this.addons.keys()), (key: string) => {
          this.AddonButton(key)
        })
      }
      .width('100%')
    }
    .width('100%').padding(12).backgroundColor(Color.White).borderRadius(12).margin({ top: 12 })
  }

  @Builder
  AddonButton(label: string) {
    Row() {
      Text(label).fontSize(13)
      Text('￥1').fontSize(11).fontColor('#999').margin({ left: 4 })
    }
    .padding({ left: 12, right: 12, top: 6, bottom: 6 })
    .borderRadius(16)
    .backgroundColor(this.addons.get(label) ? '#fcf0f4' : '#f5f5f5')
    .border({ width: this.addons.get(label) ? 2 : 0, color: '#D84A7C' })
    .margin({ right: 8, bottom: 8 })
    .onClick(() => {
      this.toggleAddon(label)
    })
  }

  /**
   * @Builder 去料多选区域
   */
  @Builder
  RemovalSection() {
    Column() {
      Text('去料（免费）').fontSize(15).fontWeight(FontWeight.Medium).width('100%').margin({ bottom: 10 })
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(Array.from(this.removals.keys()), (key: string) => {
          this.RemovalButton(key)
        })
      }
      .width('100%')
    }
    .width('100%').padding(12).backgroundColor(Color.White).borderRadius(12).margin({ top: 12 })
  }

  @Builder
  RemovalButton(label: string) {
    Text(label)
      .fontSize(13)
      .padding({ left: 12, right: 12, top: 6, bottom: 6 })
      .borderRadius(16)
      .backgroundColor(this.removals.get(label) ? '#fcf0f4' : '#f5f5f5')
      .border({ width: this.removals.get(label) ? 2 : 0, color: '#D84A7C' })
      .margin({ right: 8, bottom: 8 })
      .onClick(() => {
        this.toggleRemoval(label)
      })
  }

  /**
   * @Builder 温度单选
   */
  @Builder
  TemperatureSection() {
    Column() {
      Text('温度*').fontSize(15).fontWeight(FontWeight.Medium).width('100%').margin({ bottom: 10 })
      Row() {
        this.TempButton('正常冰')
        this.TempButton('少冰')
        this.TempButton('温')
      }
      .width('100%')
    }
    .width('100%').padding(12).backgroundColor(Color.White).borderRadius(12).margin({ top: 12 })
  }

  @Builder
  TempButton(label: string) {
    Text(label)
      .fontSize(13)
      .padding({ left: 16, right: 16, top: 6, bottom: 6 })
      .borderRadius(16)
      .backgroundColor(this.selectedTemp === label ? '#fcf0f4' : '#f5f5f5')
      .border({ width: this.selectedTemp === label ? 2 : 0, color: '#D84A7C' })
      .margin({ right: 8 })
      .onClick(() => {
        this.selectedTemp = label
        this.updatePrice()
      })
  }

  /**
   * @Builder 选糖单选
   */
  @Builder
  SugarSection() {
    Column() {
      Text('选糖*').fontSize(15).fontWeight(FontWeight.Medium).width('100%').margin({ bottom: 10 })
      Row() {
        this.SugarButton('默认糖')
      }
      .width('100%')
    }
    .width('100%').padding(12).backgroundColor(Color.White).borderRadius(12).margin({ top: 12 })
  }

  @Builder
  SugarButton(label: string) {
    Text(label)
      .fontSize(13)
      .padding({ left: 16, right: 16, top: 6, bottom: 6 })
      .borderRadius(16)
      .backgroundColor(this.selectedSugar === label ? '#fcf0f4' : '#f5f5f5')
      .border({ width: this.selectedSugar === label ? 2 : 0, color: '#D84A7C' })
      .onClick(() => {
        this.selectedSugar = label
        this.updatePrice()
      })
  }

  /**
   * @Builder 甜度单选
   */
  @Builder
  SweetnessSection() {
    Column() {
      Text('甜度*').fontSize(15).fontWeight(FontWeight.Medium).width('100%').margin({ bottom: 10 })
      Flex({ wrap: FlexWrap.Wrap }) {
        this.SweetnessButton('五分甜')
        this.SweetnessButton('七分甜（正常糖）')
        this.SweetnessButton('三分甜')
        this.SweetnessButton('十分甜')
        this.SweetnessButton('不另外加糖')
      }
      .width('100%')
    }
    .width('100%').padding(12).backgroundColor(Color.White).borderRadius(12).margin({ top: 12 })
  }

  @Builder
  SweetnessButton(label: string) {
    Text(label)
      .fontSize(13)
      .padding({ left: 12, right: 12, top: 6, bottom: 6 })
      .borderRadius(16)
      .backgroundColor(this.selectedSweetness === label ? '#fcf0f4' : '#f5f5f5')
      .border({ width: this.selectedSweetness === label ? 2 : 0, color: '#D84A7C' })
      .margin({ right: 8, bottom: 8 })
      .onClick(() => {
        this.selectedSweetness = label
        this.updatePrice()
      })
  }

  /**
   * @Builder 温馨提示
   */
  @Builder
  TipsSection() {
    Column() {
      Text('温馨提示').fontSize(15).fontWeight(FontWeight.Medium).width('100%').margin({ bottom: 10 })
      Column() {
        Text('|加料后甜度上升一档|').fontSize(12).fontColor('#999').width('100%').padding({ top: 4, bottom: 4 })
        Text('|少冰且去料时冰块偏多|').fontSize(12).fontColor('#999').width('100%').padding({ top: 4, bottom: 4 })
      }
      .width('100%').padding(10).backgroundColor('#f8f8f8').borderRadius(8)
    }
    .width('100%').padding(12).backgroundColor(Color.White).borderRadius(12).margin({ top: 12 })
  }

  /**
   * @Builder 茶底单选
   */
  @Builder
  TeaSection() {
    Column() {
      Text('茶底*').fontSize(15).fontWeight(FontWeight.Medium).width('100%').margin({ bottom: 10 })
      Row() {
        this.TeaButton('茉莉')
      }
      .width('100%')
    }
    .width('100%').padding(12).backgroundColor(Color.White).borderRadius(12).margin({ top: 12 })
  }

  @Builder
  TeaButton(label: string) {
    Text(label)
      .fontSize(13)
      .padding({ left: 16, right: 16, top: 6, bottom: 6 })
      .borderRadius(16)
      .backgroundColor(this.selectedTea === label ? '#fcf0f4' : '#f5f5f5')
      .border({ width: this.selectedTea === label ? 2 : 0, color: '#D84A7C' })
      .onClick(() => {
        this.selectedTea = label
        this.updatePrice()
      })
  }

  /**
   * @Builder 商品详情文字说明
   */
  @Builder
  DescriptionSection() {
    Column() {
      Text('·鲜活成分：珍珠×椰果×茉莉花茶').fontSize(12).fontColor('#666').width('100%').padding({ top: 4, bottom: 4 })
      Text('·鲜活风味：维C满满搭配Q弹珍珠和椰果，口感丰富，小朋友超爱！').fontSize(12).fontColor('#666').width('100%').padding({ top: 4, bottom: 4 })
      Text('·致敏原信息：本品内含青橘或奶盖，过敏者请谨慎选择').fontSize(12).fontColor('#666').width('100%').padding({ top: 4, bottom: 4 })
      Text('·杯型：中杯500ml；大杯630ml。温饮中杯500ml；大杯645ml').fontSize(12).fontColor('#666').width('100%').padding({ top: 4, bottom: 4 })
      Text('·标注容量仅供参考，饮品量请以门店实际出品为准。').fontSize(12).fontColor('#999').width('100%').padding({ top: 4, bottom: 4 })
      Divider().margin({ top: 10, bottom: 10 })
      Text('温馨提示：').fontSize(12).fontWeight(FontWeight.Medium).width('100%').padding({ top: 4, bottom: 4 })
      Text('*饮品久置易分层，喝前搅一搅，风味更佳，建议一小时内饮用；').fontSize(11).fontColor('#999').width('100%').padding({ top: 2, bottom: 2 })
      Text('*不另外加糖中，为保证口感，部分饮品小料或茶汤中含糖；').fontSize(11).fontColor('#999').width('100%').padding({ top: 2, bottom: 2 })
      Text('*部分地区【杯型】有差异，具体以实际出杯为准，敬请谅解；').fontSize(11).fontColor('#999').width('100%').padding({ top: 2, bottom: 2 })
      Text('*饮品内含小料，请勿一口吞饮，三岁以下婴幼儿不宜饮用，老人儿童需监护下饮用；').fontSize(11).fontColor('#999').width('100%').padding({ top: 2, bottom: 2 })
      Text('*温饮青橘久泡微涩，请尽快饮用；').fontSize(11).fontColor('#999').width('100%').padding({ top: 2, bottom: 2 })
      Text('*鲜活成分说明仅指产品主要原料；').fontSize(11).fontColor('#999').width('100%').padding({ top: 2, bottom: 2 })
      Text('*产品图仅供参考，实物请以门店出杯为准；').fontSize(11).fontColor('#999').width('100%').padding({ top: 2, bottom: 2 })
    }
    .width('100%').padding(12).backgroundColor(Color.White).borderRadius(12).margin({ top: 12 })
  }

  /**
   * @Builder 底部数量+价格+加入购物车栏
   * 自动收集所有选中规格，组装购物车对象并调用全局购物车管理器
   */
  @Builder
  BottomBar() {
    Row() {
      // 数量选择器
      Row() {
        Button() {
          Text('-')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333')
        }
        .width(32)
        .height(32)
        .backgroundColor('#f0f0f0')
        .borderRadius(16)
        .onClick(() => {
          if (this.quantity > 1) {
            this.quantity--
            this.updatePrice()
          }
        })

        Text(`${this.quantity}`)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 12, right: 12 })
          .width(20)
          .textAlign(TextAlign.Center)

        Button() {
          Text('+')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#fff')
        }
        .width(32)
        .height(32)
        .backgroundColor('#D84A7C')
        .borderRadius(16)
        .onClick(() => {
          this.quantity++
          this.updatePrice()
        })
      }
      .margin({ right: 12 })

      // 价格信息
      Column() {
        Text(`¥${this.displayPrice}`)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#d63333')
        Text(`${this.selectedSize}/${this.selectedTemp}/${this.selectedSugar}/${this.selectedSweetness}/${this.selectedTea}`)
          .fontSize(10)
          .fontColor('#999')
          .width('100%')
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ right: 8 })
      .layoutWeight(1)

      // 加入购物车按钮
      Button('加入购物车')
        .fontSize(14)
        .fontColor('#fff')
        .backgroundColor('#D84A7C')
        .padding({ left: 16, right: 16, top: 10, bottom: 10 })
        .borderRadius(20)
        .onClick(() => {
          // 手动遍历收集选中加料
          const selectedAddons: string[] = []
          const addonEntries = Array.from(this.addons.entries())
          for (let i = 0; i < addonEntries.length; i++) {
            const itemArr = addonEntries[i]
            const name = itemArr[0]
            const flag = itemArr[1]
            if (flag) {
              selectedAddons.push(name)
            }
          }

          // 手动遍历收集去料
          const selectedRemove: string[] = []
          const removeEntries = Array.from(this.removals.entries())
          for (let i = 0; i < removeEntries.length; i++) {
            const itemArr = removeEntries[i]
            const name = itemArr[0]
            const flag = itemArr[1]
            if (flag) {
              selectedRemove.push(name)
            }
          }

          const cartItem: CartItemType = {
            name: this.goodsName,
            size: this.selectedSize,
            temp: this.selectedTemp,
            sugar: this.selectedSugar,
            sweet: this.selectedSweetness,
            tea: this.selectedTea,
            addons: selectedAddons,
            remove: selectedRemove,
            singlePrice: this.calculateSinglePrice(),
            count: this.quantity,
            totalPrice: this.calculateTotalPrice(),
            id: '' // id 会在 CartManager 中生成
          }

          // 添加到购物车
          CartManager.addItem(cartItem)

          // 跳转回上一页
          router.back()
        })
    }
  }
}