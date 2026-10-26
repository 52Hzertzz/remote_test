// CartManager.ets 全局购物车单例管理类
import { promptAction } from '@kit.ArkUI';

// 购物车商品条目模型
export interface CartItem {
  name: string          // 商品名称
  size: string          // 杯型
  temp: string          // 温度
  sugar: string         // 选糖
  sweet: string         // 甜度
  tea: string           // 茶底
  addons: string[]      // 选中加料
  remove: string[]      // 选中去料
  singlePrice: number  // 单品单价
  count: number         // 购买数量
  totalPrice: number    // 小计总价
  id: string            // 唯一标识，区分不同规格
}

class CartManagerClass {
  // 私有购物车商品数组
  private items: CartItem[] = []
  // 订阅回调数组，数据变化后通知页面刷新UI
  private observers: (() => void)[] = []

  /**
   * 添加商品到购物车
   * 同规格商品自动合并数量
   */
  addItem(item: CartItem): void {
    // 根据规格自动生成唯一ID
    item.id = this.generateId(item)

    // 查找购物车内有没有一模一样规格的商品
    const existingIndex = this.items.findIndex(existing => existing.id === item.id)

    if (existingIndex !== -1) {
      // 已存在：累加数量，重新计算小计
      this.items[existingIndex].count += item.count
      this.items[existingIndex].totalPrice = this.items[existingIndex].singlePrice * this.items[existingIndex].count
    } else {
      // 不存在：直接新增一条购物车记录
      this.items.push(item)
    }

    // 通知所有订阅页面刷新数据
    this.notifyObservers()
    this.showToast(`${item.name} 已加入购物车`)
  }

  /**
   * 根据商品所有规格拼接生成唯一ID
   * 保证杯型、温度、甜度、加料不一样都会生成不同ID，不会互相合并
   */
  private generateId(item: CartItem): string {
    // 加料、去料排序，防止数组顺序不同导致ID不一致
    return `${item.name}_${item.size}_${item.temp}_${item.sugar}_${item.sweet}_${item.tea}_${item.addons.sort().join('+')}_${item.remove.sort().join('+')}`
  }

  /**
   * 根据ID删除整行商品
   */
  removeItem(id: string): void {
    const index = this.items.findIndex(item => item.id === id)
    if (index !== -1) {
      this.items.splice(index, 1)
      this.notifyObservers()
    }
  }

  /**
   * 修改商品数量
   * @param id 商品唯一ID
   * @param delta +1 增加，-1 减少
   */
  updateCount(id: string, delta: number): void {
    const item = this.items.find(item => item.id === id)
    if (item) {
      const newCount = item.count + delta
      if (newCount <= 0) {
        // 数量小于等于0，直接删除商品
        this.removeItem(id)
      } else {
        // 更新数量并重新计算小计
        item.count = newCount
        item.totalPrice = item.singlePrice * item.count
        this.notifyObservers()
      }
    }
  }

  /**
   * 获取购物车全部商品（返回副本，防止外部直接修改原数组）
   */
  getItems(): CartItem[] {
    return [...this.items]
  }

  /**
   * 计算购物车所有商品合计总价
   */
  getTotalPrice(): number {
    let total = 0
    for (let i = 0; i < this.items.length; i++) {
      total += this.items[i].totalPrice
    }
    return total
  }

  /**
   * 统计购物车商品总件数
   */
  getTotalCount(): number {
    let count = 0
    for (let i = 0; i < this.items.length; i++) {
      count += this.items[i].count
    }
    return count
  }

  /**
   * 清空整个购物车
   */
  clearCart(): void {
    this.items = []
    this.notifyObservers()
  }

  /**
   * 订阅购物车数据变化，页面注册回调实现自动刷新
   */
  subscribe(callback: () => void): void {
    this.observers.push(callback)
  }

  /**
   * 取消订阅（页面销毁时调用，防止内存泄漏）
   */
  unsubscribe(callback: () => void): void {
    const index = this.observers.indexOf(callback)
    if (index !== -1) {
      this.observers.splice(index, 1)
    }
  }

  /**
   * 遍历执行所有订阅回调，通知页面更新状态
   */
  private notifyObservers(): void {
    for (let i = 0; i < this.observers.length; i++) {
      this.observers[i]()
    }
  }

  /**
   * 弹出Toast提示
   */
  private showToast(message: string): void {
    promptAction.showToast({
      message: message,
      duration: 1500
    })
  }
}

// 全局单例对象，整个项目共用同一个购物车实例
export const CartManager = new CartManagerClass()